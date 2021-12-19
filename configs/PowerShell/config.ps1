<#
.SYNOPSIS
Configure operation for Windows PowerShell.
#>

$ProfileDir = '~/Documents/PowerShell'
if (!(Test-Path $ProfileDir)) { New-Item -ItemType 'Directory' $ProfileDir }

$ProfileName = 'Microsoft.PowerShell_profile.ps1'
Copy-Item "$PSScriptRoot/$ProfileName" "$ProfileDir/$ProfileName"
