# Install git-workflow as a git submodule into a consumer project.
param(
    [string]$PackUrl = "",
    [string]$TargetPath = ".cursor/git-workflow"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = (Get-Location).Path

if (-not (Test-Path (Join-Path $ProjectRoot ".git"))) {
    throw "Run this from a git repository root."
}

if (-not $PackUrl) {
    $sibling = Join-Path $ProjectRoot "../git-workflow"
    if (Test-Path (Join-Path $sibling ".git")) {
        $PackUrl = (Resolve-Path $sibling).Path -replace '\\', '/'
        Write-Host "Using local sibling repo: $PackUrl"
    } else {
        throw "Pass -PackUrl (git remote) or place git-workflow as sibling ../git-workflow"
    }
}

New-Item -ItemType Directory -Force -Path (Join-Path $ProjectRoot ".cursor") | Out-Null

if (Test-Path (Join-Path $ProjectRoot $TargetPath)) {
    Write-Host "Target already exists: $TargetPath — skipping submodule add"
} else {
    git -c protocol.file.allow=always submodule add --force $PackUrl $TargetPath
}

git -c protocol.file.allow=always submodule update --init --recursive
$sync = Join-Path $ProjectRoot "$TargetPath/scripts/sync-to-project.ps1"
& powershell.exe -NoProfile -File $sync -ProjectRoot $ProjectRoot

Write-Host "Done. Commit .gitmodules, $TargetPath, synced rules/skills when ready."
