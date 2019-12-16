function New-Directory([string] $name) {
    if (Test-Path $name) { return }
    New-Item -ItemType 'directory' $name -Force | Out-Null
}

function Validate-OneDrive-Path() {
    if (Test-Path '~/OneDrive') {
        $script:oneDrive = "$Env:HOME/OneDrive"
    } elseif (Test-Path '/mnt/c/Windows') {
        $user = $(cmd.exe /c 'echo %USERNAME%' 2> $null)
        $script:oneDrive = "/mnt/c/Users/$user/OneDrive"
    } else {
        Write-Error 'Failed to detect a valid OneDrive path, exiting...'
        exit
    }
}
