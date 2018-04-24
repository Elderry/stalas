New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root 'HKEY_CLASSES_ROOT'

# Baidu Yun
Remove-Item -LiteralPath 'HKCR:\*\shellex\ContextMenuHandlers\YunShellExt' | Out-Null
Remove-Item 'HKCR:\Directory\shellex\ContextMenuHandlers\YunShellExt'      | Out-Null

# Git
Remove-Item -Recurse 'HKCR:\Directory\Background\shell\git_gui'   | Out-Null
Remove-Item -Recurse 'HKCR:\Directory\Background\shell\git_shell' | Out-Null
Remove-Item -Recurse 'HKCR:\Directory\shell\git_gui'              | Out-Null
Remove-Item -Recurse 'HKCR:\Directory\shell\git_shell'            | Out-Null
Remove-Item -Recurse 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\git_gui'   | Out-Null
Remove-Item -Recurse 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\git_shell' | Out-Null
Remove-Item -Recurse 'HKLM:\SOFTWARE\Classes\Directory\shell\git_gui'              | Out-Null
Remove-Item -Recurse 'HKLM:\SOFTWARE\Classes\Directory\shell\git_shell'            | Out-Null
