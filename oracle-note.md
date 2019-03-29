Oracleのわけのわからなさは
* 歴史的なもの
* 環境的なもの
* ライセンスのせい
* すぐ変わるURL
* アカウントがないと何も見れない

などが原因と思われる。まあ仕事でなかったら絶対に使わないよね。


- [FAQリンク](#faq%E3%83%AA%E3%83%B3%E3%82%AF)
- [エディション](#%E3%82%A8%E3%83%87%E3%82%A3%E3%82%B7%E3%83%A7%E3%83%B3)
- [Oracleの入手先](#oracle%E3%81%AE%E5%85%A5%E6%89%8B%E5%85%88)
- [X](#x)
- [sqlplusと叩いたときに何が起きているのか](#sqlplus%E3%81%A8%E5%8F%A9%E3%81%84%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AB%E4%BD%95%E3%81%8C%E8%B5%B7%E3%81%8D%E3%81%A6%E3%81%84%E3%82%8B%E3%81%AE%E3%81%8B)
- [listener.ora](#listenerora)

# FAQリンク

Oracleの情報は見つけるのがしんどい。

Oracleは12cの次が18c。


# エディション

Oracle12c(12.1.0.2以降)では
* Enterprise Edition（EE）
* Standard Edition 2（SE2）
* Personal Edition（PE）
(偉い順)

学習用なら`Personal Edition（PE）`。

[Oracle Database Personal Edition の使用上の制限について教えて下さい。](https://faq.oracle.co.jp/app/answers/detail/a_id/2649/~/oracle-database-personal-edition-%E3%81%AE%E4%BD%BF%E7%94%A8%E4%B8%8A%E3%81%AE%E5%88%B6%E9%99%90%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E6%95%99%E3%81%88%E3%81%A6%E4%B8%8B%E3%81%95%E3%81%84%E3%80%82)

(古い)[Oracle Database Standard Edition 2と、Oracle Database Standard Edition、Oracle Database Standard Edition Oneの違いを教えて下さい。](https://faq.oracle.co.jp/app/answers/detail/a_id/2797/related/1)

# Oracleの入手先

[Oracle Database ソフトウェア･ダウンロード](https://www.oracle.com/technetwork/jp/database/enterprise-edition/downloads/index.html)

PE版というものは特にない。普通にSE版を入れればOKで、あとは「使用上の制限」に従って使えばよい。


参考:
* [Oracle12cのエディションとは | Oracle初心者でもスッキリわかる](https://sql-oracle.com/?p=417)
* [Oracle Database 12c エディション比較 - SE/EEの違い、Enterprise Editionでできること | Oracle オラクルエンジニア通信 - 技術資料、マニュアル、セミナー Blog](https://blogs.oracle.com/oracle4engineer/oracle-database-12c-seeeenterprise-edition)
* [Oracle Databaseのエディション毎の違い | Oracle Technology Network Japan Blog](https://blogs.oracle.com/otnjp/oracle-database-v4)


[Oracleの起動モード(NOMOUNT・MOUNT・OPEN)と使い方 | Oracle初心者でもスッキリわかる](https://sql-oracle.com/?p=56)


# X

ちょっと仮想マシン上に環境を作るにはしきいが高い。

Xが必要。

RHEL/CentOSの場合
```
sudo yum -y groupinstall "X Window System"
sudo yum -y install vlgothic-* xterm xorg-x11-apps
```

[Microsoft Azure上でのCentOS仮想マシン作成と、X11転送でGUIインストーラをWindowsから操作する手順 - Elixir Report](https://qiita.com/mdmom/items/1b8044dcb21e38510a44)

sshdが`X11Forwarding yes`になってるか確認。

sshでログインするユーザのhomeに.Xauthorityファイルを作る。
```
touch ~/.Xauthority
```

X11を有効にしたputtyで接続し、DISPLAY環境変数を表示してみる。
```
$ echo $DISPLAY
localhost:10.0
```
こんな感じになれば準備OK

[PuTTY + Xming でX を使おう](http://www.ep.sci.hokudai.ac.jp/~epnetfan/tebiki/server-login/xming.html)

XサーバはVcXsrvを使ってみる。
[VcXsrv Windows X Server download | SourceForge.net](https://sourceforge.net/projects/vcxsrv/)

Xサーバを普通にインストール&起動したあと、
puttyから`xeyes &`してxeyesが表示されればOK(ものすごく遅いかも)。

あとはputtyで`xterm &`でターミナル起動して、
そこからLinuxを操作する。




# sqlplusと叩いたときに何が起きているのか

リスナー経由の接続と、そうでない接続。

`@`なしだと直接接続。

`@<接続識別子>`だとリスナー経由 (接続識別子は`tnsnames.ora`に書いてあるやつ)

リスナー経由の方法は`@<接続識別子>`以外にもいくつかある。


* [「データベースへの接続の仕組み」を正しく理解する (1/2)：ゼロからのリレーショナルデータベース入門（8） - ＠IT](http://www.atmarkit.co.jp/ait/articles/0905/28/news109.html)
* [データベースの識別とアクセス](https://docs.oracle.com/cd/E57425_01/121/NETAG/concepts.htm#CIHGGHEE)

* [リスナーを経由しない接続 - 解決!ORACLE!](http://www.noguopin.com/oracle/index.php?%A5%EA%A5%B9%A5%CA%A1%BC%A4%F2%B7%D0%CD%B3%A4%B7%A4%CA%A4%A4%C0%DC%C2%B3)
* [ORACLE　クライアント接続設定(クライアント編)](http://www.doppo1.net/oracle/beginner/network_connect_2.html)
* [「データベースへの接続の仕組み」を正しく理解する (1/2)：ゼロからのリレーショナルデータベース入門（8） - ＠IT](http://www.atmarkit.co.jp/ait/articles/0905/28/news109.html)

# listener.ora


完全なリファレンス:
[Oracle Database Net Services管理者ガイド12cリリース1 (12.1)](https://docs.oracle.com/cd/E57425_01/121/NETAG/toc.htm)

Oracle Net Servicesというのがリスナー。

* [12.10.2 リスナーの設定とネットサービス名の登録（Oracleの場合）](http://software.fujitsu.com/jp/manual/manualfiles/M080163/J2X15990/05Z200/setup12/setup265.html)
* (重要)[Oracle Net Listenerの構成と管理](http://otndnld.oracle.co.jp/document/products/oracle11g/111/doc_dvd/network.111/E05725-04/listenercfg.htm)
* [リスナー・パラメータ（listener.ora）](http://otndnld.oracle.co.jp/document/products/oracle10g/102/doc_cd/network.102/B19209-01/listener.htm)

典型的なlistener.ora
```
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
    )
  )
SID_LIST_LISTENER=
  (SID_LIST=
    (SID_DESC=
      (SID_NAME=XXX)
      (ORACLE_HOME=/oracle10g)
      (PROGRAM=extproc)
    )
  )
```
リスナー名`LISTNEER`を指定した例。これに`SID_LIST_<リスナー名>`でSIDの「静的登録」をする。
外部プロシージャ・エージェント

ただし、動的サービス登録すれば静的登録は不要。
- (古い)PMONプロセス（PMON process）プロセス・モニター・データベース・プロセスによって
- (12c)リスナー登録(LREG)プロセスによって
動的登録されるらしい。

確認は
```
 lsnrctl status
``
[インスタンスのリスナーへの登録（その１） | サイクル＆オラクル](http://onefact.jp/wp/2015/07/05/%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%8A%E3%83%BC%E3%81%B8%E3%81%AE%E7%99%BB%E9%8C%B2%EF%BC%88%E3%81%9D%E3%81%AE%EF%BC%91%EF%BC%89/)
[インスタンスのリスナーへの登録（その２） | サイクル＆オラクル](http://onefact.jp/wp/2015/07/12/%e3%82%a4%e3%83%b3%e3%82%b9%e3%82%bf%e3%83%b3%e3%82%b9%e3%81%ae%e3%83%aa%e3%82%b9%e3%83%8a%e3%83%bc%e3%81%b8%e3%81%ae%e7%99%bb%e9%8c%b2%ef%bc%88%e3%81%9d%e3%81%ae%ef%bc%92%ef%bc%89/)


SIDまたはサービス名(service_name)
> SID,サービス名は接続先データベースを識別する名前だと考えてください。 過去のバージョンではSIDしか使用できませんでしたが8iのバージョン以降SIDに機能拡張されたサービスという仕組みが追加されました。 単純に接続するだけであればどちらを設定しても問題はなくデフォルトではSIDとサービス名は同じ名前が設定されるためあまり意識する必要はありませんが サービス名を指定して接続するとDB側で様々な統計がサービス単位で収集されチューニング等に役立つ場合があるのでサービス名指定での接続をお勧めします。 リスナ側で設定したSIDやサービス名とデータベースの設定は一致しなくては接続できませんが、 設定を行わなくともデフォルト設定だとデータベース側が自動でリスナへ自身の情報を登録させにきます。
引用元:
[ORACLE　クライアントからの接続設定(サーバ編)](http://www.doppo1.net/oracle/beginner/network_connect.html)

listener.oraとtnsnames.ora


# IPCつかってみる

listener.oraとtnsnames.oraのサンプル。
* [サンプル・ファイル](http://otndnld.oracle.co.jp/document/products/oracle10g/102/doc_cd/gateways.102/B25249-01/a_smpfil.htm)