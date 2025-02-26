# AWS Fargate のメモ

> Fargate はサーバーレスの従量制料金計算エンジンです。
> Fargate を使用すると、サーバーを管理したり、キャパシティ計画に対処したり、セキュリティのためにコンテナワークロードを分離したりする必要がなくなります。

Fargate は Amazon ECS キャパシティの 1 つ

> Amazon ECS キャパシティは、コンテナが稼働するインフラストラクチャ(コンテナ実行環境)です。

引用元: [Amazon Elastic Container Service とは - Amazon Elastic Container Service](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/Welcome.html)

## ECS と Fargate の違い

超 FAQ らしい...

| 特徴             | ECS (Elastic Container Service)          | Fargate                                |
| ---------------- | ---------------------------------------- | -------------------------------------- |
| **インフラ管理** | サーバー管理が必要(EC2 インスタンス使用) | インフラ管理不要(サーバーレス)         |
| **スケーリング** | EC2 インスタンスの管理が必要             | 自動スケーリング、リソースに応じて調整 |
| **課金方式**     | EC2 インスタンスの時間単位で発生         | コンテナ単位でリソースに応じて課金     |
| **利便性**       | 高いカスタマイズ性がある                 | シンプルで運用が簡単                   |

ECS でなければできないことは以下の通り:

- **EC2 インスタンスのカスタマイズ**: ECS では EC2 インスタンスを直接管理できるため、インスタンスの設定や環境を細かく調整可能
- **オンプレミスとの統合**: EC2 インスタンスをオンプレミスと統合し、ハイブリッド環境を構築できる
- **特定のハードウェアリソースの利用**: GPU や専用インスタンスなど、特定のハードウェアリソースを直接指定して利用可能
- **高度なネットワーキング設定**: VPC 内での細かいネットワーク設定や、特定のセキュリティグループを使ったアクセス管理が可能

Fargate では自動化されている部分を細かくカスタマイズしたい場合、
ECS を使う、という感じ。

[Getting Started with AWS Fargate (日本語) - Getting Started with AWS Fargate (Japanese) 日本語吹き替え版](https://explore.skillbuilder.aws/learn/courses/17170/getting-started-with-aws-fargate-ri-ben-yu/lessons/100244/getting-started-with-aws-fargate-japanese-ri-ben-yu-chuiki-tie-ban)
に、違いがこまかく書いてあるけど、意味がいまいちわからん。学習してから見直す

## 料金

[料金 - AWS Fargate | AWS](https://aws.amazon.com/jp/fargate/pricing/)

「1 時間あたりの GB 単位」はたぶんメモリ。

## チュートリアル

- まあこのへんから? [Introduction to AWS Fargate (日本語吹き替え版) - AWS Skill Builder](https://explore.skillbuilder.aws/learn/courses/1589/Introduction-to-AWS-Fargate-Japanese-%E6%97%A5%E6%9C%AC%E8%AA%9E%E5%90%B9%E3%81%8D%E6%9B%BF%E3%81%88%E7%89%88) なんか古い... まあいいか
- [Amazon ECS の AWS Fargate - Amazon Elastic Container Service](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-walkthrough)
- AWS のポータルから作る [Fargate 起動タイプ用の Amazon ECS Linux タスクを作成する方法について説明します。 - Amazon Elastic Container Service](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/getting-started-fargate.html)
- AWS CLI で作る [AWS CLI を使用して、Fargate 起動タイプ用の Amazon ECS Linux タスクを作成する - Amazon Elastic Container Service](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_AWSCLI_Fargate.html)

## CFn の場合

[AWS::ECS::Cluster の CapacityProviders](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-cluster.html#cfn-ecs-cluster-capacityproviders)
で`FARGATE` か `FARGATE_SPOT` を指定するらしい。

参考:

- [CloudFormation を使用して ECS Fargate を構築してみた | DevelopersIO](https://dev.classmethod.jp/articles/building-ecs-fargate-using-cloudformation/)

## 動かす手順

- VPC、サブネット、インターネットゲートウェイ、ルートテーブル、セキュリティグループを作成
- VPC エンドポイントを作成
  - ECR の VPC エンドポイント
  - S3 の VPC エンドポイント
  - CloudWatch Logs の VPC エンドポイント
  - SystemsManager の VPC エンドポイント
- ALB を作成
- Fargate で動かすコンテナイメージを作成
- コンテナイメージを ECR へ push
- ECR の作成

これが参考になる:
[CloudFormation を使用して ECS Fargate を構築してみた | DevelopersIO](https://dev.classmethod.jp/articles/building-ecs-fargate-using-cloudformation/)

## AWS ECS 用語

- **クラスター**: ECS クラスターは、コンテナを実行するための計算リソースのグループ(EC2 インスタンスや Fargate のようなサービス)です。
  クラスター自体はコンテナを含みませんが、コンテナが配置される場所です。
- **タスク**: タスクは、コンテナの実行単位です。1 つのタスクには、複数のコンテナが含まれる場合があります。
  各コンテナは、定義されたイメージと設定に基づいて実行されます。
- **サービス**: ECS サービスは、特定のタスク定義に基づいてタスクの実行を管理します。
  サービスを使用すると、タスクが常に所定の数だけ実行されるようにできます。サービス自体はコンテナを直接含まないですが、タスクを起動するために使用されます。
