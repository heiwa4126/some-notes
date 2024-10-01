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

素性はよくわからないけど日本語あった。[AWS Cloud Development Kit \(AWS CDK\) ワークショップへようこそ!](https://summit-online-japan-cdk.workshop.aws/)

オリジナル: [AWS CDK Intro Workshop :: AWS Cloud Development Kit (AWS CDK) Workshop](https://cdkworkshop.com/)

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
const myFunction = new lambda.Function(this, "HelloWorldFunction", {
  runtime: lambda.Runtime.NODEJS_20_X,
  handler: "app.lambdaHandler",
  code: lambda.Code.fromAsset(path.join(__dirname, "..", "lambda", "hello"), {
    exclude: ["*.log", "tests/**/*"],
  }),
});
```

のように使う。(Lambda の中身は `./lambda/hello` にある想定)

**ただし** AWS SAM みたいに package.json や requirements.txt を自動で処理してくれないので
`npm ci` とか `pip install -r requirements.txt --target .` を自前でやる必要はある。

## AWS CDK でリソースの物理 ID を固定する

できるんだけど、リソースの種類によって設定方法が異なるのでつらい。

```javascript
// S3のバケット名を固定
const bucket = new s3.Bucket(this, "MyBucket", {
  bucketName: "my-fixed-bucket-name",
});

// テーブル名を固定
const table = new dynamodb.Table(this, "MyTable", {
  tableName: "my-fixed-table-name",
  partitionKey: { name: "id", type: dynamodb.AttributeType.STRING },
});

// Lambda関数名を固定
const lambdaFunction = new lambda.Function(this, "MyFunction", {
  functionName: "my-fixed-function-name",
  runtime: lambda.Runtime.NODEJS_20_X,
  handler: "index.handler",
  code: lambda.Code.fromAsset("lambda"),
});

// IAM Roleの名前を固定
const myRole = new iam.Role(this, "MyFixedRole", {
  roleName: "my-fixed-role-name",
  assumedBy: new iam.ServicePrincipal("lambda.amazonaws.com"),
});

// IAM Policyの名前を固定
const myPolicy = new iam.ManagedPolicy(this, "MyFixedPolicy", {
  managedPolicyName: "my-fixed-policy-name", // 固定名
  statements: [
    new iam.PolicyStatement({
      actions: ["s3:ListBucket"],
      resources: ["arn:aws:s3:::my-bucket"],
    }),
  ],
});
```

どうしてもダメなら
`cdk.CfnResource()`
という必殺技もある。

```javascript
const resource = new cdk.CfnResource(this, "MyResource", {
  type: "AWS::S3::Bucket",
  properties: {
    BucketName: "my-custom-bucket-name",
  },
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
