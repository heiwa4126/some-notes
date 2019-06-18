# AWS忘備録

AWSのメモ
- [AWS忘備録](#AWS忘備録)
- [メタデータ](#メタデータ)
- [AWS CLIのインストール手順](#AWS-CLIのインストール手順)
  - [Amazon Linux](#Amazon-Linux)
  - [Debian, Ubuntu Linux系](#Debian-Ubuntu-Linux系)
  - [RHEL 7, CentOS 7](#RHEL-7-CentOS-7)
- [EC2ってntpは要るの?](#EC2ってntpは要るの)

# メタデータ

* [インスタンスメタデータとユーザーデータ - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
* [Instance Metadata and User Data - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
* [AWS | AWS の169.254.169.254とは何か](https://awsjp.com/AWS/Faq/c/AWS-169.254.169.254-towa-4135.html)

``` bash
curl http://169.254.169.254/latest/meta-data/
```

# AWS CLIのインストール手順

## Amazon Linux

プリインストール

## Debian, Ubuntu Linux系

```
sudo apt install awscli -y
```

## RHEL 7, CentOS 7

[Linux に AWS CLI をインストールする - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-linux.html)

カレントユーザにインストールする例
```
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
rm ./get-pip.py
pip install awscli --upgrade --user
hash -r
```

# EC2ってntpは要るの?

[Linux インスタンスの時刻の設定 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-time.html)
というのがあるので、たぶん要る。

Azureでは
[Azure での Linux VM の時刻同期 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync)
によると
「Hyper-VなのでVMICTimeSyncあるけど、ntp併用のほうが多いね。でもAzure内にNTPサーバはないよ」
みたいな感じ。
このページの[ツールとリソース](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync#tools-and-resources)
の項目が、Linuxでhvが動いてるかのチェックになってて面白い。

NTPサーバは

- 169.254.169.123 (リンクローカル)
- 0.amazon.pool.ntp.org
- 1.amazon.pool.ntp.org
- 2.amazon.pool.ntp.org
- 3.amazon.pool.ntp.org

が使える。

ntpdだったら景気よく
```
server 169.254.169.123 iburst
server 0.amazon.pool.ntp.org iburst
server 1.amazon.pool.ntp.org iburst
server 2.amazon.pool.ntp.org iburst
server 3.amazon.pool.ntp.org iburst
```
しとけばいいのではないか。

ntpdやchronyのようなNTPサーバの機能を持つものではなく
sntpやsystemd-timesyncdのようなSNTPクライアントだけのものが軽いのではないか。試してみる。

systemd-timesyncdはVMだと動かない? [ゆきろぐ: systemd-timesyncdによる時刻同期](http://yukithm.blogspot.com/2014/09/systemd-timesyncd.html)
試してみたが動くみたい。

