
# /etc/altanativeとsetenv.sh

RHELなんかで、パッケージで入れるopenjdk-1.8.0と
バイナリビルドから入れるtomcat9を
うまく付き合わせるには、

[tomcat/catalina.sh at master · apache/tomcat](https://github.com/apache/tomcat/blob/master/bin/catalina.sh)
は、同じパスにあるsetenv.shを読むので

/opt/tomcat/apache-tomcat-vvvvv/bin/setenv.sh
```sh
# [JAVA HOME]
JAVA_HOME=$(readlink -f /bin/java | sed 's|/bin/java$||')

# [CATALINA_OPTS] の例
CATALINA_OPTS="$CATALINA_OPTS -Xms1024M"
CATALINA_OPTS="$CATALINA_OPTS -Xmx1024m"
CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=1024M"
CATALINA_OPTS="$CATALINA_OPTS -Djava.net.preferIPv4Stack=true"
```
みたいに書いておくと、altanativeシステムとうまく付き合える。