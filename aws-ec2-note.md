# AWS EC2 のメモ

## キーペアのインポート

- キーペアはリージョンごと
- ポータルからキーペアのインポートはできない(昔は出来たような気がするんだけど)

AWS CLI を使って.ssh の下から pub キーをインポートする。

[import-key-pair — AWS CLI 2.15.24 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/import-key-pair.html)

例

```bash
aws ec2 import-key-pair \
  --key-name xxxx \
  --public-key-material fileb://~/.ssh/xxxx.pub \
  --region us-east-1

# 確認
aws ec2 describe-key-pairs \
    --key-name xxxx \
    --region us-east-1
```

## Windows のパスワードを受け取る

要約: 秘密キーは OpenSSH 形式でないとダメ

最近では Windows インスタンスのパスワードはキーペアの秘密鍵で複合して受け取る式になっていて、
ポータルに秘密鍵ファイルを指定するかコピペする。

で、古めの PKCS#8 形式 の秘密キーファイルをそのまま貼り付けると
`-----BEGIN RSA PRIVATE KEY----- -----END RSA PRIVATE KEY----- の形式でないとダメ`
と言われるので変換する。

実行例:

```terminal
$ mkdir /tmp/x

$ cd /tmp/x

$ cp -a ~/.ssh/xxxxx .

$ ssh-keygen -p -m PEM -f xxxxx
Enter old passphrase:
Enter new passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved with the new passphrase.
```

- -----BEGIN PRIVATE KEY----- で始まる形式は PKCS#8 形式と呼ばれます。
- -----BEGIN RSA PRIVATE KEY----- で始まる形式は OpenSSH 形式または PEM 形式と呼ばれます。

OpenSSH 7.8 以降では、デフォルトで OpenSSH 形式が使用されます。
それ以前のバージョンの OpenSSH では、PKCS#8 形式がデフォルトで使用されていました。

実際はさらにややこしい。参考: [RSA 鍵のフォーマットについて](https://zenn.dev/htlsne/articles/rsa-key-format)

## AWS のセキュリティグループのルールで、「マイ IP」とは?

(セキュリティグループは EC2 だけど...)

いまポータルにつないでる IP らしい。
よほどのことがないと役に立たないのでは?

## AWS のセキュリティグループのルールで IGW 経由のソースアドレスは、サブネットの GW アドレスですか、それともインタネット上のアドレスですか?

AWS のセキュリティグループのルールで、IGW 経由のソースアドレスは、サブネットの GW アドレスではなく、インターネット上のアドレスになります。

## AWS のセキュリティグループのルールで 「拒否するルール」は書けますか?

無理っぽい。許可のみ。

参考: [AWS::EC2::SecurityGroup Ingress - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-securitygroup-ingress.html)

## AWS の「新しいセキュリティグループにコピー」で VPC はコピーされない

コピー元の VPC が引き継がれない。「[驚き最小の原則](https://ja.wikipedia.org/wiki/%E9%A9%9A%E3%81%8D%E6%9C%80%E5%B0%8F%E3%81%AE%E5%8E%9F%E5%89%87)」に反する UI。

タグと description もコピーされない...

## 「パブリック IP の自動割り当て」の設定はどこにあるのか

[AWS::EC2::Instance - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html#aws-resource-ec2-instance--examples) に `AssociatePublicIpAddress` の設定がある。

たどって
[AssociatePublicIpAddress](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance-networkinterface.html#cfn-ec2-instance-networkinterface-associatepublicipaddress)

> インスタンスにパブリック IPv4 アドレスを割り当てるかどうかを示します。インスタンスの起動時にネットワーク・インターフェイスを作成する場合にのみ適用されます。ネットワーク・インターフェイスはプライマリ・ネットワーク・インターフェイスでなければなりません。デフォルトのサブネットに起動する場合、デフォルト値は true です。

> AWS は、実行中のインスタンスと Elastic IP アドレスに関連付けられたパブリック IPv4 アドレスを含む、すべてのパブリック IPv4 アドレスに対して課金します。詳細については、VPC 価格ページの「パブリック IPv4 アドレス」タブを参照してください。

2024 年 2 月から

- 使用中のパブリック IPv4 アドレスの 1 時間あたりの料金は 0.005 USD です
- アイドル状態のパブリック IPv4 アドレスの 1 時間あたりの料金は 0.005 USD です

のように使用中とアイドル状態の IPv4 の価格がおんなじになるので注意。[料金 - Amazon VPC | AWS](https://aws.amazon.com/jp/vpc/pricing/)

この価格は EIP と同じ。

IPv6 やってみるかな...

- [AWS EC2 を IPv6 で構築する方法 #AWS - Qiita](https://qiita.com/koji4104/items/4a2b4554ae01061334e4)
- [AWS EC2 を IPv6 のみ(パブリック IPv4 アドレスなし)で作って ssh 接続する #AWS - Qiita](https://qiita.com/ran/items/7ae62f7dba2bba49e330)
- [Egress-Only インターネットゲートウェイを使用してアウトバウンド IPv6 トラフィックを有効にする - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/egress-only-internet-gateway.html)
