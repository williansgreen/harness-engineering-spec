param(
    [string]$SkillValidatorPath = "",
    [string]$PythonPath = ""
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

function Get-PythonWithYaml([string]$Preferred) {
    # The validator needs PyYAML. Plain `python` may resolve to an
    # interpreter without it, and `py` follows the validator's
    # `#!/usr/bin/env python3` shebang straight back to whatever
    # `python3` happens to be first on PATH. Resolve a real interpreter
    # and prove it can import yaml before using it.
    $candidates = New-Object System.Collections.Generic.List[string]

    if (-not [string]::IsNullOrWhiteSpace($Preferred)) {
        $candidates.Add($Preferred) | Out-Null
    }

    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $pyExe = & py -3 -c "import sys; print(sys.executable)" 2>&1
        if ($LASTEXITCODE -eq 0 -and $pyExe) {
            $resolved = ($pyExe | Select-Object -Last 1).ToString().Trim()
            if ($resolved) { $candidates.Add($resolved) | Out-Null }
        }
    } catch {
    } finally {
        $ErrorActionPreference = $prevEap
    }

    foreach ($name in @("python", "python3")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd -and $cmd.Source) { $candidates.Add($cmd.Source) | Out-Null }
    }

    $localRoot = Join-Path $env:LOCALAPPDATA "Programs\Python"
    if (Test-Path -LiteralPath $localRoot) {
        Get-ChildItem -LiteralPath $localRoot -Filter "python.exe" -Recurse -Depth 1 -ErrorAction SilentlyContinue |
            ForEach-Object { $candidates.Add($_.FullName) | Out-Null }
    }

    foreach ($candidate in ($candidates | Select-Object -Unique)) {
        if (-not (Test-Path -LiteralPath $candidate)) { continue }
        $prevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            $null = & $candidate -c "import yaml" 2>&1
            $ok = ($LASTEXITCODE -eq 0)
        } catch {
            $ok = $false
        } finally {
            $ErrorActionPreference = $prevEap
        }
        if ($ok) { return $candidate }
    }

    return $null
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

$requiredSpecFiles = @(
    "docs/13-evaluation-records.md",
    "docs/14-harness-skill-boundary.md",
    "docs/15-loop-engineering.md",
    "templates/benchmark-record.md",
    "templates/feature-list.schema.json",
    "templates/harness-hardware-test.md",
    "templates/harness-protocol-replay.md",
    "templates/harness-ui-acceptance.md",
    "templates/harness-deployment-acceptance.md",
    "templates/harness-security-data.md",
    "templates/harness-update-evidence.ps1",
    "skills/csharp-winforms-wpf/references/project-setup-ci.md",
    "skills/csharp-winforms-wpf/references/feature-validation-checklists.md",
    "skills/csharp-winforms-wpf/references/runtime-workflow-loop-engineering.md",
    "skills/csharp-winforms-wpf/references/winforms-dpi-scaling.md",
    "skills/csharp-winforms-wpf/references/winforms-packaging-deployment.md",
    "skills/csharp-winforms-wpf/references/serial-protocol-replay.md",
    "skills/csharp-winforms-wpf/references/hardware-acceptance.md",
    "skills/csharp-winforms-wpf/references/medical-data-security.md",
    "skills/csharp-winforms-wpf/references/winforms-ipc-ui-acceptance.md",
    "skills/csharp-winforms-wpf/references/theme-design-tokens.md",
    "skills/csharp-winforms-wpf/assets/templates/winforms-mainform-layout.md",
    "skills/csharp-winforms-wpf/assets/templates/device-protocol-template.md"
)

foreach ($relativePath in $requiredSpecFiles) {
    $fullPath = Join-Path $repoRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-CheckError "Missing required spec file: $relativePath"
    }
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

