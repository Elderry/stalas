. "$PSScriptRoot/../common.ps1"

Validate-OneDrive-Path

(Get-Content "$PSScriptRoot/config") -replace '<onedrive path>', $oneDrive |
    Set-Content ~/.ssh/config
