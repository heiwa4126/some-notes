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

### s3 ゲートウェイエンドポイントをつなぐルーティングテーブルを変更するには?

ルーティングテーブルを編集するのではなく
s3 ゲートウェイエンドポイント側で変更する。

### S3 と DynamoDB のゲートウェイエンドポイントは設定しといた方がいい

タダだし。

- [Amazon DynamoDB のゲートウェイエンドポイント - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/privatelink/vpc-endpoints-ddb.html)
- [Amazon S3 のゲートウェイエンドポイント - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/privatelink/vpc-endpoints-s3.html)

インターフェースエンドポイント型(ENI 型)は多数あるけど、こちらは有料なのでむやみに作らない。ECR なんかは微妙なライン。NATGW と PrivateLink の損益分岐点が 100GB/月ぐらい。

全部のリスト:
[AWS のサービス と統合する AWS PrivateLink - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/privatelink/aws-services-privatelink-support.html)

## NAT ゲートウェイとは

[NAT ゲートウェイ - Amazon Virtual Private Cloud](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-nat-gateway.html)

VPC 内から外(インタネット)へは行けるが、インタネットから中へは行けない。つまり...NAT だ。

NATGW は価格が高い。EIP より高い。使っていなくても存在するだけで課金される。

で、2 種類ある。

1. **Public NAT Gateway**
   - **用途**:プライベートサブネットのインスタンスがインターネットにアクセスするため
   - **設置場所**:**パブリックサブネット**
   - **必要なもの**:**Elastic IP アドレス**(固定のグローバル IP)
   - **通信の流れ**:
     - インスタンス → NAT Gateway → インターネットゲートウェイ → インターネット
   - **特徴**:
     - 外部からの接続は不可(セキュリティ的に安全)
     - インターネットアクセスが必要な場合に使う
2. **Private NAT Gateway**
   - **用途**:プライベートサブネットのインスタンスが**他の VPC やオンプレミスネットワーク**にアクセスするため
   - **設置場所**:**プライベートサブネット**
   - **Elastic IP は不要**
   - **通信の流れ**:
     - インスタンス → NAT Gateway → Transit Gateway や VPN Gateway → 他のネットワーク
   - **注意点**:
     - インターネットゲートウェイにルーティングしても、**通信は破棄される**(インターネットには出られない)

プライベートサブネットがインターネットにアクセスする場合は、
パブリックサブネットが必要。
