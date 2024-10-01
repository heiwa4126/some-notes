Tenable社製品メモ

# もくじ

- [もくじ](#もくじ)
- [概要](#概要)
  - [Tenable.io](#tenableio)
  - [Tenable.sc](#tenablesc)
  - [Nessus(ネサス)](#nessusネサス)
- [ドキュメント](#ドキュメント)
  - [公式](#公式)
  - [YouTube](#youtube)
  - [そのほか](#そのほか)
- [TIPS](#tips)

# 概要

## Tenable.io

> Tenable.io でリスクを理解し、最初に修正すべき脆弱性を把握する

クラウドベース

[現代のIT向け脆弱性管理ソリューション | Tenable.io®](https://jp.tenable.com/products/tenable-io)

## Tenable.sc

> Tenable.sc でリスクを理解し、先に修正すべき脆弱性を把握する

オンプレミス

[オンプレミスでの脆弱性評価・管理 | Tenable.sc](https://jp.tenable.com/products/tenable-sc)

## Nessus(ネサス)

- [Nessus (software) - Wikipedia](https://en.wikipedia.org/wiki/Nessus_(software))
- [Nessus - Wikipedia](https://ja.wikipedia.org/wiki/Nessus) - 来歴とかわかりやすい
- [Nessus脆弱性評価のダウンロード | Tenable®](https://jp.tenable.com/products/nessus)

# ドキュメント

## 公式

- [Documentation Center | Tenable™](https://docs.tenable.com/)
- [サポートポータル](https://community.tenable.com/s/)
- [日本語ドキュメント | Tenable™](https://jp.docs.tenable.com/)
- [ようこそ Nessus 8.12.x (Nessus)](https://jp.docs.tenable.com/nessus/8_12/Content/GettingStarted.htm)

## YouTube

けっこう参考になる。初心者おすすめ。

- [Nessusの無料版(Nessus Essentials)をインストールしてみよう - YouTube](https://www.youtube.com/watch?v=SegCYc4_21U) - 徳丸氏によるビデオ
- [初めてのNessus: 徳丸本VMをNessusでプラットフォーム診断してみよう - YouTube](https://www.youtube.com/watch?v=1TDP8Rlsdnc)
- [Nessus Essentialsのクレデンシャルスキャンによりパッチ適用状況を確認してみよう - YouTube](https://www.youtube.com/watch?v=VrP9B8tdW0g)

## そのほか

- [Nessusによる脆弱性スキャン - Qiita](https://qiita.com/prt445/items/81ea55eb3d6f0ecff329)
- [ポートスキャンしただけで落ちるCentOS6サーバ - Qiita](https://qiita.com/ockeghem/items/9e8158a51cd4d3368ac5)
- [Tenable.ioを使って脆弱性診断を15分で試してみた | Developers.IO](https://dev.classmethod.jp/articles/tenable-io-nessus-basicnetworkscan/)
- [Tenable.ioのBasic Network Scanを実施してみた | Developers.IO](https://dev.classmethod.jp/articles/tenable-io-vulnerabilitymanagement-basicnetworkscan/)

# TIPS

Nessus Essentials 8.12をWindows10で試した時のtips(2020-11)

NessusはWebUI

proxyがあるとめちゃくちゃ面倒。

初回起動時(とプラグイン更新時)のpluginのコンパイルはほんとうに時間がかかるので、事前に起動だけはしておくこと。
これ実際にはなにをやってるんだろう。気になる。

レポートをHTMLでダウンロードするときに
ブラウザの設定が「ダウンロード前に各ファイルの保存場所を確認する」にしてると固まることが多い。
レポートダウンロード時だけ設定を「ファイルの保存場所を確認しない」ように変更しておくといい。
