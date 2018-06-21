if ($IsWindows) {
    $shell = "$PSHOME/pwsh.exe" -replace '\\', '/'
    $settings = "$Env:AppData/Code/User/settings.json"
    $os = 'windows'
    $keep = '\s+//\[Windows\]'
    $discard = '\s+//\[macOS\]'
} elseif ($IsMacOS) {
    $shell = "$PSHOME/pwsh"
    $settings = '~/Library/Application Support/Code/User/settings.json'
    $os = 'osx'
    $keep = '\s+//\[macOS\]'
    $discard = '\s+//\[Windows\]'
}

$content = (Get-Content "$PSScriptRoot/settings.json") `
    -replace '("powershell\.powerShellExePath")\s*:\s*".*"', "`$1: `"$shell`"" `
    -replace "(`"terminal\.integrated\.shell\.$os`")\s*:\s*`".*`"", "`$1: `"$shell`"" `
    -replace $keep -notmatch $discard |
    Set-Content $settings
