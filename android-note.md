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

[「Compose を用いた Android アプリ開発の基礎」コース](https://developer.android.com/courses/android-basics-compose/course?hl=ja)
の
Android Studio をセットアップする
の
[初めての Android アプリを作成する](https://developer.android.com/codelabs/basic-android-kotlin-compose-first-app?hl=ja#0)

"empty compose activity" は "empty activity" になったらしい。

つどつど ダウンロード & インストール が始まるのは結構つらい。
Gradle だからしょうがないけど、最初が長い。

ここでテンプレートの

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

"Project Structure dialog" (Ctrl+AIt+Shift+S) の modules
からでも OK。

## compileSdk と minSdk と targetSdk がよくわからん

- compileSdk: このアプリをビルドするために使用する Android SDK のバージョン。最新バージョンを使用すれば問題なし。
- minSdk: このアプリをサポートする最低限の Android バージョン。指定したバージョン以上でデバイスにインストール可能。できるだけ低いバージョンを指定する。
- targetSdk: このアプリが対象としている Android バージョンを指定。 主に後方互換性などの制御に使用。原則 compileSdk と同じか、それよりも 1 つ低いバージョンを指定。

targetSdk やっぱりわからん。

[compileSdk・minSdk・targetSdk の違い(Android) #Android - Qiita](https://qiita.com/uhooi/items/0f2ad61d83b96d9166c8)

> compileSdk と同じく基本的には現時点での最新を指定すればいいですが、例えば Android 12(API レベル 31) 対応が完了していない場合、 targetSdk を 30 に指定すれば Android 12 でも 11 のように振る舞う、ということです。

### SDK を追加

Android Studio に別のバージョンの Android SDK を追加するには、以下の手順で行います。

1. Android Studio を起動します。
1. 画面上部のメニューバーの「Tools」\>「SDK Manager」を選択します。
1. \[SDK Platforms\] タブで、追加する Android SDK のバージョンを選択します。
1. \[OK\] をクリックします。

### Android Studio で使っている JDK のバージョン

昔は
File -\> Project Structure -\> SDK Location

いまは Gradle setting の下にある。

- File -\> Setting から Gradle を探す
- または右端の Gradle tab -\> 上のスパナ

新しい JDK のダウンロードと設定もここからできる。

### design の live update の頻度が早すぎる

(TODO)

## SDK と Android

Android SDK バージョン(SDK level)と
Android のバージョン
対応表

| Android SDK バージョン | Android のバージョン   |
| ---------------------- | ---------------------- |
| 1                      | 1.0                    |
| 2                      | 1.1                    |
| 3                      | 1.5 Cupcake            |
| 4                      | 1.6 Donut              |
| 5                      | 1.1                    |
| 6                      | 2.0 Eclair             |
| 7                      | 2.1 Eclair             |
| 8                      | 2.2 Froyo              |
| 9                      | 2.3 Gingerbread        |
| 10                     | 3.0 Honeycomb          |
| 11                     | 3.1 Honeycomb          |
| 12                     | 3.2 Honeycomb          |
| 13                     | 4.0 Ice Cream Sandwich |
| 14                     | 4.1 Jelly Bean         |
| 15                     | 4.2 Jelly Bean         |
| 16                     | 4.3 Jelly Bean         |
| 17                     | 4.4 KitKat             |
| 18                     | 5.0 Lollipop           |
| 19                     | 5.1 Lollipop           |
| 20                     | 5.2 Lollipop           |
| 21                     | 6.0 Marshmallow        |
| 22                     | 6.0.1 Marshmallow      |
| 23                     | 7.0 Nougat             |
| 24                     | 7.1 Nougat             |
| 25                     | 7.1.1 Nougat           |
| 26                     | 8.0 Oreo               |
| 27                     | 8.1 Oreo               |
| 28                     | 9.0 Pie                |
| 29                     | 10                     |
| 30                     | 11                     |
| 31                     | 12                     |
| 32                     | 13                     |
| 33                     | 14                     |
| 34                     | 15                     |

[Android SDK API Level 一覧 \#Android \- Qiita](https://qiita.com/irgaly/items/bd2ffe3725424690b856)

## Kotlin の var, val

TypeScript の let, const は
Kotlin では var, val ですか?

おおむねその通り。

ただし
let はブロックスコープ、var は関数スコープ。

const と val はブロックスコープ。

さらに Kotlin には lateinit var というのがある。
変数の初期化を後回しにできる定数。

## WSL2 で Android Studio

Windows のファイル I/O が異様に遅いので試してみたい。

以下は Copilot による出力そのまま

**Android Studio**を**WSL2**で使う方法を紹介します。以下の手順に従って設定してみてください。

1. **usbipd-win**のインストール:

   - 予め**winget**をインストールしておきます。次に、以下のコマンドを実行して、PowerShell 等で**usbipd-win**をインストールします:
     ```PowerShell
     PS C:\Users\horie-t> winget install usbipd
     ```
   - WSL 上の Ubuntu で以下のコマンドを実行して、ツールをインストールします:
     ```bash
     sudo apt install linux-tools-virtual hwdata
     sudo update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20
     ```
   - OS 起動後に毎回必要なコマンドも実行しておきましょう:
     ```bash
     sudo update-alternatives --install /usr/local/bin/usbip usbip `ls /usr/lib/linux-tools/*/usbip | tail -n1` 20
     ```

2. **Android Studio**のインストール・セットアップ:

   - [ダウンロードサイト](http://developer.android.com/studio)から**Android Studio**をダウンロードし、インストール先ディレクトリで展開します:
     ```
     tar xvf ~/Downloads/android-studio-2022.3.1.19-linux.tar.gz
     ```
   - Android デバイスに対応する**udev ルール**がシステムにインストールされている必要があります。以下のコマンドを実行して、インストール・セットアップします:
     ```
     sudo apt-get install -y android-sdk-platform-tools-common && sudo cp /lib/udev/rules.d/51-android.rules /etc/udev/rules.d/
     ```
   - **adb**を使用するユーザーは、**plugdev**グループに属している必要があります。以下のコマンドでグループに追加します:
     ```
     sudo usermod -aG plugdev $LOGNAME
     ```
   - セットアップ完了後に一度 WSL を停止して再起動します:
     ```
     PS C:\Users\horie-t> wsl --shutdown
     ```

3. Android デバイスをアタッチして、**Android Studio**からアプリケーションを起動:
   - Android デバイスを PC に USB で接続します（開発者向けオプションを有効にしておいてください）。
   - 接続後、以下のコマンドで USB デバイスをリストアップします:
     ```
     PS C:\Users\horie-t> usbipd.exe wsl list
     ```
   - デバイスの**BUSID**を確認したら、以下のコマンドでデバイスを WSL にアタッチします:
     ```
     usbipd.exe wsl attach --busid=<BUSID>  # 例: usbipd.exe wsl attach --busid=1-3
     ```
   - WSL 上で**Android Studio**のインストール先ディレクトリに移動して、**Android Studio**を起動します:
     ```
     $ android-studio/bin/studio.sh
     ```
   - 起動後、**Android Studio**の Device Manager に Android デバイスが認識されていることを確認できます。

これで、**Android Studio**を WSL2 で快適に使えるようになります。¹²

ソース: Bing との会話 2024/2/2
(1) WSL2 上で Android Studio で Android アプリケーションを、usbipd .... https://zenn.dev/thorie/articles/548mbl-android-studio-on-wsl2.
(2) Can I run android studio on windows 10 Subsystem Linux. https://askubuntu.com/questions/1189343/can-i-run-android-studio-on-windows-10-subsystem-linux.
(3) WSL2 と Android エミュレータの共存 #Android - Qiita. https://qiita.com/tsukushibito/items/9201201356ac36c52a32.
(4) undefined. http://amazon.co.jp/dp/4802098057/.
(5) undefined. http://amazon.co.jp/dp/B09C3Y8SHY/.
(6) undefined. https://developer.android.com/studio/run/emulator-acceleration?hl=ja.
(7) undefined. https://developer.android.com/studio/run/emulator.
