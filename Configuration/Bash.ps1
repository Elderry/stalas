# Use `wslpath` when it is ready.
# Reference: https://github.com/MicrosoftDocs/WSL/releases/tag/17046
$wslpath = $PSScriptRoot -replace 'C:\\', '/mnt/c/' -replace '\\', '/'

$settings = Get-Content "$PSScriptRoot/../Settings/Bash.bashrc"

if ($IsWindows) {
    ($settings -replace '\s+#\[Linux\]' -notmatch '\[macOS\]') -join "`n" |
        Set-Content "$PSScriptRoot/Bash.bashrc.temp" -NoNewLine
    bash -c "cp $wslpath/Bash.bashrc.temp ~/.bashrc"
    Remove-Item "$PSScriptRoot/Bash.bashrc.temp"
} elseif ($IsMacOS) {
    $settings -replace '\s+#\[Linux\]' -notmatch '\[Windows\]' | Set-Content '~/.bash_profile'
}
