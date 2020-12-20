<#
.SYNOPSIS
Configure operation for Windows PowerShell.
#>

$coreDir = '~/Documents/PowerShell'
if (!(Test-Path $coreDir)) { New-Item -ItemType 'Directory' $coreDir }
$nativeDir = '~/Documents/WindowsPowerShell'
if (!(Test-Path $nativeDir)) { New-Item -ItemType 'Directory' $nativeDir }

$profileName = 'Microsoft.PowerShell_profile.ps1'
$content = Get-Content "$PSScriptRoot/$profileName"
Set-Content ("$coreDir/$profileName", "$nativeDir/$profileName") $content
