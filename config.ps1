param (
    [ValidateSet("Windows Console", "PowerShell", "Visual Studio Code", "Bash", "Vim", "Hyper", "Registry")]
    [string] $target
)

$pwshInstalled = $false
if ($IsWindows) {
    $pwsh = 'C:\Program Files\PowerShell'
    if (Test-Path $pwsh) {
        Get-ChildItem $pwsh | ForEach-Object {
            if ($_.Name -match '\d+(\.\d+)*') {
                $pwshInstalled = $true
                [Environment]::SetEnvironmentVariable('PWSH_HOME', (Join-Path $pwsh $_.Name), 'User')
            }
        }
    }
}

if (-not $pwshInstalled) {
    Write-Host -ForegroundColor 'Red' 'Failed to configure, please install PowerShell Core first.'
    Write-Host 'Link: https://github.com/PowerShell/PowerShell/releases'
    exit
}

$width = 80

function Write-Split([string] $prefix, [string] $key, [string] $suffix) {
    $length = $prefix.Length + $key.Length + $suffix.Length + 4
    $hyphen = ($width - $length) / 2
    Write-Host ('-' * [Math]::Floor($hyphen)) -ForegroundColor 'DarkBlue' -NoNewLine
    Write-Host " $prefix[" -ForegroundColor 'DarkGreen' -NoNewLine
    Write-Host "$key" -ForegroundColor 'DarkRed' -NoNewLine
    Write-Host "]$suffix " -ForegroundColor 'DarkGreen' -NoNewLine
    Write-Host ('-' * [Math]::Ceiling($hyphen)) -ForegroundColor 'DarkBlue'
}

function Config([string] $name, [string] $type, [string[]] $arguments) {
    Write-Host
    Write-Split 'Going to config ' $name '.'
    switch ($type) {
        'ps1' { & "Configuration/$name.$_" @arguments }
        'sh' { bash "Configuration/$name.$_" @arguments }
    }
    Write-Split 'Configuration of ' $name ' finished.'
}

$hyphen = ($width - $Env:UserName.Length - 17) / 2
$banner = "$('-' * [Math]::Floor($hyphen)) $Env:UserName's Config Files $('-' * [Math]::Floor($hyphen))"
Write-Host "`n$banner" -ForegroundColor 'DarkBlue'

$configs = @{}
Get-ChildItem 'Configuration' | Select-Object -ExpandProperty 'Name' | ForEach-Object {
    $name = $_.Split('.')
    $configs[$name[0]] = $name[1]
}

if ($target -ne '') {
    Config $target $configs[$target] $args
} else {
    $configs.GetEnumerator() | ForEach-Object { Config $_.Name $_.Value }
}

Write-Host "`n$banner`n" -ForegroundColor 'DarkBlue'
