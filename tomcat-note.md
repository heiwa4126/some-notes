
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

参考:
[UbuntuにおけるTomcatの覚え書き - Qiita](https://qiita.com/hidekuro/items/119317f826253326e490)


# JSPでphpinfo()っぽいもの

動作確認とかしたい時に...

[cfmaniac/JSP-Info: JSP Info is similiar to phpInfo, perlInfo or my tag CFInfo](https://github.com/cfmaniac/JSP-Info)

`curl https://raw.githubusercontent.com/cfmaniac/JSP-Info/master/info.jsp -O`
で。


# AJPのトラブル

RHEL7の標準のApacheのmod_proxy_ajpは古くて、シークレットキーが使えない。

Tomcatのserver.xmlのajpの部分で

```xml
<Connector protocol="AJP/1.3"
               address="127.0.0.1"
               port="8009"
               enableLookups="false"
               redirectPort="8443"
               secretRequired="false" />
```
みたいに`secretRequired="false"`を入れてください。