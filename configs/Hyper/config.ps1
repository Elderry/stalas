$settings = '~/.hyper.js'
$pwsh = if ($IsWindows) { "$PSHOME/pwsh.exe" -replace '\\', '/' } `
    elseif ($IsMacOS) { "$PSHOME/pwsh" }
$content = (Get-Content "$PSScriptRoot/.hyper.js") -replace "(shell:)\s*'.*'", "`$1 '$pwsh'"

$done = (Test-Path $settings) -and ([String]::Concat((Get-Content $settings)) -eq [String]::Concat($content))
if ($done) {
    exit
}

Set-Content -Value $content -Path $settings
