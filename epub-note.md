# EPUBのメモ

## markdownからreflow epub (GFM味)

Pandoc でできる。

```sh
pandoc -f gfm -t epub README.md -o README.epub --metadata title="README!!"
```

かなり古い Pandoc でも出来た。

```console
$ pandoc --version
pandoc 2.9.2.1
Compiled with pandoc-types 1.20, texmath 0.12.0.2, skylighting 0.8.5
```

## EPUBビューアー

主要OSごとに「定番」といえるEPUBビューアーを挙げます。 [speechify](https://speechify.com/ja/blog/epub-reader-windows/)

### Windows

- Calibre
  - オープンソースの定番、EPUB管理+ビューア一体型。 [dvdfab](https://dvdfab.org/bookfab/windows-epub-reader.htm)
- Adobe Digital Editions
  - DRM付きEPUB対応、図書館系や商用ストア本でよく使われる。 [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml)
- Sumatra PDF
  - 超軽量でEPUBも読める、表示だけ重視ならこれ。 [speechify](https://speechify.com/ja/blog/epub-reader-windows/)
- FBReader
  - 軽量で多フォーマット対応、複数OS対応の読み専用アプリ。 [note](https://note.com/naomiz_cs44/n/nf62b1b1e9f6d)

### macOS

- Apple Books(ブックス / 旧iBooks)
  - mac標準クラスのEPUBビューア、iCloud連携でiPhone/iPadと同期可能。 [jp.epubor](https://jp.epubor.com/resource/%E3%83%91%E3%82%BD%E3%82%B3%E3%83%B3%E3%81%A7%E4%BD%BF%E3%81%88%E3%82%8Bepub%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC/)
- Calibre
  - Windows同様、ライブラリ管理も含めた定番ツール。 [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml)
- Adobe Digital Editions
  - DRM付きEPUB・PDFを読む用途でよく使われる。 [note](https://note.com/naomiz_cs44/n/nf62b1b1e9f6d)

### iOS(iPhone / iPad)

- Apple Books(ブックス)
  - 純正EPUBリーダー、ストア連携・iCloud同期が強い。 [jp.epubor](https://jp.epubor.com/resource/%E3%83%91%E3%82%BD%E3%82%B3%E3%83%B3%E3%81%A7%E4%BD%BF%E3%81%88%E3%82%8Bepub%E3%83%AA%E3%83%BC%E3%83%80%E3%83%BC/)
- Neat Reader
  - EPUB専用リーダー、iOSアプリ+他プラットフォームでも利用可能。 [epubreader](https://www.epubreader.xyz/ja)

### Android

- FBReader
  - 古くからある定番、EPUB含む多フォーマット対応、同期機能もあり。 [dvdfab](https://dvdfab.org/bookfab/windows-epub-reader.htm)
- Neat Reader
  - Windows/macOS/iOS/Android+Webで動くクロスプラットフォームEPUBリーダー。 [epubreader](https://www.epubreader.xyz/ja)

### クロスプラットフォームで押さえておくと楽なもの

| 用途                   | Windows                                                           | macOS                                                                      | iOS                                                                        | Android                                                           | 特徴                          |
| ---------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------- |
| Calibre                | ○ [speechify](https://speechify.com/ja/blog/epub-reader-windows/) | ○ [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml) | –                                                                          | –                                                                 | PCでの管理+閲覧の定番         |
| Adobe Digital Editions | ○ [speechify](https://speechify.com/ja/blog/epub-reader-windows/) | ○ [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml) | –                                                                          | –                                                                 | DRM付きEPUB向け               |
| Apple Books            | –                                                                 | ○ [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml) | ○ [ic.daito.ac](http://www.ic.daito.ac.jp/~mizutani/ebook/epub_view.xhtml) | –                                                                 | Apple環境で完結するなら最優先 |
| FBReader               | ○ [speechify](https://speechify.com/ja/blog/epub-reader-windows/) | ○ [note](https://note.com/naomiz_cs44/n/nf62b1b1e9f6d)                     | ○ [note](https://note.com/naomiz_cs44/n/nf62b1b1e9f6d)                     | ○ [speechify](https://speechify.com/ja/blog/epub-reader-windows/) | 軽量・多OS対応                |
| Neat Reader            | ○ [epubreader](https://www.epubreader.xyz/ja)                     | ○ [epubreader](https://www.epubreader.xyz/ja)                              | ○ [epubreader](https://www.epubreader.xyz/ja)                              | ○ [epubreader](https://www.epubreader.xyz/ja)                     | すべてのデバイスでEPUB読書    |

「PCで管理もしたいならCalibre、DRM本を読むならAdobe Digital Editions、Apple環境中心ならApple Books、軽快さとクロスプラットフォームならFBReaderかNeat Reader」というイメージで選ぶと分かりやすいです。 [speechify](https://speechify.com/ja/blog/epub-reader-windows/)
