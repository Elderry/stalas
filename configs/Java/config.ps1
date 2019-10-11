#Requires -RunAsAdministrator

param(
    [ValidateSet(8, 10, 11, 12)]
    [int] $version = 11,
    [ValidateSet('TS', 'TSCN', 'ALL')]
    [string] $environment = 'TSCN',
    [string] $storePass = 'changeit'
)

if (-not ((Test-Path $Env:JAVA_HOME))) {
    Write-Error "JAVA_HOME [$JAVA_HOME] needs to be a valid java directory."
    exit
}

(java -version 2>&1)[0] -Match '(java|openjdk) version "(\d+)(\.(\d+))?(\.[_\d]+)?"' | Out-Null
$modernJava = $Matches[2] -ne 1

# Modern Java uses sha-256 finger print instead of sha-1.
if ($modernJava) {
    $TS_ROOT_CA_FINGERPRINT = '3A:98:46:AA:24:54:11:0A:3E:74:AE:15:87:BA:3B:56:4E:BD:88:7A:7E:41:F8:4D:C7:D7:79:CD:5D' +
        ':16:11:E2'
    $TS_EMPLOYEE_CA_FINGERPRINT = 'AF:4D:B9:BD:9B:6D:B1:FC:CA:FB:D3:5F:E5:DC:62:A2:90:1E:B8:E9:D3:BE:D8:83:A2:BF:DB:C' +
        '8:56:15:47:46'
    $TSCN_ROOT_CA_FINGERPRINT = 'CB:24:22:5C:27:C3:AC:C3:43:A6:DD:CA:9A:FD:79:8A:55:42:8B:2D:C4:91:BD:1A:36:93:2E:E2:' +
        'FE:AB:05:C7'
    $TSCN_EMPLOYEE_CA_FINGERPRINT = '22:A2:A4:25:6F:40:E3:09:69:DE:42:C5:4E:9C:50:A6:FF:C5:8E:3C:8B:CE:A9:C8:8C:8C:55' +
        ':F0:16:2B:68:A6'
} else {
    $TS_ROOT_CA_FINGERPRINT = 'EC:AE:D0:96:5A:4E:A7:6A:5D:53:B0:70:55:E8:CA:12:09:BF:78:0B'
    $TS_EMPLOYEE_CA_FINGERPRINT = 'EB:E1:44:3D:1F:7C:97:3C:7F:27:B5:1D:3C:D1:A0:4F:8B:91:98:12'
    $TSCN_ROOT_CA_FINGERPRINT = 'A3:A8:A1:00:5B:36:FF:FE:84:29:23:41:05:26:60:FD:6D:ED:D7:F1'
    $TSCN_EMPLOYEE_CA_FINGERPRINT = 'D5:65:43:CA:25:83:51:B4:68:09:CE:0B:63:C9:E3:A1:4B:4E:13:FA'
}

if (-not $modernJava) {
    $certsPath = "$Env:JAVA_HOME/jre/lib/security/cacerts/"
}

function Add-Cert($file, $alias, $fingerprint) {

    $file = (Resolve-Path "~/OneDrive/Collections/AppBackup/Tradeshift/$file").Path
    if ($modernJava) {
        $certs = keytool -list -cacerts -storepass $storePass
        if ($certs.Where({ $_.Contains($fingerprint) }).Count -eq 0) {
            keytool -importcert -cacerts -storepass $storePass -alias $alias -file $file -noprompt
        } else {
            Write-Host "Certificate [$alias] is already in trust store."
        }
    } else {
        $certs = keytool -list -keystore $certsPath -storepass $storePass
        if ($certs.Where({ $_.Contains($fingerprint) }).Count -eq 0) {
            keytool -importcert -keystore $certsPath -storepass $storePass -alias $alias -file $file -noprompt
        } else {
            Write-Host "Certificate [$alias] is already in trust store."
        }
    }
}

if (($environment -eq 'TS') -or ($environment -eq 'ALL')) {
    Add-Cert 'root-ca.crt' 'root_ca_ts' $TS_ROOT_CA_FINGERPRINT
    Add-Cert 'employee-ca.crt' 'employee_ca_ts' $TS_EMPLOYEE_CA_FINGERPRINT
}
if (($environment -eq 'TSCN') -or ($environment -eq 'ALL')) {
    Add-Cert 'root-ca-cn.crt' 'root_ca_tscn' $TSCN_ROOT_CA_FINGERPRINT
    Add-Cert 'employee-ca-cn.crt' 'employee_ca_tscn' $TSCN_EMPLOYEE_CA_FINGERPRINT
}
