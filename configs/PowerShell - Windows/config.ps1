<#
.SYNOPSIS
Configure operation for Windows PowerShell.
#>

$coreDir = '~/Documents/PowerShell'
$nativeDir = '~/Documents/WindowsPowerShell'
New-Item -ItemType 'directory' ($coreDir, $nativeDir) -Force | Out-Null

$content = Get-Content "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"
$core = "$coreDir/Microsoft.PowerShell_profile.ps1"
$native = "$nativeDir/Microsoft.PowerShell_profile.ps1" 
Set-Content ($core, $native) $content
