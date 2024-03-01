# AWS VPC のメモ

## VPC の enableDnsHostnames

[VPC 内の DNS 属性](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-dns.html#vpc-dns-support)

> 両方の DNS 属性が true の場合、VPC 内のインスタンスはパブリック DNS ホスト名を受け取ります。

...意味が分からん。

[VPC の DNS 属性についてまとめ - lifehack blog](https://walk0204.hatenablog.com/entry/tech/aws/vpc/DNS-attribute#enableDNSHostnames)

> VPC 内のインスタンスがパブリック IP を持つときに、そのインスタンスにパブリック DNS ホスト名を自動でアタッチするかを制御する属性です。

[\<AWS\> VPC の DNS ホスト名を『有効』にするということ - Qiita](https://qiita.com/fumiya-konno/items/f94ed3e3c114793c898a)

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
