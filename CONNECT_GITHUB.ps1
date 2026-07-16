# Connect GitHub + publish loaders (private repo: roblox-loaders)
# Run in PowerShell:  .\CONNECT_GITHUB.ps1

$ErrorActionPreference = "Stop"
$gh = "$env:ProgramFiles\GitHub CLI\gh.exe"
$root = $PSScriptRoot
$repoName = "roblox-loaders"

Set-Location $root

Write-Host "`n=== Step 1: GitHub login ===" -ForegroundColor Cyan
& $gh auth status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Browser will open. Enter the code shown below at https://github.com/login/device"
    & $gh auth login -h github.com -p https -w
}

$user = & $gh api user --jq ".login"
$email = "$user@users.noreply.github.com"
Write-Host "Logged in as: $user" -ForegroundColor Green

Write-Host "`n=== Step 2: Git commit ===" -ForegroundColor Cyan
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}
$env:GIT_AUTHOR_NAME = $user
$env:GIT_COMMITTER_NAME = $user
$env:GIT_AUTHOR_EMAIL = $email
$env:GIT_COMMITTER_EMAIL = $email

git add vader_loader.lua vader.lua vader_execute.lua velocity_loader.lua kurumi_linoria_loader.lua README.md publish.ps1 CONNECT_GITHUB.ps1
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "Add Roblox UI loaders"
} else {
    Write-Host "Already committed."
}

Write-Host "`n=== Step 3: Create PRIVATE repo + push ===" -ForegroundColor Cyan
& $gh repo view "$user/$repoName" 2>$null
if ($LASTEXITCODE -ne 0) {
    & $gh repo create $repoName --private --source=. --remote=origin --push
} else {
    git push -u origin main
}

Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "Repo: https://github.com/$user/$repoName (private)"
Write-Host ""
Write-Host "IMPORTANT: Private repos cannot be loaded with game:HttpGet from executors." -ForegroundColor Yellow
Write-Host "Use readfile in executor workspace, OR make repo public for HttpGet one-liners."
Write-Host ""
Write-Host "Local executor:"
Write-Host '  loadstring(readfile("vader_loader.lua"))()'
Write-Host ""
Write-Host "If you make the repo public later, raw URL:"
Write-Host "  https://raw.githubusercontent.com/$user/$repoName/main/vader_loader.lua"
