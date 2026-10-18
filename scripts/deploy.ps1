$ErrorActionPreference = "Stop"

$RepoPath = "C:\Users\Administrator\Desktop\devserver\resources"

Write-Host "Checking repository..."
git -C $RepoPath status --short
if ($LASTEXITCODE -ne 0) { throw "Could not check repository status." }

$Changes = git -C $RepoPath status --porcelain
if ($LASTEXITCODE -ne 0) { throw "Could not read repository status." }
if ($Changes) { throw "Deployment stopped: the working tree is not clean. No files were changed." }

Write-Host "Fetching latest changes from GitHub..."
git -C $RepoPath fetch origin main
if ($LASTEXITCODE -ne 0) { throw "Fetch failed. No deployment performed." }

$LocalCommit = git -C $RepoPath rev-parse HEAD
$RemoteCommit = git -C $RepoPath rev-parse origin/main
if ($LASTEXITCODE -ne 0) { throw "Could not identify commits." }

if ($LocalCommit -eq $RemoteCommit) {
    Write-Host "Already up to date. Nothing to deploy."
    exit 0
}

$Behind = git -C $RepoPath rev-list --count HEAD..origin/main
$Ahead = git -C $RepoPath rev-list --count origin/main..HEAD
if ($LASTEXITCODE -ne 0) { throw "Could not compare commits." }
if ([int]$Ahead -gt 0) { throw "Deployment stopped: local branch has commits not on GitHub." }

Write-Host "Checking Git LFS objects..."
git -C $RepoPath lfs fetch origin main
if ($LASTEXITCODE -ne 0) { throw "LFS fetch failed. No deployment performed." }

Write-Host "Updating tracked files..."
git -C $RepoPath merge --ff-only origin/main
if ($LASTEXITCODE -ne 0) { throw "Fast-forward update failed. Review repository state." }

Write-Host "Deployment files updated. FiveM was not restarted."
