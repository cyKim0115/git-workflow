# git-workflow → project sync
# Copies Cursor rules + skills into the consuming project.
# Does NOT touch .cursor/rules/local/

param(
    [string]$ProjectRoot = ""
)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding $false

function Read-Utf8Text([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, $utf8)
}
function Write-Utf8Text([string]$Path, [string]$Text) {
    [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}

if (-not $ProjectRoot) {
    $packRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    $ProjectRoot = Resolve-Path (Join-Path $packRoot "../..")
} else {
    $ProjectRoot = Resolve-Path $ProjectRoot
    $packRoot = Join-Path $ProjectRoot ".cursor/git-workflow"
    if (-not (Test-Path $packRoot)) {
        $packRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
    }
}

$srcRules = Join-Path $packRoot "cursor/rules"
$srcSkills = Join-Path $packRoot "skills/project-workflows"
$dstRules = Join-Path $ProjectRoot ".cursor/rules"
$dstSkills = Join-Path $ProjectRoot ".cursor/skills/project-workflows"
$localRules = Join-Path $dstRules "local"
$stamp = Join-Path $dstRules ".git-workflow-sync.json"

if (-not (Test-Path $srcRules)) { throw "Source rules not found: $srcRules" }
if (-not (Test-Path $srcSkills)) { throw "Source skills not found: $srcSkills" }

New-Item -ItemType Directory -Force -Path $dstRules | Out-Null
New-Item -ItemType Directory -Force -Path $localRules | Out-Null
New-Item -ItemType Directory -Force -Path $dstSkills | Out-Null

# Replace synced rule files only
@(
    "korean-git-commit.mdc",
    "git-commit-on-finish.mdc"
) | ForEach-Object {
    $p = Join-Path $dstRules $_
    if (Test-Path $p) { Remove-Item $p -Force }
    Copy-Item (Join-Path $srcRules $_) $dstRules -Force
}

# Replace synced skill tree under project-workflows (pack-owned names only)
@(
    "SKILL.md",
    "korean-git-commit",
    "grouped-git-commit"
) | ForEach-Object {
    $target = Join-Path $dstSkills $_
    if (Test-Path $target) { Remove-Item $target -Recurse -Force }
    $source = Join-Path $srcSkills $_
    if (Test-Path $source -PathType Container) {
        Copy-Item $source $target -Recurse -Force
    } else {
        Copy-Item $source $target -Force
    }
}

$versionFile = Join-Path $packRoot "VERSION"
$version = if (Test-Path $versionFile) { (Read-Utf8Text $versionFile).Trim() } else { "unknown" }
$meta = @{
    syncedAt = (Get-Date).ToString("o")
    version  = $version
    packPath = ".cursor/git-workflow"
} | ConvertTo-Json
Write-Utf8Text $stamp $meta

Write-Host "Synced git-workflow $version → rules + skills"
Write-Host "Local overrides preserved under $localRules"
