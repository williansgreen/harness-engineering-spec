param(
    [string]$SkillValidatorPath = ""
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-CheckError([string]$Message) {
    $script:errors.Add($Message) | Out-Null
}

function Add-CheckWarning([string]$Message) {
    $script:warnings.Add($Message) | Out-Null
}

function Test-PowerShellFile([string]$Path) {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors) {
        foreach ($parseError in $parseErrors) {
            Add-CheckError "PowerShell parse error in ${Path}: $($parseError.Message)"
        }
    }
}

function Test-JsonFile([string]$Path) {
    try {
        Get-Content -Raw -LiteralPath $Path | ConvertFrom-Json | Out-Null
    } catch {
        Add-CheckError "JSON parse error in ${Path}: $($_.Exception.Message)"
    }
}

$psFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -Filter "*.ps1" -File
foreach ($file in $psFiles) {
    Test-PowerShellFile $file.FullName
}

$jsonFiles = Get-ChildItem -LiteralPath $repoRoot -Recurse -Filter "*.json" -File
foreach ($file in $jsonFiles) {
    Test-JsonFile $file.FullName
}

$checkHarness = Join-Path $scriptRoot "check-harness.ps1"
foreach ($example in @("examples/minimal-harness", "examples/csharp-instrument-harness")) {
    $examplePath = Join-Path $repoRoot $example
    if (-not (Test-Path -LiteralPath $examplePath)) {
        Add-CheckError "Missing example: $example"
        continue
    }

    & powershell -NoProfile -ExecutionPolicy Bypass -File $checkHarness -TargetPath $examplePath -Strict
    if ($LASTEXITCODE -ne 0) {
        Add-CheckError "Harness example failed strict check: $example"
    }
}

if ([string]::IsNullOrWhiteSpace($SkillValidatorPath)) {
    $defaultValidator = Join-Path $env:USERPROFILE ".codex\skills\.system\skill-creator\scripts\quick_validate.py"
    if (Test-Path -LiteralPath $defaultValidator) {
        $SkillValidatorPath = $defaultValidator
    }
}

if (-not [string]::IsNullOrWhiteSpace($SkillValidatorPath)) {
    $skillPath = Join-Path $repoRoot "skills/csharp-winforms-wpf"
    & python $SkillValidatorPath $skillPath
    if ($LASTEXITCODE -ne 0) {
        Add-CheckError "Skill validation failed: $skillPath"
    }
} else {
    Add-CheckWarning "Skill validator not found; skipped quick_validate.py."
}

$tempTarget = Join-Path $repoRoot ".tmp-check-spec-install"
if (Test-Path -LiteralPath $tempTarget) {
    $resolvedTemp = (Resolve-Path -LiteralPath $tempTarget).Path
    if (-not $resolvedTemp.StartsWith($repoRoot)) {
        throw "Unsafe temp path: $resolvedTemp"
    }
    Remove-Item -LiteralPath $resolvedTemp -Recurse -Force
}

try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $scriptRoot "install-harness.ps1") -TargetPath $tempTarget | Out-Host
    if ($LASTEXITCODE -ne 0) {
        Add-CheckError "install-harness.ps1 failed during temp install."
    } else {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $checkHarness -TargetPath $tempTarget | Out-Host
        if ($LASTEXITCODE -ne 0) {
            Add-CheckError "Temp installed harness failed check."
        }
    }
} finally {
    if (Test-Path -LiteralPath $tempTarget) {
        $resolvedTemp = (Resolve-Path -LiteralPath $tempTarget).Path
        if (-not $resolvedTemp.StartsWith($repoRoot)) {
            throw "Unsafe cleanup path: $resolvedTemp"
        }
        Remove-Item -LiteralPath $resolvedTemp -Recurse -Force
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  - $warning" -ForegroundColor Yellow
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Errors:" -ForegroundColor Red
    foreach ($errorMessage in $errors) {
        Write-Host "  - $errorMessage" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Spec check passed. Root: $repoRoot"

