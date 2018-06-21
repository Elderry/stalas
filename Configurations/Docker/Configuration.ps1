$target = if ($IsWindows) { "$Env:ProgramData/Docker/" } `
    elseif ($IsMacOS) { '~/.docker' }
$target = "$target/certs.d/docker.tradeshift.net"

New-Item -ItemType 'directory' $target -Force | Out-Null
Copy-Item "$PSScriptRoot/../../Resources/Certificates/Root - TS.crt" "$target/ca.crt"
Copy-Item "$PSScriptRoot/../../Resources/Certificates/client.cert" "$target/client.cert"
Copy-Item "$PSScriptRoot/../../Resources/Private/client.key" "$target/client.key"
