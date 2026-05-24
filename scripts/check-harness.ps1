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

function Get-PropertyItemCount([object]$Object, [string]$PropertyName) {
    if ($null -eq $Object) {
        return 0
    }
    $property = $Object.PSObject.Properties[$PropertyName]
    if ($null -eq $property -or $null -eq $property.Value) {
        return 0
    }
    return @($property.Value).Count
}

function Get-PropertyValue([object]$Object, [string]$PropertyName) {
    if ($null -eq $Object) {
        return $null
    }

    $property = $Object.PSObject.Properties[$PropertyName]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function Test-HasProperty([object]$Object, [string]$PropertyName) {
    if ($null -eq $Object) {
        return $false
    }

    return $null -ne $Object.PSObject.Properties[$PropertyName]
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
    "feature-list.schema.json",
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
        $allowedStatuses = @("not_started", "in_progress", "blocked", "passing")
        $allowedRiskLevels = @("low", "medium", "high", "critical")
        $allowedEvidenceResults = @("passed", "failed", "blocked", "not_run", "partial")

        if (-not (Test-HasProperty $featureState "last_updated") -or [string]::IsNullOrWhiteSpace([string](Get-PropertyValue $featureState "last_updated"))) {
            Add-WarningMessage "feature_list.json is missing last_updated."
        } elseif (-not ([string](Get-PropertyValue $featureState "last_updated") -match '^\d{4}-\d{2}-\d{2}$')) {
            Add-WarningMessage "feature_list.json last_updated should use YYYY-MM-DD."
        }

        if (-not $featureState.features) {
            Add-ErrorMessage "feature_list.json has no features array."
        } else {
            $active = @($featureState.features | Where-Object { $_.status -eq "in_progress" })
            if ($active.Count -gt 1) {
                Add-ErrorMessage "feature_list.json has more than one in_progress feature."
            }

            $featureIds = @{}
            foreach ($feature in $featureState.features) {
                if (-not $feature.id) {
                    Add-ErrorMessage "A feature is missing id."
                } elseif ($featureIds.ContainsKey([string]$feature.id)) {
                    Add-ErrorMessage "Duplicate feature id: $($feature.id)."
                } else {
                    $featureIds[[string]$feature.id] = $true
                }
                if (-not $feature.status) {
                    Add-ErrorMessage "Feature '$($feature.id)' is missing status."
                } elseif ($allowedStatuses -notcontains $feature.status) {
                    Add-ErrorMessage "Feature '$($feature.id)' has unsupported status '$($feature.status)'. Allowed: $($allowedStatuses -join ', ')."
                }
                if (-not (Test-HasProperty $feature "risk_level")) {
                    Add-WarningMessage "Feature '$($feature.id)' is missing risk_level."
                } elseif ($allowedRiskLevels -notcontains $feature.risk_level) {
                    Add-ErrorMessage "Feature '$($feature.id)' has unsupported risk_level '$($feature.risk_level)'. Allowed: $($allowedRiskLevels -join ', ')."
                }
                if (-not (Test-HasProperty $feature "hardware_required")) {
                    Add-WarningMessage "Feature '$($feature.id)' is missing hardware_required."
                } elseif (-not ($feature.hardware_required -is [bool])) {
                    Add-ErrorMessage "Feature '$($feature.id)' hardware_required must be true or false."
                }
                if (-not (Test-HasProperty $feature "simulation_strategy") -or [string]::IsNullOrWhiteSpace([string]$feature.simulation_strategy)) {
                    Add-WarningMessage "Feature '$($feature.id)' is missing simulation_strategy."
                }
                $verificationCount = Get-PropertyItemCount $feature "verification"
                if ($verificationCount -eq 0) {
                    Add-WarningMessage "Feature '$($feature.id)' has no verification requirements."
                }
                $evidenceItems = @()
                if (Test-HasProperty $feature "evidence") {
                    $evidenceItems = @($feature.evidence)
                }
                foreach ($evidence in $evidenceItems) {
                    if ($evidence -is [string]) {
                        Add-WarningMessage "Feature '$($feature.id)' has string evidence; use structured evidence objects."
                        continue
                    }

                    foreach ($requiredEvidenceField in @("type", "result", "notes")) {
                        if (-not (Test-HasProperty $evidence $requiredEvidenceField) -or [string]::IsNullOrWhiteSpace([string](Get-PropertyValue $evidence $requiredEvidenceField))) {
                            Add-WarningMessage "Feature '$($feature.id)' evidence item is missing $requiredEvidenceField."
                        }
                    }

                    $evidenceResult = [string](Get-PropertyValue $evidence "result")
                    if (-not [string]::IsNullOrWhiteSpace($evidenceResult) -and $allowedEvidenceResults -notcontains $evidenceResult) {
                        Add-ErrorMessage "Feature '$($feature.id)' evidence result '$evidenceResult' is unsupported. Allowed: $($allowedEvidenceResults -join ', ')."
                    }
                }
                if ($feature.status -eq "passing") {
                    $evidenceCount = Get-PropertyItemCount $feature "evidence"
                    if ($evidenceCount -eq 0) {
                        Add-ErrorMessage "Feature '$($feature.id)' is passing but has no evidence."
                    } else {
                        $passedEvidence = @($evidenceItems | Where-Object { $_ -isnot [string] -and (Get-PropertyValue $_ "result") -eq "passed" })
                        if ($passedEvidence.Count -eq 0) {
                            Add-WarningMessage "Feature '$($feature.id)' is passing but has no structured evidence with result 'passed'."
                        }
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
