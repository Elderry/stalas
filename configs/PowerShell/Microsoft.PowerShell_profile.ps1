<#
.SYNOPSIS
Personal PowerShell profile for Elderry.
#>

# Custom Variables
Set-Alias au Archive-Update
Set-Alias ci Compress-Image
Set-Alias sj Simplify-JpegName

# *nux like ls
Remove-Item Alias:ls
function ls { Get-ChildItem | Format-Wide -AutoSize -Property 'Name' }

# Modules
if (!$GitPromptSettings) { Import-Module 'posh-git' }
$GitPromptSettings.AfterStatus.Text = '] '

$GitBackgroundColor = [ConsoleColor]::DarkBlue
$GitPromptSettings.DefaultColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.IndexColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.WorkingColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.StashColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.ErrorColor.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.PathStatusSeparator.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BeforeStatus.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.DelimStatus.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.AfterStatus.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BeforeStash.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.AfterStash.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.LocalWorkingStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.LocalStagedStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchGoneStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchIdenticalStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchAheadStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchBehindStatusSymbol.BackgroundColor = $GitBackgroundColor
$GitPromptSettings.BranchBehindAndAheadStatusSymbol.BackgroundColor = $GitBackgroundColor

$GitPromptSettings.LocalDefaultStatusSymbol.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.LocalWorkingStatusSymbol.ForegroundColor = [ConsoleColor]::Red
$GitPromptSettings.IndexColor.ForegroundColor = [ConsoleColor]::Green
$GitPromptSettings.WorkingColor.ForegroundColor = [ConsoleColor]::Red

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
    $prompt += Write-VcsStatus
    if (Get-GitDirectory) { $prompt += "$DarkBlueOnBlue" }

    # Path
    $path = "$($PWD.Path -replace ($HOME -replace '\\', '\\'), '~' -replace '\\', '/')"
    $prompt += "$WhiteOnBlue 📁 $path $BlueOnWhite`n"

    # User and symbol
    $user = "$Env:USERNAME@$((Get-Culture).TextInfo.ToTitleCase($env:COMPUTERNAME.ToLower()))"
    $symbol = if (IsAdmin) { '#' } else { '$' }
    $prompt += "$WhiteOnGreen 💻 $user $GreenOnMagenta$WhiteOnMagenta $symbol $MagentaOnWhite$Reset "

    return $prompt
}
# This has to be after prompt function because zLocation alters prompt to work.
Import-Module -Name 'zLocation'
