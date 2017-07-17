$desktopPath = "$Home\OneDrive\Collections\AppBackup\Desktop"
$poshShortcut = 'PS.lnk'
$poshAdminShortcut = 'PSA.lnk'
$bashShortcut = 'BS.lnk'
$cmdShortcut = 'CD.lnk'
$cmdAdminShortcut = 'CDA.lnk'

$consoleRegPath = 'HKCU:\Console'
$regPaths = @{
    'cmd'        = Join-Path $consoleRegPath '%SystemRoot%_System32_cmd.exe'
    'posh'       = Join-Path $consoleRegPath '%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
    'posh32'     = Join-Path $consoleRegPath '%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'
    'poshNative' = Join-Path $consoleRegPath '%SystemRoot%_sysnative_WindowsPowerShell_v1.0_powershell.exe'
}

$colorTable = (
    "Black",    "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray",
    "DarkGray",     "Blue",     "Green",     "Cyan",     "Red",     "Magenta",     "Yellow", "White"
)

$config = @{}
((Get-Content '.\Settings - Windows Console.json') -Replace '\/\/.*' | ConvertFrom-Json)[1].PSObject.Properties |
ForEach-Object {
    $name = $_.Name
    $value = $_.Value
    switch ($name) {
        { $colorTable.Contains($name) } {
            $config.Add('ColorTable' + ('{0:D2}' -f $colorTable.IndexOf($name)), '0X' + $value -as [int])
        }
        'CursorSize' { $config.Add($name, $(switch ($value) { 'small' { 25 } 'medium' { 50 } 'large' { 100 } })) }
        'FontSize' { $config.FontSize = $value * 65536 }
        'ScreenBufferSize.Lines'   { $config.ScreenBufferSize += $value * 65536 }
        'ScreenBufferSize.Columns' { $config.ScreenBufferSize += $value }
        'ScreenColors.Background' { $config.ScreenColors += $value * 16 }
        'ScreenColors.Foreground' { $config.ScreenColors += $value }
        'WindowAlpha' { $config.WindowAlpha = $value * 2.55 -as [int] }
        'WindowPosition.LeftMargin' { $config.WindowPosition += $value }
        'WindowPosition.TopMargin'  { $config.WindowPosition += $value * 65536 }
        'WindowSize.Height' { $config.WindowSize += $value * 65536 }
        'WindowSize.Width'  { $config.WindowSize += $value }
        default { $config.Add($name, $value) }
    }
}

function Set-Registry([string] $path, [string] $name, $value, [string] $type) {
    New-ItemProperty -Path $path -Name $name -Value $value -PropertyType $type -Force -ErrorAction SilentlyContinue |
        Out-Null
}

function Remove-Registry([string] $path, [string] $name) {
    $exists = Get-ItemProperty $path -Name $name -ErrorAction SilentlyContinue
    if ($exists -ne $null) { Remove-ItemProperty -Path $path -Name $name | Out-Null }
}

$config.GetEnumerator() | ForEach-Object {
    $name = $_.Name
    $value = $_.Value
    switch ($value) {
        { $_ -is [int] -or $_ -is [bool] } { $type = 'DWORD' }
        { $_ -is [string]                } { $type = 'SZ'    }
    }
    Set-Registry $consoleRegPath $name $value $type
    # Clean up unnecessary entries.
    # 'CodePage' is a special entry that only works while setting on specific profiles.
    switch ($name) {
        'CodePage' { $regPaths.GetEnumerator() | ForEach-Object { Set-Registry $_.Value $name $value $type } }
        default    { $regPaths.GetEnumerator() | ForEach-Object { Remove-Registry $_.Value $name } }
    }
}

function Set-Shortcut([string] $Path, [string] $Target, [string] $Icon, [switch] $RequireAdmin) {
    $wshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($Path)
    $shortcut.TargetPath = $Target
    $shortcut.WorkingDirectory = "$Home"
    if ($Icon -and (Test-Path $Icon)) { $shortcut.IconLocation = $Icon }
    if (Test-Path $Path) { Remove-Item $Path }
    $shortcut.Save()
    if ($RequireAdmin) {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        $bytes[0x15] = $bytes[0x15] -bor 0x20
        [System.IO.File]::WriteAllBytes($Path, $bytes)
    }
}

$poshPath = "$Env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$cmdPath  = "$Env:SystemRoot\System32\cmd.exe"
$bashPath = "$Env:SystemRoot\System32\bash.exe"
$bashIcon = "$Env:UserProfile\AppData\Local\lxss\bash.ico"

Set-Shortcut (Join-Path $desktopPath $poshShortcut) $poshPath
Set-Shortcut (Join-Path $desktopPath $poshAdminShortcut) $poshPath -RequireAdmin
Set-Shortcut (Join-Path $desktopPath $cmdShortcut) $cmdPath
Set-Shortcut (Join-Path $desktopPath $cmdAdminShortcut) $cmdPath -RequireAdmin
Set-Shortcut (Join-Path $desktopPath $bashShortcut) $bashPath $bashIcon
