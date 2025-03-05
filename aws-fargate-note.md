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
- AWS のポータルから作る [Fargate 起動タイプ用の Amazon ECS Linux タスクを作成する方法について説明します。 - Amazon Elastic Container Service](https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/getting-started-fargate.html) - チュートリアルっぽいのに不親切。まあしょうがないけど。これこのままやると「動作確認」が無いのね。いまなら Amazon VPC AWS CloudShell で curl で確認できる。
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

### クラスター

ECS クラスターは、コンテナを実行するための計算リソースのグループ(EC2 インスタンスや Fargate のようなサービス)です。
クラスター自体はコンテナを含みませんが、コンテナが配置される場所です。

複数のサービスを配置することができる。

### タスク定義

タスク定義は、アプリケーションを構成するテンプレート(ブループリント)です。
JSON 形式で記述でき、以下のような情報を含みます:

- 使用する Docker イメージ(複数可)
- CPU やメモリの割り当て
- ネットワーク設定
- コンテナ間の通信方法
- 起動タイプ(Fargate や EC2 など)

タスク定義をもとにサービスが生成されます。

### サービス

ECS の「サービス」は、**特定のタスク定義に基づいてタスクを管理・運用する仕組み**です。
サービスは、アプリケーションの高可用性やスケーラビリティを実現するために設計されています。

サービスには「サービス」と「タスク」の 2 種類ある。

- サービスは、指定された数(デザイアドカウント:desired count)のタスクが常に実行されるように管理します。
- タスクが停止した場合、自動的に再起動して望ましい状態を維持します。
- サービスはロードバランサー(Elastic Load Balancer)と連携し、トラフィックを各タスクに分散できます。
- オートスケーリングを使用して、トラフィック量やリソース利用率に応じてタスク数を動的に調整できます。

### タスク

一方、「タスク」は、**タスク定義に基づいて起動されるコンテナ群(1 つ以上のコンテナ)の実行単位**です。

- タスクは、単発で起動することもできますし、サービスによって管理される形で起動することもあります。
- タスクにはライフサイクルがあり、終了条件(例:ジョブ完了)を満たすと停止します。
- サービスによって管理されない単発のタスクは、停止しても自動的に再起動されません。

「単発タスク」は standalone task または one-off task というらしい。

### サービス vs. 単発タスク

- **「サービス」** は「特定のタスク定義に基づいて複数のタスクを管理・維持する仕組み」であり、高可用性やスケーラビリティが必要なシステム向けです。
- **「単発タスク」** は「一時的なジョブやバッチ処理など、終了後に再起動が不要な処理」に適しています。

| 特徴                     | サービス                                          | 単発タスク                           |
| ------------------------ | ------------------------------------------------- | ------------------------------------ |
| 管理方法                 | 指定した数のタスクを常に実行・維持                | 手動で起動し、終了後は再起動されない |
| 主な用途                 | Web アプリケーションや API などの常時稼働システム | バッチ処理や一時的なジョブ           |
| 自動再起動               | 停止したタスクは自動的に再起動                    | 停止後は再起動されない               |
| オートスケーリング対応   | 対応可能                                          | 非対応                               |
| ロードバランサーとの連携 | 可能                                              | 不可能                               |

## docker-compose.yml から AWS ECS のタスク定義の元はつくれますか?

