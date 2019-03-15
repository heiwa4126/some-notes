その他いろいろノート

- [Tomcatの新し目のやつをRHELに入れたときに参考にした記事](#tomcatの新し目のやつをrhelに入れたときに参考にした記事)

# Tomcatの新し目のやつをRHELに入れたときに参考にした記事

* [CentOS 7にTomcat9/JDK8の開発環境を構築する - Qiita](https://qiita.com/mkyz08/items/97802acb6911f0173e7c)

自分は OpenJDK(RHELの配布)と、ApacheのTomcat9で設定した。
「参考」というよりはほぼそのままコピペ(tomcat.seviceとか)。

- /optの下に展開する
- /etc/profile.dで全ユーザにJAVA_HOME,CATALINA_HOMEを設定する
- 「Managerにログイン」の設定方法が載ってる

のがよい。

logrotateだけ追加したけど、
tomcat9では自前のloggerがちゃんとしてるので
いらないかもしれない。

単にJava Servletコンテナを使うんだったらjettyのほうがいいんじゃないかとは思うけど、諸般の事情があって辛い。
