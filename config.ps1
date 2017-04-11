$consoleRegPath = 'HKCU:\Console'
$cmdRegPath     = Join-Path $consoleRegPath '%SystemRoot%_System32_cmd.exe'
$poshRegPath    = Join-Path $consoleRegPath '%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
$posh32RegPath  = Join-Path $consoleRegPath '%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'

$colorTable = [ordered]@{
                  # 0xBBGGRR
    "Black"       = 0x000000
    "DarkBlue"    = 0xC00000 #0x800000
    "DarkGreen"   = 0x00C000 #0x008000
    "DarkCyan"    = 0xC0C000 #0x808000
    "DarkRed"     = 0x0000C0 #0x000080
    "DarkMagenta" = 0xC000C0 #0x800080
    "DarkYellow"  = 0x00C0C0 #0x008080
    "Gray"        = 0x808080 #0xC0C0C0
    "DarkGray"    = 0xFF8000 #0x808080
    "Blue"        = 0xFF0080 #0xFF0000
    "Green"       = 0x00C080 #0x00FF00
    "Cyan"        = 0x80C000 #0xFFFF00
    "Red"         = 0x0000FF
    "Magenta"     = 0x8000FF #0xFF00FF
    "Yellow"      = 0x0080FF #0x00FFFF
    "White"       = 0xFFFFFF
}
$config = @{
    'CtrlKeyShortcutsDisabled' = $false
    'CodePage'                 = 936
    'CursorSize'               = 0x64       # 0x19: Small (25%); 0x32: Medium (50%); 0x64: Large (100%);
    'ExtendedEditKey'          = $true
    'FilterOnPaste'            = $true
    'FaceName'                 = 'Inziu Iosevka SC'
    'ForceV2'                  = $true
    'FontSize'                 = 0x180000   # 14pt
    'HistoryBufferSize'        = 999
    'HistoryNoDup'             = $true
    'InsertMode'               = $true
    'LineSelection'            = $true      # Line wrapping selection.
    'LineWrap'                 = $true      # Wraps text when resize console windows.
    'NumberOfHistoryBuffers'   = 999
    'ScreenBufferSize'         = 0x270F0064 # Number of lines: 0x270F (9999); Number of columns: 0x64 (100);
    'ScreenColors'             = 0xF0       # 0xF: Background color is White; 0x0: Foreground color is Black.
    'QuickEdit'                = $true      # Able to copy and paste using mouse.
    'WindowAlpha'              = 0xFF       # Adjust opacity between 30% and 100%: 0x4C to 0xFF -or- 76 to 255.
    'WindowPosition'           = 0x3C00A0   # Left margin: 0x3C (60); Top Margin: 0xA0 (160);
    'WindowSize'               = 0x190064   # Hight: 0x19 (25); Width: 0x64 (100);
}

function Remove-RegistryValue([string] $path, [string] $name) {
    $exists = Get-ItemProperty $path -Name $name -ErrorAction SilentlyContinue
    if ($exists -ne $null) {
        Remove-ItemProperty -Path $path -Name $name | Out-Null
    }
}

for($i = 0; $i -lt $colorTable.Count; $i++) {
    $config.Add('ColorTable' + ('{0:D2}' -f $i), $colorTable[$i])
}

foreach($i in $config.GetEnumerator()) {
    switch ($i) {
        { $_ -is [int] -or $_ -is [bool] } { $type = 'DWORD' }
        { $_ -is [string]                } { $type = 'SZ'    }
    }
    New-ItemProperty -Path $consoleRegPath -Name $i.Name -Value $i.Value -PropertyType $type -Force | Out-Null
    if ($i.Name -ne 'CodePage') {
        Remove-RegistryValue $cmdRegPath    $i.Name
        Remove-RegistryValue $poshRegPath   $i.Name
        Remove-RegistryValue $posh32RegPath $i.Name
    } else {
        New-ItemProperty -Path $cmdRegPath    -Name $i.Name -Value $i.Value -PropertyType $type -Force | Out-Null
        New-ItemProperty -Path $poshRegPath   -Name $i.Name -Value $i.Value -PropertyType $type -Force | Out-Null
        New-ItemProperty -Path $posh32RegPath -Name $i.Name -Value $i.Value -PropertyType $type -Force | Out-Null
    }
}
