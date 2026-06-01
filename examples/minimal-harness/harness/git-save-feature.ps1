param(
    [Parameter(Mandatory = $true)]
    [string]$Message,

    [string[]]$Paths = @(),

    [switch]$All,

    [string[]]$VerifyCommand = @(),

    [switch]$VerificationAlreadyRun,

    [switch]$Wip,

    [switch]$DryRun,

    [string]$EvidenceFeatureId = "",

    [ValidateSet("build", "test", "quality", "run", "manual", "substitute", "artifact", "review")]
    [string]$EvidenceType = "review",

    [string]$EvidenceNotes = "",

    [string]$FeatureListPath = "feature_list.json",

    [switch]$RecordProgress,

    [switch]$RecordHandoff
)

$ErrorActionPreference = "Stop"

function Invoke-GitCommand([string[]]$Arguments) {
    & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed: git $($Arguments -join ' ')"
    }
}

function Get-GitLines([string[]]$Arguments) {
    $output = & git @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Git command failed: git $($Arguments -join ' ')"
    }
    if ($null -eq $output) {
        return @()
    }
    return @($output)
}

function Test-PathInsideRepo([string]$Path, [string]$RepoRoot) {
    if ([string]::IsNullOrWhiteSpace($Path)) {
        throw "Empty path is not allowed."
    }

    if ([System.IO.Path]::IsPathRooted($Path)) {
        $candidate = [System.IO.Path]::GetFullPath($Path)
    } else {
        $candidate = [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $Path))
    }

    $rootWithSlash = $RepoRoot.TrimEnd([char[]]"\/") + [System.IO.Path]::DirectorySeparatorChar
    if (-not ($candidate.Equals($RepoRoot, [System.StringComparison]::OrdinalIgnoreCase) -or $candidate.StartsWith($rootWithSlash, [System.StringComparison]::OrdinalIgnoreCase))) {
        throw "Path is outside the repository: $Path"
    }
}

function Add-CheckpointRecord([string]$Path, [string]$Hash, [string]$CommitMessage) {
    if (-not (Test-Path -LiteralPath $Path)) {
        Write-Warning "Record target not found: $Path"
        return
    }

    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $content = Get-Content -Raw -LiteralPath $Path
    if (-not $content.Contains("## Git Checkpoints")) {
        Add-Content -LiteralPath $Path -Value ""
        Add-Content -LiteralPath $Path -Value "## Git Checkpoints"
    }
    Add-Content -LiteralPath $Path -Value "- $timestamp $Hash $CommitMessage"
}

$repoRoot = (& git rev-parse --show-toplevel 2>$null)
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($repoRoot)) {
    throw "This command must run inside a Git repository."
}
$repoRoot = [System.IO.Path]::GetFullPath($repoRoot)
Set-Location $repoRoot

if ($All -and $Paths.Count -gt 0) {
    throw "Use either -Paths or -All, not both."
}

if (-not $All -and $Paths.Count -eq 0) {
    throw "Provide explicit -Paths for this checkpoint, or use -All only after reviewing every dirty file."
}

if (-not $All) {
    foreach ($path in $Paths) {
        Test-PathInsideRepo $path $repoRoot
    }
}

$existingStaged = Get-GitLines @("diff", "--cached", "--name-only")
if ($existingStaged.Count -gt 0) {
    throw "Staged changes already exist. Unstage them before using this helper so unrelated work is not committed."
}

if ($DryRun) {
    Write-Host "[dry-run] Message: $Message"
    if ($All) {
        Write-Host "[dry-run] Would stage all reviewed dirty files."
    } else {
        Write-Host "[dry-run] Would stage: $($Paths -join ', ')"
    }
    if ($VerifyCommand.Count -gt 0) {
        foreach ($command in $VerifyCommand) {
            Write-Host "[dry-run] Would run verification: $command"
        }
    } elseif ($VerificationAlreadyRun) {
        Write-Host "[dry-run] Verification marked as already run."
    } elseif ($Wip) {
        Write-Host "[dry-run] WIP commit requested."
    }
    exit 0
}

if ($VerifyCommand.Count -gt 0) {
    foreach ($command in $VerifyCommand) {
        Write-Host "[verify] $command"
        & powershell -NoProfile -ExecutionPolicy Bypass -Command $command
        if ($LASTEXITCODE -ne 0) {
            if ($Wip) {
                Write-Warning "Verification failed but -Wip was set: $command"
            } else {
                throw "Verification failed: $command"
            }
        }
    }
} elseif (-not $VerificationAlreadyRun -and -not $Wip) {
    throw "Run verification first, pass -VerifyCommand, or pass -VerificationAlreadyRun. Use -Wip only for explicitly requested WIP commits."
}

