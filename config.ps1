function Write-Split([string] $prefix, [string] $key, [string] $suffix) {
    $total = 50
    $length = $prefix.Length + $key.Length + $suffix.Length
    $hyphen = ($total - $length) / 2
    $hyphenBefore = '-' * [math]::floor($hyphen)
    $hyphenAfter  = '-' * [math]::ceiling($hyphen)
    Write-Host $hyphenBefore -ForegroundColor DarkMagenta -NoNewLine
    Write-Host " $prefix[" -ForegroundColor Green -NoNewLine
    Write-Host "$key" -ForegroundColor Magenta -NoNewLine
    Write-Host "]$suffix " -ForegroundColor Green -NoNewLine
    Write-Host $hyphenAfter -ForegroundColor DarkMagenta
}

Write-Host
Write-Host "--------------- Elderry's Config Files ---------------" -ForegroundColor DarkBlue

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

Write-Host
Write-Host "--------------- Elderry's Config Files ---------------" -ForegroundColor DarkBlue
Write-Host
