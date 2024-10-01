# バーコード & QR コードメモ

- [コードの種類](#コードの種類)
  - [JAN](#jan)
  - [CODE128](#code128)
- [ブラウザでバーコード](#ブラウザでバーコード)
- [QR コードのスキャナ](#qr-コードのスキャナ)
- [バーコードのスキャナ](#バーコードのスキャナ)
  - [javascript-barcode-reader](#javascript-barcode-reader)
  - [JOB](#job)
  - [QuaggaJS](#quaggajs)
  - [QuaggaJS2](#quaggajs2)
  - [webcodecamjs](#webcodecamjs)

## コードの種類

どうもコード方式と表現方式がごっちゃになって記述されることが多いみたいので注意。
両方を兼ねてる言い方もあるのがますますややこしい。

例:

- CODE128 表現方式
- GS1-128 コード方式+それを CODE128 のスタートコード CODE-C で画像にしたもの
- JAN 表現方式+コード方式

### JAN

- 標準タイプ(13 桁)
  - 7 桁 JAN 企業コード
    1. JAN 企業コード(7 桁)
    2. 商品アイテムコード(5 桁)
    3. チェックデジット(1 桁)
  - 9 桁 JAN 企業コード
    1. JAN 企業コード(9 桁)
    2. 商品アイテムコード(3 桁)
    3. チェックデジット(1 桁)
- 短縮タイプ(8 桁)
  1. JAN 企業コード(6 桁)
  2. 商品アイテムコード(1 桁)
  3. チェックデジット(1 桁)

参考: [JAN | バーコード講座 | キーエンス](https://www.keyence.co.jp/ss/products/autoid/codereader/basic_jan.jsp)

サンプル

- 4912345678904
- 4561234567890
- 49012347

![4912345678904](imgs/barcode/jan_4912345678904.png '4912345678904')
![4561234567890](imgs/barcode/jan_4561234567890.png '4561234567890')
![49012347](imgs/barcode/jan_49012347.png '49012347')

それを QR コードにしたもの ([QR コードの作成|バーコードどころ](https://barcode-place.azurewebsites.net/Barcode/qr)で作成)

![4912345678904](imgs/barcode/qr_4912345678904.png '4912345678904')
![4561234567890](imgs/barcode/qr_4561234567890.png '4561234567890')
![49012347](imgs/barcode/qr_49012347.png '49012347')

なんで QR コードなの w は秘密だ。

### CODE128

> CODE128 は、アスキーコード 128 文字(数字、アルファベット大文字/小文字、記号、制御コード)全てをバーコード化することができます。

[CODE128 | バーコード講座 | キーエンス](https://www.keyence.co.jp/ss/products/autoid/codereader/basic_code128.jsp)

ASCII コードなんでも、とはいうものの具体的な例としては

- [Code 128 Barcode Examples](https://www.computalabel.com/m/c128examplesM.htm)

他、参考: [Code 128 - Wikipedia](https://en.wikipedia.org/wiki/Code_128)

Code128 のスタートコードに CODE-C を使った
[GS1-128](https://www.keyence.co.jp/ss/products/autoid/codereader/basic-gs1.jsp)のサンプル:

![(01)04912345123459(10)ABC123](<imgs/barcode/gs1_128_(01)04912345123459(10)ABC123.png> '(01)04912345123459(10)ABC123')

(01)04912345123459(10)ABC123

## ブラウザでバーコード

- [ブラウザでバーコード/QR コードリーダー【実装・カスタマイズ編】 - Qiita](https://qiita.com/mm_sys/items/6e5e927ef75ab82fa8d3)
- [GitHub - andrastoth/webcodecamjs: Demo page](https://github.com/andrastoth/webcodecamjs)
  - [GitHub - EddieLa/JOB: A Barcode scanner capapable of reading Code128, Code93, Code39, Standard/Industrial 2 of 5, Interleaved 2 of 5, Codabar and EAN-13 barcodes in javascript.](https://github.com/EddieLa/JOB) - JAN コードは EAN になります。
  - [GitHub - LazarSoft/jsqrcode: Javascript QRCode scanner](https://github.com/LazarSoft/jsqrcode)
- [スマフォカメラにブラウザからアクセス - Qiita](https://qiita.com/tkyko13/items/1871d906736ac88a1f35)

> スマフォブラウザからカメラを利用するときは ssl じゃないとだめらしいです

[JAN/EAN | バーコード講座 | キーエンス](https://www.keyence.co.jp/ss/products/autoid/codereader/basic-ean.jsp)

## QR コードのスキャナ

`jsQR`がいまのところ一番らしい。

- [cozmo/jsQR: A pure javascript QR code reading library. This library takes in raw images and will locate, extract and parse any QR code found within.](https://github.com/cozmo/jsQR)
- [jsqr - npm](https://www.npmjs.com/package/jsqr)
- [jsqr CDN by jsDelivr - A CDN for npm and GitHub](https://www.jsdelivr.com/package/npm/jsqr)

## バーコードのスキャナ

これいろいろあって、試してみる。

参考:

- [Javascript のバーコードライブラリ - Qiita](https://qiita.com/k-murayama/items/eddcc974bd0dd3a214ed)

### javascript-barcode-reader

- [mubaidr/Javascript-Barcode-Reader: Simple and Fast Barcode decoder with support of Code128, Code93, Code39, Standard/Industrial 2 of 5, Interleaved 2 of 5, Codabar, EAN-13, EAN-8 barcodes in javascript.](https://github.com/mubaidr/Javascript-Barcode-Reader)
- [javascript-barcode-reader - npm](https://www.npmjs.com/package/javascript-barcode-reader)
- [javascript-barcode-reader CDN by jsDelivr - A CDN for npm and GitHub](https://www.jsdelivr.com/package/npm/javascript-barcode-reader)
- [javascript-barcode-reader | javascript-barcode-reader](https://mubaidr.js.org/Javascript-Barcode-Reader/)

### JOB

[EddieLa/JOB: A Barcode scanner capapable of reading Code128, Code93, Code39, Standard/Industrial 2 of 5, Interleaved 2 of 5, Codabar and EAN-13 barcodes in javascript.](https://github.com/EddieLa/JOB)

EAN-8 が読めないらしいので今回はパス

レポジトリのサンプルイメージは使えるかも [JOB/Sample-images at master · EddieLa/JOB](https://github.com/EddieLa/JOB/tree/master/Sample-images)

### QuaggaJS

評判いい

- [QuaggaJS, an advanced barcode-reader written in JavaScript](https://serratus.github.io/quaggaJS/)
- [serratus/quaggaJS: An advanced barcode-scanner written in JavaScript](https://github.com/serratus/quaggaJS)
- [quagga CDN by jsDelivr - A CDN for npm and GitHub](https://www.jsdelivr.com/package/npm/quagga)
- デモページ [QuaggaJS, an advanced barcode-reader written in JavaScript](https://serratus.github.io/quaggaJS/examples/static_images.html) - ライブイメージのデモもあるけど、さっぱり読めない。

他参考:

- [QuaggaJS を使ったバーコードリーダ実装 | WatchContents](https://watchcontents.com/quaggajs-barcode-reader/)

### QuaggaJS2

QuaggaJS のフォーク

- [ericblade/quagga2: An advanced barcode-scanner written in Javascript and TypeScript - Continuation from https://github.com/serratus/quaggajs](https://github.com/ericblade/quagga2)
- [@ericblade/quagga2 - npm](https://www.npmjs.com/package/@ericblade/quagga2)

### webcodecamjs

- [andrastoth/webcodecamjs: Demo page](https://github.com/andrastoth/webcodecamjs)
- [webcodecamjs - npm](https://www.npmjs.com/package/webcodecamjs)
- [webcodecamjs CDN by jsDelivr - A CDN for npm and GitHub](https://www.jsdelivr.com/package/npm/webcodecamjs)
