Java関係ノート

- [Tomcatの新し目のやつをRHELに入れたときに参考にした記事](#Tomcat%E3%81%AE%E6%96%B0%E3%81%97%E7%9B%AE%E3%81%AE%E3%82%84%E3%81%A4%E3%82%92RHEL%E3%81%AB%E5%85%A5%E3%82%8C%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AB%E5%8F%82%E8%80%83%E3%81%AB%E3%81%97%E3%81%9F%E8%A8%98%E4%BA%8B)
- [tomcatで不要なwebapps](#tomcat%E3%81%A7%E4%B8%8D%E8%A6%81%E3%81%AAwebapps)


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
