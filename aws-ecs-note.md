# AWS ECS のメモ

## サービスにリンクされたロール(SLR)とは?

AWS の特定リージョンで初めて AWS ECS Cluster を作成するとき

- `aws iam create-service-linked-role --aws-service-name es.amazonaws.com`
- または CloudFormation で AWS::IAM::ServiceLinkedRole リソース

が必要な理由を以下のリンクを参考にして、解説してください。

- [class CfnServiceLinkedRole (construct) · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_iam.CfnServiceLinkedRole.html)
- [AWS::IAM::ServiceLinkedRole - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-iam-servicelinkedrole.html)
- [サービスにリンクされたロールの作成 - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_create-service-linked-role.html)

以下 ChatGPT の言うまま。内容は未確認だが、おおむね正しいのでは?

---

AWS ECS Cluster を特定のリージョンで初めて作成するときに、以下のように **サービスにリンクされたロール (Service-Linked Role, SLR)** を作成する必要がある理由を説明します。

### 1. サービスにリンクされたロール (SLR) とは?

サービスにリンクされたロールは、特定の AWS サービスがそのサービスのリソースを管理するために AWS IAM で自動的に作成される特別な IAM ロールです。これにより、AWS サービスが他の AWS リソースにアクセスできるようになります。

公式ドキュメントによると、[サービスにリンクされたロールの作成](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_create-service-linked-role.html) では、SLR の目的として以下が挙げられています:

- AWS サービスが他の AWS リソースに対してアクションを実行するのを許可する
- 明示的な権限管理を可能にする
- AWS によって自動管理される (ユーザーが手動で更新する必要がない)

### 2. ECS とサービスにリンクされたロール

AWS ECS では、ECS クラスタの管理やタスクのスケジューリングなどの操作を行うために、 **`AWSServiceRoleForECS` というサービスにリンクされたロール** が必要になります。

AWS ECS のサービスリンクロールは以下の操作を行うために必要です:

- ECS が **EC2 インスタンスまたは Fargate タスクの起動/管理** を行う
- ECS が **ELB や Auto Scaling** との統合を管理する
- ECS タスクやサービスの **ロギングやメトリクスの収集** を許可する

**最初に ECS クラスタを作成する際に、このロールがリージョンに存在しない場合は、自動で作成されるか、明示的に作成する必要があります。**

### 3. 手動で SLR を作成するケース

ECS を特定のリージョンで **初めて** 作成するとき、SLR (`AWSServiceRoleForECS`) がそのリージョンに存在しない場合があります。そのため、以下のような方法で事前に作成することができます:

#### 方法 1: AWS CLI で作成する

```sh
aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com
```

これにより、ECS のためのサービスリンクロール `AWSServiceRoleForECS` が作成されます。

#### 方法 2: AWS CloudFormation で作成する

CloudFormation を使う場合、[`AWS::IAM::ServiceLinkedRole`](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-iam-servicelinkedrole.html) を定義することで、SLR を明示的に作成できます。

例:

```yaml
Resources:
  ECSServiceLinkedRole:
    Type: AWS::IAM::ServiceLinkedRole
    Properties:
      AWSServiceName: ecs.amazonaws.com
      Description: 'Service-linked role for Amazon ECS'
```

この CloudFormation テンプレートをデプロイすることで、AWSServiceRoleForECS が作成されます。

#### 方法 3: AWS CDK で作成する

AWS CDK では [`CfnServiceLinkedRole`](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_iam.CfnServiceLinkedRole.html) クラスを使って SLR を作成できます。

TypeScript 版:

```typescript
import * as iam from 'aws-cdk-lib/aws-iam';
import * as cdk from 'aws-cdk-lib';

const app = new cdk.App();
const stack = new cdk.Stack(app, 'EcsServiceLinkedRoleStack');

new iam.CfnServiceLinkedRole(stack, 'ECSServiceLinkedRole', {
  awsServiceName: 'ecs.amazonaws.com',
  description: 'Service-linked role for Amazon ECS'
});
```

