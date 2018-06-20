# Custom Variables
Set-Alias vc "$Env:ProgramFiles/Microsoft VS Code/Code.exe" #[Windows]
Set-Alias vc "$Env:ProgramFiles/Microsoft VS Code/Code.exe" #[macOS]
Set-Alias mg '~/OneDrive/Collections/Adults/magick.ps1'
Set-Alias au '~/Projects/Personal/chocolatey-packages/update_all.ps1'
Set-Alias aphro '~/Projects/Personal/Aphrodite/Aphrodite/bin/Release/netcoreapp2.1/win10-x64/Aphrodite.exe' #[Windows]
Set-Alias config '~/Projects/Personal/config/config.ps1'

# Custom Commands
Remove-Alias 'ls' #[Windows]
function ls { Get-ChildItem | Format-Wide -AutoSize -Property 'Name' }
function git_drop {
    git reset --hard
    git clean -fd
}
function git_prune {
    $branches = git branch -l |
        ForEach-Object { $_.Trim() } |
        Where-Object { -Not $_.StartsWith('*') } |
        Where-Object { $_ -ne 'master' }
    if ($branches.Length -eq 0) {
        Write-Host 'No branch is going to be deleted.'
        return
    }
    Write-Host 'Going to ' -NoNewline
    Write-Host 'delete' -ForegroundColor 'Red' -NoNewline
    Write-Host ' these branches:'
    Write-Host $branches
    $choice = Read-Host '[Y]es or [N]o?'
    if ($choice -eq 'y') {
        foreach ($branch in $branches) {
            git branch -D $branch
        }
    }
}

# Modules
if (!$global:GitPromptSettings) { Import-Module 'posh-git' }
$global:GitPromptSettings.BeforeText = ' ['
$global:GitPromptSettings.AfterText  = '] '
Import-Module 'Jump.Location'

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

$global:GitPromptSettings.LocalDefaultStatusForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.LocalWorkingStatusForegroundColor = [ConsoleColor]::Red
$global:GitPromptSettings.BeforeIndexForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.IndexForegroundColor = [ConsoleColor]::Green
$global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Red

Set-PSReadLineOption -Colors @{
    "Number" = [ConsoleColor]::Green
    "Member" = [ConsoleColor]::Magenta
}

function IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {

    # Git
    Write-VcsStatus
    if (Get-GitDirectory) {
        Write-Host '' -ForegroundColor $GitBackgroundColor -BackgroundColor $DirectoryBackgroundColor -NoNewline
    }

    # Path
    $path = " $($PWD.Path -replace ($HOME -replace '\\', '\\'), '~') "
    Write-Host $path -ForegroundColor 'White' -BackgroundColor $DirectoryBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $DirectoryBackgroundColor

    # User
    $user = " $Env:USERNAME@$((Get-Culture).TextInfo.ToTitleCase($env:USERDOMAIN.ToLower())) "
    Write-Host $user -ForegroundColor 'White' -BackgroundColor $UserBackgroundColor -NoNewline
    # Write-Host '' -ForegroundColor $UserBackgroundColor -BackgroundColor $HostBackgroundColor -NoNewline

    # Host symbol
    $symbol = if (IsAdmin) { '#' } else { '$' }
    Write-Host " $symbol " -ForegroundColor 'White' -BackgroundColor $HostBackgroundColor -NoNewline
    # Write-Host '' -ForegroundColor $HostBackgroundColor -NoNewline

    return ' '
}
