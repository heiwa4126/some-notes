# AWS CLIのメモ

- [AWS CLIのメモ](#aws-cliのメモ)
- [aws cliの最新バージョンは?](#aws-cliの最新バージョンは)
- [pipの最新版をユーザーローカルにインストールする](#pipの最新版をユーザーローカルにインストールする)
- [AWS CLIのインストール手順](#aws-cliのインストール手順)
  - [Amazon Linux 2](#amazon-linux-2)
  - [Debian, Ubuntu Linux系](#debian-ubuntu-linux系)
  - [RHEL 7, CentOS 7](#rhel-7-centos-7)
  - [Windows](#windows)
  - [Windows(古い)](#windows古い)
- [pipでawscliのインストールに失敗する](#pipでawscliのインストールに失敗する)
- [コマンド補完](#コマンド補完)


# aws cliの最新バージョンは?

ここ参照
[aws\-cli/CHANGELOG\.rst at v2 · aws/aws\-cli](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst)



# pipの最新版をユーザーローカルにインストールする

[Installation — pip 19.2.1 documentation](https://pip.pypa.io/en/stable/installing/)

``` bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user -U
```

RHEL7, CentOS7ではpython3が面倒なので、pythonで。

Ubuntu, Debianでは`~.local/bin`へのパスが、
「パスが存在しない場合は追加しない」ようになってるので、
一旦ログアウトして、入り直す
(詳しくは~/.profile参照。手動でパスに追加してhash -rでもOK)。

``` bash
$ which pip
$ pip --version
```
で確認。


# AWS CLIのインストール手順

[AWS CLI のインストール](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-install.html)
に書かれているとおりなのだが、
pipを使った例しか出ておらず、
そのpipが意外と面倒(Python2と3の混乱のせいで)だったりして、
実際にやってみるとかなり面倒。


## Amazon Linux 2

プリインストール。


## Debian, Ubuntu Linux系

パッケージで入れるなら

``` bash
sudo apt install awscli -y
```

で、Python3ベースのaws cliがインストールされる。
ただバージョンが若干古い(Ubutu18.04LTSで1.14.44)。

2019-7の最新版 (Ubuntu 18.04LTSで)
```
$ aws --version
aws-cli/1.16.206 Python/3.6.8 Linux/4.15.0-55-generic botocore/1.12.196
```


## RHEL 7, CentOS 7

[Linux に AWS CLI をインストールする - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-linux.html)

RHEL7系は未だにpython3が不自由なので、
python2で我慢する。

カレントユーザにインストールする例
``` bash
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm ./get-pip.py
pip install awscli --upgrade --user
hash -r
```

## Windows

[Windows での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-windows.html)


クレデンシャルの場所
[構成設定はどこに保存されていますか](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-files.html#cli-configure-files-where)

Windowsについて記述がない... `aws configure`で。

aws cliがv2なら `aws configure list-profiles`でリストも出せる。





## Windows(古い)

まずAnacondaを更新する。
Anaconda promptを管理者権限で起動して

```
conda update --all -y
```

Anaconda promptを閉じる。

awscliをインストール。
Anaconda promptを起動して、

```
pip install awscli --user -U
```


# pipでawscliのインストールに失敗する

[cryptography](https://pypi.org/project/cryptography/)が
opensslのdevパッケージを要求するので、

先に
``` bash
sudo apt install libssl-dev
# または
sudo apt install python3-cryptography
```
してから。


# コマンド補完

v2では
`/usr/local/bin/aws_completer` (symlink)
