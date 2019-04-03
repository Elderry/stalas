function New-Directory([string] $name) {
    if (Test-Path $name) { return }
    New-Item -ItemType 'directory' $name -Force | Out-Null
}
