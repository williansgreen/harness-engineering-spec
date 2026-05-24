param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z][A-Za-z0-9_.-]*$")]
    [string]$ProductName,

    [string]$TargetPath = ".",

    [ValidateSet("Wpf", "WinForms")]
    [string]$UiFramework = "Wpf",

    [string]$TargetFramework = "",

    [ValidateSet("AnyCPU", "x86", "x64")]
    [string]$Platform = "AnyCPU",

    [switch]$DryRun,
    [switch]$RunVerification
)

$ErrorActionPreference = "Stop"

function Invoke-LoggedStep([string]$Description, [scriptblock]$Action) {
    if ($DryRun) {
        Write-Host "[dry-run] $Description"
        return
    }

    Write-Host "[step] $Description"
    & $Action
}

function Invoke-DotNet([string[]]$Arguments) {
    & dotnet @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "dotnet $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
    }
}

function Get-DefaultTargetFramework {
    $sdkLines = & dotnet --list-sdks 2>$null
    $versions = @()
    foreach ($line in $sdkLines) {
        if ($line -match "^(\d+)\.") {
            $versions += [int]$Matches[1]
        }
    }

    if ($versions.Count -eq 0) {
        return "net8.0"
    }

    $major = ($versions | Sort-Object -Descending | Select-Object -First 1)
    if ($major -lt 8) {
        return "net8.0"
    }

    return "net$major.0"
}

function Get-ProjectPath([string]$Root, [string]$RelativePath, [string]$Name) {
    return Join-Path (Join-Path $Root $RelativePath) $Name
}

