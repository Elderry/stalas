$nativeProfile = Join-Path $Env:UserProfile 'Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
$coreProfile = Join-Path $Env:UserProfile 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
Copy-Item 'Profile - Powershell.ps1' $nativeProfile
Copy-Item 'Profile - Powershell.ps1' $coreProfile
