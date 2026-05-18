param(
    [switch]$RunTests
)

$ErrorActionPreference = "Stop"

Write-Host "Harness startup check"

$required = @(
    "AGENTS.md",
    "feature_list.json",
    "progress.md",
    "harness/build.md",
    "harness/test.md"
)

foreach ($path in $required) {
    if (-not (Test-Path $path)) {
        Write-Warning "Missing required harness file: $path"
    }
}

if (Test-Path "harness/build.md") {
    Write-Host "Read harness/build.md for the project build command."
}

if ($RunTests -and (Test-Path "harness/test.md")) {
    Write-Host "Run the project-specific test command from harness/test.md."
}

