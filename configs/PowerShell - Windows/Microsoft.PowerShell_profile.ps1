<#
.SYNOPSIS
Personal PowerShell profile for Elderry.
#>

# Custom Variables
Set-Alias config '~/Projects/Personal/stalas/config.ps1'

# *nux like ls
Remove-Item Alias:ls
function ls { Get-ChildItem | Format-Wide -AutoSize -Property 'Name' }

# Modules
if (!$global:GitPromptSettings) { Import-Module 'posh-git' }
$global:GitPromptSettings.BeforeText = ' ['
$global:GitPromptSettings.AfterText  = '] '

$GitBackgroundColor = [ConsoleColor]::DarkBlue
$global:GitPromptSettings.BeforeBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.DelimBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.AfterBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.LocalDefaultStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.LocalWorkingStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.LocalStagedStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchGoneStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchIdenticalStatusToBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchAheadStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchBehindStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BranchBehindAndAheadStatusBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BeforeIndexBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.IndexBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.WorkingBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.BeforeStashBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.AfterStashBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.StashBackgroundColor = $GitBackgroundColor
$global:GitPromptSettings.ErrorBackgroundColor = $GitBackgroundColor

$global:GitPromptSettings.LocalDefaultStatusForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.LocalWorkingStatusForegroundColor = [ConsoleColor]::Red
$global:GitPromptSettings.BeforeIndexForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.IndexForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Red

Set-PSReadLineOption -Colors @{
    'Number' = [ConsoleColor]::Green
    'Member' = [ConsoleColor]::Magenta
    'Type' = [ConsoleColor]::DarkYellow
    'ContinuationPrompt' = [ConsoleColor]::DarkMagenta
}

function IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Reference: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
$DarkBlueOnBlue = "`e[34;104m"
$WhiteOnBlue    = "`e[97;104m"
$BlueOnWhite    = "`e[94;107m"
$WhiteOnGreen   = "`e[97;102m"
$GreenOnMagenta = "`e[92;105m"
$WhiteOnMagenta = "`e[97;105m"
$MagentaOnWhite = "`e[95;107m"
$Reset          = "`e[0m"
function prompt {

    # Git
    Write-VcsStatus
    if (Get-GitDirectory) { Write-Host "$DarkBlueOnBlue" -NoNewline }

    # Path
    $path = "$($PWD.Path -replace ($HOME -replace '\\', '\\'), '~' -replace '\\', '/')"
    Write-Host "$WhiteOnBlue $path $BlueOnWhite"

    # User and symbol
    $user = "$Env:USERNAME@$((Get-Culture).TextInfo.ToTitleCase($env:COMPUTERNAME.ToLower()))"
    $symbol = if (IsAdmin) { '#' } else { '$' }
    Write-Host "$WhiteOnGreen $user $GreenOnMagenta$WhiteOnMagenta $symbol $MagentaOnWhite$Reset" -NoNewline

    return ' '
}
# This has to be after prompt function because zLocation alters prompt to work.
Import-Module -Name 'zLocation'
