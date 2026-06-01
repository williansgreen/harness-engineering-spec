param(
    [string]$FeatureListPath = "feature_list.json",

    [Parameter(Mandatory = $true)]
    [string]$FeatureId,

    [Parameter(Mandatory = $true)]
    [ValidateSet("build", "test", "quality", "run", "manual", "substitute", "artifact", "review")]
    [string]$Type,

    [Parameter(Mandatory = $true)]
    [ValidateSet("passed", "failed", "blocked", "not_run", "partial")]
    [string]$Result,

    [string]$Command = "",

    [string]$Artifact = "",

    [Parameter(Mandatory = $true)]
    [string]$Notes,

    [ValidateSet("", "not_started", "in_progress", "blocked", "passing")]
    [string]$Status = "",

    [string]$Timestamp = "",

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $FeatureListPath)) {
    throw "Feature list not found: $FeatureListPath"
}

if ([string]::IsNullOrWhiteSpace($Timestamp)) {
    $Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}

if ($Notes.Length -gt 500) {
    Write-Warning "Evidence notes are longer than 500 characters. Prefer concise restartable evidence."
}

$featureList = Get-Content -Raw -LiteralPath $FeatureListPath | ConvertFrom-Json
if (-not $featureList.features) {
    throw "feature_list.json has no features array."
}

$targetFeature = $featureList.features | Where-Object { $_.id -eq $FeatureId } | Select-Object -First 1
if ($null -eq $targetFeature) {
    $knownIds = @($featureList.features | ForEach-Object { $_.id }) -join ", "
    throw "Feature id '$FeatureId' was not found. Known ids: $knownIds"
}

$evidence = [ordered]@{
    type = $Type
    result = $Result
    timestamp = $Timestamp
    notes = $Notes
}

if (-not [string]::IsNullOrWhiteSpace($Command)) {
    $evidence.command = $Command
}

if (-not [string]::IsNullOrWhiteSpace($Artifact)) {
    $evidence.artifact = $Artifact
}

if ($null -eq $targetFeature.PSObject.Properties["evidence"]) {
    $targetFeature | Add-Member -MemberType NoteProperty -Name "evidence" -Value @()
}

$targetFeature.evidence = @($targetFeature.evidence) + ([pscustomobject]$evidence)

if (-not [string]::IsNullOrWhiteSpace($Status)) {
    $targetFeature.status = $Status
}

if ($null -eq $featureList.PSObject.Properties["last_updated"]) {
    $featureList | Add-Member -MemberType NoteProperty -Name "last_updated" -Value (Get-Date -Format "yyyy-MM-dd")
} else {
    $featureList.last_updated = Get-Date -Format "yyyy-MM-dd"
}

$json = $featureList | ConvertTo-Json -Depth 20

if ($DryRun) {
    Write-Host "[dry-run] Would append evidence to $FeatureListPath"
    Write-Host ($evidence | ConvertTo-Json -Depth 5)
    if (-not [string]::IsNullOrWhiteSpace($Status)) {
        Write-Host "[dry-run] Would set feature '$FeatureId' status to '$Status'"
    }
    exit 0
}

Set-Content -LiteralPath $FeatureListPath -Value $json
Write-Host "[evidence] $FeatureId $Type/$Result"
