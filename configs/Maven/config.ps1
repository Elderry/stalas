param(
    [ValidateSet('TS', 'TSCN')]
    [string] $environment = 'TSCN'
)

Import-Module powershell-yaml

$resource = (Resolve-Path '~/OneDrive/Collections/AppBackup/Tradeshift').Path -replace '\\', '/'
$LDAP = Get-Content "$resource/LDAP.yml" -Raw | ConvertFrom-Yaml
switch ($environment) {
    'TSCN' { $mail = 'lry@cn.tradeshift.com' }
    'TS' { $mail = 'lry@tradeshift.com' }
}
$keyStorePassword = Get-Content "$resource/$mail.pfx.pass.txt"
$opts = "-Djavax.net.ssl.keyStore=$resource/$mail.pfx " +
    "-Djavax.net.ssl.keyStoreType=pkcs12 " +
    "-Djavax.net.ssl.keyStorePassword=$keyStorePassword"
if ($IsWindows) {
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts, 'User')
    [Environment]::SetEnvironmentVariable('SBT_OPTS', $opts, 'User')
    [Environment]::SetEnvironmentVariable('GRAILS_OPTS', $opts, 'User')
} elseif ($IsMacOS) {
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('SBT_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('GRAILS_OPTS', $opts)

    (Get-Content '~/.bash_profile') `
        -replace '~', (Resolve-Path '~').Path `
        -replace '\w+@.+\.pfx', "$mail.pfx" `
        -replace '(-Djavax\.net\.ssl\.keyStorePassword=).+"', "`${1}$($keyStorePassword)`"" |
        Set-Content '~/.bash_profile'
} elseif ($IsLinux) {
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('SBT_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('GRAILS_OPTS', $opts)
    (Get-Content '~/.bashrc') `
        -replace '~', (Resolve-Path '~').Path `
        -replace '\w+@.+\.pfx', "$mail.pfx" `
        -replace '(-Djavax\.net\.ssl\.keyStorePassword=).+"', "`${1}$($keyStorePassword)`"" |
        Set-Content '~/.bashrc'
}

(Get-Content "$resource/Maven/settings - $environment.xml") `
    -replace '{user}', $LDAP.$environment.user `
    -replace '{password}', $LDAP.$environment.password |
    Set-Content '~/.m2/settings.xml'
