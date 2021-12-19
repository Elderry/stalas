Import-Module powershell-yaml

$desktop = "$Home/OneDrive/Collections/AppBackup/Desktop"
$PwshShortcut = 'PS.lnk'
$PwshAdminShortcut = 'PSA.lnk'
$PwshNativeShortcut = 'PN.lnk'
$PwshNativeAdminShortcut = 'PNA.lnk'
$CmdShortcut = 'CD.lnk'
$CmdAdminShortcut = 'CDA.lnk'

$colorTable = (
    "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "DarkWhite", "BrightBlack",
    "BrightBlue", "BrightGreen", "BrightCyan", "BrightRed", "BrightMagenta", "BrightYellow", "White"
)

function Convert-BGRString([string] $BGR) {
    $RGB = $BGR.Substring(4, 2) + $BGR.Substring(2, 2) + $BGR.Substring(0, 2)
    return '0X' + $RGB -as [int]
}

$config = @{}
(Get-Content "$PSScriptRoot/settings.yml" -Raw | ConvertFrom-Yaml).GetEnumerator() | ForEach-Object {
    $name = $_.Name
    $value = $_.Value
    switch ($name) {
        { $colorTable.Contains($name) } {
            $config.Add('ColorTable' + ('{0:D2}' -f $colorTable.IndexOf($name)), (Convert-BGRString $value))
        }
        'CursorSize' { $config.Add($name, $(switch ($value) { 'small' { 25 } 'medium' { 50 } 'large' { 100 } })) }
        'FontFamily.Family' { $config.FontFamily += $(switch ($value) {
            'dontCare' { 0 } 'roman' { 0x10 } 'swiss' { 0x20 } 'modern' { 0x30 } 'script' { 0x40 } 'decorative' { 0x50 }
        })}
        'FontFamily.Pitch' { if ($value) { $config.FontFamily += 1 }}
        'FontFamily.Vector' { if ($value) { $config.FontFamily += 2 }}
        'FontFamily.TrueType' { if ($value) { $config.FontFamily += 4 }}
        'FontFamily.Device' { if ($value) { $config.FontFamily += 8 }}
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

function Remove-Registry([String] $path) {
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Recurse }
}

$HKCU_Console = 'HKCU:/Console'
Remove-Item -Path "$HKCU_Console/*" -Recurse
Remove-ItemProperty -Path $HKCU_Console -Name '*'
$config.GetEnumerator().ForEach({

    $name = $_.Name
    $value = $_.Value
    switch ($value) {
        { $_ -is [int] -or $_ -is [bool] } { $type = 'Dword' }
        { $_ -is [string] } { $type = 'String' }
    }
    Set-Registry $HKCU_Console $name $value $type
})

function Set-Shortcut([string] $Path, [string] $Target, [string] $IconLocation, [switch] $RequireAdmin) {

    if (Test-Path $Path) { Remove-Item $Path }

    $Shortcut = $(New-Object -ComObject 'WScript.Shell').CreateShortcut($Path)
    $Shortcut.TargetPath = $Target
    $Shortcut.WorkingDirectory = '%USERPROFILE%'
    if ($IconLocation) { $Shortcut.IconLocation = $IconLocation }
    $Shortcut.Save()

    if ($RequireAdmin) {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        $bytes[0x15] = $bytes[0x15] -bor 0x20
        [System.IO.File]::WriteAllBytes($Path, $bytes)
    }
}

$PwshPath = '%USERPROFILE%/AppData/Local/Microsoft/WindowsApps/pwsh.exe'
$PwshIcon = '%USERPROFILE%/OneDrive/Collections/AppBackup/Desktop/Resources/PS.exe, 0'
$PwshNativePath = '%SYSTEMROOT%/System32/WindowsPowerShell/v1.0/powershell.exe'
$CmdPath = '%SYSTEMROOT%/System32/cmd.exe'

Set-Shortcut "$desktop/$PwshShortcut" $PwshPath $PwshIcon
Set-Shortcut "$desktop/$PwshAdminShortcut" $PwshPath $PwshIcon -RequireAdmin
Set-Shortcut "$desktop/$PwshNativeShortcut" $PwshNativePath
Set-Shortcut "$desktop/$PwshNativeAdminShortcut" $PwshNativePath -RequireAdmin
Set-Shortcut "$desktop/$CmdShortcut" $CmdPath
Set-Shortcut "$desktop/$CmdAdminShortcut" $CmdPath -RequireAdmin
