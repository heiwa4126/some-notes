
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

RHEL7の標準のApache(httpd)付属の
mod_proxy_ajpは古くて、シークレットキーが使えない。

Tomcatのserver.xmlのajpの部分で

```xml
<Connector protocol="AJP/1.3"
               address="127.0.0.1"
               port="8009"
               redirectPort="8443"
               enableLookups="true"
               secretRequired="false" />
```
みたいに`secretRequired="false"`を入れてください。

モジュールのバージョン自体を知るコマンドはないし、
必ずバージョン文字列が埋め込まれてる、ということもない。
```
# httpd -v
Server version: Apache/2.4.6 (Red Hat Enterprise Linux)
Server built:   Apr 21 2020 10:19:09
```

TODO: 「シークレットキーが使える時」を書く

参考:
- [The Apache Tomcat Connectors - Reference Guide (1.2.48) - workers.properties configuration](https://tomcat.apache.org/connectors-doc/reference/workers.html)
- [mod_proxy_ajp - Apache HTTP Server Version 2.5](https://httpd.apache.org/docs/trunk/en/mod/mod_proxy_ajp.html)

# apache + tomcat ajp

tomcatのserver.xmlに↑のような記述を書いてtomcatを再起動

8009をtomcatが使ってるか確認。例:
```
# fuser -v 8009/tcp
                     USER        PID ACCESS COMMAND
8009/tcp:            tomcat    10823 F.... java
```

apacheでmod_proxyとmod_ajp_proxyが読みこまれてるか確認。例)
```
# httpd -M | grep proxy
 proxy_module (shared)
 proxy_ajp_module (shared)
...
```

読み込まれてなかったら、ディストリによって微妙に違うけど、RHEL7系の場合:

/etc/httpd/conf.modules.d/00-tomcat.conf
```
LoadModule proxy_module modules/mod_proxy.so
# LoadModule proxy_http_module modules/mod_proxy_http.so
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
```
こんなファイルを置く。
ついでに転送先の設定も:

/etc/httpd/conf.d/tomcat.conf
```
ProxyPass /tomcat-test/ ajp://127.0.0.1:8009/test/
```
webappのtest/以下に置かれたservlet or jspを
http://xxx.xxx.xxx/tomcat-test/でアクセスする設定。

`httpd -t`でシンタックスチェックの後apache再起動。

```
curl http://127.0.0.1:8080/test/hello.jsp
curl http://127.0.0.1/tomcat-test/hello.jsp
```
でテスト(上:Tomcat直接、下:Apache経由)