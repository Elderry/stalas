$nativeProfile = Join-Path $Env:UserProfile 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
$coreProfile = Join-Path $Env:UserProfile 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
Copy-Item "$PSScriptRoot/../Settings/Powershell.ps1" $nativeProfile
Copy-Item "$PSScriptRoot/../Settings/Powershell.ps1" $coreProfile
