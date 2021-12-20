<#
.SYNOPSIS
Install stalas into current machine.
#>

Write-Host '-----Configure OneDrivePath-----' -ForegroundColor 'Green'
$OneDrivePath = [Environment]::GetEnvironmentVariable('OneDrive')
if (!$OneDrivePath) {
    $OneDrivePath = '~/OneDrive'
}
if (!(Test-Path $OneDrivePath)) {
    Write-Error "OneDrivePath [$OneDrivePath] does not exist, exiting..."
    exit
}
Write-Host "OneDrivePath is [$OneDrivePath]"

Write-Host '-----Configure SSH-----' -ForegroundColor 'Green'
$SSHConfigFileContent = "IdentityFile = $OneDrivePath/Collections/AppBackup/SSH/lry_rsa`n"
if (!(Test-Path "$Env:UserProfile/.ssh")) {
    Write-Warning 'Directory [~/.ssh] doesn''t exist, creating...'
    New-Item -Type 'Directory' "$Env:UserProfile/.ssh"
}
Set-Content -Value $SSHConfigFileContent -Path "$Env:UserProfile/.ssh/config"
Write-Host 'SSH configured, testing...'
$Response = ssh -T 'git@github.com' 2>&1
if ($Response.Exception.Message.Contains('successfully authenticated')) {
    Write-Host 'SSH test passed'
} else {
    Write-Error "SSH test failed, with response of [$Response], exiting..."
    exit
}

Write-Host '-----Clone Repository-----' -ForegroundColor 'Green'
if (Test-Path './stalas') {
    Write-Warning 'Repository already cloned, skipping...'
} else {
    git clone 'git@github.com:Elderry/stalas.git'
}


Write-Host '-----Configure Environment Variable-----' -ForegroundColor 'Green'
$ProjectPath = Join-Path $PSScriptRoot 'stalas'
$Path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (!$Path.Contains($PSScriptRoot)) {
    [Environment]::SetEnvironmentVariable("Path", "$Path;$ProjectPath", 'User')
}

Write-Host '-----Installation Complete-----' -ForegroundColor 'Green'
