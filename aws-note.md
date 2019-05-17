# AWS忘備録

AWSのメモ
- [AWS忘備録](#aws忘備録)
- [メタデータ](#メタデータ)
- [AWS CLIのインストール手順](#aws-cliのインストール手順)
  - [Amazon Linux](#amazon-linux)
  - [Debian, Ubuntu Linux系](#debian-ubuntu-linux系)
  - [RHEL 7, CentOS 7](#rhel-7-centos-7)

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





