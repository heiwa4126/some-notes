# QR コードのメモ

- [メジャーなライブラリ](#メジャーなライブラリ)
- [それ以外のマイナーなライブラリ](#それ以外のマイナーなライブラリ)
- [反則技っぽいやつ](#反則技っぽいやつ)
- [ZXing メモ](#zxing-メモ)
  - [FinderPattern インターフェース](#finderpattern-インターフェース)
  - [AlignmentPattern インターフェース](#alignmentpattern-インターフェース)

## メジャーなライブラリ

- ZBar と、そのバインディングやポーティング
- ZXing と、そのバインディングやポーティング
- OpenCV の QRCodeDetector()と QRCodeDetectorAruco()

## それ以外のマイナーなライブラリ

- [dlbeer/quirc: QR decoder library](https://github.com/dlbeer/quirc)
  - (Python バインディング) [maxnoe/pyquirc: python bindings for quirc](https://github.com/maxnoe/pyquirc)
- [serratus/quaggaJS: An advanced barcode-scanner written in JavaScript](https://github.com/serratus/quaggaJS)
- [josephholsten/libdecodeqr: A C/C++ library for decoding QR code 2D barcodes](https://github.com/josephholsten/libdecodeqr/tree/master)
- [BoofCV](https://boofcv.org/index.php?title=Main_Page)
  - [Tutorial QRCodes - BoofCV](https://boofcv.org/index.php?title=Tutorial_QRCodes)
  - [Example Detect QR Code - BoofCV](https://boofcv.org/index.php?title=Example_Detect_QR_Code)
- (商用) [Robust Barcode Reader SDK - Quick Implementation | Dynamsoft](https://www.dynamsoft.com/barcode-reader/overview/)
- (商用) [Barcode Scanning Software | Scandit](https://www.scandit.com/products/barcode-scanning/)
- (WebAPI) [QR code API: command “read-qr-code” (read / scan QR code, QR code reader)](https://goqr.me/api/doc/read-qr-code/)

## 反則技っぽいやつ

[qreader · PyPI](https://pypi.org/project/qreader/)

けっこうすごい。

1. 物体検知(YOLOv8)で QR コードっぽいものを位置検出
2. Quadrilateral 変形
3. Pyzbar で QR コードを読む

という手順で、他とは一線を画する高性能マルチリーダー。
高性能ではあるが遅い、torch と QR コードのモデルが必要(モデルは作者が提供している)なのが欠点。あと Python でしか動かない。

## ZXing メモ

### FinderPattern インターフェース

QR コードの位置と向きを特定するための大きな正方形のパターン

FinderPattern は、QR コードの位置検出パターンを表します。
位置検出パターンは、QR コードの 3 つの角に配置されている大きな正方形のパターンで、QR コードの位置と向きを特定するために使用されます。

主なプロパティとメソッド

- getX(): パターンの X 座標を取得します。
- getY(): パターンの Y 座標を取得します。
- getEstimatedModuleSize(): パターンのモジュールサイズを推定します。
- getCount(): パターンの検出回数を取得します。

### AlignmentPattern インターフェース

QR コードの歪みを補正するための小さな正方形のパターン

AlignmentPattern は、QR コードのアライメントパターンを表します。アライメントパターンは、QR コードの歪みを補正するために使用される小さな正方形のパターンで、特に大きな QR コードで重要です。

主なプロパティとメソッド

- getX(): パターンの X 座標を取得します。
- getY(): パターンの Y 座標を取得します。
- getEstimatedModuleSize(): パターンのモジュールサイズを推定します。
