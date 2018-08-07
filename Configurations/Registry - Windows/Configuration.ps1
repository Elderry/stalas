#Requires -RunAsAdministrator

New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root 'HKEY_CLASSES_ROOT' | Out-Null

function Remove-Registry([String] $registry) {
    if (Test-Path -LiteralPath $registry) {
        Remove-Item -LiteralPath $registry -Recurse
    }
}

# New File
Remove-Registry 'HKCR:\.ahk\ShellNew'
Remove-Registry 'HKCR:\.bmp\ShellNew'
Remove-Registry 'HKCR:\.contact\ShellNew'
Remove-Registry 'HKCR:\.rar\ShellNew'
Remove-Registry 'HKCR:\.rtf\ShellNew'
Remove-Registry 'HKCR:\.zip\ShellNew'

# Baidu Yun
Remove-Registry 'HKCR:\*\shellex\ContextMenuHandlers\YunShellExt'
Remove-Registry 'HKCR:\Directory\shellex\ContextMenuHandlers\YunShellExt'

# Git
Remove-Registry 'HKCR:\Directory\Background\shell\git_gui'
Remove-Registry 'HKCR:\Directory\Background\shell\git_shell'
Remove-Registry 'HKCR:\Directory\shell\git_gui'
Remove-Registry 'HKCR:\Directory\shell\git_shell'
Remove-Registry 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\git_gui'
Remove-Registry 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\git_shell'
Remove-Registry 'HKLM:\SOFTWARE\Classes\Directory\shell\git_gui'
Remove-Registry 'HKLM:\SOFTWARE\Classes\Directory\shell\git_shell'
Remove-Registry 'HKCU:\Console\Git Bash'
Remove-Registry 'HKCU:\Console\Git CMD'

# Visual Studio
Remove-Registry 'HKCR:\Directory\Background\shell\AnyCode'
Remove-Registry 'HKCR:\Directory\shell\AnyCode'
