# Git Environment
. $env:LOCALAPPDATA\GitHub\shell.ps1 -SkipSSHSetup

# Custom Variables
Set-Alias vc "${env:ProgramFiles(x86)}\Microsoft VS Code\Code.exe"
Set-Alias mg '~\OneDrive\Collections\Adults\magick.ps1'
Set-Alias au '~\Projects\Personal\chocolatey-packages\update_all.ps1'
$tasks = '~\OneDrive\Collections\Tasks'

# WSL Commands
Remove-Item Alias:ls
function ls { bash -c "source ~/.bashrc; ls $args" }
function vim { bash -c "vim $args" }
function lsb_release { bash -c "lsb_release $args" }
function cowsay { bash -c "echo $input | cowsay $args" }
function fortune { bash -c "fortune $args" }
function cat { bash -c "cat $args" }
function ifconfig { bash -c "ifconfig $args" }

# Modules
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) { Import-Module "$ChocolateyProfile" }
if (!$global:GitPromptSettings) { Import-Module posh-git }
$global:GitPromptSettings.BeforeText = '['
$global:GitPromptSettings.AfterText  = '] '

function prompt {
    $origLastExitCode = $LASTEXITCODE
    Write-VcsStatus
    Write-Host ($PWD.Path -replace ($HOME -replace '\\', '\\'), '~') -ForegroundColor DarkBlue
    Write-Host "$env:USERNAME@$env:USERDOMAIN" -ForegroundColor DarkGray -NoNewline
    $LASTEXITCODE = $origLastExitCode
    return " $('>' * ($nestedPromptLevel + 1)) "
}

# Colors
$host.PrivateData.ErrorBackgroundColor    = 'White'
$host.PrivateData.WarningBackgroundColor  = 'White'
$host.PrivateData.DebugBackgroundColor    = 'White'
$host.PrivateData.VerboseBackgroundColor  = 'White'
$host.PrivateData.ProgressBackgroundColor = 'White'

# PSReadLine Colors
Set-PSReadlineOption -TokenKind Number -ForegroundColor Green
Set-PSReadlineOption -TokenKind Member -ForegroundColor DarkYellow
