$profile = "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"
$core = "$Env:UserProfile/Documents/PowerShell"
$native = "$Env:UserProfile/Documents/WindowsPowerShell"
Copy-Item $profile $core
Copy-Item $profile $native
