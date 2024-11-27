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
- [AWS CDK のテストはどう書く?](#aws-cdkのテストはどう書く)

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
