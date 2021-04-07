# OpenJDKメモ

- [OpenJDKメモ](#openjdkメモ)
- [参考リンク](#参考リンク)
- [OpenJDKの概要](#openjdkの概要)
  - [JREの廃止](#jreの廃止)
  - [Java8](#java8)
- [Oracleの提供するOpenJDKのバイナリ](#oracleの提供するopenjdkのバイナリ)
- [Oracle以外が配布するOpenJDKのバイナリ](#oracle以外が配布するopenjdkのバイナリ)
  - [AdoptOpenJDKによる配布](#adoptopenjdkによる配布)
  - [Azul Systemsによる配布 (Zulu)](#azul-systemsによる配布-zulu)
  - [Red Hatによる配布](#red-hatによる配布)
  - [Amazonによる配布 (Amazon Corretto)](#amazonによる配布-amazon-corretto)
  - [Microsoft Build of OpenJDK](#microsoft-build-of-openjdk)
  - [その他の配布](#その他の配布)

# 参考リンク

わかりやすい:

- [Introduction to Java 11: Support and JVM Features #jjug](https://www.slideshare.net/YujiKubota/introduction-to-java-11-support-and-jvm-features)
- [Oracle Java SEの有償化に伴うOpenJDKへの切り替えの案内 | 京都教育大学 情報処理センター](https://ipc.kyokyo-u.ac.jp/page/696)
- [来月にはJava 10が登場し、9月にはJava 11が登場予定。新しいリリースモデルを採用した今後のJava、入手方法やサポート期間はこう変わる（OpenJDKに関する追記あり） － Publickey](https://www.publickey1.jp/blog/18/java_109java_11java.html)
- [Java Is Still Free - Google ドキュメント](https://docs.google.com/document/d/1nFGazvrCvHMZJgFstlbzoHjpAVwv5DEdnaBr_5pKuHo/preview#heading=h.pcjnntz9twpw)
- [Javaは今も無償です - Google ドキュメント](https://docs.google.com/document/d/1HtUnuAkUEDGL2gwUOkrDrmLe_zrD6wpAyqYBZxRmHv4/edit)
- [最適なOpenJDKディストリビューションの選び方(PDF)](https://www.oracle.co.jp/campaign/code/2019/pdfs/oct2019_b-3-3.pdf)

Oracle公式:

- [JDKの新しいリリース・モデル、および提供ライセンスについて](https://www.oracle.com/technetwork/jp/articles/java/ja-topics/jdk-release-model-4487660-ja.html)
- [Oracle Java SE サポート･ロードマップ](https://www.oracle.com/technetwork/java/eol-135779-ja.html)

Wikipedia:

- [OpenJDK - Wikipedia](https://en.wikipedia.org/wiki/OpenJDK)
- [OpenJDK - ウィキペディア](https://ja.wikipedia.org/wiki/OpenJDK)


# OpenJDKの概要

OpenJDKはオープンソースとして配布(ソースのみ提供。
OpenJDKのレポジトリ [OpenJDK Mercurial Repositories](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjgiKH29eXhAhWmyosBHVmaBOQQFjAAegQIABAB&url=https%3A%2F%2Fhg.openjdk.java.net%2F&usg=AOvVaw2qWknA1P18mdKk5PNw3FVa))。

新しいバージョンが出た時点で、Oracleによるメンテナンス終了。

毎年3月と9月に新しいバージョン(新機能の追加や機能の変更が行われるフィーチャー・リリース)が出る。つまり6ヶ月毎に更新する必要がある。

Oracle JDKはOpenJDKより機能が多く、サポート期間が長い以外は、機能的には同じもの(バージョン番号が同じならば)。

Oracle JDKは有償。
LTS版(Long Term Support)は3年、
non‑LTSは6ヶ月
サポート。
(詳しくは[Oracle Java SE サポート･ロードマップ](https://www.oracle.com/technetwork/java/eol-135779-ja.html)参照)

「Oracle Java 11以降はオラクルとの契約なしでの商用利用を全く許可しない」という点が
Oracle JDKとOpenJDKの最大の相違。

OpenJDKはオープンソース([GPLv2+CE](http://openjdk.java.net/legal/gplv2+ce.html))なので、
バイナリのビルド&配布は誰がやってもいいし、
Oracleのサポート終了後、フォークしてバックポートしてもかまわない。


## JREの廃止

Oracleは
Java Runtime Environment (JRE)の配布を廃止する。その理由は以下の通り:

(「[JDKの新しいリリース・モデル、および提供ライセンスについて](https://www.oracle.com/technetwork/jp/articles/java/ja-topics/jdk-release-model-4487660-ja.html)」から引用)

> JavaアプリケーションはシステムにインストールされたJREを使って実行されていた。

> Javaの脆弱性問題から最新版のJREに移行する必要が生じた際、ユーザー側はアプリケーション・ベンダーが最新版を推奨していないために移行できず、
一方でアプリケーション・ベンダー側は多くのユーザーが旧バージョンを利用しており、サポートの手間を考慮すると簡単には移行できないといったジレンマが生じるケースがある。

> Java SE 8までのJava仕様ではJREのサブセットを作ることはできず、アプリケーションが使わないライブラリも含めたフルセットの巨大なJREをバンドルする必要があった。

> 今後はカスタマイズしたJREをアプリケーションにバンドルする方法を推奨 (参考:[jlink](https://docs.oracle.com/javase/jp/9/tools/jlink.htm))

OracleはOracleJavaでもOracle OepnJDKでもJREを廃止するが、
Oracle以外でOpenJDKでJRE相当のパッケージを出しているディストリビューターはある。


## Java8

> 商用ユーザー向けの最後の無償バージョンはJava 8 Update 201(8u201)とJava 8 Update 202(8u202)です。
このバージョンは商用ユーザーであっても無償で使用し続けることができます。
ただし、今後脆弱性を修正したバージョンの無償提供は行われません。

([Oracle Java SEの有償化に伴うOpenJDKへの切り替えの案内 | 京都教育大学 情報処理センター](https://ipc.kyokyo-u.ac.jp/page/696)から引用)

Java8でも2019年4月16日以降のリリース(8u211,8u212以降)は、ライセンスが変わって有償。

正確には「2019年1月が商用無償の最後(Free updates superseded / ended (by Oracle) ... Ends January 2019 for commercial use)」。
8u201,202は1月15日リリース。


- [JDK 8 Update Release Notes](https://www.oracle.com/technetwork/java/javase/8u-relnotes-2225394.html)
- [Java™ SE Development Kit 8, Update 212 Release Notes](https://www.oracle.com/technetwork/java/javase/8u212-relnotes-5292913.html) 新元号対応 + セキュリティパッチ


# Oracleの提供するOpenJDKのバイナリ

OracleがビルドしたOpenJDKのバイナリは
[OpenJDK](http://openjdk.java.net/)
から入手できる。

Oracleの提供するOpenJDKのバイナリのアーカイブは
[Archived OpenJDK GA Releases](http://jdk.java.net/archive/)
から入手できる(セキュリティ問題やバグが含まれている。また更新もされない)

Oracleの提供するOpenJDKのバイナリには「インストーラー」が無い。WindowsではZIPの展開、環境変数の設定を手動で行う
(参考:[Chapter 1. Getting Started with OpenJDK 11 for Windows - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/openjdk/11/html/openjdk_11_for_windows_getting_started_guide/getting_started_with_openjdk_for_windows))

その性質上、基本6ヶ月ごとにアップグレードするべき。

JDK8はここから

[Java SE Development Kit 8 - Downloads](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)
Oracleのアカウントが必要(free)

# Oracle以外が配布するOpenJDKのバイナリ

(Linuxはディストリビューションのパッケージを普通に使用するのが基本)

利点:

- 「インストーラー」がある配布が多い
- 無償のLTS (+ 有償によるサポート)
- OracleのOpenJDK buildと違って過去バージョンもある(特にJava8)
- JDKだけでなくJREに相当する配布があるものがある
- 32bit版がある。

欠点:

- サポート期間や範囲が不安
- 無償の範囲がさまざまでわかりにくい (Cloudのみ、非商用など)
- OpenJDK, OracleのOpenJDK buildよりリリースが少し遅れる

参考:

- [Oracle Java SEの有償化に伴うOpenJDKへの切り替えの案内 | 京都教育大学 情報処理センター](https://ipc.kyokyo-u.ac.jp/page/696)
- [JDKの長期商用サポート(LTS)の提供ベンダー比較（無償利用についても言及あり） - Qiita](https://qiita.com/u-tanick/items/bb166929a58a4c20bb88)
- [Javaのサポートについてのまとめ - Qiita](https://qiita.com/nowokay/items/edb5c5df4dbfc4a99ffb)
- [Oracle JDK 8 の無償アップデート終了後の選択肢は何があるのか | そるでぶろぐ](https://devlog.arksystems.co.jp/2018/09/21/5953/)
- [Oracle Java 更新版公開、ただしライセンス変更に注意。抵触する場合はOpenJDKへの移行を - 特に重要なセキュリティ欠陥・ウイルス情報](https://www.st.ryukoku.ac.jp/blog/vuln/01058)


## AdoptOpenJDKによる配布

- コミュニティベース(スポンサーにIBMがいる)
- JRE相当の配布あり
- OpenJDK(HotSpot)にIBMのOpenJ9を追加したバージョンの配布あり
- OpenJDK 11をLTS(4年)

リンク:

- [AdoptOpenJDK - Open source, prebuilt OpenJDK binaries](https://adoptopenjdk.net/)
- [コミュニティのOpenJDKビルドファームが稼働](https://www.infoq.com/jp/news/2018/04/AdoptOpenJDKMar18)


## Azul Systemsによる配布 (Zulu)

- JavaFX(OpenFX)の配布がある(ZuluFX)

リンク:

- [OpenJDK Java Linux Windows macOS Alpine Java 11 Java 8のダウンロード](https://jp.azul.com/downloads/zulu/)

MicrosoftはAzure上ではZuluを推していく模様。

- [Microsoft and Azul Systems bring free Java LTS support to Azure | Blog | Microsoft Azure](https://azure.microsoft.com/en-us/blog/microsoft-and-azul-systems-bring-free-java-lts-support-to-azure/)


## Red Hatによる配布

- RHELとWindowsをサポート
- OpenJDK11は2024年10月までサポート
- Red Hat Networkのアカウントが必要(無料アカウントあり)
- Windows用は開発用途専用らしい(あいまい)

リンク:

- [OpenJDK Life Cycle and Support Policy - Red Hat Customer Portal](https://access.redhat.com/articles/1299013)
- [Product Documentation for OpenJDK 11 - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/openjdk/11/)
- [Red Hat Developer | Red Hat OpenJDK Download](https://developers.redhat.com/products/openjdk/download/)
- [Red Hat、Windows版OpenJDKの長期商用サポート提供を発表 － Publickey](https://www.publickey1.jp/blog/18/red_hatwindowsopenjdklts.html)
- [Red HatのOpenJDKのサポート - nekop's blog](https://nekop.hatenablog.com/entry/2018/09/18/115712)


## Amazonによる配布 (Amazon Corretto)

- OpenJDK 8,11をLTS
- AWS上のみ使用可、というわけではなく、どこでつかってもいい。
- Windows版はMSIインストーラ付き

リンク:

- [Amazon Corretto（本番環境に対応したOpenJDKディストリビューション）| AWS](https://aws.amazon.com/jp/corretto/)
- [Amazon Corretto FAQs](https://aws.amazon.com/jp/corretto/faqs/)
- [Amazon Corretto Documentation](https://docs.aws.amazon.com/corretto/index.html)
- [Amazon Corretto 8 とは - Amazon Corretto 8](https://docs.aws.amazon.com/ja_jp/corretto/latest/corretto-8-ug/what-is-corretto-8.html)
- [What Is Amazon Corretto 11? - Amazon Corretto](https://docs.aws.amazon.com/ja_jp/corretto/latest/corretto-11-ug/what-is-corretto-11.html)

## Microsoft Build of OpenJDK

- [Microsoft Build of OpenJDK](https://msopenjdk.azurewebsites.net/)
- [マイクロソフトが無償でJavaの長期サポートを提供へ、「Microsoft Build of OpenJDK」をリリース － Publickey](https://www.publickey1.jp/blog/21/javamicrosoft_build_of_openjdk.html)

(2021-04現在)OpenJDK 11でいいなら、これかな...


## その他の配布

以下参照

- [OpenJDK Builds - OpenJDK - Wikipedia](https://en.wikipedia.org/wiki/OpenJDK#OpenJDK_Builds)
- [パーミッシブ・ライセンス - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%91%E3%83%BC%E3%83%9F%E3%83%83%E3%82%B7%E3%83%96%E3%83%BB%E3%83%A9%E3%82%A4%E3%82%BB%E3%83%B3%E3%82%B9)