$mirroredTemplates = @(
    @{
        Template = "templates/harness-git-save-feature.ps1"
        Mirrors = @(
            "examples/minimal-harness/harness/git-save-feature.ps1",
            "examples/csharp-instrument-harness/harness/git-save-feature.ps1"
        )
    },
    @{
        Template = "templates/harness-update-evidence.ps1"
        Mirrors = @(
            "examples/minimal-harness/harness/update-evidence.ps1",
            "examples/csharp-instrument-harness/harness/update-evidence.ps1"
        )
    }
)

foreach ($mirrorGroup in $mirroredTemplates) {
    $templatePath = Join-Path $repoRoot $mirrorGroup.Template
    if (-not (Test-Path -LiteralPath $templatePath)) {
        Add-CheckError "Missing mirrored template source: $($mirrorGroup.Template)"
        continue
    }
    $templateHash = (Get-FileHash -LiteralPath $templatePath -Algorithm SHA256).Hash
    foreach ($mirror in $mirrorGroup.Mirrors) {
        $mirrorPath = Join-Path $repoRoot $mirror
        if (-not (Test-Path -LiteralPath $mirrorPath)) {
            Add-CheckError "Missing mirrored template file: $mirror"
            continue
        }
        $mirrorHash = (Get-FileHash -LiteralPath $mirrorPath -Algorithm SHA256).Hash
        if ($templateHash -ne $mirrorHash) {
            Add-CheckError "Mirrored template is out of sync: $mirror"
        }
    }
}

if ([string]::IsNullOrWhiteSpace($SkillValidatorPath)) {
    $defaultValidator = Join-Path $env:USERPROFILE ".codex\skills\.system\skill-creator\scripts\quick_validate.py"
    if (Test-Path -LiteralPath $defaultValidator) {
        $SkillValidatorPath = $defaultValidator
    }
}

if (-not [string]::IsNullOrWhiteSpace($SkillValidatorPath)) {
    $skillsRoot = Join-Path $repoRoot "skills"
    $skillPaths = @()
    if (Test-Path -LiteralPath $skillsRoot) {
        $skillPaths = @(Get-ChildItem -LiteralPath $skillsRoot -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") } |
            ForEach-Object { $_.FullName })
    }
    if ($skillPaths.Count -eq 0) {
        Add-CheckWarning "No skills with SKILL.md found under skills/; skipped skill validation."
    }
    $python = Get-PythonWithYaml -Preferred $PythonPath
    if ($null -eq $python) {
        Add-CheckWarning "No Python with PyYAML found; skipped skill validation. Run 'pip install pyyaml' or pass -PythonPath."
    } else {
        foreach ($skillPath in $skillPaths) {
            $prevEap = $ErrorActionPreference
            $prevUtf8 = $env:PYTHONUTF8
            $ErrorActionPreference = 'Continue'
            # The validator opens files with Python's default encoding, which is
            # the ANSI code page on Windows (gbk on a zh-CN system). Skill docs are
            # UTF-8 and legitimately contain characters like em dashes, so force
            # UTF-8 mode rather than restricting what the docs may contain.
            $env:PYTHONUTF8 = '1'
            try {
                $validatorOutput = & $python $SkillValidatorPath $skillPath 2>&1
                $validatorExit = $LASTEXITCODE
            } finally {
                $ErrorActionPreference = $prevEap
                if ($null -eq $prevUtf8) {
                    Remove-Item Env:PYTHONUTF8 -ErrorAction SilentlyContinue
                } else {
                    $env:PYTHONUTF8 = $prevUtf8
                }
            }
            if ($validatorExit -ne 0) {
                # Take the message off each record; Out-String would drag in
                # CategoryInfo/FullyQualifiedErrorId noise around the real cause.
                $lines = @($validatorOutput | ForEach-Object {
                    if ($_ -is [System.Management.Automation.ErrorRecord]) {
                        $_.Exception.Message
                    } else {
                        $_.ToString()
                    }
                } | Where-Object { $_ -and $_.Trim() })
                $detail = ($lines -join "`n  ").Trim()
                if ($detail) {
                    Add-CheckError "Skill validation failed: $skillPath`n  $detail"
                } else {
                    Add-CheckError "Skill validation failed: $skillPath (exit $validatorExit)"
                }
            }
        }
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
