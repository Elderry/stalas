param(
    [ValidateSet('TS', 'TSCN')]
    [string] $environment = 'TSCN'
)

Import-Module powershell-yaml

$private = [IO.Path]::GetFullPath("$PSScriptRoot/../../Resources/Private")
$credentials = Get-Content "$private/Credentials.yml" -Raw | ConvertFrom-Yaml
switch ($environment) {
    'TSCN' {
        $opts = "-Djavax.net.ssl.keyStore=$private\lry@cn.tradeshift.com.pfx " `
            + "-Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=$($credentials["$_-key-pair"])"
    }
    'TS' {
        $opts = "-Djavax.net.ssl.keyStore=$private\lry@tradeshift.com.pfx " `
            + "-Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=$($credentials["$_-key-pair"])"
    }
}
[Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts, 'User')

(Get-Content "$PSScriptRoot/Maven - $environment.xml") `
    -replace '{user}', $credentials["LDAP-$environment-user"] `
    -replace '{password}', $credentials["LDAP-$environment-password"] |
    Set-Content '~/.m2/settings.xml'
