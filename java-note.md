その他いろいろノート

- [Tomcatの新し目のやつをRHELに入れたときに参考にした記事](#tomcatの新し目のやつをrhelに入れたときに参考にした記事)
- [tomcatで不要なwebapps](#tomcatで不要なwebapps)

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

下の
[Tomcat の初期設定まとめ - Qiita](https://qiita.com/hidekatsu-izuno/items/ab604b6c764b5b5a86ed)
も参照

# tomcatで不要なwebapps

デフォルトで入っていることが多い(ディストリ版ではそうでもない)、
不要＆セキュリティに問題のあるwebapps

- ROOT
- docs
- examples
- manager
- host-manager

ディレクトリごと削除 または どこかに移動する。

参考:
- [Tomcat の初期設定まとめ - Qiita](https://qiita.com/hidekatsu-izuno/items/ab604b6c764b5b5a86ed)
