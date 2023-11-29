# Android メモ

## Android Studio 関連

### Intel HAXM installation failed

[【どうして...?】Android Studio インストールで「HAXM installation failed.」が発生する #Android - Qiita](https://qiita.com/rice_rice_rice/items/c00f1338b173a149fb28)

WSL2 が入ってるとインストーラーが死ぬらしい。
無視していい。

HAXM は WHPX(Windows Hypervisor Platform) が無効な時に使われるらしい。

- [Intel HAXM vs Hyper-V for Android emulator : r/androiddev](https://www.reddit.com/r/androiddev/comments/b2awwa/intel_haxm_vs_hyperv_for_android_emulator/)
- [Hyper-V でサクサク Android エミュレータを使おうと思ったらハマったはなし](https://gist.github.com/seraphy/ff966de0f9d658400707382ecdb0e8a2)

こういうのあるから IDE はイヤ。
初心者にやさしくない。

### チュートリアルやってみる

[初めての Android アプリを作成する](https://developer.android.com/codelabs/basic-android-kotlin-compose-first-app?hl=ja#0)

つどつど ダウンロード & インストール が始まるのは結構つらい。
Gradle だからしょうがないけど、最初が長い。

ビルドするとエラーが出る (2023-11-29)。

> 1.  Dependency 'androidx.activity:activity:1.8.1' requires libraries and applications that
>     depend on it to compile against version 34 or later of the
>     Android APIs.
>
> :app is currently compiled against android-33.

androidx.activity:activity:1.8.1 は android sdk 33 ではダメで
34 以上にしろ、だそうだ。

build.gradle.kts (Module:app) を開いて
`compileSdk=34` にする

## compileSdk と minSdk と targetSdk がよくわからん

- compileSdk: このアプリをビルドするために使用する Android SDK のバージョン。最新バージョンを使用すれば問題なし。
- minSdk: このアプリをサポートする最低限の Android バージョン。指定したバージョン以上でデバイスにインストール可能。できるだけ低いバージョンを指定する。
- targetSdk: このアプリが対象としている Android バージョンを指定。 主に後方互換性などの制御に使用。原則 compileSdk と同じか、それよりも一つ低いバージョンを指定。

targetSdk やっぱりわからん。

例を書いてもらった。

targetSdk 未満の場合、
後方互換のための特別な対応が無効化されます。
たとえば targetSdk が 28 未満で、ユーザーの端末が Android 9.0(API レベル 28)の場合、
透明なバックグラウンドなどの Android 9 新機能が有効になります。

