. "$PSScriptRoot/../common.ps1"

$resources = '~/OneDrive/Collections/AppBackup/Tradeshift'
if ($IsWindows) {
    $targetPath = "$Env:ProgramData/Docker/certs.d"
} elseif ($IsMacOS) {
    $targetPath = '~/.docker/certs.d'
} elseif ($IsLinux) {
    $targetPath = '/etc/docker/certs.d'
}
$TSDomain = "$targetPath/docker.tradeshift.net"
$TSCNDomain = "$targetPath/registry.bwtsi.cn"

New-Directory $TSDomain
New-Directory $TSCNDomain
Copy-Item "$resources/root-ca.crt" "$TSDomain/ca.crt"
Copy-Item "$resources/root-ca-cn.crt" "$TSCNDomain/ca.crt"

Copy-Item "$resources/lry@tradeshift.com.crt" "$TSDomain/client.cert"
Get-Content "$resources/employee-ca.crt" | Out-File -Append -FilePath "$TSDomain/client.cert"
Copy-Item "$resources/lry@cn.tradeshift.com.crt" "$TSCNDomain/client.cert"
Get-Content "$resources/employee-ca-cn.crt" | Out-File -Append -FilePath "$TSCNDomain/client.cert"

Copy-Item "$resources/lry@tradeshift.com.key" "$TSDomain/client.key"
Copy-Item "$resources/lry@cn.tradeshift.com.key" "$TSCNDomain/client.key"
