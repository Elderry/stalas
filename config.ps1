function Write-Split([string] $prefix, [string] $key, [string] $suffix) {
    $total = 50
    $length = $prefix.Length + $key.Length + $suffix.Length
    $hyphen = ($total - $length) / 2
    $hyphenBefore = '-' * [math]::floor($hyphen)
    $hyphenAfter  = '-' * [math]::ceiling($hyphen)
    Write-Host $hyphenBefore -ForegroundColor DarkBlue -NoNewLine
    Write-Host " $prefix[" -ForegroundColor DarkGreen -NoNewLine
    Write-Host "$key" -ForegroundColor DarkRed -NoNewLine
    Write-Host "]$suffix " -ForegroundColor DarkGreen -NoNewLine
    Write-Host $hyphenAfter -ForegroundColor DarkBlue
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

Write-Host "`n--------------- Elderry's Config Files ---------------" -ForegroundColor DarkBlue

function Config([string] $name, [string] $script) {
    Write-Host
    Write-Split 'Going to config ' $name '.'
    switch -wildcard ($script) { '*.ps1' { & ".\$_" } '*.sh' { bash $_ } }
    Write-Split 'Config of ' $name ' finished.'
}

Config 'Windows Console'    'Config - Windows Console.ps1'
Config 'Powershell'         'Config - Powershell.ps1'
Config 'Visual Studio Code' 'Config - Visual Studio Code.ps1'
Config 'Bash'               'Config - Bash.sh'
Config 'Vim'                'Config - Vim.sh'
Config 'Hyper'              'Config - Hyper.ps1'

Write-Host "`n--------------- Elderry's Config Files ---------------`n" -ForegroundColor DarkBlue
