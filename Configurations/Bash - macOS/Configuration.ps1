Import-Module powershell-yaml

$private = [IO.Path]::GetFullPath("$PSScriptRoot/../../Resources/Private")
$credentials = Get-Content "$private/Credentials.yml" -Raw | ConvertFrom-Yaml

(Get-Content "$PSScriptRoot/.bash_profile") `
    -replace '<key store password>', $credentials['TSCN-key-pair'] |
    Set-Content '~/.bash_profile'
