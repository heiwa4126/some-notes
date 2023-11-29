# Unity メモ

## 学習環境を作る

まず Unity Hub ではなく Visual Studio 2022 community edition をインストールする。

- [Visual Studio Tools のダウンロード - Windows、Mac、Linux 用の無料インストール](https://visualstudio.microsoft.com/ja/downloads/)
- [Visual Studio 製品の比較 | Visual Studio](https://visualstudio.microsoft.com/ja/vs/compare/)

Visual Studio インストーラーに Unity の項目があるのでそれをチェック。

参照: [クイックスタート: Visual Studio Tools for Unity のインストールと構成 | Microsoft Learn](https://learn.microsoft.com/ja-jp/visualstudio/gamedev/unity/get-started/getting-started-with-visual-studio-tools-for-unity?pivots=windows)

で、上記の手順で Unity Hub もインストールされるので、
そこから Unity Editor をインストールする。

その前に Unity ID つくること。 [Unity ID](https://id.unity.com/ja/)

最新版の Unity Editor (2022.3LTS)をインストールすると、チュートリアルで使う Microgames が出てこない。
Unity Editor は複数入れられるので 2021.3LTS を入れる。

あとライセンスはとりあえず Personal で。

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
https://visualstudio.microsoft.com/ja/downloads/ の
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

Digital Content Creation（DCC）ツール
