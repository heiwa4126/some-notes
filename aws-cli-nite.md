# AWS CLI のメモ

- [aws cli の最新バージョンは?](#aws-cli-の最新バージョンは)
- [aws cli のプロファイルの場所](#aws-cli-のプロファイルの場所)
- [コマンド補完](#コマンド補完)
- [AWS CLI のインストール手順](#aws-cli-のインストール手順)
  - [pip の最新版をユーザーローカルにインストールする](#pip-の最新版をユーザーローカルにインストールする)
  - [Amazon Linux 2](#amazon-linux-2)
  - [Debian, Ubuntu Linux 系](#debian-ubuntu-linux-系)
  - [RHEL 7, CentOS 7](#rhel-7-centos-7)
  - [Windows](#windows)
  - [Windows(古い)](#windows古い)
- [pip で awscli のインストールに失敗する](#pip-で-awscli-のインストールに失敗する)
- [ログインとリスト](#ログインとリスト)
- [AMI のイメージ ID から名前を得る](#ami-のイメージ-id-から名前を得る)
- [AWS CloudShell から VPC に接続](#aws-cloudshell-から-vpc-に接続)
- [aws cli の bash completion](#aws-cli-の-bash-completion)

## aws cli の最新バージョンは?

ここ参照
[aws\-cli/CHANGELOG\.rst at v2 · aws/aws\-cli](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst)

## aws cli のプロファイルの場所

- Windows: `%USERPROFILE%\.aws` - v1 では%HOME が定義されていれば `%HOME%\.aws` だった。
- Linux & Mac: `~/.aws/credentials`

[名前付きプロファイル - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-profiles.html)

## コマンド補完

v2 では
`/usr/local/bin/aws_completer` (symlink)

## AWS CLI のインストール手順

**以下 v1 の場合。v2 は Python 3 ごと配布されてる**

[AWS CLI のインストール](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-install.html)
に書かれているとおりなのだが、
pip を使った例しか出ておらず、
その pip が意外と面倒(Python2 と 3 の混乱のせいで)だったりして、
実際にやってみるとかなり面倒。

### pip の最新版をユーザーローカルにインストールする

[Installation — pip 19.2.1 documentation](https://pip.pypa.io/en/stable/installing/)

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user -U
```

RHEL7, CentOS7 では python3 が面倒なので、python で。

Ubuntu, Debian では `~.local/bin` へのパスが、
「パスが存在しない場合は追加しない」ようになってるので、
一旦ログアウトして、入り直す
(詳しくは~/.profile 参照。手動でパスに追加して hash -r でも OK)。

```bash
which pip
pip --version
```

で確認。

### Amazon Linux 2

プリインストール。

### Debian, Ubuntu Linux 系

パッケージで入れるなら

```bash
sudo apt install awscli -y
```

で、Python3 ベースの aws cli がインストールされる。
ただバージョンが若干古い(Ubutu18.04LTS で 1.14.44)。

2019-7 の最新版 (Ubuntu 18.04LTS で)

```console
$ aws --version

aws-cli/1.16.206 Python/3.6.8 Linux/4.15.0-55-generic botocore/1.12.196
```

### RHEL 7, CentOS 7

[Linux に AWS CLI をインストールする - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-linux.html)

RHEL7 系は未だに python3 が不自由なので、
python2 で我慢する。

カレントユーザにインストールする例

```bash
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm ./get-pip.py
pip install awscli --upgrade --user
hash -r
```

### Windows

[Windows での AWS CLI バージョン 2 のインストール、更新、アンインストール - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-windows.html)

クレデンシャルの場所
[構成設定はどこに保存されていますか](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-files.html#cli-configure-files-where)

Windows について記述がない... `aws configure`で。

aws cli が v2 なら `aws configure list-profiles`でリストも出せる。

### Windows(古い)

まず Anaconda を更新する。
Anaconda prompt を管理者権限で起動して

```powershell
conda update --all -y
```

Anaconda prompt を閉じる。

awscli をインストール。
Anaconda prompt を起動して、

```bash
pip install awscli --user -U
```

## pip で awscli のインストールに失敗する

[cryptography](https://pypi.org/project/cryptography/)が
openssl の dev パッケージを要求するので、

先に

```bash
sudo apt install libssl-dev
## または
sudo apt install python3-cryptography
```

してから。

## ログインとリスト

```bash
az login
az account list -o table
```

## AMI のイメージ ID から名前を得る

ポータルからだと名前が取れない。

以下例:

```bash
aws ec2 describe-images --region ap-northeast-1 --image-ids ami-0d52744d6551d851e --query "Images[].{Name:Name,Description:Description}"
```

ami はリージョンごとに ID が違うみたい。
でも名前はだいたい同じはずなので
Terraform なんかでは filter で ID を見つける。

これ参照: [aws_instance | Resources | hashicorp/aws | Terraform | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#basic-example-using-ami-lookup)

## AWS CloudShell から VPC に接続

VPN とか無しにできるらしい。

- [CloudShell を VPC で試してみた #AWS - Qiita](https://qiita.com/zumax/items/64433406a6123862957e)
- [【AWS】手を動かして学ぶ AWS AWS CloudShell #AWS - Qiita](https://qiita.com/ymd65536/items/14f6dc1164cbf83b7de8)
- [AWS CloudShell を VPC 環境下で起動してみた - DENET 技術ブログ](https://blog.denet.co.jp/aws-cloudshell-on-vpc/)
- [Amazon VPC AWS CloudShell での の使用 - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/using-cshell-in-vpc.html)
- [CloudShell の VPC 環境を作成する - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/creating-vpc-environment.html)

最大 2 個まで作れて、削除は画面上部の\[アクション ▼\]からできるらしい。

## aws cli の bash completion

基本は

```bash
complete -C "$(which aws_completer)" aws
```

を実行するか ~/.bashrc や ~/.profile に書く。

lazy loading したければ

```bash
# ~/.bashrc に追記
_aws_lazy_complete() {
    complete -C "$(which aws_completer)" aws
    unset -f _aws_lazy_complete
}
complete -F _aws_lazy_complete aws
```

が定石らしい。

根性のあるひとは which のかわりに `command -v` を使って効率よくしよう!
