# 概要

[AWS CloudShell の使用 - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/working-with-cloudshell.html)
意外と重要なことが書いてある。

OSはAmazon Linux2。1 CPU 3GHz メモリ 4GB


aws cliもSAMもある(ちょっと古い)。けどPython3は3.7
LambdaのPython3.8が動かない。

3.8入れて、venvでならいけるはず。
```sh
sudo amazon-linux-extras install -y python3.8
python3.8 -m venv ~/.venv/38/
. ~/.venv/38/bin/activate
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python get-pip.py -U
```


ブラウザから使えるのは便利だけど、
メタキーとかが辛い。
tmuxも入ってるんだがctrl-tがブラウザに食われる。
そのへんさえ我慢できれば

# 制限

- [AWS CloudShell – AWS リソースへのコマンドラインアクセス | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-cloudshell-command-line-access-to-aws-resources/)
- [の制限と制約AWS CloudShell - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/limits.html#persistent-storage-limitations)

- HOMEは永続する。ただし最後にログインしてから120日まで。容量は各リージョンで1GBまで
- 10セッションまで同時接続可能 (タブブラウザっぽく使える)。でもw叩いても他の人は見えない。
- **再起動すると変更は全部消えます**. ある意味便利
- shellのhistoryが残らない。


# だいたいのバージョン

```
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

Amazon Linux 2 なので必要ならyumやamazon-linux-extrasで更新。

**ただし再起動すると変更は全部消えます**


# awsのデフォルトプロファイル

```sh
aws sts get-caller-identity
```
で確認。ポータルのログインユーザと同じ。リージョンもポータルといっしょ(ターミナルの左上)。


# 自分環境


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

考えてみるとRPM作ったほうがよくないか?
