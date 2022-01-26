param (
    [ValidateSet(
        'BaiduYun',
        'Console',
        'PowerShell',
        'Bash',
        'Registry',
        'SSH',
        'Git')]
    [string] $target
)

if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error 'Failed to configure, please install PowerShell Core first.'
    Write-Host 'Link: https://github.com/PowerShell/PowerShell/releases'
    exit
}

if (-not $target) {
    Write-Host 'Usage: config <target> [arguments]'
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
    $script = "$PSScriptRoot/configs/$name/config.ps1"
    Write-Split 'Going to config ' $name '.'
    if ($arguments.Length -eq 0) {
        & $script
    } else {
        & $script @arguments
    }
    Write-Split 'Configuration of ' $name ' finished.'
}

$user = if ($IsWindows) { $Env:USERNAME } else { $Env:USER }
$hyphen = ($width - $user.Length - 17) / 2
$banner = "$('-' * [Math]::Floor($hyphen)) $user's Config Files $('-' * [Math]::Ceiling($hyphen))"
Write-Host "`n$banner" -ForegroundColor 'DarkBlue'

$script = Get-ChildItem "$PSScriptRoot/configs" |
    Select-Object -ExpandProperty 'Name' |
    ForEach-Object { $_ -replace '\.ps1' } |
    Where-Object { $_ -match $target } |
    Select-Object -First 1

Start-Config $script $args

Write-Host "`n$banner`n" -ForegroundColor 'DarkBlue'
