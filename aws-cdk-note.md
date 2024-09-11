# AWS CDK (Cloud Development Kit)

- [インストール](#インストール)
- [チュートリアル](#チュートリアル)
- [AWS CDK Workshop](#aws-cdk-workshop)
- [AWS CloudShell](#aws-cloudshell)
- [cdk でリージョンを変えるには?](#cdk-でリージョンを変えるには)
- [AWS CDK には AWS SAM のように lambda を zip にしたりモジュール入れたりするサポートはある?](#aws-cdk-には-aws-sam-のように-lambda-を-zip-にしたりモジュール入れたりするサポートはある)

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
