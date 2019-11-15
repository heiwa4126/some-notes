# AWS CloudFormaton 練習帳

YAMLでリソースを作るアレ。
「せっかく書いても、手動で修正したら(統合性が)壊れちゃうんでしょ」とか思ってたら、

- [【アップデート】ついに来た！CloudFormationで手動で作成したリソースをStackにインポート可能になりました ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudformation-import-existing-resources/)
- [ドリフトとは - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift.html#what-is-drift)
- [ドリフト検出をサポートしているリソース - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-stack-drift-resource-list.html)

こんなことに↑なったので、ちゃんとやる。(2019-11)

# チュートリアル

このへんから → [【CloudFormation入門1】5分と6行で始めるAWS CloudFormationテンプレートによるインフラ構築 ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/cloudformation-beginner01/)

↑に載ってたやつ。
``` yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  FirstVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
```
**`FirstVPC`という名前のVPCが存在しないことを確認してからやること。**

実査に使ったのは [template01.yml](./CloudFormation/template01.yml).

まずポータルでやってみる。https://ap-northeast-1.console.aws.amazon.com/cloudformation/home

やってみた。削除する。AWS CLIでやってみる。

- [AWS コマンドラインインターフェイスの使用 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html)
- [cloudformation — AWS CLI 1.16.282 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/index.html)

``` bash
#!/bin/sh
set -uex
aws cloudformation create-stack \
    --stack-name stackOta01 \
    --template-body file://./template01.yml \
    --tags 'Key=Owner,Value=heiwa4126@example.com'
```

`--param`でパラメータが指定できるらしい。[パラメータ - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html)。後で試す。

既存のリソースからCloudFormationのテンプレートを得ることが出来るらしい。
- [CloudFormer (ベータ) を使用して既存の AWS リソースから AWS CloudFormation テンプレートを作成する - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/cfn-using-cloudformer.html)
- [【AWS】CloudFormerの使い方 - Qiita](https://qiita.com/ktsuchi/items/f5ba5bab119cf40764cf)
