# Custom Variables
Set-Alias vc "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
Set-Alias mg '~\OneDrive\Collections\Adults\magick.ps1'
Set-Alias au '~\Projects\Personal\chocolatey-packages\update_all.ps1'

# WSL Commands
function bash_file { $args = $args -replace '\\', '/'; bash -c "$((Get-PSCallStack)[1].Command) '$args'" }

function cat { bash_file $args }
function cowsay { bash -c "echo $input | cowsay $args" }
function fortune { bash -c "fortune $args" }
function ifconfig { bash -c "ifconfig $args" }
Remove-Item Alias:ls
function ls { bash -c "source ~/.bashrc; ls $args" }
function lsb_release { bash -c "lsb_release $args" }
function touch { bash -c "touch $args" }
function vi { bash_file $args }
function vim { bash_file $args }

# Modules
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) { Import-Module "$ChocolateyProfile" }
if (!$global:GitPromptSettings) { Import-Module posh-git }
$global:GitPromptSettings.BeforeText = ' ['
$global:GitPromptSettings.AfterText  = '] '

# Colors
$host.PrivateData.ErrorBackgroundColor    = 'White'
$host.PrivateData.WarningBackgroundColor  = 'White'
$host.PrivateData.DebugBackgroundColor    = 'White'
$host.PrivateData.VerboseBackgroundColor  = 'White'
$host.PrivateData.ProgressBackgroundColor = 'White'

$DirectoryBackgroundColor = [ConsoleColor]::Blue
$UserBackgroundColor      = [ConsoleColor]::Green
$HostBackgroundColor      = [ConsoleColor]::Magenta

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

Set-PSReadlineOption -TokenKind Number -ForegroundColor Green
Set-PSReadlineOption -TokenKind Member -ForegroundColor Magenta

function IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {

    # Git
    Write-VcsStatus
    if (Test-Path '.git') {
        Write-Host '' -ForegroundColor $GitBackgroundColor -BackgroundColor $DirectoryBackgroundColor -NoNewline
    }

    # Path
    $path = " $($PWD.Path -replace ($HOME -replace '\\', '\\'), '~') "
    Write-Host $path -ForegroundColor White -BackgroundColor $DirectoryBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $DirectoryBackgroundColor

    # User
    $user = " $Env:USERNAME@$((Get-Culture).TextInfo.ToTitleCase($env:USERDOMAIN.ToLower())) "
    Write-Host $user -ForegroundColor White -BackgroundColor $UserBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $UserBackgroundColor -BackgroundColor $HostBackgroundColor -NoNewline

    # Host symbol
    $symbol = if (IsAdmin) { '#' } else { '$' }
    Write-Host "$symbol " -ForegroundColor White -BackgroundColor $HostBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $HostBackgroundColor -NoNewline

    return ' '
}

# PSReadLine Colors

