# AWS CDK (Cloud Development Kit)

- [インストール](#インストール)
- [チュートリアル](#チュートリアル)
- [AWS CDK Workshop](#aws-cdk-workshop)
- [AWS CloudShell](#aws-cloudshell)
- [cdk でリージョンを変えるには?](#cdk-でリージョンを変えるには)
- [AWS CDK で環境変数で環境を選択するには](#aws-cdk-で環境変数で環境を選択するには)
- [AWS CDK には AWS SAM のように lambda を zip にしたりモジュール入れたりするサポートはある?](#aws-cdk-には-aws-sam-のように-lambda-を-zip-にしたりモジュール入れたりするサポートはある)
- [AWS CDK でリソースの物理 ID を固定する](#aws-cdk-でリソースの物理-id-を固定する)
- [dependsOn を明示する](#dependson-を明示する)
- [cdk.CfnOutput() と cdk.Fn.importValue()](#cdkcfnoutput-と-cdkfnimportvalue)
- [`cdk init` で パッケージマネージャの指定と、`git init`を止めさせたい](#cdk-init-で-パッケージマネージャの指定とgit-initを止めさせたい)
- [lambda.Function のかわりに NodejsFunction を使う](#lambdafunction-のかわりに-nodejsfunction-を使う)
- [AWS CDK と CloudFormation の Pros \& Cons](#aws-cdk-と-cloudformation-の-pros--cons)
- [CDK で物理 ID が指定できるリソース](#cdk-で物理-id-が指定できるリソース)
- [Construct](#construct)
- [AWS CDK プロジェクトの構成](#aws-cdk-プロジェクトの構成)
  - [`bin/` ディレクトリ](#bin-ディレクトリ)
  - [`lib/` ディレクトリ](#lib-ディレクトリ)
  - [その他のファイル](#その他のファイル)
  - [CDK のディレクトリ構造参考リンク](#cdk-のディレクトリ構造参考リンク)
- [何でコンストラクタでリソースをつくるの?](#何でコンストラクタでリソースをつくるの)
- [AWS CDK のテストはどう書く?](#aws-cdk-のテストはどう書く)
- [AwsCustomResource で 別リージョンの SSM パラメータを取得する](#awscustomresource-で-別リージョンの-ssm-パラメータを取得する)
  - [**1. 他のリージョンのスタック出力を取得する**](#1-他のリージョンのスタック出力を取得する)
  - [**2. コード例**](#2-コード例)
  - [**3. 詳細な説明**](#3-詳細な説明)
  - [**4. 注意点**](#4-注意点)
  - [**5. Lambda を使用したカスタムリソースの代替案**](#5-lambda-を使用したカスタムリソースの代替案)
  - [**6. この方法の利点と欠点**](#6-この方法の利点と欠点)
  - [**7. まとめ**](#7-まとめ)
  - [**複数の SSM パラメータを一度に取得する方法**](#複数の-ssm-パラメータを一度に取得する方法)
    - [**1. `getParameters` API を使用する**](#1-getparameters-api-を使用する)
    - [**2. `AwsCustomResource`の設定**](#2-awscustomresourceの設定)
  - [**コード例**](#コード例)
  - [**詳細な説明**](#詳細な説明)
  - [**注意事項**](#注意事項)
  - [**修正したコード例**](#修正したコード例)
  - [**まとめ**](#まとめ)
  - [**`parameters`変数のサンプル**](#parameters変数のサンプル)
    - [**説明**](#説明)
  - [**CDK 内での`parameters`の扱い方**](#cdk-内でのparametersの扱い方)
  - [**個々のパラメータ値の取得方法**](#個々のパラメータ値の取得方法)
    - [**コード例**](#コード例-1)
  - [**JMESPath 式を使用したパラメータ値の取得**](#jmespath-式を使用したパラメータ値の取得)
    - [**修正したコード例**](#修正したコード例-1)
    - [**説明**](#説明-1)
  - [**完全なコード例**](#完全なコード例)
  - [**ポイント**](#ポイント)
  - [**`parameters`変数の実際の値に基づく具体例**](#parameters変数の実際の値に基づく具体例)
    - [**CDK での取得結果**](#cdk-での取得結果)
  - [**エラーハンドリング**](#エラーハンドリング)
    - [**例**](#例)
  - [**まとめ**](#まとめ-1)
  - [**AwsCustomResource はクロスアカウントで使用可能か?**](#awscustomresource-はクロスアカウントで使用可能か)
  - [**1. クロスアカウントアクセスの概要**](#1-クロスアカウントアクセスの概要)
  - [**2. クロスアカウントでの AwsCustomResource の設定方法**](#2-クロスアカウントでの-awscustomresource-の設定方法)
    - [**ステップ 1: IAM ロールの設定**](#ステップ-1-iam-ロールの設定)
    - [**ステップ 2: アクセス先アカウントでのリソースポリシーの設定**](#ステップ-2-アクセス先アカウントでのリソースポリシーの設定)
    - [**ステップ 3: AwsCustomResource の IAM ポリシーの調整**](#ステップ-3-awscustomresource-の-iam-ポリシーの調整)
  - [**3. コード例**](#3-コード例)
    - [**StackB での設定(アクセス元のスタック)**](#stackb-での設定アクセス元のスタック)
    - [**アクセス先アカウントでの設定(StackA 側)**](#アクセス先アカウントでの設定stacka-側)
  - [**4. アクセス先アカウントでのリソースポリシーの設定方法**](#4-アクセス先アカウントでのリソースポリシーの設定方法)
    - [**ステップ 1: アクセス先アカウントで IAM ロールを作成**](#ステップ-1-アクセス先アカウントで-iam-ロールを作成)
    - [**ステップ 2: 必要なポリシーをアタッチ**](#ステップ-2-必要なポリシーをアタッチ)
    - [**ステップ 3: アクセス元の IAM ロールから AssumeRole する**](#ステップ-3-アクセス元の-iam-ロールから-assumerole-する)
  - [**5. 注意事項**](#5-注意事項)
  - [**6. 代替案**](#6-代替案)
    - [**方法 1: AWS Secrets Manager の使用**](#方法-1-aws-secrets-manager-の使用)
    - [**方法 2: S3 バケットや DynamoDB を介した共有**](#方法-2-s3-バケットや-dynamodb-を介した共有)
    - [**方法 3: AWS Resource Access Manager (RAM) の使用**](#方法-3-aws-resource-access-manager-ram-の使用)
  - [**7. まとめ**](#7-まとめ-1)
  - [**ご質問やサポートが必要な場合**](#ご質問やサポートが必要な場合)
  - [**S3 バケットや DynamoDB テーブルを介した場合、onUpdate()は使えますか?**](#s3-バケットや-dynamodb-テーブルを介した場合onupdateは使えますか)
  - [**1. AwsCustomResource の onUpdate()で S3 や DynamoDB を操作する方法**](#1-awscustomresource-の-onupdateで-s3-や-dynamodb-を操作する方法)
  - [**2. クロスアカウント/クロスリージョンアクセスの設定**](#2-クロスアカウントクロスリージョンアクセスの設定)
    - [**ステップ 1: アクセス先リソースのポリシー設定**](#ステップ-1-アクセス先リソースのポリシー設定)
    - [**ステップ 2: AwsCustomResource の IAM ポリシー設定**](#ステップ-2-awscustomresource-の-iam-ポリシー設定)
  - [**3. コード例**](#3-コード例-1)
    - [**例 1: S3 バケットからデータを取得**](#例-1-s3-バケットからデータを取得)
    - [**例 2: DynamoDB テーブルからデータを取得**](#例-2-dynamodb-テーブルからデータを取得)
  - [**4. 注意事項**](#4-注意事項)
    - [**1. アクセス先リソースのポリシー設定**](#1-アクセス先リソースのポリシー設定)
    - [**2. IAM ロールの設定**](#2-iam-ロールの設定)
    - [**3. セキュリティの考慮**](#3-セキュリティの考慮)
    - [**4. デプロイの順序**](#4-デプロイの順序)
  - [**5. `onUpdate()`の使用に関するポイント**](#5-onupdateの使用に関するポイント)
  - [**6. 代替案の検討**](#6-代替案の検討)
    - [**方法 1: Lambda 関数を使用したカスタムリソース**](#方法-1-lambda-関数を使用したカスタムリソース)
    - [**方法 2: 外部パイプラインやスクリプトを使用**](#方法-2-外部パイプラインやスクリプトを使用)
  - [**7. まとめ**](#7-まとめ-2)
  - [**ご提案**](#ご提案)

## インストール

v1 と v2 でけっこう違うらしい。

```bash
npm install -g aws-cdk
cdk bootstrap aws://123456789012/ap-northeast-1
# ↑リージョンにcdk用のS3バケットやIAMを作る。多分各リージョンで1回は実行する必要がある。
# これ実行後cloudformationでCDKToolkitを参照
```

## チュートリアル

[Your first AWS CDK app - AWS Cloud Development Kit (AWS CDK) v2](https://docs.aws.amazon.com/cdk/v2/guide/hello_world.html)

## AWS CDK Workshop

オリジナル: [AWS CDK Intro Workshop :: AWS Cloud Development Kit (AWS CDK) Workshop](https://cdkworkshop.com/)
日本語もあります。

## AWS CloudShell

AWS CloudShell (2021-11-08)

```console
$ aws --version
aws-cli/2.2.15 Python/3.8.8 Linux/4.14.243-185.433.amzn2.x86_64 exec-env/CloudShell exe/x86_64.amzn.2 prompt/off

$ sam --version
SAM CLI, version 1.23.0

$ cdk --version
bash: cdk: command not found

$ node -v
v14.16.1

$ sudo npm install -g aws-cdk
$ cdk --version
1.131.0 (build 7560c79)
```

最初からは入ってなかった。

## cdk でリージョンを変えるには?

(この章、嘘。あとで修正)

環境変数しかないらしい。

```sh
export AWS_DEFAULT_REGION="us-west-2"
```

事前に `cdk bootstrap aws://123456789012/us-west-2` 的のは必要。

## AWS CDK で環境変数で環境を選択するには

基本 `~/.aws/credentials` 経由でしか環境の選択ができないみたい。

特に CDK で出来ないのが環境変数

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION

を指定しての環境設定。AWS CLI だとこれで動くんだけど。

確認は `cdk doctor` コマンドで。これで `No CDK environment variables` が出るなら動きません。

実は上の 3 つのほかに

- CDK_DEFAULT_ACCOUNT

に AWS アカウントの番号が必要。

つまり

```bash
export AWS_ACCESS_KEY_ID=AKxxxxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-west-1
export CDK_DEFAULT_ACCOUNT=99999999999
cdk doctor # 確認
cdk bootstrap # もし最初なら(複数回やっても問題なさそう)
```

のようにやる。ここまではコードの追加なしにできるし、
`~/.aws/credentials`を設定しなくてもいける。

複数アカウントだと、内部で上記の環境変数を書き換えるコードを追加するか、すなおに`~/.aws/credentials`に書くかどちらか。

## AWS CDK には AWS SAM のように lambda を zip にしたりモジュール入れたりするサポートはある?

[lambda.Code.fromAsset()](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda.Code.html#static-fromwbrassetpath-options)
を使う。

で, たとえば `./lib/foo-stack.ts` で

```typescript
const myFunction = new lambda.Function(this, 'HelloWorldFunction', {
  runtime: lambda.Runtime.NODEJS_20_X,
  handler: 'app.lambdaHandler',
  code: lambda.Code.fromAsset(path.join(__dirname, '..', 'lambda', 'hello'), {
    exclude: ['*.log', 'tests/**/*']
  })
});
```

のように使う。(Lambda の中身は `./lambda/hello` にある想定)

**ただし** AWS SAM みたいに package.json や requirements.txt を自動で処理してくれないので
`npm ci` とか `pip install -r requirements.txt --target .` を自前でやる必要はある。

## AWS CDK でリソースの物理 ID を固定する

できるんだけど、リソースの種類によって設定方法が異なるのでつらい。

```javascript
// S3のバケット名を固定
const bucket = new s3.Bucket(this, 'MyBucket', {
  bucketName: 'my-fixed-bucket-name'
});

// テーブル名を固定
const table = new dynamodb.Table(this, 'MyTable', {
  tableName: 'my-fixed-table-name',
  partitionKey: { name: 'id', type: dynamodb.AttributeType.STRING }
});

// Lambda関数名を固定
const lambdaFunction = new lambda.Function(this, 'MyFunction', {
  functionName: 'my-fixed-function-name',
  runtime: lambda.Runtime.NODEJS_20_X,
  handler: 'index.handler',
  code: lambda.Code.fromAsset('lambda')
});

// IAM Roleの名前を固定
const myRole = new iam.Role(this, 'MyFixedRole', {
  roleName: 'my-fixed-role-name',
  assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com')
});

// IAM Policyの名前を固定
const myPolicy = new iam.ManagedPolicy(this, 'MyFixedPolicy', {
  managedPolicyName: 'my-fixed-policy-name', // 固定名
  statements: [
    new iam.PolicyStatement({
      actions: ['s3:ListBucket'],
      resources: ['arn:aws:s3:::my-bucket']
    })
  ]
});
```

どうしてもダメなら
`cdk.CfnResource()`
という必殺技もある。

```javascript
const resource = new cdk.CfnResource(this, 'MyResource', {
  type: 'AWS::S3::Bucket',
  properties: {
    BucketName: 'my-custom-bucket-name'
  }
});
```

CloudFormation と同じに書ける。当然型サポートはない。

メモ: もう 1 階層上の CfnBucket() みたいのもある。

## dependsOn を明示する

ほぼ不要なんだけど要る時は要る。リソースの場合は:

```javascript
// myFunctionがmyBucketに依存することを明示
myFunction.node.addDependency(myBucket);
```

みたいに書く(myFunction はたぶん Role で S3 への put を許可してるとかなんとか)。

stack 間の依存はまた今度。

## cdk.CfnOutput() と cdk.Fn.importValue()

クロススタック参照は

- クロスリージョンでは使えない
- マルチアカウントでは使えない

ことに注意

クロスリージョン(よくあるシナリオは「REST API を作って、それの証明書をつくる」)
では SSM パラメータストアを使うのが推奨らしい。
マルチアカウントでも同様にがんばればできる。

でも正直そこまで来たら CDKTF を使った方がいいと思う。
CDKTF だと state がアカウントやリージョンと無関係なので。

## `cdk init` で パッケージマネージャの指定と、`git init`を止めさせたい

[cdk init - AWS Cloud Development Kit (AWS CDK) v2](https://docs.aws.amazon.com/cdk/v2/guide/ref-cli-cmd-init.html)

```sh
mkdir learn-cdk1 && cd !$  # フォルダ名わりと重要。パッケージ名に使われる。
cdk init app -l typescript --generate-only
bun i  # ここは好きなパッケージマネージャを使う
git init
git add --all
git commit -am 'initial commit'
```

## lambda.Function のかわりに NodejsFunction を使う

- [class Function (construct) · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda.Function.html) - ZIP や Image は、これでしか扱えない
- aws-cdk-lib なので安定板
  - [class NodejsFunction (construct) · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.aws_lambda_nodejs.NodejsFunction.html)
- @aws-cdk/なので、古いまたはアルファ版
  - [class PythonFunction (construct) · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/@aws-cdk_aws-lambda-python-alpha.PythonFunction.html)
  - [class GoFunction (construct) · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/@aws-cdk_aws-lambda-go-alpha.GoFunction.html)

NodejsFunction を使うと、モジュールの管理や TypeScript のトランスパイルなんかを esbuild がやってくれるので、すごい楽。

ただし esbuild がインストールされてないと、Docker でやろうとしてイメージをビルドしはじめるので、先に`npm add esbuild -D` しておくといい。

esbuild オプションも渡せるので「バンドルせずに layer にするモジュール」も指定できるし、mjs も cjs も出せる。minify も。

## AWS CDK と CloudFormation の Pros & Cons

利点:

- **抽象化されたリソース定義**: 高レベルの抽象化により、複雑な CloudFormation テンプレートを簡潔なコードで記述可能。
- **プログラミングの柔軟性**: TypeScript や Python などの言語でロジックを組み込め、動的なリソース作成が可能。
- **モジュール性と再利用性**: スタックやコンストラクトを分離してモジュール化し、再利用性を高められる。
- **簡単なデプロイ**: `cdk deploy`コマンドで、コードからリソース作成や更新を簡単に実行。
- **変更のプレビュー**: `cdk diff`コマンドで、リソース変更の差分を視覚的に確認できる。
- **コミュニティサポート**: AWS 公式ライブラリやサードパーティ製の便利な Construct が豊富。

欠点:

- **学習コスト**: CDK 独自の API や設計思想を理解する必要があり、初心者にはハードルが高い。
- **抽象化の制限**: 高レベル抽象が原因で、細かい設定が必要な場合に CloudFormation を直接操作する必要がある。
- **依存関係の管理**: CDK ライブラリの更新に伴う破壊的変更や依存関係の複雑化が発生する場合がある。
- **デバッグの難しさ**: CloudFormation エラーが発生した際、エラーの原因が CDK コードから追いづらい。
- **生成テンプレートのサイズ**: CDK が生成する CloudFormation テンプレートが冗長になることがある。
- **対応の遅れ**: 新しい AWS サービスや機能が CDK に対応するまでにタイムラグがある場合がある。
- **デプロイの遅延**: 大規模なスタックではデプロイに時間がかかることがある。

以下中学生版

AWS CDK のいいところ:

- **シンプルに書ける**: むずかしい設定も、プログラムを書くみたいに簡単に書ける。
- **自由に操作できる**: プログラムで条件をつけたり、自動でリソースを作ったりできる。
- **使い回せる**: 作ったものをいろいろなプロジェクトで使えるようにできる。
- **簡単に公開できる**: コマンド 1 つで作ったリソースを AWS に送れる。
- **変更が分かりやすい**: 「どこが変わったか」を確認できる機能がある。
- **たくさんの便利な部品**: AWS 公式や他の人が作った便利なツールがたくさん使える。

AWS CDK のよくないところ:

- **覚えるのが大変**: 使い方を理解するまでに時間がかかる。
- **細かい設定が難しい**: 難しいカスタマイズをする時は、別の方法を使わないといけないことがある。
- **更新が面倒なことも**: 新しい機能が増えると、CDK の設定を直さないといけない場合がある。
- **エラーが分かりにくい**: プログラムを動かした時に起きた問題の原因が探しにくい。
- **作るものが増える**: 作ったファイルが大きくて見づらくなることがある。
- **新機能への対応が遅れる**: AWS の新しいサービスが CDK で使えるようになるまで時間がかかることがある。
- **時間がかかることも**: 大きなプロジェクトだと、AWS に送るのに時間がかかることがある。

## CDK で物理 ID が指定できるリソース

そもそも AWS CDK では物理名を設定することは非推奨だけれども、プロパティによって指定できるものプロパティもある。

| リソース名                            | プロパティ             | 説明                           |
| ------------------------------------- | ---------------------- | ------------------------------ |
| **S3 バケット**                       | `bucketName`           | バケット名を指定               |
| **DynamoDB テーブル**                 | `tableName`            | テーブル名を指定               |
| **EFS ファイルシステム**              | `fileSystemName`       | ファイルシステム名を指定       |
| **VPC**                               | `vpcName`              | VPC の名前を指定               |
| **サブネット**                        | `subnetName`           | サブネットの名前を指定         |
| **セキュリティグループ**              | `securityGroupName`    | セキュリティグループ名を指定   |
| **Elastic Load Balancer (ALB/NLB)**   | `loadBalancerName`     | ロードバランサー名を指定       |
| **EC2 インスタンス**                  | `instanceName`         | インスタンス名を指定           |
| **ECS クラスター**                    | `clusterName`          | クラスター名を指定             |
| **Lambda 関数**                       | `functionName`         | 関数名を指定                   |
| **RDS インスタンス**                  | `dbInstanceIdentifier` | インスタンス ID を指定         |
| **Aurora クラスター**                 | `clusterIdentifier`    | クラスター ID を指定           |
| **ElastiCache クラスター**            | `clusterName`          | クラスター名を指定             |
| **Neptune クラスター**                | `dbClusterIdentifier`  | クラスター ID を指定           |
| **SNS トピック**                      | `topicName`            | トピック名を指定               |
| **SQS キュー**                        | `queueName`            | キュー名を指定                 |
| **CloudFront ディストリビューション** | `distributionName`     | ディストリビューション名を指定 |
| **IAM ロール**                        | `roleName`             | ロール名を指定                 |
| **IAM ユーザー**                      | `userName`             | ユーザー名を指定               |
| **IAM グループ**                      | `groupName`            | グループ名を指定               |
| **IAM ポリシー**                      | `policyName`           | ポリシー名を指定               |
| **CloudWatch アラーム**               | `alarmName`            | アラーム名を指定               |
| **CloudWatch ダッシュボード**         | `dashboardName`        | ダッシュボード名を指定         |
| **Logs グループ**                     | `logGroupName`         | ロググループ名を指定           |

※ この表は一部。

一方 CDK で絶対に物理名を固定できないリソースは

| リソース名                                    | 説明                                                                                |
| --------------------------------------------- | ----------------------------------------------------------------------------------- |
| **VPC ピアリング**                            | VPC ピアリングの ID は自動生成されるため、ユーザーが指定できません。                |
| **IAM ロールポリシーアタッチメント**          | ロールポリシーアタッチメントは ID が自動生成されます。                              |
| **Auto Scaling グループ**                     | Auto Scaling グループの ID は自動生成され、名前を固定できません。                   |
| **Elastic IP**                                | Elastic IP は自動的に割り当てられる IP アドレスで、物理 ID は手動で指定できません。 |
| **Route 53 レコードセット**                   | レコードセットの名前や ID は自動生成されます。                                      |
| **CloudFormation スタック**                   | スタックの ID は自動生成され、ユーザーが直接指定することはできません。              |
| **Amazon Kinesis ストリーム**                 | ストリーム名は指定できますが、ストリーム ID は自動生成されます。                    |
| **SQS キュー(FIFO)**                          | FIFO キューは名前を指定できますが、物理 ID(内部的なキュー ID)は自動生成されます。   |
| **CloudWatch イベントルール**                 | ルールの ID は CloudFormation が自動生成します。                                    |
| **API Gateway リソース**                      | リソース ID は自動生成されます。                                                    |
| **SNS サブスクリプション**                    | サブスクリプションの ID は自動生成され、手動で指定できません。                      |
| **DynamoDB グローバルセカンダリインデックス** | インデックス ID は自動的に生成されます。                                            |
| **CloudWatch メトリクス**                     | メトリクス名は指定できますが、メトリクスの内部 ID は自動生成されます。              |
| **Lambda レイヤー**                           | レイヤーの ID は自動生成されます。                                                  |
| **Elastic Beanstalk 環境**                    | 環境 ID は自動生成されます。                                                        |

## Construct

`import type { Construct } from "constructs";` の Construct。
汎用っぽい名前だけど、AWS CDK 専用。"aws-cdk-lib/constructs" にするべきだったのでは?

[constructs - npm](https://www.npmjs.com/package/constructs)

## AWS CDK プロジェクトの構成

明確な規定はない。
bin/と lib/じゃなくて、entry/と stack/にすればよかったのに。

で、以下は慣習的なルール。

### `bin/` ディレクトリ

- **役割**: CDK アプリケーションのエントリポイントとなるスクリプトを配置します。「エントリーポイント」(entry point)と呼ぶ(非公式名称)。  
  ここにあるスクリプトは、CDK アプリを初期化し、スタックをインスタンス化してデプロイ環境を定義します。
- **内容**: 通常、プロジェクト名やアプリ名に基づくファイル名の TypeScript/JavaScript スクリプトが含まれます。`cdk deploy` コマンドで実行されるスクリプトです。

### `lib/` ディレクトリ

- **役割**: スタックの定義を行うコードを配置します。「スタック定義ファイル」(stack definition file)と呼ぶ(非公式名称)。 各スタックは、関連する AWS リソースをグループ化したものとして扱われます。
- **内容**: TypeScript または JavaScript で記述されたクラスファイルが格納されます。複数のスタックを作成する場合は、`lib/` 以下に複数のファイルを配置することが一般的です。

### その他のファイル

- **`cdk.json`**: CDK アプリの設定ファイルで、エントリポイントスクリプトやデフォルトの設定を記述。
- **`cdk.context.json`**: デプロイ時に使用されるコンテキスト値を保存。
- **`node_modules/`**: 必要な依存パッケージがインストールされる Node.js 標準のディレクトリ。

### CDK のディレクトリ構造参考リンク

- [大規模プロジェクトのコード編成 - AWS 規範ガイダンス](https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/best-practices-cdk-typescript-iac/organizing-code-best-practices.html)
- [Understanding AWS-CDK Directory Structure](https://www.turbogeek.co.uk/cdk-files/)

## 何でコンストラクタでリソースをつくるの?

CDK のスタックやコンストラクトは、「インフラの状態」を明示的に構築する設計思想に基づいています。リソースはコンストラクタ内で定義されることで、構成要素がスタックの初期化時に完全に定義されます。

リソースは「ステート」だからそうなるわな。

クラスメソッドをサポートスクリプト(同じパターンのリソースを何度も作るなど)として
使うのはベストプラクティスに従っている。

[AWS CDK ベストプラクティス - AWS 規範ガイダンス](https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/best-practices-cdk-typescript-iac/best-practices.html)

## AWS CDK のテストはどう書く?

[テスト駆動型の開発アプローチを採用 - AWS 規範ガイダンス](https://docs.aws.amazon.com/ja_jp/prescriptive-guidance/latest/best-practices-cdk-typescript-iac/development-best-practices.html)

## AwsCustomResource で 別リージョンの SSM パラメータを取得する

マルチリージョンのスタックだと、スタック間のパラメータ渡しが異常に面倒で、
SSM パラメータも、CfnOutput も、異なるリージョンの間では無理。

通常は外部から共通の名前を渡す、などで対処するのだけど、
どうしても動的に生成される値を使いたい場合は、
CDK には AwsCustomResource というのがある。

[aws-cdk-lib.custom_resources module · AWS CDK](https://docs.aws.amazon.com/cdk/api/v2/docs/aws-cdk-lib.custom_resources-readme.html#custom-resources-for-aws-apis)

**以下 ChatGPT o1-preview に作ってもらったコード(おおむね動く)を
メモとして残しておきます。**

---

AWS CDKv2 で別リージョンにスタックをデプロイしてパラメータをリージョン間で受け渡す方法を教えて。重要:v2 です。v1 ではありません。

---

AWS CDK v2 で異なるリージョンにスタックをデプロイし、リージョン間でパラメータを受け渡す方法をご紹介します。

---

**1. スタックのデプロイ先リージョンを指定する**

各スタックのデプロイ先リージョンは、`StackProps`の`env`プロパティで指定します。

```typescript
import * as cdk from 'aws-cdk-lib';

const app = new cdk.App();

// リージョン us-east-1 にデプロイするスタック
new StackA(app, 'StackA', { env: { region: 'us-east-1' } });

// リージョン us-west-2 にデプロイするスタック
new StackB(app, 'StackB', { env: { region: 'us-west-2' } });

app.synth();
```

---

**2. パラメータの受け渡し方法**

異なるリージョン間でパラメータを受け渡すためには、AWS Systems Manager Parameter Store(以下、SSM Parameter Store)を使用します。`StackA`でパラメータを作成し、`StackB`でそのパラメータを取得します。

---

**3. StackA でパラメータを作成する**

```typescript
import * as cdk from 'aws-cdk-lib';
import { StringParameter } from 'aws-cdk-lib/aws-ssm';

export class StackA extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // パラメータをSSM Parameter Storeに保存
    new StringParameter(this, 'MyParameter', {
      parameterName: '/myapp/shared-parameter',
      stringValue: '共有する値'
    });
  }
}
```

---

**4. StackB でパラメータを取得する**

`AwsCustomResource`を使用して、別リージョンのパラメータを取得します。

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // AwsCustomResourceを使用してパラメータを取得
    const getParameter = new AwsCustomResource(this, 'GetParameter', {
      onUpdate: {
        service: 'SSM',
        action: 'getParameter',
        parameters: {
          Name: '/myapp/shared-parameter'
        },
        region: 'us-east-1', // パラメータが存在するリージョン
        physicalResourceId: PhysicalResourceId.of('GetParameter') // 常に最新の値を取得
      },
      policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE })
    });

    // パラメータの値を取得
    const parameterValue = getParameter.getResponseField('Parameter.Value');

    // 取得したパラメータを使用してリソースを作成
    new cdk.CfnOutput(this, 'ParameterValueOutput', {
      value: parameterValue
    });
  }
}
```

---

**5. 注意事項**

- **権限の設定**: `AwsCustomResource`を使用するためには、適切な IAM ポリシーが必要です。上記の例では、`AwsCustomResourcePolicy.fromSdkCalls`を使用して自動的に必要な権限を付与しています。
- **リージョンの指定**: `AwsCustomResource`内で`region`を指定することで、別リージョンのリソースにアクセスできます。
- **物理 ID の設定**: `physicalResourceId`を適切に設定することで、リソースの変更を検知し、最新の値を取得できます。

---

**6. まとめ**

AWS CDK v2 では、`AwsCustomResource`を活用することで、デプロイ時に別リージョンの SSM パラメータを取得し、スタック内で使用することが可能です。この方法を用いて、リージョン間でパラメータを受け渡すことができます。

---

以上が、AWS CDK v2 で異なるリージョンにスタックをデプロイし、パラメータをリージョン間で受け渡す方法です。ご参考になれば幸いです。

---

AwsCustomResource を使って他スタックの CfnOutput を取得できませんか?

---

確かに、`AwsCustomResource`を使用して他のスタックの`CfnOutput`を取得することも可能です。これにより、CloudFormation のスタック出力を直接取得できます。以下にその方法をご説明します。

---

### **1. 他のリージョンのスタック出力を取得する**

`AwsCustomResource`を使用して、CloudFormation の`DescribeStacks` API を呼び出し、特定のスタックの出力を取得します。

---

### **2. コード例**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 他のスタックの名前
    const stackName = 'StackA';

    // AwsCustomResourceを使用してスタック出力を取得
    const getStackOutput = new AwsCustomResource(this, 'GetStackOutput', {
      onUpdate: {
        service: 'CloudFormation',
        action: 'describeStacks',
        parameters: {
          StackName: stackName
        },
        region: 'us-east-1', // StackAがデプロイされているリージョン
        physicalResourceId: PhysicalResourceId.of(Date.now().toString()) // 毎回新しい値を取得
      },
      policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE })
    });

    // スタック出力から特定のキーの値を取得
    const outputKey = 'MyOutputKey';
    const outputs = getStackOutput.getResponseField('Stacks.0.Outputs');

    // Outputs配列から特定のOutputKeyを持つOutputValueを取得
    const outputValue = cdk.Token.asString(outputs.find((output: any) => output.OutputKey === outputKey).OutputValue);

    // 取得した値を使用
    new cdk.CfnOutput(this, 'RetrievedOutput', {
      value: outputValue
    });
  }
}
```

---

### **3. 詳細な説明**

- **スタック名の指定**: `StackName`には、取得したいスタックの正確な名前を指定します。
- **リージョンの指定**: `region`プロパティで、`StackA`が存在するリージョンを指定します。
- **IAM ポリシー**: `AwsCustomResourcePolicy.fromSdkCalls`を使用して、自動的に必要な権限を付与しています。
- **物理 ID の設定**: `physicalResourceId`をユニークな値に設定し、リソースの更新をトリガーします。
- **Output の取得**: `getResponseField`を使用して、スタックの出力情報を取得します。

---

### **4. 注意点**

1. **デプロイ順序**: `StackA`が`StackB`より先にデプロイされている必要があります。
2. **権限の設定**: `StackB`が`StackA`の出力を取得するため、適切な権限が必要です。
3. **エラーハンドリング**: スタックや出力キーが存在しない場合のエラー処理を考慮する必要があります。
4. **パフォーマンスと依存関係**: この方法では、デプロイ時に API コールが発生し、デプロイ時間が増加する可能性があります。

---

### **5. Lambda を使用したカスタムリソースの代替案**

より高度な処理やエラーハンドリングが必要な場合、Lambda 関数を使用したカスタムリソースを作成することも検討できます。

```typescript
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { CustomResource, CustomResourceProvider } from 'aws-cdk-lib';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Lambda関数を作成
    const provider = new lambda.Function(this, 'CustomResourceProvider', {
      code: lambda.Code.fromInline(`
        import json
        import boto3

        def handler(event, context):
          cf = boto3.client('cloudformation', region_name='us-east-1')
          stack_name = 'StackA'
          output_key = 'MyOutputKey'
          response = cf.describe_stacks(StackName=stack_name)
          outputs = response['Stacks'][0]['Outputs']
          output_value = next((o['OutputValue'] for o in outputs if o['OutputKey'] == output_key), None)
          return {'Data': {'OutputValue': output_value}}
      `),
      handler: 'index.handler',
      runtime: lambda.Runtime.PYTHON_3_9
    });

    // カスタムリソースを作成
    const customResource = new CustomResource(this, 'GetStackOutput', {
      serviceToken: provider.functionArn
    });

    // 取得した値を使用
    new cdk.CfnOutput(this, 'RetrievedOutput', {
      value: customResource.getAttString('OutputValue')
    });
  }
}
```

---

### **6. この方法の利点と欠点**

**利点**:

- 複雑なロジックやエラーハンドリングを Lambda 内で実装可能
- 複数の出力や条件に基づいた処理が可能

**欠点**:

- Lambda 関数の管理が必要
- デプロイ時間が増加する可能性
- IAM ロールの設定やセキュリティの考慮が必要

---

### **7. まとめ**

`AwsCustomResource`を使用して、他のスタックの`CfnOutput`を取得することは可能です。ただし、以下の点に注意してください。

- **適切な権限とリージョンの設定**が必要
- **デプロイ順序**を考慮する必要がある
- **依存関係の管理**や**デプロイ時間**への影響を理解する

ご質問やさらなるサポートが必要な場合は、お気軽にお知らせください。

---

getParameter は SSM パラメータ 1 つにつき 1 個必要ですか?

---

ご質問ありがとうございます。

**いいえ、必ずしも SSM パラメータ 1 つにつき 1 つの`AwsCustomResource`が必要なわけではありません。** AWS の`SSM`サービスが提供する`getParameters` API を使用することで、一度に複数のパラメータを取得することが可能です。これにより、1 つの`AwsCustomResource`で複数のパラメータをまとめて取得できます。

---

### **複数の SSM パラメータを一度に取得する方法**

#### **1. `getParameters` API を使用する**

`getParameter`ではなく、`getParameters` API を使用します。この API は、複数のパラメータ名を配列で受け取り、一度にそれらの値を返します。

#### **2. `AwsCustomResource`の設定**

`AwsCustomResource`を設定する際に、`onUpdate`ブロック内で`getParameters`を指定し、取得したいパラメータ名のリストを`Names`パラメータに渡します。

---

### **コード例**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 取得したいSSMパラメータのリスト
    const parameterNames = ['/myapp/parameter1', '/myapp/parameter2', '/myapp/parameter3'];

    // AwsCustomResourceを使用して複数のパラメータを取得
    const getParameters = new AwsCustomResource(this, 'GetParameters', {
      onUpdate: {
        service: 'SSM',
        action: 'getParameters',
        parameters: {
          Names: parameterNames,
          WithDecryption: true // 必要に応じて暗号化されたパラメータを復号化
        },
        region: 'us-east-1', // パラメータが存在するリージョン
        physicalResourceId: PhysicalResourceId.of(Date.now().toString()) // 毎回最新の値を取得
      },
      policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE })
    });

    // 取得したパラメータの値を個別に取得
    const parameters = getParameters.getResponseField('Parameters');

    // パラメータの値をマップに格納
    const parameterValues = parameterNames.map((name, index) => {
      return {
        name: name,
        value: cdk.Token.asString(parameters[index].Value)
      };
    });

    // 取得したパラメータを使用
    parameterValues.forEach((param) => {
      new cdk.CfnOutput(this, `Output${param.name}`, {
        value: param.value
      });
    });
  }
}
```

---

### **詳細な説明**

- **`Names`プロパティ**: 取得したいパラメータ名のリストを配列として指定します。
- **`WithDecryption`プロパティ**: 暗号化されたパラメータを復号化して取得する場合は`true`に設定します。
- **`getResponseField`メソッド**: API レスポンスから特定のフィールドを取得します。`Parameters`フィールドには、取得したパラメータの配列が含まれます。
- **パラメータのマッピング**: 取得したパラメータの値を扱いやすいようにマップに格納しています。

---

### **注意事項**

1. **パラメータの順序と存在**:

   - `getParameters` API は、リクエストしたパラメータのうち取得に成功したもののみを返します。そのため、レスポンスの`Parameters`配列の順序がリクエストした順序と一致する保証はありません。
   - 存在しないパラメータやアクセス権限がないパラメータは、レスポンスの`InvalidParameters`フィールドにリストされます。

2. **パラメータの関連付け**:

   - 取得したパラメータをリクエストした名前と関連付けるためには、各パラメータの`Name`フィールドを使用してマッチングする必要があります。

3. **最大パラメータ数**:

   - `getParameters` API で一度にリクエストできるパラメータの数には上限があります(2023 年 10 月時点で 10 個)。大量のパラメータを取得する場合は、複数回に分けてリクエストする必要があります。

4. **エラーハンドリング**:

   - 存在しないパラメータやアクセス権限のないパラメータがある場合、エラーではなく`InvalidParameters`として返されます。これらを適切に処理する必要があります。

---

### **修正したコード例**

上記の注意事項を考慮して、パラメータ名と値を正確に関連付けるコード例を示します。

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 取得したいSSMパラメータのリスト
    const parameterNames = ['/myapp/parameter1', '/myapp/parameter2', '/myapp/parameter3'];

    // AwsCustomResourceを使用して複数のパラメータを取得
    const getParameters = new AwsCustomResource(this, 'GetParameters', {
      onUpdate: {
        service: 'SSM',
        action: 'getParameters',
        parameters: {
          Names: parameterNames,
          WithDecryption: true
        },
        region: 'us-east-1',
        physicalResourceId: PhysicalResourceId.of(Date.now().toString())
      },
      policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE })
    });

    // パラメータの値を取得し、パラメータ名と関連付ける
    const parameters = getParameters.getResponseField('Parameters');

    parameterNames.forEach((name) => {
      const parameterValue = cdk.Token.asString(cdk.Fn.select(0, cdk.Fn.split('|', cdk.Fn.findInMap('ParametersMap', name, 'Value'))));

      new cdk.CfnOutput(this, `Output${name}`, {
        value: parameterValue
      });
    });
  }
}
```

※上記のコードは複雑になるため、代わりにレスポンスをループしてパラメータ名と値をマップに格納することをおすすめします。

---

### **まとめ**

- **1 つの`AwsCustomResource`で複数の SSM パラメータを取得可能**: `getParameters` API を使用することで、一度に複数のパラメータを取得できます。
- **パラメータの関連付け**: レスポンスの`Parameters`配列から、各パラメータの`Name`フィールドを使用して値を取得します。
- **注意事項**: パラメータが存在しない場合やアクセス権限がない場合に備えて、`InvalidParameters`フィールドもチェックする必要があります。

---

ご不明な点や追加のご質問がございましたら、お気軽にお知らせください。

---

上記の parameters の実際の値のサンプルをみせてもらえますか?

---

承知いたしました。`parameters`変数には、`getParameters` API 呼び出しの結果として取得したパラメータの配列が格納されます。具体的にどのような値が含まれているのか、サンプルを示してご説明いたします。

---

### **`parameters`変数のサンプル**

`AwsCustomResource`を使用して`getParameters` API を呼び出すと、レスポンスは以下のような形になります。

```json
{
  "Parameters": [
    {
      "Name": "/myapp/parameter1",
      "Type": "String",
      "Value": "ParameterValue1",
      "Version": 1,
      "LastModifiedDate": "2023-10-01T12:34:56.789Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/parameter1",
      "DataType": "text"
    },
    {
      "Name": "/myapp/parameter2",
      "Type": "String",
      "Value": "ParameterValue2",
      "Version": 1,
      "LastModifiedDate": "2023-10-01T12:35:00.123Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/parameter2",
      "DataType": "text"
    },
    {
      "Name": "/myapp/parameter3",
      "Type": "SecureString",
      "Value": "ParameterValue3",
      "Version": 1,
      "LastModifiedDate": "2023-10-01T12:35:05.456Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/parameter3",
      "DataType": "text"
    }
  ],
  "InvalidParameters": []
}
```

#### **説明**

- **Parameters**: 取得に成功したパラメータのリスト。
  - **Name**: パラメータのフルネーム。
  - **Type**: パラメータのタイプ(`String`、`StringList`、`SecureString`)。
  - **Value**: パラメータの値。`WithDecryption`が`true`の場合、暗号化された値が復号化されます。
  - **Version**: パラメータのバージョン番号。
  - **LastModifiedDate**: 最終更新日時。
  - **ARN**: パラメータの Amazon リソースネーム。
  - **DataType**: パラメータのデータタイプ(通常は`text`)。
- **InvalidParameters**: 取得に失敗したパラメータの名前のリスト。

---

### **CDK 内での`parameters`の扱い方**

CDK コード内で、このレスポンスを使用して各パラメータの値を取得します。

```typescript
// getParametersで取得したレスポンスから'Parameters'フィールドを取得
const parameters = getParameters.getResponseField('Parameters');
```

しかし、`parameters`はトークンであり、そのままでは直接操作できません。そのため、`getResponseField`を使用して個々のパラメータの値を取得します。

---

### **個々のパラメータ値の取得方法**

`AwsCustomResource`の`getResponseField`メソッドを使用して、特定のパラメータの値を取得します。`getResponseField`は、AWS SDK のレスポンスから JSON パスを指定して値を取得します。

#### **コード例**

```typescript
parameterNames.forEach((paramName) => {
  const parameterValue = getParameters.getResponseField(
    `Parameters.0.Value` // ここを修正
  );
});
```

上記の`Parameters.0.Value`では、配列の最初の要素の値しか取得できません。そこで、パラメータ名に基づいて正確に値を取得するために、JMESPath 式を使用します。

---

### **JMESPath 式を使用したパラメータ値の取得**

`getResponseField`で JMESPath 式を使用すると、レスポンス内の特定の項目をフィルタリングできます。

#### **修正したコード例**

```typescript
parameterNames.forEach((paramName) => {
  const parameterValue = getParameters.getResponseField(`Parameters[?Name=='${paramName}'].Value | [0]`);

  new cdk.CfnOutput(this, `Output${paramName.replace('/', '_')}`, {
    value: parameterValue
  });
});
```

#### **説明**

- **Parameters[?Name=='${paramName}'].Value**: `Name`が`paramName`と一致するパラメータの`Value`を取得。
- **| [0]**: 結果の配列から最初の要素を取得。

---

### **完全なコード例**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 取得したいSSMパラメータのリスト
    const parameterNames = ['/myapp/parameter1', '/myapp/parameter2', '/myapp/parameter3'];

    // AwsCustomResourceを使用して複数のパラメータを取得
    const getParameters = new AwsCustomResource(this, 'GetParameters', {
      onUpdate: {
        service: 'SSM',
        action: 'getParameters',
        parameters: {
          Names: parameterNames,
          WithDecryption: true
        },
        region: 'us-east-1',
        physicalResourceId: PhysicalResourceId.of(Date.now().toString()) // 毎回最新の値を取得
      },
      policy: AwsCustomResourcePolicy.fromSdkCalls({ resources: AwsCustomResourcePolicy.ANY_RESOURCE })
    });

    // パラメータの値を取得し、使用する
    parameterNames.forEach((paramName) => {
      const parameterValue = getParameters.getResponseField(`Parameters[?Name=='${paramName}'].Value | [0]`);

      new cdk.CfnOutput(this, `Output${paramName.replace('/', '_')}`, {
        value: parameterValue
      });
    });
  }
}
```

---

### **ポイント**

- **`getResponseField`メソッド**: レスポンスから指定したフィールドの値を取得します。
- **JMESPath 式**: レスポンスデータを検索・フィルタリングするためのクエリ言語。
- **`[0]`を使用する理由**: フィルタリング結果は配列になるため、最初の要素を取得します。

---

### **`parameters`変数の実際の値に基づく具体例**

例えば、`parameterNames`が以下の場合:

```typescript
const parameterNames = ['/myapp/db/username', '/myapp/db/password', '/myapp/api/key'];
```

そして、対応するパラメータの値がそれぞれ以下の場合:

- `/myapp/db/username`: `admin`
- `/myapp/db/password`: `secretpassword`
- `/myapp/api/key`: `APIKEY12345`

この場合、`parameters`変数には以下のようなデータが格納されます。

```json
{
  "Parameters": [
    {
      "Name": "/myapp/db/username",
      "Type": "String",
      "Value": "admin",
      "Version": 1,
      "LastModifiedDate": "2023-10-05T10:00:00Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/db/username",
      "DataType": "text"
    },
    {
      "Name": "/myapp/db/password",
      "Type": "SecureString",
      "Value": "secretpassword",
      "Version": 1,
      "LastModifiedDate": "2023-10-05T10:05:00Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/db/password",
      "DataType": "text"
    },
    {
      "Name": "/myapp/api/key",
      "Type": "String",
      "Value": "APIKEY12345",
      "Version": 1,
      "LastModifiedDate": "2023-10-05T10:10:00Z",
      "ARN": "arn:aws:ssm:us-east-1:123456789012:parameter/myapp/api/key",
      "DataType": "text"
    }
  ],
  "InvalidParameters": []
}
```

#### **CDK での取得結果**

CDK 内で以下のように`parameterValue`を取得します。

```typescript
const parameterValue = getParameters.getResponseField(`Parameters[?Name=='/myapp/db/username'].Value | [0]`);
```

`parameterValue`には`admin`が格納されます。同様に、他のパラメータも取得できます。

---

### **エラーハンドリング**

- **存在しないパラメータ**: `InvalidParameters`フィールドにリストされます。
- **アクセス権限がない場合**: パラメータは返されず、`InvalidParameters`に含まれます。

#### **例**

```json
{
  "Parameters": [
    {
      "Name": "/myapp/db/username",
      "Type": "String",
      "Value": "admin"
      // 他のフィールド
    }
  ],
  "InvalidParameters": ["/myapp/db/password", "/myapp/api/key"]
}
```

この場合、`/myapp/db/password`と`/myapp/api/key`は取得できませんでした。CDK コード内でこれらのパラメータを取得しようとすると、空の値またはエラーが発生します。

---

### **まとめ**

- **`parameters`変数**: `getParameters` API のレスポンスから取得したパラメータの配列。
- **値の取得**: `getResponseField`と JMESPath 式を組み合わせて、特定のパラメータの値を取得。
- **エラーハンドリング**: 存在しないパラメータやアクセス権限のないパラメータに注意。

---

ご質問や不明な点がございましたら、お気軽にお知らせください。

---

AwsCustomResource はクロスアカウントでも使えますか? StackA と StackB が別ユーザで作られる場合です。

---

ご質問ありがとうございます。

---

### **AwsCustomResource はクロスアカウントで使用可能か?**

**はい、AwsCustomResource を使用してクロスアカウントの操作を行うことは可能です。** しかし、クロスアカウントでの使用にはいくつかの重要な設定と考慮事項があります。以下で詳細に説明いたします。

---

### **1. クロスアカウントアクセスの概要**

- **デフォルトの挙動**: `AwsCustomResource`は内部で Lambda 関数を使用し、その Lambda 関数はデフォルトではデプロイされているアカウント内でのみリソースにアクセスできます。
- **クロスアカウントアクセス**: 他の AWS アカウントのリソースにアクセスするためには、適切な IAM ロールの設定とリソースポリシーの構成が必要です。

---

### **2. クロスアカウントでの AwsCustomResource の設定方法**

#### **ステップ 1: IAM ロールの設定**

- **Lambda 関数用の IAM ロール**: `AwsCustomResource`が内部で使用する Lambda 関数には、アクセス先のアカウントのリソースに対する適切な権限が必要です。
- **クロスアカウントアクセスの許可**: アクセス先アカウントのリソースが、Lambda 関数の IAM ロールからのアクセスを許可するように設定します。

#### **ステップ 2: アクセス先アカウントでのリソースポリシーの設定**

- **SSM パラメータの場合**: アクセス先アカウントの SSM パラメータに対して、IAM ロールからの`ssm:GetParameter`または`ssm:GetParameters`アクションを許可するリソースポリシーを設定します。
- **CloudFormation スタックの場合**: アクセス先アカウントの CloudFormation スタックに対して、`cloudformation:DescribeStacks`アクションを許可する必要があります。

#### **ステップ 3: AwsCustomResource の IAM ポリシーの調整**

- **デフォルトのポリシーの上書き**: `AwsCustomResourcePolicy`を使用して、クロスアカウントアクセスに必要な IAM ポリシーを明示的に設定します。
- **例**: `AwsCustomResourcePolicy.fromStatements`を使用して、カスタムの IAM ポリシーステートメントを指定します。

---

### **3. コード例**

#### **StackB での設定(アクセス元のスタック)**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';
import * as iam from 'aws-cdk-lib/aws-iam';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // アクセス先アカウントの情報
    const targetAccountId = '123456789012'; // StackAが存在するアカウントID
    const targetRegion = 'us-east-1';

    // アクセスしたいSSMパラメータの名前
    const parameterName = '/myapp/shared-parameter';

    // AwsCustomResourceのポリシーを設定
    const customResourcePolicy = AwsCustomResourcePolicy.fromStatements([
      new iam.PolicyStatement({
        actions: ['ssm:GetParameter'],
        resources: [`arn:aws:ssm:${targetRegion}:${targetAccountId}:parameter${parameterName}`]
      })
    ]);

    // AwsCustomResourceを作成
    const getParameter = new AwsCustomResource(this, 'GetParameter', {
      onUpdate: {
        service: 'SSM',
        action: 'getParameter',
        parameters: {
          Name: parameterName,
          WithDecryption: true
        },
        region: targetRegion,
        physicalResourceId: PhysicalResourceId.of(Date.now().toString())
      },
      policy: customResourcePolicy
    });

    // パラメータの値を取得
    const parameterValue = getParameter.getResponseField('Parameter.Value');

    // 取得した値を使用
    new cdk.CfnOutput(this, 'RetrievedParameter', {
      value: parameterValue
    });
  }
}
```

#### **アクセス先アカウントでの設定(StackA 側)**

- **SSM パラメータのリソースポリシーを設定**: アクセス先の SSM パラメータに対して、アクセス元アカウントの IAM ロールからのアクセスを許可するリソースポリシーを設定します。

---

### **4. アクセス先アカウントでのリソースポリシーの設定方法**

SSM パラメータにはリソースポリシーを直接設定できません。しかし、AWS IAM ポリシーを使用して、アクセス元の IAM エンティティ(ユーザー、ロール)に必要な権限を付与することができます。

#### **ステップ 1: アクセス先アカウントで IAM ロールを作成**

- **IAM ロールを作成**: アクセス元のアカウントの IAM ロールを信頼できるエンティティとして設定します。

#### **ステップ 2: 必要なポリシーをアタッチ**

- **ポリシー例**:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<アクセス元アカウントID>:role/<アクセス元のIAMロール名>"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

#### **ステップ 3: アクセス元の IAM ロールから AssumeRole する**

- **Lambda 関数の IAM ロールを更新**: アクセス先アカウントの IAM ロールを AssumeRole できるように、Lambda 関数の IAM ロールを更新します。

---

### **5. 注意事項**

1. **セキュリティの考慮**

   - クロスアカウントアクセスには、適切なセキュリティ対策が必要です。
   - 必要最小限の権限のみを付与し、ポリシーを細かく制御してください。

2. **Lambda 関数の IAM ロール**

   - `AwsCustomResource`が内部で使用する Lambda 関数の IAM ロールに、クロスアカウントアクセスのための信頼関係と権限を正しく設定する必要があります。

3. **デプロイの順序**

   - アクセス先のリソースや IAM 設定が正しく行われていることを確認してから、`StackB`をデプロイしてください。

4. **リージョンの考慮**

   - クロスアカウントかつクロスリージョンの場合、リージョンの指定も正しく行う必要があります。

---

### **6. 代替案**

#### **方法 1: AWS Secrets Manager の使用**

- **リソースポリシーの設定が可能**: Secrets Manager のシークレットにはリソースポリシーを設定でき、クロスアカウントアクセスをより簡単に管理できます。

#### **方法 2: S3 バケットや DynamoDB を介した共有**

- **データの共有**: S3 バケットや DynamoDB テーブルを介して、データを共有することも可能です。
- **リソースポリシーの設定**: これらのリソースにはリソースポリシーを設定できるため、クロスアカウントアクセスの管理が容易です。

#### **方法 3: AWS Resource Access Manager (RAM) の使用**

- **リソース共有**: RAM を使用して、特定の AWS リソースを他のアカウントと共有できます。
- **対応リソース**: ただし、対応しているリソースタイプが限られているため、要件に合うか確認が必要です。

---

### **7. まとめ**

- **可能性**: `AwsCustomResource`を使用して、クロスアカウントでリソースにアクセスすることは可能です。
- **設定の複雑さ**: 適切な IAM ロールとポリシーの設定が必要であり、セキュリティと運用面での考慮が必要です。
- **代替手段の検討**: 要件によっては、他の方法(Secrets Manager や S3 など)を使用した方が簡単で安全な場合があります。

---

### **ご質問やサポートが必要な場合**

クロスアカウントアクセスは複雑であり、設定ミスがセキュリティリスクにつながる可能性があります。具体的なユースケースや要件に基づいて、最適なアプローチを選択することをお勧めします。

ご不明な点や追加のご質問がございましたら、お気軽にお知らせください。

---

S3 バケットや DynamoDB テーブルを介した場合、onUpdate()は使えますか?

---

ご質問ありがとうございます。

---

### **S3 バケットや DynamoDB テーブルを介した場合、onUpdate()は使えますか?**

**はい、`AwsCustomResource`の`onUpdate()`を使用して、S3 バケットや DynamoDB テーブルにアクセスすることが可能です。** これにより、クロスアカウントやクロスリージョンでのデータ取得や操作を行うことができます。ただし、適切な設定と考慮事項があります。

---

### **1. AwsCustomResource の onUpdate()で S3 や DynamoDB を操作する方法**

`AwsCustomResource`は、AWS SDK を直接呼び出すことで、AWS リソースを操作するカスタムリソースです。`onUpdate()`ハンドラー内で、S3 や DynamoDB の API を呼び出すことができます。

---

### **2. クロスアカウント/クロスリージョンアクセスの設定**

#### **ステップ 1: アクセス先リソースのポリシー設定**

- **S3 バケットの場合**:
  - アクセス先の S3 バケットポリシーに、アクセス元アカウントの IAM ロールからのアクセスを許可するステートメントを追加します。
- **DynamoDB テーブルの場合**:
  - アクセス先の DynamoDB テーブルに対して、IAM ポリシーやリソースポリシーを設定して、アクセス元アカウントの IAM ロールからのアクセスを許可します。

#### **ステップ 2: AwsCustomResource の IAM ポリシー設定**

- **IAM ポリシーの設定**:
  - `AwsCustomResourcePolicy`を使用して、必要なアクション(例:`s3:GetObject`、`dynamodb:GetItem`)を許可する IAM ポリシーを設定します。
- **クロスアカウントアクセス**:
  - アクセス先リソースの ARN を明示的に指定し、クロスアカウントでのアクセスを許可します。

---

### **3. コード例**

#### **例 1: S3 バケットからデータを取得**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';
import * as iam from 'aws-cdk-lib/aws-iam';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // アクセス先の情報
    const targetAccountId = '123456789012'; // アクセス先アカウントID
    const targetRegion = 'us-east-1';
    const bucketName = 'my-shared-bucket'; // アクセス先のS3バケット名
    const objectKey = 'shared-data.json'; // 取得したいオブジェクトのキー

    // AwsCustomResourceのポリシーを設定
    const customResourcePolicy = AwsCustomResourcePolicy.fromStatements([
      new iam.PolicyStatement({
        actions: ['s3:GetObject'],
        resources: [`arn:aws:s3:::${bucketName}/${objectKey}`]
      })
    ]);

    // AwsCustomResourceを作成
    const getObject = new AwsCustomResource(this, 'GetObject', {
      onUpdate: {
        service: 'S3',
        action: 'getObject',
        parameters: {
          Bucket: bucketName,
          Key: objectKey
        },
        region: targetRegion,
        physicalResourceId: PhysicalResourceId.of(Date.now().toString())
      },
      policy: customResourcePolicy
    });

    // オブジェクトの内容を取得
    const objectContent = getObject.getResponseField('Body');

    // 取得したデータを使用
    new cdk.CfnOutput(this, 'RetrievedData', {
      value: objectContent
    });
  }
}
```

#### **例 2: DynamoDB テーブルからデータを取得**

```typescript
import * as cdk from 'aws-cdk-lib';
import { AwsCustomResource, AwsCustomResourcePolicy, PhysicalResourceId } from 'aws-cdk-lib/custom-resources';
import * as iam from 'aws-cdk-lib/aws-iam';

export class StackB extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // アクセス先の情報
    const targetAccountId = '123456789012'; // アクセス先アカウントID
    const targetRegion = 'us-east-1';
    const tableName = 'my-shared-table'; // アクセス先のDynamoDBテーブル名
    const key = { id: { S: 'shared-item' } }; // 取得したいアイテムのキー

    // AwsCustomResourceのポリシーを設定
    const customResourcePolicy = AwsCustomResourcePolicy.fromStatements([
      new iam.PolicyStatement({
        actions: ['dynamodb:GetItem'],
        resources: [`arn:aws:dynamodb:${targetRegion}:${targetAccountId}:table/${tableName}`]
      })
    ]);

    // AwsCustomResourceを作成
    const getItem = new AwsCustomResource(this, 'GetItem', {
      onUpdate: {
        service: 'DynamoDB',
        action: 'getItem',
        parameters: {
          TableName: tableName,
          Key: key
        },
        region: targetRegion,
        physicalResourceId: PhysicalResourceId.of(Date.now().toString())
      },
      policy: customResourcePolicy
    });

    // アイテムの内容を取得
    const item = getItem.getResponseField('Item');

    // 取得したデータを使用
    new cdk.CfnOutput(this, 'RetrievedItem', {
      value: JSON.stringify(item)
    });
  }
}
```

---

### **4. 注意事項**

#### **1. アクセス先リソースのポリシー設定**

- **S3 バケットポリシー**:

  - アクセス元アカウントの IAM ロールからのアクセスを許可するバケットポリシーを設定します。
  - ポリシー例:

    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AllowCrossAccountGetObject",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::<アクセス元アカウントID>:role/<アクセス元のIAMロール名>"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::my-shared-bucket/shared-data.json"
        }
      ]
    }
    ```

- **DynamoDB テーブルの IAM ポリシー**:
  - テーブルに対して、アクセス元の IAM ロールからの`dynamodb:GetItem`アクションを許可するポリシーを設定します。

#### **2. IAM ロールの設定**

- **Lambda 関数の IAM ロール**:
  - `AwsCustomResource`が内部で使用する Lambda 関数の IAM ロールに、必要な権限を付与します。
  - クロスアカウントアクセスのため、信頼関係や権限の設定が正しく行われていることを確認します。

#### **3. セキュリティの考慮**

- **最小権限の原則**:
  - 必要最小限の権限のみを付与し、リソースやアクションを限定します。
- **リソース ARN の指定**:
  - ポリシーで指定するリソース ARN は、具体的なリソースに限定します。

#### **4. デプロイの順序**

- **リソースの準備**:
  - アクセス先の S3 バケットや DynamoDB テーブルが事前に存在し、適切なポリシーが設定されていることを確認します。

---

### **5. `onUpdate()`の使用に関するポイント**

- **`onUpdate()`ハンドラー**:

  - スタックの更新時やデプロイ時に実行されます。
  - リソースの状態に応じて、API コールを実行できます。

- **クロスアカウント/クロスリージョンアクセス**:

  - `onUpdate()`内で`region`や`credentials`(必要な場合)を指定することで、他のアカウントやリージョンのリソースにアクセスできます。

- **物理 ID の設定**:
  - `physicalResourceId`を適切に設定することで、リソースの更新や再実行を制御できます。

---

### **6. 代替案の検討**

#### **方法 1: Lambda 関数を使用したカスタムリソース**

- **利点**:

  - より複雑なロジックやエラーハンドリングが可能。
  - クロスアカウントアクセスのための STS を使用した AssumeRole も実装可能。

- **欠点**:
  - Lambda 関数のコード管理が必要。
  - デプロイ時間や複雑性が増加。

#### **方法 2: 外部パイプラインやスクリプトを使用**

- **利点**:

  - CDK のデプロイフローとは独立してデータを同期できる。
  - カスタマイズ性が高い。

- **欠点**:
  - ワークフローが複雑化し、管理が難しくなる可能性。

---

### **7. まとめ**

- **`AwsCustomResource`の`onUpdate()`を使用して、S3 や DynamoDB にアクセス可能。**
- **クロスアカウントアクセスには、適切な IAM ポリシーとリソースポリシーの設定が必要。**
- **セキュリティと運用面での考慮が重要。**

---

### **ご提案**

クロスアカウントやクロスリージョンでのデータ共有は、セキュリティリスクや運用上の複雑性が増すため、以下の点を検討してください。

1. **セキュリティの強化**:

   - IAM ポリシーとリソースポリシーを細かく制御し、必要最小限の権限のみを付与します。

2. **運用の簡素化**:

   - 可能であれば、データの共有方法を見直し、同一アカウント内でのデータ共有や、他のサービス(例:AWS Secrets Manager)を使用することも検討してください。

3. **監査とログ**:
   - アクセスログや監査ログを有効にし、異常なアクセスや操作がないか監視します。
