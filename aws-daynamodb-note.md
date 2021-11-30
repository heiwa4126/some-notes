
# queryとscan

[ステップ 4: データをクエリおよびスキャンする - Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.04.html)
> scan メソッドは、テーブル全体のすべての項目を読み込み、テーブルの全データを返します


# サンプルデータ

AWSが配布しているIMDBの映画データ
https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/samples/moviedata.zip

使い方は

* [ステップ 1: Python を使用してテーブルを作成する - Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.01.html)
* [ステップ 2: サンプルデータをロードする \- Amazon DynamoDB](https://docs.aws.amazon.com/ja_jp/ja_jp/amazondynamodb/latest/developerguide/GettingStarted.Python.02.html)



# Former2

[TimeToLiveSpecification](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-table.html#cfn-dynamodb-table-timetolivespecification)
がついてくるんだけど
これを CFnに食わせると `Property AttributeName cannot be empty.`　全然意味不明なエラーになる。

`TimeToLiveSpecification: false`だったらデフォルトなので、これをコメントアウトする。
