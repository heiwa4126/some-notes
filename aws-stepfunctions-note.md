# ASLの仕様は

ここ: [Amazon States Language](https://states-language.net/)

なんでamazonでないの?

GitHubにもある。
[awslabs/states-language: The States Language spec](https://github.com/awslabs/states-language)


# AWS Step Functions との協働および統合

ASLの Resource: に書く
`arn:aws:states:::dynamodb:putItem`
みたいののリファレンスはどこにある?

ここ
- [Step Functions 用統合最適化 - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/connect-suppo\
rted-services.html) - タイトルから想像できない内容...
- DynamoDBについては [Step Functions を使用した DynamoDB API の呼び出し](https://docs.aws.amazon.com/ja_jp/step-functions/lat\
est/dg/connect-ddb.html)

統合最適化(optimized integrations)以外の呼び出し方は
[他のサービスで AWS Step Functions を使用する - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/concepts-service-integrations.html)

`arn:aws:states:::aws-sdk:*` を使う
[AWS SDK のサービスの統合 - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/supported-services-awssdk.html)
など。


# 標準 vs エクスプレス

何が違う?

[標準ワークフロー対 Express ワークフロー - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/concepts-standard-vs-express.html)

用途次第。

# ASLの '$.' とは?

JsonPath。ASL内では使えない関数あり(lenght()とか)

> パスは、JSON テキスト内でコンポーネントを識別するために使用できる $ で始まる文字列です

- [パス - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/amazon-states-language-paths.html)
- [json-path/JsonPath: Java JsonPath implementation](https://github.com/json-path/JsonPath)
- [JSONPath Online Evaluator](https://jsonpath.com/)

`$$.` ってのもあります。
[Context オブジェクト - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/input-output-contextobject.html)



まず [ステートマシンデータ - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/concepts-state-machine-data.html) を読んで、
[データフローシミュレーター](https://ap-northeast-1.console.aws.amazon.com/states/home?region=ap-northeast-1#/simulator)
を試す。

# ASLの '.$' とは?

[InputPath、パラメータ、および ResultSelector - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/ja_jp/step-functions/latest/dg/input-output-inputpath-params.html#input-output-parameters)

> パスを使用して値を選択するキーと値のペアの場合、キーの名前は .$ で終わる必要があります。


# アクティビティとは?

ステートマシンの途中で
AWSの外に(中でもいいけど)
制御をわたす、みたいな感じ?

AWSの外のやつをWorkerというらしい。

WorkerのPythonでのサンプル:
- [Step Function Activity with Python | by Yuvaraj Ravikumar | Medium](https://medium.com/@yuvarajmailme/step-function-activity-with-python-c007178037af)
- [awsboto3/stepfunction_activity.py at master · yuvarajskr/awsboto3](https://github.com/yuvarajskr/awsboto3/blob/master/stepfunction_activity.py)
