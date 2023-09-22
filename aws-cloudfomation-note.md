# AWS CloudFormaton 練習帳

- [AWS CloudFormaton 練習帳](#aws-cloudformaton-練習帳)
  - [リファレンス](#リファレンス)
    - [Ref](#ref)
  - [チュートリアル](#チュートリアル)
  - [CloudFormation で S3 を作る](#cloudformation-で-s3-を作る)
  - [CloudFormation で stack の外のリソースの IAM をマネージするかっこいい方法](#cloudformation-で-stack-の外のリソースの-iam-をマネージするかっこいい方法)
  - [route53](#route53)
  - [CLI](#cli)
  - [CFn のサンプル](#cfn-のサンプル)
  - [CloudFormation Macros](#cloudformation-macros)
  - [CloudFomation の YAML で anchors/aliases を使うには?](#cloudfomation-の-yaml-で-anchorsaliases-を使うには)
  - [ARN](#arn)
  - [template.yaml の linter](#templateyaml-の-linter)
  - [UpdateReplacePolicy と DeletionPolicy](#updatereplacepolicy-と-deletionpolicy)

YAML でリソースを作るアレ。
「せっかく書いても、手動で修正したら(統合性が)壊れちゃうんでしょ」とか思ってたら、

- [【アップデート】ついに来た!CloudFormation で手動で作成したリソースを Stack にインポート可能になりました | Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudformation-import-existing-resources/)
- [ドリフトとは - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift.html#what-is-drift)
- [ドリフト検出をサポートしているリソース - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift-resource-list.html)

こんなことに ↑ なったので、ちゃんとやる。(2019-11)

## リファレンス

- [組み込み関数リファレンス - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html)
- [形式バージョン \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/format-version-structure.html)

### Ref

[Ref \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html)

> リソースの論理名を指定すると、それはそのリソースを参照するために通常使用できる値を返します (Logical ID)。

## チュートリアル

このへんから → [【CloudFormation 入門 1】5 分と 6 行で始める AWS CloudFormation テンプレートによるインフラ構築 | Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudformation-beginner01/)

↑ に載ってたやつ。

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  FirstVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
```

**`FirstVPC`という名前の VPC が存在しないことを確認してからやること。**

実査に使ったのは [template01.yml](./CloudFormation/template01.yml).

まずポータルでやってみる。<https://ap-northeast-1.console.aws.amazon.com/cloudformation/home>

やってみた。削除する。AWS CLI でやってみる。

- [AWS コマンドラインインターフェイスの使用 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html)
- [cloudformation - AWS CLI 1.16.282 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/index.html)

```bash
##!/bin/sh
set -uex
aws cloudformation create-stack \
    --stack-name stackOta01 \
    --template-body file://./template01.yml \
    --tags 'Key=Owner,Value=heiwa4126@example.com'
```

`--param`でパラメータが指定できるらしい。[パラメータ - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html)。後で試す。

既存のリソースから CloudFormation のテンプレートを得ることが出来るらしい。

- [CloudFormer (ベータ) を使用して既存の AWS リソースから AWS CloudFormation テンプレートを作成する - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-using-cloudformer.html)
- [【AWS】CloudFormer の使い方 - Qiita](https://qiita.com/ktsuchi/items/f5ba5bab119cf40764cf)

## CloudFormation で S3 を作る

- [AWS::S3::Bucket - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html)
- [CloudFormation でいろいろな S3 バケットを作成してみた | Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudformation-s3bucket-type/)
- [CloudFormation で S3 を作成する - Qiita](https://qiita.com/yoshiokaCB/items/f8c36a6fe250856fd672)

> バケット名には、小文字の英文字、数字、ハイフン、およびピリオドを使用することができます。
> バケット名の先頭と末尾は文字または数値とし、ハイフンまたは別のピリオドの横にピリオドを使用することはできません。 - [AWS CLI での高レベル (s3) コマンドの使用 - AWS Command Line Interface](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-services-s3-commands.html)

## CloudFormation で stack の外のリソースの IAM をマネージするかっこいい方法

ホントは SAM で なんだけど。

- [AWS CloudFormation のベストプラクティス - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/best-practices.html)

## route53

[Route 53 テンプレートスニペット - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/quickref-route53.html)

## CLI

[AWS Command Line Interface の使用 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html)

よく使うパターン

[スタックの削除](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-cli-deleting-stack.html):
`aws cloudformation delete-stack --stack-name YourStackName`

[スタックの作成](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-cli-creating-stack.html)
`aws cloudformation create-stack --stack-name YourStackName --template-body file://Your.yaml`

## CFn のサンプル

[Asia Pacific \(Tokyo\) Region \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-sample-templates-ap-northeast-1.html)

## CloudFormation Macros

- [AWS CloudFormation Macros について](https://aws.amazon.com/jp/about-aws/whats-new/2018/09/introducing-aws-cloudformation-macros/)
- [AWS CloudFormation を AWS Lambda によるマクロで拡張する | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/cloudformation-macros/)
- [CloudFormation のマクロ機能で Lambda 関数と一緒に CloudWatch Logs の Log Group を自動作成してみる | DevelopersIO](https://dev.classmethod.jp/articles/craete-log-group-by-cfnmacro/)

要は Lambda で変換コードを書いて、最後にそれを呼び出してまとめて変換する。マクロというよりはフィルターみたいなもの。
ローカルで動けばいいのに...
複数指定はできるの?

デフォルトで存在する
[変換のリファレンス \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/transform-reference.html)

## CloudFomation の YAML で anchors/aliases を使うには?

リクエストはけっこう出てるけどいまのところ使えないみたい。

- [Support YAML anchors/aliases in CFN yaml templates · Issue \#613 · aws\-cloudformation/cloudformation\-coverage\-roadmap](https://github.com/aws-cloudformation/cloudformation-coverage-roadmap/issues/613)
- [CloudFormation coding using YAML\. This is not a “101” on CloudFormation… \| by Bob van den Heuvel \| Schuberg Philis](https://stories.schubergphilis.com/cloudformation-coding-using-yaml-9127025813bb)

## ARN

`!GetAttr FooBar.arn`
でエラーになって散々悩んだ。

正しくは
`!GetAttr FooBar.Arn`
です。

超ありがち。「アトリビュートは大文字で始まる」と覚えること

## template.yaml の linter

3 つある。

- [aws-cloudformation/cfn-lint: CloudFormation Linter](https://github.com/aws-cloudformation/cfn-lint) - 公式らしい。ふつうこれ
  - [cfn-lint · PyPI](https://pypi.org/project/cfn-lint/)
  - [CloudFormation Linter - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=kddejong.vscode-cfn-lint) - VSCode 拡張。別途 cfn-lint と pydot (preview 用)が必要
- [cfn-lint - npm](https://www.npmjs.com/package/cfn-lint) - メンテされてない感じ
- AWS CLI で `aws cloudformation validate-template` - テンプレートの受け渡しが大変なので実質使えない。参考: [テンプレートの検証 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-validate-template.html)

他参考:

- [cfn-lint のエラーメッセージ](https://github.com/aws-cloudformation/cfn-lint/blob/main/docs/rules.md)

## UpdateReplacePolicy と DeletionPolicy

- [DeletionPolicy 属性 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html)
- [UpdateReplacePolicy 属性 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-attribute-updatereplacepolicy.html)

参考: [[アップデート] CloudFormation の DeletionPolicy にて、リソース作成時のみ Delete でそれ以外は Retain として動作する RetainExceptOnCreate が設定できるようなりました | DevelopersIO](https://dev.classmethod.jp/articles/cloudformation-retain-except-on-create/)
