param(
    [string]$SkillName = "csharp-winforms-wpf",
    [string]$CodexHome = "",
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$skillSource = Join-Path $repoRoot "skills/$SkillName"

if (-not (Test-Path -LiteralPath $skillSource)) {
    throw "Skill source not found: $skillSource"
}

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    } else {
        $CodexHome = Join-Path $env:USERPROFILE ".codex"
    }
}

$codexHomeFull = [System.IO.Path]::GetFullPath($CodexHome)
$skillsRoot = Join-Path $codexHomeFull "skills"
$skillTarget = Join-Path $skillsRoot $SkillName

if ($DryRun) {
    Write-Host "[dry-run] Source: $skillSource"
    Write-Host "[dry-run] Target: $skillTarget"
    if (Test-Path -LiteralPath $skillTarget) {
        if ($Force) {
            Write-Host "[dry-run] Would overwrite existing skill because -Force was provided."
        } else {
            Write-Host "[dry-run] Existing skill would be skipped. Use -Force to overwrite."
        }
    } else {
        Write-Host "[dry-run] Would install skill."
    }
    exit 0
}

if (-not (Test-Path -LiteralPath $skillsRoot)) {
    New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
}

if (Test-Path -LiteralPath $skillTarget) {
    if (-not $Force) {
        Write-Host "[skip] Skill already exists: $skillTarget. Use -Force to overwrite."
        exit 0
    }

    $resolvedTarget = (Resolve-Path -LiteralPath $skillTarget).Path
    $resolvedSkillsRoot = (Resolve-Path -LiteralPath $skillsRoot).Path
    if (-not $resolvedTarget.StartsWith($resolvedSkillsRoot)) {
        throw "Refusing to remove target outside skills root: $resolvedTarget"
    }
    Remove-Item -LiteralPath $resolvedTarget -Recurse -Force
}

Copy-Item -LiteralPath $skillSource -Destination $skillTarget -Recurse -Force
Write-Host "Installed skill '$SkillName' to $skillTarget"

