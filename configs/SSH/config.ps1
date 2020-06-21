if (!$Env:OneDrive) {
    Write-Error 'Please set valid environment variable: [OneDrive].'
    exit
}

if (!(Test-Path "$Env:HOME/.ssh")) {
    Write-Warning 'Directory [~/.ssh] doesn''t exist, creating...'
    New-Item -Type 'Directory' "$Env:Home/.ssh"
}

(Get-Content "$PSScriptRoot/config") -replace '<onedrive path>', $Env:OneDrive |
    Set-Content "$Env:HOME/.ssh/config"
