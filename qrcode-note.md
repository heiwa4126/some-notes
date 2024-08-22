# QR コードのメモ

- [メジャーなライブラリ](#メジャーなライブラリ)
- [それ以外のマイナーなライブラリ](#それ以外のマイナーなライブラリ)
- [反則技っぽいやつ](#反則技っぽいやつ)

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
