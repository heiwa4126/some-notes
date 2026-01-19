# queryとscan

[ステップ 4: データをクエリおよびスキャンする - Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.04.html)

> scan メソッドは、テーブル全体のすべての項目を読み込み、テーブルの全データを返します

# サンプルデータ

AWS が配布している IMDB の映画データ
https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/samples/moviedata.zip

使い方は

- [ステップ 1: Python を使用してテーブルを作成する - Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.01.html)
- [ステップ 2: サンプルデータをロードする \- Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.02.html)

# Former2

[TimeToLiveSpecification](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-table.html#cfn-dynamodb-table-timetolivespecification)
がついてくるんだけど
これを CFn に食わせると `Property AttributeName cannot be empty.`　全然意味不明なエラーになる。

`TimeToLiveSpecification: false`だったらデフォルトなので、これをコメントアウトする。

[AWS::DynamoDB::Table TimeToLiveSpecification \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-dynamodb-timetolivespecification.html)
にあるとおり

```yaml
AttributeName: String
Enabled: Boolean
```

なんで、 `Enabled: false`は無理ですね。

# DynamoDBには予約語がある

[Reserved Words in DynamoDB - Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ReservedWords.html)

項目名にこれら予約語を使うと ProjectionExpression とかで

> Invalid UpdateExpression: Attribute name is a reserved keyword; reserved keyword: (属性名)

と言われて死ぬので避けたほうがいいです。

いまさら変えられない、という場合には以下参照、

[AWS lambdaのDynamoDB更新処理で "Invalid UpdateExpression: Attribute name is a reserved keyword"になった時の対処方法 - Qiita](https://qiita.com/shimajiri/items/715c7da4467dd048c93f)
