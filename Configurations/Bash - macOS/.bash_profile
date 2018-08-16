# Java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# Maven
export MAVEN_OPTS="-Djavax.net.ssl.keyStore=/Users/ruiyang/Projects/Personal/config/Resources/Private/lry@cn.tradeshift.com.pfx \
                   -Djavax.net.ssl.keyStoreType=pkcs12 \
                   -Djavax.net.ssl.keyStorePassword=<key store password>"
