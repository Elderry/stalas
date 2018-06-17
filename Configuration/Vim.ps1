# Use `wslpath` when it is ready.
# Reference: https://github.com/MicrosoftDocs/WSL/releases/tag/17046
$wslpath = $PSScriptRoot -replace 'C:\\', '/mnt/c/' -replace '\\', '/'

if ($IsWindows) {
    bash -c "cp $wslpath/../Settings/Vim.vimrc ~/.vimrc"
} elseif ($IsMacOS) {
    Copy-Item "$PSScriptRoot/../Settings/Vim.vimrc" '~/.vimrc'
}
