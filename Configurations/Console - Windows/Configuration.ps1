Import-Module powershell-yaml

$desktop = "$Home/OneDrive/Collections/AppBackup/Desktop"
$pwshShortcut = 'PS.lnk'
$pwshAdminShortcut = 'PSA.lnk'
$pwshNativeShortcut = 'PN.lnk'
$pwshNativeAdminShortcut = 'PNA.lnk'
$cmdShortcut = 'CD.lnk'
$cmdAdminShortcut = 'CDA.lnk'

$consoleRegPath = 'HKCU:\Console'
$regPaths = (
    (Join-Path $consoleRegPath '%SystemRoot%_System32_cmd.exe'),
    (Join-Path $consoleRegPath '%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'),
    (Join-Path $consoleRegPath '%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'),
    (Join-Path $consoleRegPath '%SystemRoot%_sysnative_WindowsPowerShell_v1.0_powershell.exe')
)

$colorTable = (
    "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray", "Blue",
    "Green", "Cyan", "Red", "Magenta", "Yellow", "White"
)

$config = @{}
(Get-Content "$PSScriptRoot/settings.yml" -Raw | ConvertFrom-Yaml).GetEnumerator() | ForEach-Object {
    $name = $_.Name
    $value = $_.Value
    switch ($name) {
        { $colorTable.Contains($name) } {
            $config.Add('ColorTable' + ('{0:D2}' -f $colorTable.IndexOf($name)), '0X' + $value -as [int])
        }
        'CursorSize' { $config.Add($name, $(switch ($value) { 'small' { 25 } 'medium' { 50 } 'large' { 100 } })) }
        'FontSize' { $config.FontSize = $value * 65536 }
        'ScreenBufferSize.Lines' { $config.ScreenBufferSize += $value * 65536 }
        'ScreenBufferSize.Columns' { $config.ScreenBufferSize += $value }
        'ScreenColors.Background' { $config.ScreenColors += $value * 16 }
        'ScreenColors.Foreground' { $config.ScreenColors += $value }
        'WindowAlpha' { $config.WindowAlpha = $value * 2.55 -as [int] }
        'WindowPosition.LeftMargin' { $config.WindowPosition += $value }
        'WindowPosition.TopMargin' { $config.WindowPosition += $value * 65536 }
        'WindowSize.Height' { $config.WindowSize += $value * 65536 }
        'WindowSize.Width' { $config.WindowSize += $value }
        default { $config.Add($name, $value) }
    }
}

function Set-Registry([string] $path, [string] $name, $value, [string] $type) {
    New-ItemProperty -Path $path -Name $name -Value $value -PropertyType $type -Force -ErrorAction 'SilentlyContinue' |
        Out-Null
}

function Remove-Registry([string] $path, [string] $name) {
    $exists = Get-ItemProperty $path -Name $name -ErrorAction 'SilentlyContinue'
    if ($exists) { Remove-ItemProperty -Path $path -Name $name | Out-Null }
}

$config.GetEnumerator() | ForEach-Object {
    $name = $_.Name
    $value = $_.Value
    switch ($value) {
        { $_ -is [int] -or $_ -is [bool] } { $type = 'Dword' }
        { $_ -is [string] } { $type = 'String' }
    }
    Set-Registry $consoleRegPath $name $value $type
    # Clean up unnecessary entries.
    $regPaths | ForEach-Object { Remove-Registry $_ $name }
}

function Set-Shortcut([string] $Path, [string] $Target, [switch] $RequireAdmin) {
    if (Test-Path $Path) { Remove-Item $Path }
    $shortcut = $(New-Object -ComObject WScript.Shell).CreateShortcut($Path)
    $shortcut.TargetPath = $Target
    $shortcut.WorkingDirectory = "$Home"
    $shortcut.Save()
    if ($RequireAdmin) {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        $bytes[0x15] = $bytes[0x15] -bor 0x20
        [System.IO.File]::WriteAllBytes($Path, $bytes)
    }
}

function Update-Shortcut([string] $Path) {
    $shortcut = $(New-Object -ComObject 'WScript.Shell').CreateShortcut($Path)
    # Restore this when the occassionally fail issue is fixed.
    # $target = "${PSHOME}/pwsh.exe"
    $target = "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
    if ($shortcut.TargetPath -eq $target) { return }
    $shortcut.TargetPath = $target
    $shortcut.Save()
}

$pwshPath = "$PSHOME/pwsh.exe"
$pwshNativePath = "$Env:SystemRoot/System32/WindowsPowerShell/v1.0/powershell.exe"
$cmdPath = "$Env:SystemRoot/System32/cmd.exe"

Set-Shortcut "$desktop/$pwshShortcut" $pwshPath
Set-Shortcut "$desktop/$pwshAdminShortcut" $pwshPath -RequireAdmin
Set-Shortcut "$desktop/$pwshNativeShortcut" $pwshNativePath
Set-Shortcut "$desktop/$pwshNativeAdminShortcut" $pwshNativePath -RequireAdmin
Set-Shortcut "$desktop/$cmdShortcut" $cmdPath
Set-Shortcut "$desktop/$cmdAdminShortcut" $cmdPath -RequireAdmin

Get-ChildItem $desktop |
    Where-Object { $_.Name -Match '`\w+\.lnk' } |
    ForEach-Object { Update-Shortcut $_.FullName }