function Write-TextFile([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }

    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Remove-GeneratedClass1([string]$ProjectDir) {
    $class1 = Join-Path $ProjectDir "Class1.cs"
    if (Test-Path -LiteralPath $class1) {
        Remove-Item -LiteralPath $class1
    }
}

function Repair-UiTemplateApplicationConflict([string]$ProjectDir, [string]$Framework) {
    if ($Framework -eq "Wpf") {
        $appCodePath = Join-Path $ProjectDir "App.xaml.cs"
        if (Test-Path -LiteralPath $appCodePath) {
            $content = Get-Content -Raw -LiteralPath $appCodePath
            $content = $content -replace ": Application", ": System.Windows.Application"
            Set-Content -LiteralPath $appCodePath -Value $content -Encoding UTF8
        }
        return
    }

    $programPath = Join-Path $ProjectDir "Program.cs"
    if (Test-Path -LiteralPath $programPath) {
        $content = Get-Content -Raw -LiteralPath $programPath
        $content = $content -replace "Application\.Run\(", "global::System.Windows.Forms.Application.Run("
        Set-Content -LiteralPath $programPath -Value $content -Encoding UTF8
    }
}

if ([string]::IsNullOrWhiteSpace($TargetFramework)) {
    $TargetFramework = Get-DefaultTargetFramework
}

$libraryFramework = $TargetFramework -replace "-windows$", ""
$uiTargetFramework = $libraryFramework
if (-not $uiTargetFramework.EndsWith("-windows")) {
    $uiTargetFramework = "$uiTargetFramework-windows"
}

if (Test-Path -LiteralPath $TargetPath) {
    $root = (Resolve-Path -LiteralPath $TargetPath).Path
} else {
    $root = [System.IO.Path]::GetFullPath($TargetPath)
}

$solutionPath = Join-Path $root "$ProductName.sln"
$uiProjectName = if ($UiFramework -eq "Wpf") { "$ProductName.UI.Wpf" } else { "$ProductName.UI.WinForms" }
$uiProjectDir = Get-ProjectPath $root "src" $uiProjectName
$applicationProjectDir = Get-ProjectPath $root "src" "$ProductName.Application"
$domainProjectDir = Get-ProjectPath $root "src" "$ProductName.Domain"
$devicesProjectDir = Get-ProjectPath $root "src" "$ProductName.Devices"
$infrastructureProjectDir = Get-ProjectPath $root "src" "$ProductName.Infrastructure"
$domainTestsDir = Get-ProjectPath $root "tests" "$ProductName.Domain.Tests"
$applicationTestsDir = Get-ProjectPath $root "tests" "$ProductName.Application.Tests"
$devicesTestsDir = Get-ProjectPath $root "tests" "$ProductName.Devices.Tests"

Write-Host "Target root: $root"
Write-Host "Library framework: $libraryFramework"
Write-Host "UI framework: $uiTargetFramework"
Write-Host "UI project: $uiProjectName"
Write-Host "Platform strategy: $Platform"

Invoke-LoggedStep "create target directory" {
    New-Item -ItemType Directory -Force -Path $root | Out-Null
}

Invoke-LoggedStep "create solution" {
    $arguments = @("new", "sln", "-n", $ProductName, "-o", $root)
    $solutionHelp = (& dotnet new sln -h 2>$null) -join "`n"
    if ($solutionHelp -match "--format") {
        $arguments += @("--format", "sln")
    }

    Invoke-DotNet $arguments
}

if (-not $DryRun -and -not (Test-Path -LiteralPath $solutionPath)) {
    $solutionXPath = Join-Path $root "$ProductName.slnx"
    if (Test-Path -LiteralPath $solutionXPath) {
        $solutionPath = $solutionXPath
    } else {
        throw "Solution file was not created at $solutionPath."
    }
}

$uiTemplate = if ($UiFramework -eq "Wpf") { "wpf" } else { "winforms" }
Invoke-LoggedStep "create $UiFramework UI project" {
    Invoke-DotNet @("new", $uiTemplate, "-n", $uiProjectName, "-o", $uiProjectDir, "-f", $libraryFramework, "--no-restore")
    Repair-UiTemplateApplicationConflict $uiProjectDir $UiFramework
}

foreach ($project in @(
    @{ Name = "$ProductName.Domain"; Path = $domainProjectDir },
    @{ Name = "$ProductName.Devices"; Path = $devicesProjectDir },
    @{ Name = "$ProductName.Application"; Path = $applicationProjectDir },
    @{ Name = "$ProductName.Infrastructure"; Path = $infrastructureProjectDir }
)) {
    Invoke-LoggedStep "create $($project.Name)" {
        Invoke-DotNet @("new", "classlib", "-n", $project.Name, "-o", $project.Path, "-f", $libraryFramework, "--no-restore")
        Remove-GeneratedClass1 $project.Path
    }
}

foreach ($project in @(
    @{ Name = "$ProductName.Domain.Tests"; Path = $domainTestsDir },
    @{ Name = "$ProductName.Application.Tests"; Path = $applicationTestsDir },
    @{ Name = "$ProductName.Devices.Tests"; Path = $devicesTestsDir }
)) {
    Invoke-LoggedStep "create $($project.Name)" {
        Invoke-DotNet @("new", "xunit", "-n", $project.Name, "-o", $project.Path, "-f", $libraryFramework, "--no-restore")
    }
}

$projects = @(
    (Join-Path $uiProjectDir "$uiProjectName.csproj"),
    (Join-Path $domainProjectDir "$ProductName.Domain.csproj"),
    (Join-Path $devicesProjectDir "$ProductName.Devices.csproj"),
    (Join-Path $applicationProjectDir "$ProductName.Application.csproj"),
    (Join-Path $infrastructureProjectDir "$ProductName.Infrastructure.csproj"),
    (Join-Path $domainTestsDir "$ProductName.Domain.Tests.csproj"),
    (Join-Path $applicationTestsDir "$ProductName.Application.Tests.csproj"),
    (Join-Path $devicesTestsDir "$ProductName.Devices.Tests.csproj")
)

Invoke-LoggedStep "add projects to solution" {
    $arguments = @("sln", $solutionPath, "add") + $projects
    Invoke-DotNet $arguments
}

$domainProject = Join-Path $domainProjectDir "$ProductName.Domain.csproj"
$devicesProject = Join-Path $devicesProjectDir "$ProductName.Devices.csproj"
$applicationProject = Join-Path $applicationProjectDir "$ProductName.Application.csproj"
$infrastructureProject = Join-Path $infrastructureProjectDir "$ProductName.Infrastructure.csproj"
$uiProject = Join-Path $uiProjectDir "$uiProjectName.csproj"

Invoke-LoggedStep "add project references" {
    Invoke-DotNet @("add", $devicesProject, "reference", $domainProject)
    Invoke-DotNet @("add", $applicationProject, "reference", $domainProject, $devicesProject)
    Invoke-DotNet @("add", $infrastructureProject, "reference", $domainProject, $devicesProject, $applicationProject)
    Invoke-DotNet @("add", $uiProject, "reference", $applicationProject, $domainProject, $devicesProject, $infrastructureProject)
    Invoke-DotNet @("add", (Join-Path $domainTestsDir "$ProductName.Domain.Tests.csproj"), "reference", $domainProject)
    Invoke-DotNet @("add", (Join-Path $applicationTestsDir "$ProductName.Application.Tests.csproj"), "reference", $applicationProject, $devicesProject, $domainProject)
    Invoke-DotNet @("add", (Join-Path $devicesTestsDir "$ProductName.Devices.Tests.csproj"), "reference", $devicesProject, $domainProject)
}

Invoke-LoggedStep "write shared build files and starter domain/device/application code" {
    Write-TextFile (Join-Path $root ".editorconfig") @"
root = true

[*.cs]
dotnet_style_qualification_for_field = false:suggestion
dotnet_style_qualification_for_property = false:suggestion
dotnet_style_qualification_for_method = false:suggestion
dotnet_style_qualification_for_event = false:suggestion

[*.{cs,csproj}]
indent_style = space
indent_size = 4
"@

    Write-TextFile (Join-Path $root "Directory.Build.props") @"
<Project>
  <PropertyGroup>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <LangVersion>latest</LangVersion>
    <AnalysisLevel>latest</AnalysisLevel>
    <Deterministic>true</Deterministic>
    <PlatformTarget>$Platform</PlatformTarget>
  </PropertyGroup>
</Project>
"@

    Write-TextFile (Join-Path $domainProjectDir "DeviceConnectionState.cs") @"
namespace $ProductName.Domain;

public enum DeviceConnectionState
{
    Disconnected,
    Connecting,
    Connected,
    Running,
    Faulted
}
"@

    Write-TextFile (Join-Path $devicesProjectDir "DeviceModels.cs") @"
using $ProductName.Domain;

namespace $ProductName.Devices;

public sealed record DeviceCommand(string Name);

public sealed record DeviceStatus(DeviceConnectionState State, string Message);
"@

    Write-TextFile (Join-Path $devicesProjectDir "IDeviceService.cs") @"
namespace $ProductName.Devices;

public interface IDeviceService : IAsyncDisposable
{
    Task ConnectAsync(CancellationToken cancellationToken);
    Task DisconnectAsync(CancellationToken cancellationToken);
    Task<DeviceStatus> GetStatusAsync(CancellationToken cancellationToken);
    Task StartAsync(DeviceCommand command, CancellationToken cancellationToken);
    Task StopAsync(CancellationToken cancellationToken);
}
"@

    Write-TextFile (Join-Path $devicesProjectDir "SimulatedDeviceService.cs") @"
using $ProductName.Domain;

namespace $ProductName.Devices;

public sealed class SimulatedDeviceService : IDeviceService
{
    private DeviceConnectionState _state = DeviceConnectionState.Disconnected;

    public Task ConnectAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        _state = DeviceConnectionState.Connected;
        return Task.CompletedTask;
    }

    public Task DisconnectAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        _state = DeviceConnectionState.Disconnected;
        return Task.CompletedTask;
    }

    public Task<DeviceStatus> GetStatusAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        return Task.FromResult(new DeviceStatus(_state, _state.ToString()));
    }

    public Task StartAsync(DeviceCommand command, CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        if (_state is not DeviceConnectionState.Connected)
        {
            throw new InvalidOperationException("Device must be connected before starting.");
        }

        _state = DeviceConnectionState.Running;
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        cancellationToken.ThrowIfCancellationRequested();
        if (_state is DeviceConnectionState.Running)
        {
            _state = DeviceConnectionState.Connected;
        }

        return Task.CompletedTask;
    }

    public ValueTask DisposeAsync()
    {
        _state = DeviceConnectionState.Disconnected;
        return ValueTask.CompletedTask;
    }
}
"@

    Write-TextFile (Join-Path $applicationProjectDir "InstrumentWorkflow.cs") @"
