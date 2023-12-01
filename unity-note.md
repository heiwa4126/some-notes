# Unity メモ

## 学習環境を作る

まず Unity Hub ではなく Visual Studio 2022 community edition をインストールする。

- [Visual Studio Tools のダウンロード - Windows、Mac、Linux 用の無料インストール](https://visualstudio.microsoft.com/ja/downloads/)
- [Visual Studio 製品の比較 | Visual Studio](https://visualstudio.microsoft.com/ja/vs/compare/)

Visual Studio インストーラーに Unity の項目があるのでそれをチェック。

参照: [クイックスタート: Visual Studio Tools for Unity のインストールと構成 | Microsoft Learn](https://learn.microsoft.com/ja-jp/visualstudio/gamedev/unity/get-started/getting-started-with-visual-studio-tools-for-unity?pivots=windows)

で、上記の手順で Unity Hub もインストールされるので、
そこから Unity Editor をインストールする。

1. Unity ID つくる。 [Unity ID](https://id.unity.com/ja/)
1. Unity Hub の右上のユーザアイコンからいま作った Unity ID でサインイン
1. Unity Hub の左の「ライセンス」を選び、「新規ライセンス」で Unity Personal (とりあえず) を選ぶ。

最新版の Unity Editor (2022.3LTS)をインストールすると、チュートリアルで使う Microgames が出てこない。
Unity Editor は複数入れられるので 2021.3LTS を入れる。

入れたモジュールは

- Microsoft Visual Studio Community 2019 は入れない 2022 で OK
- Windows Build Support (lL2CPP)
- 日本語言語パック (あんまり役に立たない)

で [Unity Learn](https://learn.unity.com/)から
`Unity Essentials` を始める。

横に「Unity バージョンを選択してください」のプルダウンがあるので
これを Editor に合わせること。

その他

Build Tools for Visual Studio 2022 も要るかもしれない。

コンソールから `dotnet --info` とタイプして、エラーにならなければ不要。

もし Build Tools for Visual Studio 2022 が要る場合は
https://visualstudio.microsoft.com/ja/downloads/
の下のほうの
`Tools for Visual Studio` を広げると
`Build Tools for Visual Studio 2022` が出てくる。

## 公式チュートリアルが 2021.3

最新版の Unity Editor(2022.3LTS)をインストールすると
Microgames が出てこない。

1. Visual Studio インストーラーで
2. Visual Studio 2022 comunity edition を Unity サポート付き でインストール
3. Unity Hub から 2021.3 エディタをインストール(Visual Studio 2019 のインストールを外して)

がいいと思う

## チュートリアルメモ

- Get started with Unity
- Welcome to Unity Essentials
-

## 選択したオブジェクトにフォーカス

- Shift+F
- 階層でダブルクリック
- 階層で F キー

## Flythrough mode

マウス右ボタンを押しっぱなし。

Digital Content Creation(DCC)ツール

## WebGL でビルドしようとすると Color Space を直せ、と言われる

> In order to build a player, go to 'Player Settings...'
> Unity Build "to resolve the incompatibility between the Color Space and the current settings."

さすがになんだかわからないので以下のリンクに従う。

[Unity：WebGL で Build ボタンが押せない「In order to build a player,go to ‘Player Settings…’ to resolve the incompatibility between the Color Space and the current settings.」エラーの対処 | 電脳産物](https://dianxnao.com/unity%EF%BC%9Awebgl%E3%81%A7build%E3%83%9C%E3%82%BF%E3%83%B3%E3%81%8C%E6%8A%BC%E3%81%9B%E3%81%AA%E3%81%84%E3%80%8Cin-order-to-build-a-playergo-to-player-settings-to-resolve-the-incompatibility/)

Player setting の Other Settings のところで Auto Graphics API の項目のチェックを外す。

## WebGL でビルドしたものを Node.js の http-server で見ようとすると

> Unable to parse Build/build.framework.js.gz! This can happen if build compression was enabled but web server hosting the content was misconfigured to not serve the file with HTTP Response Header "Content-Encoding: gzip" present. Check browser Console and Devtools Network tab to debug.

と言われる。言ってることはわかるけど...

ひとつの答えは「圧縮しない」。

File \> Publishing Settings \>
Player \> Publishing Settings \> Decompression fallback

gzip,brotli,disable から選べる。
圧縮処理けっこう時間かかるし、テストはこれがいいと思う。

普段は

- 非圧縮を設定
- "build & run" ボタン
  でいいと思う。

で、build 済みのディレクトリを使うには

- 非圧縮
- `http-server ./build` (./build にビルドした場合)

圧縮する場合は
これなんかが参考になる。
[WebGL ビルドしたコンテンツを nginx で配信する](https://egashira.dev/blog/webgl-nginx-server-conf)
結構手の込んだ設定が必要。

パブリッシュする場合はまた話が別。AWS S3 なんかだとオブジェクト単位で指定できるし。

## Unity Editor で WebGL で build すると影がでないのはなぜ?

File \> Publishing Settings \> Quarity のところで

こうなってるのを:  
![Alt text](imgs/unity/q1.png)

こうする:  
![Alt text](imgs/unity/q2.png)

下の ▼ ▼ ▼ の一番右をクリックするとプルダウンが出る。

Ultra でなく Very High でも影は出る。
