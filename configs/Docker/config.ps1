$resources = "$PSScriptRoot/../../Resources/Certificates"
$private = "$PSScriptRoot/../../Resources/Private"

$certificates = '~/.docker/certs.d'
$TSDomain = "$certificates/docker.tradeshift.net"
$TSCNDomain = "$certificates/registry.bwtsi.cn"

New-Item -ItemType 'directory' $TSDomain -Force | Out-Null
New-Item -ItemType 'directory' $TSCNDomain -Force | Out-Null
Copy-Item "$resources/Root - TS.crt" "$TSDomain/ca.crt"
Copy-Item "$resources/Root - TSCN.crt" "$TSCNDomain/ca.crt"
Copy-Item "$resources/Certificate Bundle - TS.pem" "$TSDomain/client.cert"
Copy-Item "$resources/Certificate Bundle - TSCN.pem" "$TSCNDomain/client.cert"
Copy-Item "$private/Private Key - TS.pem" "$TSDomain/client.key"
Copy-Item "$private/Private Key - TSCN.pem" "$TSCNDomain/client.key"
