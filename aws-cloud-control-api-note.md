# AWS Cloud Control API

# 使い方

[Getting started with Cloud Control API - Cloud Control API](https://docs.aws.amazon.com/ja_jp/cloudcontrolapi/latest/userguide/getting-started.html)

# サポートしているリソースの一覧

[Resource types that support Cloud Control API - Cloud Control API](https://docs.aws.amazon.com/ja_jp/cloudcontrolapi/latest/userguide/supported-resources.html)

または CLI

[Using resource types - Cloud Control API](https://docs.aws.amazon.com/ja_jp/cloudcontrolapi/latest/userguide/resource-types.html#resource-types-determine-support)
にある例

```sh
aws cloudformation list-types --type RESOURCE --visibility PUBLIC --provisioning-type FULLY_MUTABLE --max-results 100
```

または
[CloudFormation レジストリ: アアクティブ化済み拡張機能](https://ap-northeast-1.console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/registry/activated-extensions/resource-types)

「アアクティブ化済み拡張機能」はママ。もとは "Registry: Activated extensions"

# パラメータの詳細

これも
[Using resource types - Cloud Control API](https://docs.aws.amazon.com/ja_jp/cloudcontrolapi/latest/userguide/resource-types.html#resource-types-determine-support)

例えば LogGroup の例

```sh
aws cloudformation describe-type --type RESOURCE --type-name "AWS::Logs::LogGroup" > x.json
jq -r ."Schema" x.json | jq .
```

CFn のドキュメントとだいたい同じものが出るけど
(
[AWS::Logs::LogGroup \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html)
)
`handlers`って何だ?

[Using resource types - Cloud Control API](https://docs.aws.amazon.com/ja_jp/cloudcontrolapi/latest/userguide/resource-types.html#resource-types-schemas)の一番下 `Viewing supported resource operations` に `handlers`の説明がある。

- リソースタイプがサポートする操作
- 必要なパーミッション

# 既存のリソースの状態を見て同じものが作れるかを調べてみるメモ

(2021-11)

`AWS::DynamoDB::GlobalTable`はサポートしているが
`AWS::DynamoDB::Table`がサポートされてない。

EC2 も Instance がサポートされてない。

S3 ぐらい?

普通リソース単体で使うことなんかない(と思う)。まだ CFn のほうが楽っぽい。
