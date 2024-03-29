# WSL メモ

- [WSL メモ](#wsl-メモ)
  - [WSL2 で IPv6 がつながらない](#wsl2-で-ipv6-がつながらない)
  - [WSL 上の Ubuntu にはなぜ linux-image\* パッケージがインストールされていないのか](#wsl-上の-ubuntu-にはなぜ-linux-image-パッケージがインストールされていないのか)
  - [WSL の時間がずれる](#wsl-の時間がずれる)
  - [WSL の再起動](#wsl-の再起動)
  - [WSL の syslog は Windows イベントログに出る](#wsl-の-syslog-は-windows-イベントログに出る)
  - [WSL2 で w コマンドを叩いても他の pts が表示されないのはなぜ?](#wsl2-で-w-コマンドを叩いても他の-pts-が表示されないのはなぜ)
  - [WSL2 で docker は使えますか?](#wsl2-で-docker-は使えますか)
    - [WSL2 で docker は使えますか? - Bing の答え](#wsl2-で-docker-は使えますか---bing-の答え)
    - [docker サービスは自動起動しますか?](#docker-サービスは自動起動しますか)
    - [ChatGPT にも聞いてみた: WSL2 で docker は使えますか?](#chatgpt-にも聞いてみた-wsl2-で-docker-は使えますか)
    - [つづき: その Microsoft の公式ドキュメントやオンラインのチュートリアルの URL を教えてください](#つづき-その-microsoft-の公式ドキュメントやオンラインのチュートリアルの-url-を教えてください)
  - [WSL をバックアップすることはできますか?](#wsl-をバックアップすることはできますか)
    - [リストアする方法も教えてください](#リストアする方法も教えてください)
    - [wsl --export の出力は圧縮されないのですか?](#wsl---export-の出力は圧縮されないのですか)
    - [エクスポートしながら圧縮する方法はありませんか?](#エクスポートしながら圧縮する方法はありませんか)
    - [エクスポートしながら圧縮: あとで試すメモ](#エクスポートしながら圧縮-あとで試すメモ)
  - [WSL で Windows のやりとり](#wsl-で-windows-のやりとり)
  - [WSL で ls するとディレクトリの色が暗くて見づらい](#wsl-で-ls-するとディレクトリの色が暗くて見づらい)

## WSL2 で IPv6 がつながらない

```console
$ curl https://ipv6.google.com
curl: (7) Couldn't connect to server
```

なるほどつながらない。
ちょっと検索すると「ミラーモード」にすればいいらしい。
しかし弊害もいろいろあるらしい(Docker Desktop の不具合)のであとで試す。

手順は

1. `%UserProfile%\.wslconfig` を作る。
2. 以下の内容を追加

   ```toml
   [wsl2]
   networkingMode=mirrored
   ```

3. WSL2 再起動 ( `wsl --shutdown` 後、WSL を開く)

参考:

- [ミラー モードのネットワーク](https://learn.microsoft.com/ja-jp/windows/wsl/networking#mirrored-mode-networking)
- [WSL 2.0.0 で導入されたミラーモードは万能薬なのか？ #Network - Qiita](https://qiita.com/shigeokamoto/items/bad3ce237f0b19aea147)

ミラーモードのネットワークけっこうおもしろい。
WSL 上と Windows 上のポートがいっぺんに見える。

## WSL 上の Ubuntu にはなぜ linux-image\* パッケージがインストールされていないのか

```console
$ uname -r
5.15.146.1-microsoft-standard-WSL2

$ dpkg -l linux-image\*
dpkg-query: no packages found matching linux-image*
```

WSL2 の Ubuntu には linux-image\*パッケージがインストールされていない理由は、WSL2 が Windows 上で Linux カーネルを実行するための特別な実装を使用しているからです。
具体的には、WSL2 は Microsoft が開発した専用の Linux カーネルを使用しており、このカーネルは Windows の更新プロセスを通じて提供されます。

## WSL の時間がずれる

本体のスリープモードがヤバいらしい。

手動であわせるのは
`sudo hwclock --systohc`

aws cli が エラー出して気が付いた。
[aws-cli がいきなり"AuthFailure"となった件 #Linux - Qiita](https://qiita.com/iam_nk/items/7acdd5e67d4a5c9ce6e2)

## WSL の再起動

```powershell
wsl.exe --shutdown
```

このへん参照: [WSL での詳細設定の構成 | Microsoft Learn](https://learn.microsoft.com/ja-jp/windows/wsl/wsl-config)

- WSL で動いてる全 Linux が再起動する
- 「8 秒ルール」

## WSL の syslog は Windows イベントログに出る

ええっ

## WSL2 で w コマンドを叩いても他の pts が表示されないのはなぜ?

```terminal
$ ps f
  PID TTY      STAT   TIME COMMAND
   95 pts/3    Ss     0:00 -bash
  108 pts/3    R+     0:00  \_ ps f
   84 pts/2    Ss     0:00 -bash
   94 pts/2    S+     0:01  \_ ssh server4
   74 pts/1    Ss+    0:00 -bash
   10 pts/0    Ss     0:00 -bash
   71 pts/0    S+     0:00  \_ tmux

$ w
 10:38:32 up 35 min,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT

$
```

「WSL が各ターミナルセッションを別々の環境として扱うためです。
これは、WSL が Linux のカーネルを完全にエミュレートしないために起こります。
その結果、一部の Linux コマンドが期待通りに動作しないことがあります。」
だそうですけど。よくわかりません。

## WSL2 で docker は使えますか?

Bing Search に聞いてみた。

注意点: リンク先読め。

### WSL2 で docker は使えますか? - Bing の答え

はい、WSL2 では docker を使えます ²³⁴⁵。
WSL2 は Linux カーネルを実装しているので、docker のネイティブな動作が可能になります ²。
しかし、WSL2 では systemd がサポートされていないので、docker をインストールするにはいくつかの手順が必要です ¹⁴。
一つの方法は、次のようにすることです ⁴。

- WSL2 で Ubuntu をインストールする
- Ubuntu で sudo apt update と sudo apt upgrade を実行する
- Ubuntu で `curl -fsSL https://get.docker.com -o get-docker.sh` を実行して docker のインストールスクリプトをダウンロードする
- Ubuntu で sudo sh get-docker.sh を実行して docker をインストールする
- Ubuntu で sudo usermod -aG docker $USER を実行して自分のユーザーに docker グループを追加する
- Ubuntu で exit して WSL2 から抜ける
- PowerShell で wsl --shutdown を実行して WSL2 を再起動する
- PowerShell で wsl -u root -e service docker start を実行して docker サービスを起動する

これで WSL2 から docker コマンドが使えるようになります。

ソース: Bing との会話 2023/2/16

1. Docker Desktop WSL 2 バックエンド — Docker-docs-ja 20.10 .... <https://docs.docker.jp/docker-for-windows/wsl.html> アクセス日時 2023/2/16.
2. Windows ＋ WSL2 で Docker 環境を用意しよう - カゴヤの .... <https://www.kagoya.jp/howto/cloud/container/wsl2_docker/> アクセス日時 2023/2/16.
3. WSL2 に docker をインストールしてみた - Qiita. <https://qiita.com/hkusaba/items/5b44248d758214f99e97> アクセス日時 2023/2/16.
4. windows に WSL2+Docker 環境を構築する手順 - Qiita. <https://qiita.com/taka777n/items/ea3a1b3a2802aabf3db2> アクセス日時 2023/2/16.
5. 知乎专栏 - 随心写作，自由表达 - 知乎. <https://zhuanlan.zhihu.com/p/148511634> アクセス日時 2023/2/16.

### docker サービスは自動起動しますか?

いいえ、WSL2 では docker サービスは自動起動しません ¹³⁴。
WSL2 では systemd がサポートされていないため、docker サービスを起動するには毎回コマンドを実行する必要があります ¹。
しかし、自動起動する方法もあります。一つの方法は、プロファイルファイルに docker サービスを起動するコマンドを追加することです ¹²。
具体的には、次のようにします ¹。

- Ubuntu で sudo visudo を実行して sudoers ファイルを編集する
- ファイルの最後に自分のユーザー名 ALL=(ALL:ALL) NOPASSWD: /usr/sbin/service docker start という行を追加する
- Ubuntu で~/.profile ファイルを開く
- ファイルの最後に sudo service docker start という行を追加する

これで WSL2 が起動するたびに docker サービスも自動的に起動します。

>

ソース: Bing との会話 2023/2/16

1. How to automatically start the Docker daemon on WSL2. <https://bing.com/search?q=WSL2+docker+service+auto+start> アクセス日時 2023/2/16.
2. wsl2 で Docker 自動起動設定 - Qiita. <https://qiita.com/ko-zi/items/949d358163bbbad5a91e> アクセス日時 2023/2/16.
3. wsl2 にインストールした Docker を自動起動する. <https://zukucode.com/2021/11/wsl2-docker-startup.html> アクセス日時 2023/2/16.
4. How to automatically start the Docker daemon on WSL2. <https://blog.nillsf.com/index.php/2020/06/29/> how-to-automatically-start-the-docker-daemon-on-wsl2/ アクセス日時 2023/2/16.
5. WSL2(Ubuntu18.04)上で Docker を起動する - Qiita. <https://qiita.com/FugitHora812/items/bc84a176234f36bf6697> アクセス日時 2023/2/16.

### ChatGPT にも聞いてみた: WSL2 で docker は使えますか?

はい、WSL2 上で Docker を使用することができます。WSL2 には、Docker を含む Linux カーネルが組み込まれており、Docker コマンドを使用して WSL2 内のコンテナを管理できます。

ただし、WSL2 にはいくつかの制限事項があります。たとえば、現時点では WSL2 は Linux カーネルバージョン 4.19 をサポートしており、一部の機能は制限されています。また、WSL2 はまだ Windows と完全に統合されておらず、一部の機能がまだ不安定である場合があります。

ただし、WSL2 は Docker を実行するために非常に便利であり、多くの開発者が利用しています。WSL2 を使用して Docker を実行する方法については、Microsoft の公式ドキュメントやオンラインのチュートリアルなどが利用できます。

### つづき: その Microsoft の公式ドキュメントやオンラインのチュートリアルの URL を教えてください

以下に、WSL2 で Docker を使用するための Microsoft 公式ドキュメントと、オンラインのチュートリアルの URL を示します。

1. Microsoft 公式ドキュメント:
   <https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package>
2. Docker 公式ドキュメント:
   <https://docs.docker.com/docker-for-windows/wsl/>
3. Devdojo.com によるチュートリアル:
   <https://devdojo.com/bobbyiliev/how-to-install-docker-on-wsl2-windows-10>

上記のドキュメントやチュートリアルを参照することで、WSL2 上で Docker をセットアップし、使用することができます。

(2.は docker desktop を使う。まあ docker 公式だから...)

## WSL をバックアップすることはできますか?

はい、WSL をバックアップすることはできます ¹²³。
WSL をバックアップするには、wsl --export コマンドを使って WSL のディストリビューションを tar ファイルにエクスポートすることができます ¹²³。
具体的には、次のようにします ¹²³。

- コマンドプロンプトか PowerShell を開く
- wsl --list --verbose を実行してバックアップしたいディストリビューションの名前を確認する
- wsl --export ディストリビューション名 バックアップファイル名を実行してディストリビューションを tar ファイルにエクスポートする
- バックアップファイルを安全な場所に保存する

これで WSL のバックアップができます。

ソース: Bing との会話 2023/2/16

1. WSL バックアップと復元方法 | SEECK.JP サポート. <https://kb.seeck.jp/archives/17024> アクセス日時 2023/2/16.
2. Windows 10 WSL2 Ubuntu のデータをバックアップするには .... <https://denor.jp/windows-10-wsl2-ubuntu%e3%81%ae%e3%83%87%e3%83%bc%e3%82%bf%e3%82%92%e3%83%90%e3%83%83%e3%82%af%e3%82%a2%e3%83%83%e3%83%97%e3%81%99%e3%82%8b%e3%81%ab%e3%81%af> アクセス日時 2023/2/16.
3. WSL 上の Linux のバックアップ. <https://www.aise.ics.saitama-u.ac.jp/~gotoh/HowToBackupLinuxOnWSL.html> アクセス日時 2023/2/16.

### リストアする方法も教えてください

WSL の復元方法は次のとおりです ¹⁴。

- コマンドプロンプトか PowerShell を開く
- wsl --import ディストリビューション名 インストール先フォルダ バックアップファイル名を実行してバックアップファイルからディストリビューションをインポートする
- wsl --list --verbose を実行してインポートしたディストリビューションが表示されることを確認する
- wsl -d ディストリビューション名を実行してインポートしたディストリビューションに入る

これで WSL の復元ができます。

>

ソース: Bing との会話 2023/2/16

1. WSL バックアップと復元方法 | SEECK.JP サポート. https://bing.com/search?q=WSL+restore アクセス日時 2023/2/16.
2. How to back up and restore a Windows Subsystem for Linux .... https://www.xda-developers.com/how-back-up-restore-wsl/ アクセス日時 2023/2/16.
3. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
4. Windows 10 の WSL 環境を初期化してクリーンな状態に戻す. https://atmarkit.itmedia.co.jp/ait/articles/1807/06/news028.html アクセス日時 2023/2/16.

### wsl --export の出力は圧縮されないのですか?

wsl --export の出力は圧縮されないのです ¹。
wsl --export は指定したディストリビューションを tar ファイルにエクスポートするだけで、圧縮は行いません。圧縮すると時間がかかるからです ¹。
もし圧縮したい場合は、別のツールを使って tar ファイルを圧縮する必要があります。

ソース: Bing との会話 2023/2/16

1. Compress distribution backups | WSL Tips and Tricks. https://craigloewen-msft.github.io/WSLTipsAndTricks/tip/compress-distro-backup.html アクセス日時 2023/2/16.
2. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
3. 【備忘録】WSL2 での import, export とログイン設定 - Qiita. https://qiita.com/koji_hattori/items/1480d25aca8cdf5ac4a1 アクセス日時 2023/2/16.
4. WSL 2 イメージファイルの圧縮 - Qiita. https://qiita.com/oita/items/c2bb26967b6e2eed4f2b アクセス日時 2023/2/16.

### エクスポートしながら圧縮する方法はありませんか?

wsl --export でエクスポートしながら圧縮する方法はありません ²。wsl --export は圧縮オプションを備えていません ²。しかし、パイプを使って wsl --export の出力を別のツールに渡して圧縮することはできます ¹。例えば、次のようなコマンドを使えば、wsl --export の出力を gzip で圧縮してファイルに保存できます。

```powershell
wsl --export ディストリビューション名 - | gzip > バックアップファイル名.gz
```

これでエクスポートしながら圧縮することができます。

ソース: Bing との会話 2023/2/16

1. 「WSL」ディストリビューションのインポート・エクスポートは .... https://forest.watch.impress.co.jp/docs/serial/yajiuma/1220926.html アクセス日時 2023/2/16.
2. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
3. 【備忘録】WSL2 での import, export とログイン設定 - Qiita. https://qiita.com/koji_hattori/items/1480d25aca8cdf5ac4a1 アクセス日時 2023/2/16.

### エクスポートしながら圧縮: あとで試すメモ

たぶん

```powershell
wsl --export distro - | wsl gzip > distro.tar.gz
```

とかになる。

あと import は tar.gz のまま行けるらしい。

## WSL で Windows のやりとり

[wsl2 でよく使う、windows と linux 間のファイル移動やコマンド実行。 - Qiita](https://qiita.com/Uchitaso/items/6e0a7859e87bb8bdb527)

## WSL で ls するとディレクトリの色が暗くて見づらい

Windows Terminal の WSL の Ubuntu で `ls` するとディレクトリの色が暗くて見づらい。

特に WSL じゃなくてもこんな感じで

```sh
dircolors -p > ~/.dircolors
```

で `~/.dircolors` を編集する。今回は'DIR ' で検索して、

```config
#DIR 01;34 # directory
DIR 01;36
```

みたいにする。

カラーコードについては [man dir_colors](https://manpages.ubuntu.com/manpages/noble/en/man5/dir_colors.5.html) の
"ISO 6429 (ANSI) color sequences" を 参照。

一般的なコード番号は

- 01: 太字
- 04: 下線
- 00: リセット(デフォルトに戻す)
- 30-37: 文字色 (黒、赤、緑、黄、青、マゼンタ、シアン、白)
- 40-47: 背景色 (黒、赤、緑、黄、青、マゼンタ、シアン、白)

上の例では 太字青 から 太字シアン に変更。

即時反映させるには

```bash
eval "$(dircolors -b ~/.dircolors)"
```

で。

ディストリによっては起動時に ~/.dircolors を自動で読む設定になっていないので、
その場合は ~/.profile に前述の eval 行を追加する等してください。

`dircolors -b ~/.dircolors` を実行するとわかるけど、
これは環境変数 LS_COLORS を設定してるので、
そちらを設定してもいい。
