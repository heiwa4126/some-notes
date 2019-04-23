# OpenJDKメモ

- [OpenJDKメモ](#openjdk%E3%83%A1%E3%83%A2)
- [参考リンク](#%E5%8F%82%E8%80%83%E3%83%AA%E3%83%B3%E3%82%AF)
- [OpenJDKの概要](#openjdk%E3%81%AE%E6%A6%82%E8%A6%81)
  - [JREの廃止](#jre%E3%81%AE%E5%BB%83%E6%AD%A2)
- [Oracleの提供するOpenJDKのバイナリ](#oracle%E3%81%AE%E6%8F%90%E4%BE%9B%E3%81%99%E3%82%8Bopenjdk%E3%81%AE%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA)
- [Oracle以外が配布するOpenJDKのバイナリ](#oracle%E4%BB%A5%E5%A4%96%E3%81%8C%E9%85%8D%E5%B8%83%E3%81%99%E3%82%8Bopenjdk%E3%81%AE%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA)
  - [AdoptOpenJDKによる配布](#adoptopenjdk%E3%81%AB%E3%82%88%E3%82%8B%E9%85%8D%E5%B8%83)
  - [Azul Systemsによる配布 (Zulu)](#azul-systems%E3%81%AB%E3%82%88%E3%82%8B%E9%85%8D%E5%B8%83-zulu)
  - [Red Hatによる配布](#red-hat%E3%81%AB%E3%82%88%E3%82%8B%E9%85%8D%E5%B8%83)

# 参考リンク

- [JDKの新しいリリース・モデル、および提供ライセンスについて](https://www.oracle.com/technetwork/jp/articles/java/ja-topics/jdk-release-model-4487660-ja.html)
- [Oracle Java SE サポート･ロードマップ](https://www.oracle.com/technetwork/java/eol-135779-ja.html)
- [来月にはJava 10が登場し、9月にはJava 11が登場予定。新しいリリースモデルを採用した今後のJava、入手方法やサポート期間はこう変わる（OpenJDKに関する追記あり） － Publickey](https://www.publickey1.jp/blog/18/java_109java_11java.html)
- [Java Is Still Free - Google ドキュメント](https://docs.google.com/document/d/1nFGazvrCvHMZJgFstlbzoHjpAVwv5DEdnaBr_5pKuHo/preview#heading=h.pcjnntz9twpw)


# OpenJDKの概要

OpenJDKはオープンソースとして配布(ソースのみ提供)。

OpenJDKのレポジトリ [OpenJDK Mercurial Repositories](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=2ahUKEwjgiKH29eXhAhWmyosBHVmaBOQQFjAAegQIABAB&url=https%3A%2F%2Fhg.openjdk.java.net%2F&usg=AOvVaw2qWknA1P18mdKk5PNw3FVa)

新しいバージョンが出た時点で、Oracleによるサポート終了。

毎年3月と9月に新しいバージョン(新機能の追加や機能の変更が行われるフィーチャー・リリース)が出る。つまり6ヶ月毎に更新する必要がある。

Oracle JDK (LTS)は有償 (LTS:Long Term Support)。
サポートは3年。

OpenJDKはオープンソース(ソースのみ提供)なので、
バイナリビルドは誰がやってもいいし、
Oracleがサポート終了後、バックポートしてもかまわない。

## JREの廃止

Oracleは
Java Runtime Environment (JRE)の配布を廃止する。その理由は以下の通り:

(「[JDKの新しいリリース・モデル、および提供ライセンスについて](https://www.oracle.com/technetwork/jp/articles/java/ja-topics/jdk-release-model-4487660-ja.html)」から引用)

> JavaアプリケーションはシステムにインストールされたJREを使って実行されていた。

> Javaの脆弱性問題から最新版のJREに移行する必要が生じた際、ユーザー側はアプリケーション・ベンダーが最新版を推奨していないために移行できず、
一方でアプリケーション・ベンダー側は多くのユーザーが旧バージョンを利用しており、サポートの手間を考慮すると簡単には移行できないといったジレンマが生じるケースがある。

> Java SE 8までのJava仕様ではJREのサブセットを作ることはできず、アプリケーションが使わないライブラリも含めたフルセットの巨大なJREをバンドルする必要があった。

> 今後はカスタマイズしたJREをアプリケーションにバンドルする方法を推奨 (参考:[jlink](https://docs.oracle.com/javase/jp/9/tools/jlink.htm))


# Oracleの提供するOpenJDKのバイナリ

Oracleの提供するOpenJDKのバイナリ(とソース)は
[OpenJDK](http://openjdk.java.net/)
から入手できる。

Oracleの提供するOpenJDKのバイナリのアーカイブは
[Archived OpenJDK GA Releases](http://jdk.java.net/archive/)
から入手できる(セキュリティ問題やバグが含まれている。また更新もされない)

Oracleの提供するOpenJDKのバイナリには「インストーラー」が無い。WindowsではZIPの展開、環境変数の設定を手動で行う(参考:[Chapter 1. Getting Started with OpenJDK 11 for Windows - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/openjdk/11/html/openjdk_11_for_windows_getting_started_guide/getting_started_with_openjdk_for_windows))

その性質上、基本6ヶ月ごとにアップグレードするべきである。


# Oracle以外が配布するOpenJDKのバイナリ

利点:
- 「インストーラー」がある配布が多い
- 無償のLTS (+ 有償によるサポート)
- JDKだけでなくJREに相当する配布があるものがある

欠点:
- サポート期間や範囲が不安
- 無償の範囲がさまざまでわかりにくい(Cloudのみ、非商用など)

参考:
- [Oracle Java SEの有償化に伴うOpenJDKへの切り替えの案内 | 京都教育大学 情報処理センター](https://ipc.kyokyo-u.ac.jp/page/696)
- [JDKの長期商用サポート(LTS)の提供ベンダー比較（無償利用についても言及あり） - Qiita](https://qiita.com/u-tanick/items/bb166929a58a4c20bb88)
- [Javaのサポートについてのまとめ - Qiita](https://qiita.com/nowokay/items/edb5c5df4dbfc4a99ffb)
- [Oracle JDK 8 の無償アップデート終了後の選択肢は何があるのか | そるでぶろぐ](https://devlog.arksystems.co.jp/2018/09/21/5953/)


## AdoptOpenJDKによる配布

- コミュニティベース(スポンサーにIBMがいる)
- JRE相当の配布あり
- OpenJDK(HotSpot)にIBMのOpenJ9を追加したバージョンの配布あり
  

リンク:
- [AdoptOpenJDK - Open source, prebuilt OpenJDK binaries](https://adoptopenjdk.net/)
- [コミュニティのOpenJDKビルドファームが稼働](https://www.infoq.com/jp/news/2018/04/AdoptOpenJDKMar18)
  

## Azul Systemsによる配布 (Zulu)

- JavaFXの配布がある(ZuluFX)

リンク:
- [OpenJDK Java Linux Windows macOS Alpine Java 11 Java 8のダウンロード](https://jp.azul.com/downloads/zulu/)


## Red Hatによる配布

- RHELとWindowsをサポート
- OpenJDK11は2024年10月までサポート
- Red Hat Networkのアカウントが必要(無料アカウントあり)
- Windows用は開発用途専用。

リンク:
- [OpenJDK Life Cycle and Support Policy - Red Hat Customer Portal](https://access.redhat.com/articles/1299013)
- [Product Documentation for OpenJDK 11 - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/openjdk/11/)
- [Red Hat Developer | Red Hat OpenJDK Download](https://developers.redhat.com/products/openjdk/download/)
- [Red Hat、Windows版OpenJDKの長期商用サポート提供を発表 － Publickey](https://www.publickey1.jp/blog/18/red_hatwindowsopenjdklts.html)
- [Red HatのOpenJDKのサポート - nekop's blog](https://nekop.hatenablog.com/entry/2018/09/18/115712)