using $ProductName.Devices;

namespace $ProductName.Application;

public sealed class InstrumentWorkflow
{
    private readonly IDeviceService _deviceService;

    public InstrumentWorkflow(IDeviceService deviceService)
    {
        _deviceService = deviceService;
    }

    public async Task<DeviceStatus> ConnectAndReadStatusAsync(CancellationToken cancellationToken)
    {
        await _deviceService.ConnectAsync(cancellationToken).ConfigureAwait(false);
        return await _deviceService.GetStatusAsync(cancellationToken).ConfigureAwait(false);
    }
}
"@

    Write-TextFile (Join-Path $devicesTestsDir "SimulatedDeviceServiceTests.cs") @"
using $ProductName.Devices;
using $ProductName.Domain;

namespace $ProductName.Devices.Tests;

public sealed class SimulatedDeviceServiceTests
{
    [Fact]
    public async Task StartAsync_WhenConnected_ChangesStateToRunning()
    {
        await using var device = new SimulatedDeviceService();

        await device.ConnectAsync(CancellationToken.None);
        await device.StartAsync(new DeviceCommand("Start"), CancellationToken.None);

        var status = await device.GetStatusAsync(CancellationToken.None);
        Assert.Equal(DeviceConnectionState.Running, status.State);
    }

    [Fact]
    public async Task StartAsync_WhenDisconnected_Throws()
    {
        await using var device = new SimulatedDeviceService();

        await Assert.ThrowsAsync<InvalidOperationException>(() =>
            device.StartAsync(new DeviceCommand("Start"), CancellationToken.None));
    }
}
"@

    Write-TextFile (Join-Path $applicationTestsDir "InstrumentWorkflowTests.cs") @"
