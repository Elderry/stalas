if ($IsLinux) {
    $content = Get-Content "$PSScriptRoot/ubuntu-base.bashrc", "$PSScriptRoot/ubuntu-custom.bashrc"
    $target = '.bashrc'
} elseif ($IsMacOS) {
    $target = '.bashrc'
}

$mavenKeyStorePassword = Get-Content '~/OneDrive/Collections/AppBackup/Tradeshift/lry@cn.tradeshift.com.pfx.pass.txt'

$content -replace '<key store password>', $mavenKeyStorePassword |
    Set-Content "~/$target"
