<#
.SYNOPSIS
Configure operation for SSH.
#>

if (!(Test-Path "$Env:UserProfile/.ssh")) {
    Write-Warning 'Directory [~/.ssh] doesn''t exist, creating...'
    New-Item -Type 'Directory' "$Env:UserProfile/.ssh"
}

Copy-Item "$PSScriptRoot/config" "$Env:UserProfile/.ssh/config"
