#Requires -RunAsAdministrator

param (
    [ValidateSet("Windows Console", "PowerShell", "Visual Studio Code", "Bash", "Vim", "Hyper", "Registry")]
    [string[]] $targets
)

function Write-Split([string] $prefix, [string] $key, [string] $suffix) {
    $total = 50
    $length = $prefix.Length + $key.Length + $suffix.Length
    $hyphen = ($total - $length) / 2
    $hyphen_before = '-' * [Math]::Floor($hyphen)
    $hyphen_after  = '-' * [Math]::Ceiling($hyphen)
    Write-Host $hyphen_before -ForegroundColor 'DarkBlue'  -NoNewLine
    Write-Host " $prefix["    -ForegroundColor 'DarkGreen' -NoNewLine
    Write-Host "$key"         -ForegroundColor 'DarkRed'   -NoNewLine
    Write-Host "]$suffix "    -ForegroundColor 'DarkGreen' -NoNewLine
    Write-Host $hyphen_after  -ForegroundColor 'DarkBlue'
}

$pwsh = 'C:\Program Files\PowerShell'
if (Test-Path $pwsh) {
    Get-ChildItem $pwsh | ForEach-Object {
        if ($_.Name -match '\d+(\.\d+)*') {
            [Environment]::SetEnvironmentVariable('PWSH_HOME', (Join-Path $pwsh $_.Name), 'User')
        }
    }
} else {
    Write-Host -ForegroundColor 'Red' 'Failed to configure, please install Powershell Core first.'
    Write-Host 'Link: https://github.com/PowerShell/PowerShell/releases'
    exit
}

Write-Host "`n--------------- Elderry's Config Files ---------------" -ForegroundColor 'DarkBlue'

function Config([string] $name, [string] $type) {
    Write-Host
    Write-Split 'Going to config ' $name '.'
    switch ($type) {
        'ps1' { &  "Configuration\$name.$_" }
        'sh'  { bash "Configuration/$name.$_" }
    }
    Write-Split 'Configuration of ' $name ' finished.'
}

$configs = @{}
Get-ChildItem 'Configuration' | Select-Object -ExpandProperty 'Name' | ForEach-Object {
    $name = $_.Split('.')
    $configs[$name[0]] = $name[1]
}

if ($targets.Length -ne 0) { 
    $complete_configs = $configs.Clone()
    $complete_configs.GetEnumerator() | ForEach-Object {
        if (-not $targets.Contains($_.Name)) { $configs.Remove($_.Name) }
    }
}
$configs.GetEnumerator() | ForEach-Object { Config $_.Name $_.Value }

Write-Host "`n--------------- Elderry's Config Files ---------------`n" -ForegroundColor 'DarkBlue'