[aws/amazon-ecs-cli: The Amazon ECS CLI enables users to run their applications on ECS/Fargate using the Docker Compose file format, quickly provision resources, push/pull images in ECR, and monitor running applications on ECS/Fargate.](https://github.com/aws/amazon-ecs-cli)
で出来るらしい。

こんな感じ(未検証)

```sh
ecs-cli compose --project-name your-project-name \
-f docker-compose.yml \
--ecs-params ecs-params.yml \
create --region your-region \
--launch-type EC2
```

## 「単発タスク」の場合、REST API 等のリクエストがあってからコンテナが起動される?

そうじゃないらしい。

`aws ecs run-task` で検索

- [AWS CLI を使って Amazon ECS のタスクを手動で実行する - michimani.net](https://michimani.net/post/aws-run-ecs-task-using-aws-cli/)
- [Amazon ECS タスクを冪等に起動できるようになりました | DevelopersIO](https://dev.classmethod.jp/articles/idempotent-ecs-task-run/)

containerOverrides で CMD を置き換えもできるらしい。

boto3 だったらこんなノリらしい

```python
import boto3

ecs = boto3.client('ecs')

response = ecs.run_task(
    cluster='cluster-name',
    taskDefinition='task-definition-family',
    launchType='EC2',  # または 'FARGATE'
    overrides={
        'containerOverrides': [
            {
                'name': 'container_name',
                'command': ["command", "arg1", "arg2"],
            },
        ],
    },
)
```

- Lambda から
  - [lambda から ECS:RunTask を使用し、Task を起動する #AWS - Qiita](https://qiita.com/kosuke-ikeura/items/277bb91e8d68d92500b1)
- Step Functions から
  - [Step Functions から ECS Task を呼びだすときに、実行するシェルスクリプトを指定してみた #AWS - Qiita](https://qiita.com/sugimount-a/items/31d03c17cc2055502fca)
  - [Step Functions で ECS タスク(Fargate)を定期実行してみる | DevelopersIO](https://dev.classmethod.jp/articles/try-to-retry-ecs-tasks-using-step-functions/)
  - [StepFunctions で ECS タスクを起動し、コマンドを指定した場合の優先順位 - CloudBuilders](https://www.cloudbuilders.jp/articles/3849/)

「Lambda から ecs run task して、SQS に入れる」とかはありがちらしい。

「step functions で ecs run task して、SQS に入れる lambda を呼ぶ」もありがちらしい。

## ecs.run_task で one-off task を起動するとき、引数を与える方法は argv だけ?

RPC みたいなものは無くて、あとは

- 環境変数で渡す
- S3 または DynamoDB などで渡す
- SSM Parameter Store / Secrets Manager など

などの、まあ誰でも思いつくものしかなさそう。

## ecs.run_task で one-off task を起動するとき、結果はどうやって得る?

例えば stdout/stderr は取得できない(cloudwatch には出せる)。

タスクの終了コードは確認できる。
[describe_tasks - Boto3 1.37.2 documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ecs/client/describe_tasks.html)

## ロギング

タスク定義で logConfiguration を書けば cloudwatch にだせる。

サンプル(未検証):

```json
{
  "containerDefinitions": [
    {
      "name": "your-container-name",
      "image": "your-image-name",
      ...
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/your-log-group",
          "awslogs-region": "your-region",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

## copilot-cli が面白そう

[Overview - AWS Copilot CLI](https://aws.github.io/copilot-cli/ja/docs/overview/)

名前がよくないので検索が面倒。Groq と Grok みたい。

## IAM

1. タスク実行 IAM ロール(Task Execution Role)
2. タスク IAM ロール(Task Role)
3. クラスター IAM ロール

の 3 か所あるらしい。まあ細かいところは CFn で見ていくしか。

## ECS 単発タスクは動かさなければ無料?

はい。

金がかかりそう&見落としがちなのは

- ECR - $0.10/GB-月
- CloudWatch

## Fargate そのものはともかく、VPC 周りがめんどくさい

「サービスごとにエンドポイントを作成する必要がある」のがめんどくさい。

お題:

> AWS VPC のプライベート subnet で ECR 上のコンテナを fargate で動かし、
> このコンテナ自体は s3 バケットに出力と CloudWatch にログを出す、
> のだとしたら、GW と PrivateLink は何が必要?

### 必要な Gateway や PrivateLink (VPC エンドポイント)

NAT Gateway を使えば...
価格はものすごく上がるけど(時間単位で課金される)...

| サービス            | 必要なエンドポイントの種類                                      | 備考                                             |
| ------------------- | --------------------------------------------------------------- | ------------------------------------------------ |
| **ECR API**         | Interface VPC エンドポイント (`com.amazonaws.<region>.ecr.api`) | ECR の API コール用 (イメージのプルには関係ない) |
| **ECR DKR**         | Interface VPC エンドポイント (`com.amazonaws.<region>.ecr.dkr`) | イメージのプルに必要                             |
| **S3**              | Gateway VPC エンドポイント (`com.amazonaws.<region>.s3`)        | S3 へのアクセス用                                |
| **CloudWatch Logs** | Interface VPC エンドポイント (`com.amazonaws.<region>.logs`)    | CloudWatch Logs へのログ送信                     |

プライベート DNS へ、これの正引きと逆引きが登録される。

#### その他のオプション

- **ECS Agent / ECS Telemetry** (ECS を Fargate で動かす場合)
  - `com.amazonaws.<region>.ecs`
  - `com.amazonaws.<region>.ecs-telemetry`
  - `com.amazonaws.<region>.ec2` (ECS タスクが IAM 認証を使う場合)

## VPC エンドポイント

まず「インターフェイスエンドポイント」と「ゲートウェイエンドポイント」の 2 種類がある。

- **インターフェイスエンドポイント**: AWS PrivateLink を利用して、VPC 内の ENI(Elastic Network Interface)を通じて AWS サービスや独自サービスにプライベート接続します。多くの AWS サービスに対応しています
- **ゲートウェイエンドポイント**: VPC のルートテーブルを変更して、S3 や DynamoDB などのサービスにゲートウェイ経由でアクセスします。対応サービスは S3 と DynamoDB のみです
