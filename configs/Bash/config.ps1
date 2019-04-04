if ($IsMacOS) {
    $target = '.bash_profile'
} elseif ($IsLinux) {
    $target = '.bashrc'
}

$mavenKeyStorePassword = Get-Content '~/OneDrive/Collections/AppBackup/Tradeshift/lry@cn.tradeshift.com.pfx.txt'

(Get-Content "$PSScriptRoot/.bash") `
    -replace '<key store password>', $mavenKeyStorePassword |
    Set-Content "~/.$target"
