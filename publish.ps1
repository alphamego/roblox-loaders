# Run after: gh auth login
$ErrorActionPreference = "Stop"
$gh = "$env:ProgramFiles\GitHub CLI\gh.exe"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoName = if ($args[0]) { $args[0] } else { "roblox-loaders" }

Set-Location $root

& $gh auth status
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}
git add vader_loader.lua vader.lua vader_execute.lua velocity_loader.lua kurumi_linoria_loader.lua README.md
git commit -m "Add Roblox UI loaders (Vader, Velocity, Kurumi)" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Nothing new to commit or commit failed."
}

$user = & $gh api user --jq ".login"
& $gh repo create $repoName --private --source=. --remote=origin --push 2>&1
if ($LASTEXITCODE -ne 0) {
    git remote add origin "https://github.com/$user/$repoName.git" 2>$null
    git push -u origin main
}

$base = "https://raw.githubusercontent.com/$user/$repoName/main"
Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Write-Host "Repo: https://github.com/$user/$repoName"
Write-Host ""
Write-Host "Executor one-liner:"
Write-Host "loadstring(game:HttpGet(""$base/vader_loader.lua""))()"
