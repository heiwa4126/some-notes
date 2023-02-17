# WSLのsyslogはWindowsイベントログに出る

ええっ


# WSL2でdockerは使えますか?

Bing Searchに聞いてみた。

注意点: リンク先読め。

## WSL2でdockerは使えますか?

はい、WSL2ではdockerを使えます²³⁴⁵。
WSL2はLinuxカーネルを実装しているので、dockerのネイティブな動作が可能になります²。
しかし、WSL2ではsystemdがサポートされていないので、dockerをインストールするにはいくつかの手順が必要です¹⁴。
一つの方法は、次のようにすることです⁴。

- WSL2でUbuntuをインストールする
- Ubuntuでsudo apt updateとsudo apt upgradeを実行する
- Ubuntuでcurl -fsSL https://get.docker.com -o get-docker.shを実行してdockerのインストールスクリプトをダウンロードする
- Ubuntuでsudo sh get-docker.shを実行してdockerをインストールする
- Ubuntuでsudo usermod -aG docker $USERを実行して自分のユーザーにdockerグループを追加する
- UbuntuでexitしてWSL2から抜ける
- PowerShellでwsl --shutdownを実行してWSL2を再起動する
- PowerShellでwsl -u root -e service docker startを実行してdockerサービスを起動する

これでWSL2からdockerコマンドが使えるようになります。

ソース: Bing との会話 2023/2/16

1. Docker Desktop WSL 2 バックエンド — Docker-docs-ja 20.10 .... https://docs.docker.jp/docker-for-windows/wsl.html アクセス日時 2023/2/16.
2. Windows＋WSL2でDocker環境を用意しよう - カゴヤの .... https://www.kagoya.jp/howto/cloud/container/wsl2_docker/ アクセス日時 2023/2/16.
3. WSL2にdockerをインストールしてみた - Qiita. https://qiita.com/hkusaba/items/5b44248d758214f99e97 アクセス日時 2023/2/16.
4. windowsにWSL2+Docker環境を構築する手順 - Qiita. https://qiita.com/taka777n/items/ea3a1b3a2802aabf3db2 アクセス日時 2023/2/16.
5. 知乎专栏 - 随心写作，自由表达 - 知乎. https://zhuanlan.zhihu.com/p/148511634 アクセス日時 2023/2/16.


## dockerサービスは自動起動しますか?

いいえ、WSL2ではdockerサービスは自動起動しません¹³⁴。
WSL2ではsystemdがサポートされていないため、dockerサービスを起動するには毎回コマンドを実行する必要があります¹。
しかし、自動起動する方法もあります。一つの方法は、プロファイルファイルにdockerサービスを起動するコマンドを追加することです¹²。
具体的には、次のようにします¹。

- Ubuntuでsudo visudoを実行してsudoersファイルを編集する
- ファイルの最後に自分のユーザー名 ALL=(ALL:ALL) NOPASSWD: /usr/sbin/service docker startという行を追加する
- Ubuntuで~/.profileファイルを開く
- ファイルの最後にsudo service docker startという行を追加する

これでWSL2が起動するたびにdockerサービスも自動的に起動します。
>

ソース: Bing との会話 2023/2/16

1. How to automatically start the Docker daemon on WSL2. https://bing.com/search?q=WSL2+docker+service+auto+start アクセス日時 2023/2/16.
2. wsl2でDocker自動起動設定 - Qiita. https://qiita.com/ko-zi/items/949d358163bbbad5a91e アクセス日時 2023/2/16.
3. wsl2にインストールしたDockerを自動起動する. https://zukucode.com/2021/11/wsl2-docker-startup.html アクセス日時 2023/2/16.
4. How to automatically start the Docker daemon on WSL2. https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/ アクセス日時 2023/2/16.
5. WSL2(Ubuntu18.04)上でDockerを起動する - Qiita. https://qiita.com/FugitHora812/items/bc84a176234f36bf6697 アクセス日時 2023/2/16.


## ChatGPTにも聞いてみた: WSL2でdockerは使えますか?

はい、WSL2上でDockerを使用することができます。WSL2には、Dockerを含むLinuxカーネルが組み込まれており、Dockerコマンドを使用してWSL2内のコンテナを管理できます。

ただし、WSL2にはいくつかの制限事項があります。たとえば、現時点ではWSL2はLinuxカーネルバージョン4.19をサポートしており、一部の機能は制限されています。また、WSL2はまだWindowsと完全に統合されておらず、一部の機能がまだ不安定である場合があります。

ただし、WSL2はDockerを実行するために非常に便利であり、多くの開発者が利用しています。WSL2を使用してDockerを実行する方法については、Microsoftの公式ドキュメントやオンラインのチュートリアルなどが利用できます。

## つづき: そのMicrosoftの公式ドキュメントやオンラインのチュートリアルのURLを教えてください。

以下に、WSL2でDockerを使用するためのMicrosoft公式ドキュメントと、オンラインのチュートリアルのURLを示します。

