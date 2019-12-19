if ($IsWindows) {
    $shell = "$PSHOME/pwsh.exe" -replace '\\', '/'
    $settings = "$Env:AppData/Code/User/settings.json"
    $os = 'windows'
    $keep = '\s+//\[Windows\]'
    $discard = '\s+//\[macOS\]'
} elseif ($IsMacOS) {
    $shell = "$PSHOME/pwsh"
    $user ='~/Library/Application Support/Code/User'
    $settings = "$user/settings.json"
    $keybindings = "$user/keybindings.json"
    $os = 'osx'
    $keep = '\s+//\[macOS\]'
    $discard = '\s+//\[Windows\]'
}

$content = (Get-Content "$PSScriptRoot/settings.json") `
    -replace $keep -notmatch $discard |
    Set-Content $settings
