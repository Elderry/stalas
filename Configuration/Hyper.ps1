$shell = "shell: '" + ((Join-Path $Env:PWSH_HOME 'pwsh.exe') -replace '\\', '\\') + "'"
$settings = Join-Path $Env:UserProfile '.hyper.js'
(Get-Content 'Settings\Hyper.js') -replace "shell:\s*'.*'", $shell | Set-Content $settings
