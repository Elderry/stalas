param (
    [ValidateSet(
        'Console',
        'PowerShell',
        'Visual Studio Code',
        'Bash',
        'Vim',
        'Hyper',
        'Registry',
        'Maven',
        'Java Runtime Environment',
        'Docker')]
    [Parameter(Position = 0, mandatory = $true)]
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
    Write-Error 'Failed to configure, please install PowerShell Core first.'
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

function Start-Config([string] $name, [string[]] $arguments) {

    Write-Host
    Write-Split 'Going to config ' $name '.'
        if ($arguments.Length -eq 0) {
            & "$PSScriptRoot/Configuration/$name.ps1"
        } else {
            & "$PSScriptRoot/Configuration/$name.ps1" @arguments
        }
    Write-Split 'Configuration of ' $name ' finished.'
}

$hyphen = ($width - $Env:UserName.Length - 17) / 2
$banner = "$('-' * [Math]::Floor($hyphen)) $Env:UserName's Config Files $('-' * [Math]::Floor($hyphen))"
Write-Host "`n$banner" -ForegroundColor 'DarkBlue'

$script = Get-ChildItem "$PSScriptRoot/Configuration" |
    Select-Object -ExpandProperty 'Name' |
    ForEach-Object { $_ -replace '\.ps1' } |
    Where-Object { $_ -match "$target( - Windows| - macOS)?" } |
    Select-Object -First 1

switch -wildcard ($script) {
    "* - Windows" {
        if (-not $IsWindows) {
            Write-Error "$target's config is Windows only."
            exit
        }
    }
    "* - macOS" {
        if (-not $IsMacOS) {
            Write-Error "$target's config is macOS only."
            exit
        }
    }
}

Start-Config $script $args

Write-Host "`n$banner`n" -ForegroundColor 'DarkBlue'
