$profile = "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"
$content = (Get-Content $profile) -replace '\s+#\[Windows\]' -notmatch '\s+#\[macOS\]'
$coreDir = '~/Documents/PowerShell'
$nativeDir = '~/Documents/WindowsPowerShell'
$core = "$coreDir/Microsoft.PowerShell_profile.ps1"
$native = "$nativeDir/Microsoft.PowerShell_profile.ps1" 
New-Item -ItemType 'directory' $coreDir -Force | Out-Null
New-Item -ItemType 'directory' $nativeDir -Force | Out-Null
Set-Content ($core, $native) $content