Python 版:

```python
import aws_cdk as cdk
from aws_cdk import aws_iam as iam

app = cdk.App()
stack = cdk.Stack(app, "EcsServiceLinkedRoleStack")

iam.CfnServiceLinkedRole(
    stack, "ECSServiceLinkedRole",
    aws_service_name="ecs.amazonaws.com",
    description="Service-linked role for Amazon ECS"
)

app.synth()
```

CDK を使うと、よりプログラム的にインフラを管理できます。

### 4. なぜ SLR が必要なのか?

ECS が EC2/Fargate でタスクをスケジューリングする際に、EC2 インスタンスやネットワーク関連のリソースにアクセスする必要があります。これを **明示的に許可する IAM ロール** が SLR です。

もし `AWSServiceRoleForECS` がリージョンにない状態で ECS クラスタを作成しようとすると、エラーが発生する可能性があります。そのため、 **ECS を初めて使うリージョンでは SLR の作成が必要** になります。

### 5. 関連する AWS サービス

ECS 以外にも、AWS の一部のサービスでは **特定のリージョンで初めて使用する際に SLR が必要** になります。例えば:

- Amazon Elastic File System (EFS)
- AWS Elastic Beanstalk
- AWS Organizations
- Amazon Elasticsearch Service (OpenSearch)

例えば、ECS のほかに **Amazon OpenSearch Service** を初めて使う場合は、以下のようなコマンドが必要になります:

```sh
aws iam create-service-linked-role --aws-service-name es.amazonaws.com
```

これは、ECS とは別に **OpenSearch (旧 Elasticsearch) のリソース管理を許可するため** に必要です。

### まとめ

- **ECS を特定のリージョンで初めて作成するとき、AWSServiceRoleForECS というサービスリンクロール (SLR) が必要**
- **SLR は AWS サービスが他の AWS リソースを操作できるようにする IAM ロール**
- **SLR がないと、ECS クラスタ作成時にエラーが発生する可能性がある**
- **CLI, CloudFormation, CDK のいずれかで SLR を作成できる**
- **他の AWS サービス (OpenSearch, EFS, Elastic Beanstalk など) でも、リージョンごとに SLR が必要になることがある**

以上の理由から、ECS クラスタ作成時に `aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com` や `AWS::IAM::ServiceLinkedRole` を使う必要があります。

---

## すでに AWSServiceRoleForECS が存在している場合

CFn でも CDK でもすでに AWSServiceRoleForECS が存在している場合
AWS::IAM::ServiceLinkedRole を使うと
エラーになる。

こんなエラー:

> Service role name AWSServiceRoleForECS has been taken in this account, please try a different suffix. (Service: Iam, Status Code: 400, Request ID: (略)

回避するためには CDK だったら `upsert-slr` がある。

- [upsert - npm search](https://www.npmjs.com/search?q=upsert)
- [upsert-slr · PyPI](https://pypi.org/project/upsert-slr/)
- [tmokmss/upsert-slr: Manage AWS service-linked roles in a better way.](https://github.com/tmokmss/upsert-slr)
- [CDK Tips: 自作コンストラクトを Python 向けに公開する - maybe daily dev notes](https://tmokmss.hatenablog.com/entry/publish_cdk_construct_to_pyhon_pypi)

カスタムリソース (Custom Resources)を使って SLR を作ったり作らなかったりする。[カスタムリソースを使用してカスタムプロビジョニングロジックを作成する - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/template-custom-resources.html)

カスタムリソースなので Lambda と IAM が増えるのが欠点。

Python の場合:

```python
# pip install upsert-slr
from upsert_slr import ServiceLinkedRole
#...
ServiceLinkedRole(
    self,
    "ECSServiceLinkedRole",
    aws_service_name="ecs.amazonaws.com",
    description="Service-linked role for Amazon ECS",
)
```

TypeScript の場合は上記の npmjs か GitHub にサンプルが載ってる。
