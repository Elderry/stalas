. "$PSScriptRoot/../common.ps1"

Validate-OneDrive-Path
if(!$IsWindows) {
    chmod 600 "$oneDrive/Collections/AppBackup/SSH/lry_rsa"
}

(Get-Content "$PSScriptRoot/config") -replace '<onedrive path>', $oneDrive |
    Set-Content "$Env:HOME/.ssh/config"

if(!$IsWindows) {
    chmod 600 "$Env:HOME/.ssh/config"
}
