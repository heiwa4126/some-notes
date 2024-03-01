# AWS VPC のメモ

## 「S3 へのゲートウェイエンドポイント」とは

[Amazon S3 のゲートウェイエンドポイント - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/privatelink/vpc-endpoints-s3.html)

- ゲートウェイエンドポイントは、VPC 内の Amazon S3 バケットにアクセスするためのプライベートネットワーク接続を提供します
- ゲートウェイエンドポイントは、インターネットゲートウェイまたは NAT デバイスを必要としません
- インターフェイスエンドポイントよりも安価
- IPv4 トラフィックのみサポートします
- 同一リージョンの S3 のみ
- オンプレミスネットワーク、別の AWS リージョンのピアリングされた VPC、またはトランジットゲートウェイを介して S3 にアクセスするために使用できません。

VPC のルートテーブルに S3 へのマネージドプレフィックスリストがあって、それに Amazon S3 のゲートウェイエンドポイントへのルートがあるはず。

EC2 インスタンスから S3 へ頻繁にアクセスがあるなら設定するべき。

### AWS で s3 ゲートウェイエンドポイントは public サブネットのルートテーブルに追加しても安全ですか?

安全らしい。

## NAT ゲートウェイとは

[NAT ゲートウェイ - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-nat-gateway.html)

VPC 内から外(インタネット)へは行けるが、インタネットから中へは行けない。つまり...NAT だ。

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