1. Microsoft公式ドキュメント:
https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package
2. Docker公式ドキュメント:
https://docs.docker.com/docker-for-windows/wsl/
3. Devdojo.comによるチュートリアル:
https://devdojo.com/bobbyiliev/how-to-install-docker-on-wsl2-windows-10

上記のドキュメントやチュートリアルを参照することで、WSL2上でDockerをセットアップし、使用することができます。

(2.はdocker desktopを使う。まあdocker公式だから...)


# WSLをバックアップすることはできますか?

はい、WSLをバックアップすることはできます¹²³。
WSLをバックアップするには、wsl --exportコマンドを使ってWSLのディストリビューションをtarファイルにエクスポートすることができます¹²³。
具体的には、次のようにします¹²³。

- コマンドプロンプトかPowerShellを開く
- wsl --list --verboseを実行してバックアップしたいディストリビューションの名前を確認する
- wsl --export ディストリビューション名 バックアップファイル名を実行してディストリビューションをtarファイルにエクスポートする
- バックアップファイルを安全な場所に保存する

これでWSLのバックアップができます。

ソース: Bing との会話 2023/2/16

1. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
2. Windows 10 WSL2 Ubuntuのデータをバックアップするには .... https://denor.jp/windows-10-wsl2-ubuntu%e3%81%ae%e3%83%87%e3%83%bc%e3%82%bf%e3%82%92%e3%83%90%e3%83%83%e3%82%af%e3%82%a2%e3%83%83%e3%83%97%e3%81%99%e3%82%8b%e3%81%ab%e3%81%af アクセス日時 2023/2/16.
3. WSL上のLinuxのバックアップ. https://www.aise.ics.saitama-u.ac.jp/~gotoh/HowToBackupLinuxOnWSL.html アクセス日時 2023/2/16.

## リストアする方法も教えてください

WSLの復元方法は次のとおりです¹⁴。

- コマンドプロンプトかPowerShellを開く
- wsl --import ディストリビューション名 インストール先フォルダ バックアップファイル名を実行してバックアップファイルからディストリビューションをインポートする
- wsl --list --verboseを実行してインポートしたディストリビューションが表示されることを確認する
- wsl -d ディストリビューション名を実行してインポートしたディストリビューションに入る

これでWSLの復元ができます。
>

ソース: Bing との会話 2023/2/16

1. WSL バックアップと復元方法 | SEECK.JP サポート. https://bing.com/search?q=WSL+restore アクセス日時 2023/2/16.
2. How to back up and restore a Windows Subsystem for Linux .... https://www.xda-developers.com/how-back-up-restore-wsl/ アクセス日時 2023/2/16.
3. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
4. Windows 10のWSL環境を初期化してクリーンな状態に戻す. https://atmarkit.itmedia.co.jp/ait/articles/1807/06/news028.html アクセス日時 2023/2/16.

## wsl --export の出力は圧縮されないのですか?

wsl --exportの出力は圧縮されないのです¹。
wsl --exportは指定したディストリビューションをtarファイルにエクスポートするだけで、圧縮は行いません。圧縮すると時間がかかるからです¹。
もし圧縮したい場合は、別のツールを使ってtarファイルを圧縮する必要があります。

ソース: Bing との会話 2023/2/16

1. Compress distribution backups | WSL Tips and Tricks. https://craigloewen-msft.github.io/WSLTipsAndTricks/tip/compress-distro-backup.html アクセス日時 2023/2/16.
2. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
3. 【備忘録】WSL2でのimport, exportとログイン設定 - Qiita. https://qiita.com/koji_hattori/items/1480d25aca8cdf5ac4a1 アクセス日時 2023/2/16.
4. WSL 2 イメージファイルの圧縮 - Qiita. https://qiita.com/oita/items/c2bb26967b6e2eed4f2b アクセス日時 2023/2/16.

## エクスポートしながら圧縮する方法はありませんか?

wsl --exportでエクスポートしながら圧縮する方法はありません²。wsl --exportは圧縮オプションを備えていません²。しかし、パイプを使ってwsl --exportの出力を別のツールに渡して圧縮することはできます¹。例えば、次のようなコマンドを使えば、wsl --exportの出力をgzipで圧縮してファイルに保存できます。

```powershell
wsl --export ディストリビューション名 - | gzip > バックアップファイル名.gz
```
これでエクスポートしながら圧縮することができます。

ソース: Bing との会話 2023/2/16

1. 「WSL」ディストリビューションのインポート・エクスポートは .... https://forest.watch.impress.co.jp/docs/serial/yajiuma/1220926.html アクセス日時 2023/2/16.
2. WSL バックアップと復元方法 | SEECK.JP サポート. https://kb.seeck.jp/archives/17024 アクセス日時 2023/2/16.
3. 【備忘録】WSL2でのimport, exportとログイン設定 - Qiita. https://qiita.com/koji_hattori/items/1480d25aca8cdf5ac4a1 アクセス日時 2023/2/16.


## メモ

たぶん
```
wsl --export distro - | wsl gzip > distro.tar.gz
```
とかになる。

あとimportはtar.gzのまま行けるらしい。
