$profile = "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"

if ($IsWindows) {
    $content = (Get-Content $profile) -replace '\s+#\[Windows\]' -notmatch '\s+#\[macOS\]'
    $core = '~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1'
    $native = '~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1' 
    Set-Content ($core, $native) $content
} elseif ($IsMacOS) {
    $content = (Get-Content $profile) -replace '\s+#\[macOS\]' -notmatch '\s+#\[Windows\]'
    $core = '/usr/local/microsoft/Microsoft.PowerShell_profile.ps1'
    Set-Content $core $content
}
