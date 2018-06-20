$shell = if ($IsWindows) { "$PSHOME/pwsh.exe" -replace '\\', '/' } `
    elseif ($IsMacOS) { "$PSHOME/pwsh" }
(Get-Content "$PSScriptRoot/settings.json") `
    -replace '("terminal\.integrated\.shell\.windows")\s*:\s*".*"', "`$1: `"$shell`"" `
    -replace '("powershell\.powerShellExePath")\s*:\s*".*"', "`$1: `"$shell`"" `
    -replace '\s+//\[Windows\]' `
    -notmatch '\[macOS\]' |
    Set-Content "$Env:AppData/Code/User/settings.json"
