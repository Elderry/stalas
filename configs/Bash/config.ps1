. "$PSScriptRoot/../common.ps1"

Validate-OneDrive-Path

if ($IsLinux) {
    $content = Get-Content "$PSScriptRoot/ubuntu-base.bashrc",
        "$PSScriptRoot/common.bashrc",
        "$PSScriptRoot/Linux-custom.bashrc"
    $target = '.bashrc'
} elseif ($IsMacOS) {
    $content = Get-Content "$PSScriptRoot/common.bashrc",
        "$PSScriptRoot/macOS-custom.bashrc"
    $target = '.bash_profile'
}

$mavenKeyStorePassword = Get-Content `
    (Join-Path $oneDrive 'Collections/AppBackup/Tradeshift/lry@cn.tradeshift.com.pfx.pass.txt')
$stalasPath = "$PSScriptRoot/../.."

$content -replace '<key store password>', $mavenKeyStorePassword `
    -replace '<stalas path>', $stalasPath |
    Set-Content "~/$target"
