param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$templateRoot = Join-Path $repoRoot "templates"

if (-not (Test-Path -LiteralPath $templateRoot)) {
    throw "Template directory not found: $templateRoot"
}

if (Test-Path -LiteralPath $TargetPath) {
    $targetRoot = (Resolve-Path -LiteralPath $TargetPath).Path
} else {
    if ([System.IO.Path]::IsPathRooted($TargetPath)) {
        $targetRoot = [System.IO.Path]::GetFullPath($TargetPath)
    } else {
        $targetRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $TargetPath))
    }
    if ($DryRun) {
        Write-Host "[dry-run] Would create target directory: $targetRoot"
    } else {
        New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
    }
}

$mappings = @(
    @{ Source = "AGENTS.md"; Destination = "AGENTS.md" },
    @{ Source = "feature_list.json"; Destination = "feature_list.json" },
    @{ Source = "feature-list.schema.json"; Destination = "feature-list.schema.json" },
    @{ Source = "progress.md"; Destination = "progress.md" },
    @{ Source = "session-handoff.md"; Destination = "session-handoff.md" },
    @{ Source = "clean-state-checklist.md"; Destination = "clean-state-checklist.md" },
    @{ Source = "evaluator-rubric.md"; Destination = "evaluator-rubric.md" },
    @{ Source = "benchmark-record.md"; Destination = "evals/benchmark-record.md" },
    @{ Source = "quality-document.md"; Destination = "quality-document.md" },
    @{ Source = "init.ps1"; Destination = "init.ps1" },
    @{ Source = "harness-env.md"; Destination = "harness/env.md" },
    @{ Source = "harness-build.md"; Destination = "harness/build.md" },
    @{ Source = "harness-run.md"; Destination = "harness/run.md" },
    @{ Source = "harness-test.md"; Destination = "harness/test.md" },
    @{ Source = "harness-quality.md"; Destination = "harness/quality.md" },
    @{ Source = "harness-release.md"; Destination = "harness/release.md" }
)

$copied = 0
$skipped = 0

foreach ($mapping in $mappings) {
    $source = Join-Path $templateRoot $mapping.Source
    $destination = Join-Path $targetRoot $mapping.Destination
    $destinationDir = Split-Path -Parent $destination

    if (-not (Test-Path -LiteralPath $source)) {
        throw "Template file not found: $source"
    }

    if ((Test-Path -LiteralPath $destination) -and -not $Force) {
        Write-Host "[skip] $($mapping.Destination) already exists. Use -Force to overwrite."
        $skipped++
        continue
    }

    if ($DryRun) {
        Write-Host "[dry-run] Copy $($mapping.Source) -> $($mapping.Destination)"
        $copied++
        continue
    }

    if (-not (Test-Path -LiteralPath $destinationDir)) {
        New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
    }

    Copy-Item -LiteralPath $source -Destination $destination -Force:$Force
    Write-Host "[copy] $($mapping.Source) -> $($mapping.Destination)"
    $copied++
}

Write-Host "Install complete. Copied: $copied. Skipped: $skipped. Target: $targetRoot"
