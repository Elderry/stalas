$target = Join-Path $Env:AppData 'Code\User\settings.json'
$shell = (Join-Path $Env:PWSH_HOME 'pwsh.exe') -replace '\\', '\\'
(Get-Content 'Settings - Visual Studio Code.json') `
    -replace '("terminal\.integrated\.shell\.windows")\s*:\s*".*"', "`$1: `"$shell`"" `
    -replace '\s+//\[Windows\]' `
    -notmatch '\[macOS\]' |
    Set-Content $target
