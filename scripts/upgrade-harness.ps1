param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [switch]$ShowDiff,

    [switch]$ApplyMissing
)

$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptRoot
$templateRoot = Join-Path $repoRoot "templates"

if (-not (Test-Path -LiteralPath $TargetPath)) {
    throw "Target path not found: $TargetPath"
}

$targetRoot = (Resolve-Path -LiteralPath $TargetPath).Path

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
    @{ Source = "harness-release.md"; Destination = "harness/release.md" },
    @{ Source = "harness-hardware-test.md"; Destination = "harness/hardware-test.md" },
    @{ Source = "harness-protocol-replay.md"; Destination = "harness/protocol-replay.md" },
    @{ Source = "harness-ui-acceptance.md"; Destination = "harness/ui-acceptance.md" },
    @{ Source = "harness-deployment-acceptance.md"; Destination = "harness/deployment-acceptance.md" },
    @{ Source = "harness-security-data.md"; Destination = "harness/security-data.md" },
    @{ Source = "harness-git-save-feature.ps1"; Destination = "harness/git-save-feature.ps1" },
    @{ Source = "harness-update-evidence.ps1"; Destination = "harness/update-evidence.ps1" }
)

$same = 0
$missing = 0
$different = 0
$copied = 0

foreach ($mapping in $mappings) {
    $source = Join-Path $templateRoot $mapping.Source
    $destination = Join-Path $targetRoot $mapping.Destination
    $destinationDir = Split-Path -Parent $destination

    if (-not (Test-Path -LiteralPath $source)) {
        throw "Template file not found: $source"
    }

    if (-not (Test-Path -LiteralPath $destination)) {
        Write-Host "[missing] $($mapping.Destination)"
        $missing++
        if ($ApplyMissing) {
            if (-not (Test-Path -LiteralPath $destinationDir)) {
                New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
            }
            Copy-Item -LiteralPath $source -Destination $destination
            Write-Host "  copied from template"
            $copied++
        }
        continue
    }

    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    $destinationHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash

    if ($sourceHash -eq $destinationHash) {
        Write-Host "[same] $($mapping.Destination)"
        $same++
        continue
    }

    Write-Host "[different] $($mapping.Destination)"
    $different++
    if ($ShowDiff) {
        & git diff --no-index -- $destination $source
        $null = $LASTEXITCODE
    }
}

Write-Host "Upgrade scan complete. Same: $same. Missing: $missing. Different: $different. Copied: $copied. Target: $targetRoot"
