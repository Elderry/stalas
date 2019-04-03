$content = Get-Content "$PSScriptRoot/.gitconfig"
if ($IsWindows) {
    $content = $content -replace '\s+#\[Windows\]' -notmatch '\s+#\[macOS\]'
} elseif ($IsMacOS) {
    $content = $content -replace '\s+#\[macOS\]' -notmatch '\s+#\[Windows\]'
}
Set-Content '~/.gitconfig' $content

[Environment]::SetEnvironmentVariable('GIT_SSH', 'C:/Windows/System32/OpenSSH/ssh.exe', 'User')
