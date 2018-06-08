param(
    [ValidateSet('TS', 'TSCN')]
    [string] $environment = 'TSCN'
)

$private = [IO.Path]::GetFullPath("$PSScriptRoot/../Resources/Certificates/Private")
switch ($environment) {
    'TSCN' {
        $opts = "-Djavax.net.ssl.keyStore=$private\lry@cn.tradeshift.com.pfx " `
            + "-Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=112233"
    }
    'TS' {
        $opts = "-Djavax.net.ssl.keyStore=$private\lry@tradeshift.com.pfx " `
            + "-Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=231210"
    }
}

[Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts, 'User')