using $ProductName.Application;
using $ProductName.Devices;
using $ProductName.Domain;

namespace $ProductName.Application.Tests;

public sealed class InstrumentWorkflowTests
{
    [Fact]
    public async Task ConnectAndReadStatusAsync_UsesDeviceAbstraction()
    {
        await using var device = new SimulatedDeviceService();
        var workflow = new InstrumentWorkflow(device);

        var status = await workflow.ConnectAndReadStatusAsync(CancellationToken.None);

        Assert.Equal(DeviceConnectionState.Connected, status.State);
    }
}
"@

    Write-TextFile (Join-Path $domainTestsDir "DeviceConnectionStateTests.cs") @"
using $ProductName.Domain;

namespace $ProductName.Domain.Tests;

public sealed class DeviceConnectionStateTests
{
    [Fact]
    public void DeviceConnectionState_HasDisconnectedDefault()
    {
        Assert.Equal(DeviceConnectionState.Disconnected, default(DeviceConnectionState));
    }
}
"@
}

if ($RunVerification) {
    Invoke-LoggedStep "restore, build, and test" {
        Invoke-DotNet @("restore", $solutionPath)
        Invoke-DotNet @("build", $solutionPath, "--configuration", "Release", "--no-restore")
        Invoke-DotNet @("test", $solutionPath, "--configuration", "Release", "--no-build")
    }
} else {
    Write-Host "Next verification commands:"
    Write-Host "  dotnet restore `"$solutionPath`""
    Write-Host "  dotnet build `"$solutionPath`" --configuration Release --no-restore"
    Write-Host "  dotnet test `"$solutionPath`" --configuration Release --no-build"
}
