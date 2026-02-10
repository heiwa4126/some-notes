# AWS CloudFormaton メモ

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
- [VSCode で SAM の template.yaml で "!Sub "等にエラーを出さなくする](#vscode-で-sam-の-templateyaml-で-sub-等にエラーを出さなくする)
- [VSCode で SAM の拡張機能は?](#vscode-で-sam-の拡張機能は)
- [CloudFormation IaC generator](#cloudformation-iac-generator)
  - [CloudFormation IaC generator のはまりポイント(事前調査)](#cloudformation-iac-generator-のはまりポイント事前調査)
  - [以下 Geminiに生成してもらった分(未確認)](#以下-geminiに生成してもらった分未確認)
  - [1. 「Cognito」周りのリソース(最大のハマりポイント)](#1-cognito周りのリソース最大のハマりポイント)
  - [2. 「API Gateway」のメソッドやモデル](#2-api-gatewayのメソッドやモデル)
  - [3. 「グローバルリソース」の罠(IAM, Route 53, CloudFront)](#3-グローバルリソースの罠iam-route-53-cloudfront)
  - [4. 依存関係が複雑な「ネットワーク・セキュリティ」周り](#4-依存関係が複雑なネットワークセキュリティ周り)
  - [5. 「デフォルトリソース」と「自動生成リソース」](#5-デフォルトリソースと自動生成リソース)
  - [6. シークレットを持つリソースの「中身」](#6-シークレットを持つリソースの中身)

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

ホントは SAM でなんだけど。

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
- [CloudFormation coding using YAML\. This is not a “101” on CloudFormation... \| by Bob van den Heuvel \| Schuberg Philis](https://stories.schubergphilis.com/cloudformation-coding-using-yaml-9127025813bb)

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

## VSCode で SAM の template.yaml で "!Sub "等にエラーを出さなくする

- [Incorrectly classifies !Ref and !GetAtt as an unknown tag in serverless · Issue #93 · threadheap/serverless-ide-vscode](https://github.com/threadheap/serverless-ide-vscode/issues/93)
- [VSCode で AWS CloudFormation を YAML で書くための個人的ベスト設定 #AWS - Qiita](https://qiita.com/yoskeoka/items/6528571a45cd69f93deb#%E8%A8%AD%E5%AE%9A2)

`setting.json` に以下を追加

```json
"yaml.customTags": [
    "!Ref",
    "!Sub scalar",
    "!Sub sequence",
    "!Join sequence",
    "!FindInMap sequence",
    "!GetAtt scalar",
    "!GetAtt sequence",
    "!Base64 mapping",
    "!GetAZs",
    "!Select scalar",
    "!Select sequence",
    "!Split sequence",
    "!ImportValue",
    "!Condition",
    "!Equals sequence",
    "!And",
    "!If",
    "!Not",
    "!Or"
  ]
```

## VSCode で SAM の拡張機能は?

たぶんこれ:
[Serverless IDE - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ThreadHeap.serverless-ide-vscode)

こっちはたぶん不要:
[CloudFormation Linter - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=kddejong.vscode-cfn-lint)

## CloudFormation IaC generator

[iann0036/former2](https://github.com/iann0036/former2)
があんまりメンテされないので、試しに使ってみる。

- [Generate templates from existing resources with IaC generator - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/generate-IaC.html)
- [CloudFormation IaC ジェネレーターを使用してリソーススキャンを開始する - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/iac-generator-start-resource-scan.html)
- [Resource type support - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resource-import-supported-resources.html) - 対応リソース一覧
- [StartResourceScan - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/APIReference/API_StartResourceScan.html)
- [AWS CloudFormation が IaC ジェネレーターでのターゲットを絞ったリソーススキャンのサポートを開始 - AWS](https://aws.amazon.com/jp/about-aws/whats-new/2025/03/aws-cloudformation-targeted-resource-scans-iac-generator/)
- [テンプレートの生成、管理、削除によく使用されるコマンド](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/generate-IaC.html)

### CloudFormation IaC generator のはまりポイント(事前調査)

- RDS Parameter Group / Option Group - スキャン自体には出ない
- RDS Subnet Group - [非存在サブネットの罠: CloudFormationのIaCGeneratorテンプレート登録失敗の真相 - 管理人Kのひとりごと](https://www.k-hitorigoto.online/entry/2024/11/26/080000)
- CloudWatch Logs の LogStream - 異様に多い(それはそうですね)
  - リソースタイプ=AWS::Logs::LogStream を除外、とかできる?
- CloudFormation 管理済みリソースはテンプレートに追加できない
- サブリソース(自動生成系) - スキャンはできてテンプレートにも追加できるが、デプロイできない(それはそうですね)
  - ENI
  - EIPAssociation
  - Lambda::Version
  - etc
- VpcId / SubnetId がハードコード - Ref ではなく物理IDが直書きされる

### 以下 Geminiに生成してもらった分(未確認)

「IaC Generatorでハマった!」というブログやコミュニティ(Reddit, AWS re:Post, DevelopersIO, Qiita等)の報告でよく見かける、「**あるはずなのに出てこない**」「**テンプレート化できなくて困る**」代表的なリソースをまとめました。

これらは仕様上の制限だけでなく、**「ユーザーが直感的に期待する挙動と異なる」**ことによるハマりポイントでもあります。

### 1. 「Cognito」周りのリソース(最大のハマりポイント)

多くのユーザーが報告する「出てこない」代表格です。

- **症状:** `AWS::Cognito::UserPool`(ユーザープール)や `IdentityPool` がスキャン結果に出てこない。
- **理由:** IaC Generatorは「Cloud Control API」に対応しているリソースしかスキャンできません。Cognitoの主要リソースはCloud Control APIへの対応が遅れており(または一部リージョンで未対応)、**リストアップすらされない**ことが多々あります。
- **対策:** 現状は手書きするか、既存のテンプレート作成ツール(`former2`など)を併用するしかありません。

### 2. 「API Gateway」のメソッドやモデル

- **症状:** API Gateway自体は見えても、その配下の細かい設定(Method, Model, Stageなど)が個別リソースとして抽出できない、またはID表示ばかりでどれがどれか分からない。
- **理由:** API Gatewayはリソース構造が複雑で、親リソース(RestApi)の中に定義が包含されているケースと、独立したリソースとして定義すべきケースが混在し、Generatorがうまく依存関係を解決できないことがあります。また、識別子が「ランダムなID」で表示されるため、**リストにあっても人間が見つけられない**(検索できない)という「実質的な取得不可」も起きています。

### 3. 「グローバルリソース」の罠(IAM, Route 53, CloudFront)

- **症状:** IAMロールやRoute 53のホストゾーンが見つからない。
- **理由:** IaC Generatorは**リージョン単位**でスキャンします。
- **IAM / Route 53 / CloudFront:** これらはグローバルリソースですが、CloudFormationの仕様上、**「us-east-1(バージニア北部)」**でスキャンしないと出てこない、あるいは管理できないケースがあります。東京リージョンでスキャンして「IAMが出てこない!」と焦るケースが非常に多いです。

### 4. 依存関係が複雑な「ネットワーク・セキュリティ」周り

- **症状:** 生成されたテンプレートを使おうとするとエラーになる。
- **具体例:**
- **VPCピアリング:** 相手側のVPCが存在しない(削除済み)のに、参照IDだけが残っていてエラーになる。
- **セキュリティグループの循環参照:** AがBを参照し、BがAを参照している場合、Generatorがどちらを先に作るか解決できず、デプロイ時にコケるテンプレートが生成されることがあります。

### 5. 「デフォルトリソース」と「自動生成リソース」

- **症状:** `Default VPC` や、Lambdaが勝手に作ったENI、LogGroupなどが大量に出てきてノイズになる、またはインポートしようとして失敗する。
- **理由:** AWSアカウント作成時からある「デフォルトVPC」や「デフォルトセキュリティグループ」は、CloudFormationで管理(インポート)しようとすると、「既存のプロパティと一致しない」などの理由でドリフト(差分)扱いされたり、削除保護の制約でハマることがあります。

### 6. シークレットを持つリソースの「中身」

- **症状:** RDSやRedshiftを作成するテンプレートはできるが、パスワード欄が空っぽ、または適当なプレースホルダーになっていて、そのままではデプロイできない。
- **理由:** APIはセキュリティ上、パスワードを返さない(Write-onlyプロパティ)ためです。これは「取得できない」というより「不完全な状態でしか取得できない」仕様です。
