<#
.SYNOPSIS
Configure operation for Windows PowerShell.
#>

$ProfileDir = '~/Documents/PowerShell'
if (!(Test-Path $ProfileDir)) { New-Item -ItemType 'Directory' $ProfileDir }

$profileName = 'Microsoft.PowerShell_profile.ps1'
$content = Get-Content "$PSScriptRoot/$profileName"
Set-Content "$coreDir/$profileName" $content
