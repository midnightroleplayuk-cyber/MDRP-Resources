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

Write-Host "Applying GitHub version of tracked files..."
git -C $RepoPath reset --hard origin/main
if ($LASTEXITCODE -ne 0) { throw "Git reset failed." }

Write-Host "Deployment complete. Tracked files now match GitHub."
Write-Host "Untracked files were not intentionally cleaned. FiveM was not restarted."