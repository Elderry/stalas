# Custom Variables
Set-Alias au '~/Projects/Personal/chocolatey-packages/update_all.ps1'
Set-Alias aphro '~/Projects/Personal/Aphrodite/Aphrodite/bin/Release/netcoreapp3.1/win10-x64/Aphrodite.exe'
Set-Alias config '~/Projects/Personal/stalas/config.ps1'

# Custom Commands
Remove-Item Alias:ls
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
function git_open {
    (git remote get-url origin) -match ':(.+)\.' | Out-Null
    $path = $Matches[1]
    (git branch | Where-Object { $_.StartsWith('*') }) -match '\* ([\w-]+)' | Out-Null
    $branch = $Matches[1]
    Start-Process "https://github.com/$path/tree/$branch"
}
function git_push {
    $first_try = & git push 2>&1
    Write-Host $first_try -Separator "`n"
    if ($first_try[3] -Match '^\s*(git push --set-upstream origin \S+)$') {
        Write-Host "The push is recoverable, going to retry..."
        Invoke-Expression $Matches[1]
    }
}
function Flatten-Files {
    Get-ChildItem -Recurse -File | ForEach-Object {
        if ((Test-Path -LiteralPath $_.Name) -and ($_.Directory.FullName -ne $PWD)) {
            Move-Item -LiteralPath $_.FullName -Destination "$PWD/$($_.Directory.Name) - $($_.Name)"
        } else {
            Move-Item -LiteralPath $_.FullName -Destination "$PWD/$($_.Name)"
        }
    }
    Get-ChildItem -Directory | ForEach-Object {
        Remove-Item $_.Name -Recurse
    }
}
function Compress-Images([switch] $Recurse) {
    if ($Recurse) {
        Get-ChildItem -Directory | ForEach-Object {
            Set-Location -LiteralPath $_.Name
            Compress-Images -Recurse
            Convert-Images
            Set-Location ..
        }
    }
    if (-not (Get-ChildItem -Filter *.jpg)) { return }
    magick mogrify -monitor -strip -quality 85% *.jpg
    Convert-Images
}
function Convert-Images {
    if (-not (Get-ChildItem -Filter *.png)) { return }
    magick mogrify -monitor -format jpg *.png
    Remove-Item *.png
}

# Modules
if (!$global:GitPromptSettings) { Import-Module 'posh-git' }
$global:GitPromptSettings.BeforeText = ' ['
$global:GitPromptSettings.AfterText  = '] '

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
    'Number' = [ConsoleColor]::Green
    'Member' = [ConsoleColor]::Magenta
    'Type' = [ConsoleColor]::DarkYellow
    'ContinuationPrompt' = [ConsoleColor]::DarkMagenta
}

if ((Get-Service ssh-agent).Status -ne 'Running') {
    ssh-agent
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
    $path = " $($PWD.Path -replace ($HOME -replace '\\', '\\'), '~' -replace '\\', '/') "
    Write-Host $path -ForegroundColor 'White' -BackgroundColor $DirectoryBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $DirectoryBackgroundColor

    # User
    $user = " $Env:USERNAME@$((Get-Culture).TextInfo.ToTitleCase($env:USERDOMAIN.ToLower())) "
    Write-Host $user -ForegroundColor 'White' -BackgroundColor $UserBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $UserBackgroundColor -BackgroundColor $HostBackgroundColor -NoNewline

    # Host symbol
    $symbol = if (IsAdmin) { '#' } else { '$' }
    Write-Host " $symbol " -ForegroundColor 'White' -BackgroundColor $HostBackgroundColor -NoNewline
    Write-Host '' -ForegroundColor $HostBackgroundColor -NoNewline

    return ' '
}
# This has to be after prompt function because zLocation alters prompt to work.
Import-Module -Name 'zLocation'
