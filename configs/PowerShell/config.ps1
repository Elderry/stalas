if ($IsMacOS) {
    if ($(id -un) -ne 'root' ) {
        Write-Error 'This configuration requires root privilege.'
        exit
    }
}

$profile = "$PSScriptRoot/Microsoft.PowerShell_profile.ps1"
if ($IsWindows) {
    $content = (Get-Content $profile) -replace '\s+#\[Windows\]' -notmatch '\s+#\[macOS\]'
    $coreDir = '~/Documents/PowerShell'
    $nativeDir = '~/Documents/WindowsPowerShell'
    $core = "$coreDir/Microsoft.PowerShell_profile.ps1"
    $native = "$nativeDir/Microsoft.PowerShell_profile.ps1" 
    New-Item -ItemType 'directory' $coreDir -Force | Out-Null
    New-Item -ItemType 'directory' $nativeDir -Force | Out-Null
    Set-Content ($core, $native) $content
} elseif ($IsMacOS) {
    $content = (Get-Content $profile) -replace '\s+#\[macOS\]' -notmatch '\s+#\[Windows\]'
    $core = '~/.config/powershell/Microsoft.PowerShell_profile.ps1'
    New-Item -ItemType 'directory' '~/.config/powershell/' -Force | Out-Null
    Set-Content $core $content
}
