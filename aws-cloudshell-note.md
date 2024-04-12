# AWS CloudShell メモ

## 最近の AWS CloudShell で最初から入ってるもの調べた (2024-04)

最近のは Amazon Linux 2023 ベースなのでいろんなものが最初から入っててびっくり

流した shell:

```sh
date
uname -a
grep PRETTY_NAME /etc/os-release
python3 -V
pip3 -V
node -v
npm -v
npm ls -g
aws --version
sam --version
cdk --version
git -v
```

output

```text
$ date
Fri Apr 12 01:20:29 AM UTC 2024

$ uname -a
Linux ip-10-132-85-58.ap-northeast-1.compute.internal 6.1.79-99.167.amzn2023.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Mar 12 18:15:55 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux

$ grep PRETTY_NAME /etc/os-release
PRETTY_NAME="Amazon Linux 2023.3.20240312"

$ python3 -V
Python 3.9.16

$ pip3 -V
pip 21.3.1 from /usr/lib/python3.9/site-packages/pip (python 3.9)

$ node -v
v18.18.2

$ npm -v
9.8.1

$ npm ls -g
/usr/local/lib
├── aws-cdk@2.132.1
└── aws-sdk@2.1576.0

$ aws --version
aws-cli/2.15.37 Python/3.11.8 Linux/6.1.79-99.167.amzn2023.x86_64 exec-env/CloudShell exe/x86_64.amzn.2023 prompt/off

$ sam --version
SAM CLI, version 1.112.0

$ cdk --version
2.132.1 (build 9df7dd3)

$ git -v
git version 2.40.1
```

あと `pip3 list` は長いので省略。

### Amazon Linux 2023.3 の Python

Amazon Linux 2023.3 には
デフォルトの Python 3.9 以外に Python 3.11 の RPM パッケージがある。

インストールは:

```sh
sudo dnf install python3.11 python3.11-libs python3.11-devel python3.11-pip python3.11-wheel -y
```

他のバージョンはソースからビルド。

参考: [Amazon Linux 2023 RPM packages as of the 2023.3.20240219 release - Amazon Linux 2023](https://docs.aws.amazon.com/linux/al2023/release-notes/all-packages-AL2023.3.html)

## 概要

[AWS CloudShell の使用 - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/working-with-cloudshell.html)
意外と重要なことが書いてある。

OS は Amazon Linux2。1 CPU 3GHz メモリ 4GB

aws cli も SAM もある(ちょっと古い)。けど Python3 は 3.7
Lambda の Python3.8 が動かない。

3.8 入れて、venv でならいけるはず。

```sh
sudo amazon-linux-extras install -y python3.8
python3.8 -m venv ~/.venv/38/
. ~/.venv/38/bin/activate
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python get-pip.py -U
```

ブラウザから使えるのは便利だけど、
メタキーとかが辛い。
tmux も入ってるんだが ctrl-t がブラウザに食われる。
そのへんさえ我慢できれば

## 制限

- [AWS CloudShell – AWS リソースへのコマンドラインアクセス | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-cloudshell-command-line-access-to-aws-resources/)
- [の制限と制約 AWS CloudShell - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/limits.html#persistent-storage-limitations)

- HOME は永続する。ただし最後にログインしてから 120 日まで。容量は各リージョンで 1GB まで
- 10 セッションまで同時接続可能 (タブブラウザっぽく使える)。でも w 叩いても他の人は見えない。
- **再起動すると変更は全部消えます**. ある意味便利
- shell の history が残らない。

## だいたいのバージョン

```text
$ date
Thu Dec 16 23:48:07 UTC 2021

$ cat /etc/os-release
NAME="Amazon Linux"
VERSION="2"
ID="amzn"
ID_LIKE="centos rhel fedora"
VERSION_ID="2"
PRETTY_NAME="Amazon Linux 2"
ANSI_COLOR="0;33"
CPE_NAME="cpe:2.3:o:amazon:amazon_linux:2"
HOME_URL="https://amazonlinux.com/"

$ aws --version
aws-cli/2.4.5 Python/3.8.8 Linux/4.14.248-189.473.amzn2.x86_64 exec-env/CloudShell exe/x86_64.amzn.2 prompt/off

$ sam --version
SAM CLI, version 1.33.0

$ python --version
Python 2.7.18

$ python3 --version
Python 3.7.10

$ python3.8 --version
bash: python3.8: command not found

$ node -v
v14.18.0

$ npm -v
6.14.15

$ yarn -v
bash: yarn: command not found
```

Amazon Linux 2 なので必要なら yum や amazon-linux-extras で更新。

**ただし再起動すると変更は全部消えます**

## aws のデフォルトプロファイル

```sh
aws sts get-caller-identity
```

で確認。ポータルのログインユーザと同じ。リージョンもポータルといっしょ(ターミナルの左上)。

## 自分環境

```sh
sudo yum update -y
sudo amazon-linux-extras install -y python3.8
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python get-pip.py -U
rm get-pip.py
sudo yum -y groupinstall "Development Tools"
sudo yum -y install openssl-devel bzip2-devel libffi-devel jq emacs-nox
curl https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tar.xz -O
tar xf Python-3.9.9.tar.xz
cd Python-3.9.9
./configure --enable-optimizations
sudo make altinstall
cd ..
sudo rm -rf Python-3.9.9 Python-3.9.9.tar.xz
sudo /usr/local/bin/python3.9 -m pip install --upgrade pip
```

```sh
curl https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tar.xz -O
tar xf Python-3.10.2.tar.xz
cd Python-3.10.2
./configure --enable-optimizations
sudo make altinstall
cd ..
sudo rm -rf Python-3.10.2 Python-3.10.2.tar.xz
sudo /usr/local/bin/python3.10 -m pip install --upgrade pip
```

考えてみると RPM 作ったほうがよくないか?
