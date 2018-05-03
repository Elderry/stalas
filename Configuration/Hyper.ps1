$shell = "shell: '" + ((Join-Path $Env:PWSH_HOME 'pwsh.exe') -replace '\\', '\\') + "'"
$settings = Join-Path $Env:UserProfile '.hyper.js'
$content = (Get-Content 'Settings\Hyper.js') -replace "shell:\s*'.*'", $shell

if ((Test-Path $settings) -And ([String]::Concat((Get-Content $settings)) -eq [String]::Concat($content))) {
    exit
}

Set-Content -Value $content -Path $settings
