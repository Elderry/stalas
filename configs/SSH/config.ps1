<#
.SYNOPSIS
Configure operation for SSH.
#>

if (!(Test-Path "$Env:HOME/.ssh")) {
    Write-Warning 'Directory [~/.ssh] doesn''t exist, creating...'
    New-Item -Type 'Directory' "$Env:Home/.ssh"
}

Copy-Item "$PSScriptRoot/config" "$Env:HOME/.ssh/config"
