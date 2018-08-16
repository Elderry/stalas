param(
    [ValidateSet('TS', 'TSCN')]
    [string] $environment = 'TSCN'
)

Import-Module powershell-yaml

$private = [IO.Path]::GetFullPath("$PSScriptRoot/../../Resources/Private") -replace '\\', '/'
$credentials = Get-Content "$private/Credentials.yml" -Raw | ConvertFrom-Yaml
switch ($environment) {
    'TSCN' { $mail = 'lry@cn.tradeshift.com' }
    'TS' { $mail = 'lry@tradeshift.com' }
}
$opts = "-Djavax.net.ssl.keyStore=$private/$mail.pfx " +
    "-Djavax.net.ssl.keyStoreType=pkcs12 " +
    "-Djavax.net.ssl.keyStorePassword=$($credentials["$environment-key-pair"])"
if ($IsWindows) {
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts, 'User')
    [Environment]::SetEnvironmentVariable('SBT_OPTS', $opts, 'User')
    [Environment]::SetEnvironmentVariable('GRAILS_OPTS', $opts, 'User')
} elseif ($IsMacOS) {
    [Environment]::SetEnvironmentVariable('MAVEN_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('SBT_OPTS', $opts)
    [Environment]::SetEnvironmentVariable('GRAILS_OPTS', $opts)

    config 'Bash'
    (Get-Content '~/.bash_profile') `
        -replace '\w+@.+\.pfx', $mail `
        -replace '(-Djavax\.net\.ssl\.keyStorePassword=).+"', "`${1}$($credentials["$environment-key-pair"])`"" |
        Set-Content '~/.bash_profile'
}

(Get-Content "$PSScriptRoot/Maven - $environment.xml") `
    -replace '{user}', $credentials["LDAP-$environment-user"] `
    -replace '{password}', $credentials["LDAP-$environment-password"] |
    Set-Content '~/.m2/settings.xml'