$evidenceUpdated = $false
$originalFeatureListContent = $null
$featureListFullPath = $null

if (-not [string]::IsNullOrWhiteSpace($EvidenceFeatureId)) {
    $evidenceScript = Join-Path $PSScriptRoot "update-evidence.ps1"
    if (-not (Test-Path -LiteralPath $evidenceScript)) {
        throw "Evidence script not found: $evidenceScript"
    }

    Test-PathInsideRepo $FeatureListPath $repoRoot
    if ([System.IO.Path]::IsPathRooted($FeatureListPath)) {
        $featureListFullPath = [System.IO.Path]::GetFullPath($FeatureListPath)
    } else {
        $featureListFullPath = [System.IO.Path]::GetFullPath((Join-Path $repoRoot $FeatureListPath))
    }
    $originalFeatureListContent = Get-Content -Raw -LiteralPath $featureListFullPath

    $evidenceResult = if ($Wip) { "partial" } else { "passed" }
    $notes = $EvidenceNotes
    if ([string]::IsNullOrWhiteSpace($notes)) {
        $notes = "Git checkpoint evidence for: $Message"
    }
    & $evidenceScript -FeatureListPath $FeatureListPath -FeatureId $EvidenceFeatureId -Type $EvidenceType -Result $evidenceResult -Command "git commit -m `"$Message`"" -Notes $notes
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to record feature evidence for $EvidenceFeatureId."
    }
    $evidenceUpdated = $true

    if (-not $All -and $Paths -notcontains $FeatureListPath) {
        $Paths = @($Paths) + $FeatureListPath
    }
}

Write-Host "[status before]"
Invoke-GitCommand @("status", "--short")

$stagedByHelper = $false
$commitCreated = $false

try {
    if ($All) {
        Write-Host "[stage] git add -A"
        Invoke-GitCommand @("add", "-A")
    } else {
        Write-Host "[stage] $($Paths -join ', ')"
        Invoke-GitCommand (@("add", "--") + $Paths)
    }
    $stagedByHelper = $true

    $stagedFiles = Get-GitLines @("diff", "--cached", "--name-only")
    if ($stagedFiles.Count -eq 0) {
        throw "No staged changes to commit."
    }

    $blockedPatterns = @(
        "(^|/)(bin|obj|\.vs|TestResults|packages)/",
        "(^|/)\.env($|\.)",
        "\.(log|tmp|bak|pdb|ilk|suo|user|pfx|pem|key)$"
    )

    $blockedFiles = New-Object System.Collections.Generic.List[string]
    foreach ($file in $stagedFiles) {
        $normalized = $file -replace "\\", "/"
        foreach ($pattern in $blockedPatterns) {
            if ($normalized -match $pattern) {
                $blockedFiles.Add($file) | Out-Null
                break
            }
        }
    }

    if ($blockedFiles.Count -gt 0) {
        Invoke-GitCommand @("reset", "--cached", "--")
        $stagedByHelper = $false
        throw "Refusing to commit generated, local, or sensitive-looking files: $($blockedFiles -join ', ')"
    }

    Write-Host "[staged files]"
    foreach ($file in $stagedFiles) {
        Write-Host "  $file"
    }

    if ($Wip -and $Message -notmatch "(?i)\bwip\b") {
        Write-Warning "This is a WIP commit, but the message does not contain 'WIP'."
    }

    Invoke-GitCommand @("commit", "-m", $Message)
    $stagedByHelper = $false
    $commitCreated = $true
    $hash = (Get-GitLines @("rev-parse", "--short", "HEAD") | Select-Object -First 1)
    Write-Host "[commit] $hash"

    if ($RecordProgress) {
        Add-CheckpointRecord "progress.md" $hash $Message
        Write-Warning "progress.md was updated after the commit. Commit or discard that state change separately."
    }

    if ($RecordHandoff) {
        Add-CheckpointRecord "session-handoff.md" $hash $Message
        Write-Warning "session-handoff.md was updated after the commit. Commit or discard that state change separately."
    }
} catch {
    if ($stagedByHelper) {
        Write-Warning "Commit failed after staging. Unstaging helper-managed files."
        Invoke-GitCommand @("reset", "--cached", "--")
    }
    if ($evidenceUpdated -and -not $commitCreated -and $null -ne $originalFeatureListContent -and $null -ne $featureListFullPath) {
        Write-Warning "Restoring feature_list.json because the checkpoint did not complete."
        Set-Content -LiteralPath $featureListFullPath -Value $originalFeatureListContent
    }
    throw
}
