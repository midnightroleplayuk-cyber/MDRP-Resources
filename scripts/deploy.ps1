

$ErrorActionPreference = "Stop"

$RepoPath = "C:\Users\Administrator\Desktop\devserver\resources"

Write-Host "Fetching latest changes from GitHub..."
git -C $RepoPath fetch origin main
if ($LASTEXITCODE -ne 0) { throw "Fetch failed." }

$LocalCommit = git -C $RepoPath rev-parse HEAD
$RemoteCommit = git -C $RepoPath rev-parse origin/main
if ($LASTEXITCODE -ne 0) { throw "Could not identify commits." }

if ($LocalCommit -eq $RemoteCommit) {
    Write-Host "Already up to date. Nothing to deploy."
    exit 0
}

$Ahead = git -C $RepoPath rev-list --count origin/main..HEAD
if ($LASTEXITCODE -ne 0) { throw "Could not compare commits." }
if ([int]$Ahead -gt 0) {
    throw "Deployment stopped: VPS has commits not present on GitHub."
}

Write-Host "Downloading Git LFS objects..."
git -C $RepoPath lfs fetch origin main
if ($LASTEXITCODE -ne 0) { throw "LFS fetch failed." }

$PreservedConfigDirs = @(
    "[medical]/osp_ambulance/config"
)

$BackupRoot = Join-Path $env:TEMP ("mdrp-config-backup-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
$PreservedFiles = @()

foreach ($Dir in $PreservedConfigDirs) {
    $Changed = git -C $RepoPath --literal-pathspecs diff --name-only HEAD -- $Dir
    if ($LASTEXITCODE -ne 0) { throw "Could not check for server-side config changes in $Dir." }

    foreach ($RelPath in @($Changed | Where-Object { $_ })) {
        $Source = Join-Path $RepoPath $RelPath
        if (-not (Test-Path -LiteralPath $Source)) { continue }

        $Dest = Join-Path $BackupRoot $RelPath
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $Dest -Parent) | Out-Null
        Copy-Item -LiteralPath $Source -Destination $Dest -Force
        $PreservedFiles += $RelPath
        Write-Host "Preserving server-side config: $RelPath"
    }
}

Write-Host "Applying GitHub version of tracked files..."
git -C $RepoPath reset --hard origin/main
if ($LASTEXITCODE -ne 0) {
    if ($PreservedFiles.Count -gt 0) { Write-Host "Config backups kept at: $BackupRoot" }
    throw "Git reset failed."
}

foreach ($RelPath in $PreservedFiles) {
    Copy-Item -LiteralPath (Join-Path $BackupRoot $RelPath) -Destination (Join-Path $RepoPath $RelPath) -Force
    Write-Host "Restored server-side config: $RelPath"
}

if ($PreservedFiles.Count -gt 0) {
    Write-Host "Config backups also kept at: $BackupRoot"
}

Write-Host "Deployment complete. Tracked files now match GitHub (except preserved server-side configs)."
Write-Host "Untracked files were not intentionally cleaned. FiveM was not restarted."

