param(
    [string]$TargetPath = ".",
    [switch]$Strict
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $TargetPath)) {
    throw "Target path not found: $TargetPath"
}

$targetRoot = (Resolve-Path -LiteralPath $TargetPath).Path
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-ErrorMessage([string]$Message) {
    $script:errors.Add($Message) | Out-Null
}

function Add-WarningMessage([string]$Message) {
    $script:warnings.Add($Message) | Out-Null
}

function Test-RelativePath([string]$RelativePath) {
    return Test-Path -LiteralPath (Join-Path $targetRoot $RelativePath)
}

function Get-RelativeContent([string]$RelativePath) {
    return Get-Content -Raw -LiteralPath (Join-Path $targetRoot $RelativePath)
}

$required = @(
    "AGENTS.md",
    "feature_list.json",
    "progress.md",
    "clean-state-checklist.md",
    "harness/build.md",
    "harness/test.md"
)

$recommended = @(
    "session-handoff.md",
    "evaluator-rubric.md",
    "quality-document.md",
    "init.ps1",
    "harness/env.md",
    "harness/run.md",
    "harness/quality.md",
    "harness/release.md"
)

foreach ($path in $required) {
    if (-not (Test-RelativePath $path)) {
        Add-ErrorMessage "Missing required harness file: $path"
    }
}

foreach ($path in $recommended) {
    if (-not (Test-RelativePath $path)) {
        Add-WarningMessage "Missing recommended harness file: $path"
    }
}

if (Test-RelativePath "feature_list.json") {
    try {
        $featureState = Get-RelativeContent "feature_list.json" | ConvertFrom-Json
        if (-not $featureState.features) {
            Add-ErrorMessage "feature_list.json has no features array."
        } else {
            $active = @($featureState.features | Where-Object { $_.status -eq "in_progress" })
            if ($active.Count -gt 1) {
                Add-ErrorMessage "feature_list.json has more than one in_progress feature."
            }

            foreach ($feature in $featureState.features) {
                if (-not $feature.id) {
                    Add-ErrorMessage "A feature is missing id."
                }
                if (-not $feature.status) {
                    Add-ErrorMessage "Feature '$($feature.id)' is missing status."
                }
                if ($feature.status -eq "passing") {
                    $evidenceCount = @($feature.evidence).Count
                    if ($evidenceCount -eq 0) {
                        Add-ErrorMessage "Feature '$($feature.id)' is passing but has no evidence."
                    }
                }
                if ($feature.status -eq "blocked" -and [string]::IsNullOrWhiteSpace([string]$feature.notes)) {
                    Add-WarningMessage "Feature '$($feature.id)' is blocked but notes are empty."
                }
            }
        }
    } catch {
        Add-ErrorMessage "feature_list.json is not valid JSON: $($_.Exception.Message)"
    }
}

$placeholderPatterns = @(
    "replace with real",
    "# replace with",
    "replace-with-project-name",
    "TODO",
    "[TODO]",
    (-join @([char]0x5F85, [char]0x586B, [char]0x5199))
)

$filesToScan = @(
    "AGENTS.md",
    "feature_list.json",
    "progress.md",
    "session-handoff.md",
    "clean-state-checklist.md",
    "evaluator-rubric.md",
    "quality-document.md",
    "harness/env.md",
    "harness/build.md",
    "harness/run.md",
    "harness/test.md",
    "harness/quality.md",
    "harness/release.md"
)

foreach ($path in $filesToScan) {
    if (-not (Test-RelativePath $path)) {
        continue
    }

    $content = Get-RelativeContent $path
    foreach ($pattern in $placeholderPatterns) {
        if ($content.Contains($pattern)) {
            Add-WarningMessage "Placeholder remains in ${path}: $pattern"
        }
    }
}

foreach ($path in @("harness/build.md", "harness/test.md")) {
    if (-not (Test-RelativePath $path)) {
        continue
    }

    $content = Get-RelativeContent $path
    $fence = -join @([char]96, [char]96, [char]96)
    if (-not $content.Contains($fence)) {
        Add-WarningMessage "$path should include a copyable command block."
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Errors:" -ForegroundColor Red
    foreach ($message in $errors) {
        Write-Host "  - $message" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($message in $warnings) {
        Write-Host "  - $message" -ForegroundColor Yellow
    }
}

if ($errors.Count -eq 0 -and ($warnings.Count -eq 0 -or -not $Strict)) {
    Write-Host "Harness check passed. Target: $targetRoot"
    exit 0
}

if ($Strict -and $warnings.Count -gt 0) {
    Write-Host "Strict mode failed because warnings are present." -ForegroundColor Red
}

exit 1
