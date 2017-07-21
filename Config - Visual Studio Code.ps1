$target = Join-Path $Env:AppData 'Code\User\settings.json'
(Get-Content 'Settings - Visual Studio Code.json') -replace '\s+//\[Windows\]' -notmatch '\[macOS\]' |
    Set-Content $target
