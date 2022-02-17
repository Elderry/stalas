<#
.SYNOPSIS
Install stalas into current machine.
#>

$Path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (!$Path.Contains($PSScriptRoot)) {
    [Environment]::SetEnvironmentVariable("Path", "$Path;$PSScriptRoot", 'User')
}
