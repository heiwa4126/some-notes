# ASLの仕様は

ここ: [Amazon States Language](https://states-language.net/)

なんで amazon でないの?

GitHub にもある。
[awslabs/states-language: The States Language spec](https://github.com/awslabs/states-language)

# AWS Step Functions との協働および統合

ASL の Resource: に書く
`arn:aws:states:::dynamodb:putItem`
みたいののリファレンスはどこにある?

ここ

- [Step Functions 用統合最適化 - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/connect-suppo
  rted-services.html) - タイトルから想像できない内容...
- DynamoDB については[Step Functions を使用した DynamoDB API の呼び出し](https://docs.aws.amazon.com/ja_jp/step-functions/lat
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

JsonPath。ASL 内では使えない関数あり(lenght()とか)

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

> **パスを使用して値を選択するキーと値のペアの場合**、キーの名前は .$ で終わる必要があります。

# アクティビティとは?

ステートマシンの途中で
AWS の外に(中でもいいけど)
制御をわたす、みたいな感じ?

AWS の外のやつを Worker というらしい。

Worker の Python でのサンプル:

- [Step Function Activity with Python | by Yuvaraj Ravikumar | Medium](https://medium.com/@yuvarajmailme/step-function-activity-with-python-c007178037af)
- [awsboto3/stepfunction_activity.py at master · yuvarajskr/awsboto3](https://github.com/yuvarajskr/awsboto3/blob/master/stepfunction_activity.py)

# ASLでlambdaを呼ぶ

Resource に lambda ARN を書く方法と "arn:aws:states:::lambda:invoke" + Parameters でやる方法と 2 つあるらしい。

- [Step FunctionsからLambda関数を実行する書き方2つの違い | DevelopersIO](https://dev.classmethod.jp/articles/differences-between-2-ways-of-invoking-lambda-functions-with-step-functions/)
- [Invoke - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/API_Invoke.html#API_Invoke_RequestParameters)

Invoke の方の FunctionName には、名前(:alias)か ARN が使える。

コールバック?
[サービス統合パターン - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/connect-to-resource.html#connect-wait-token)

# stateのtype

[States - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/ja_jp/step-functions/latest/dg/concepts-states.html)

- Task
- Choice
- Fail or Succeed
- Pass
- Wait
- Parallel
- Map

# Parallel

Parallel のブランチへの入力は同じものになるみたい。

別々にしたかったら Map を使う。

# ASLメモ

Next がなければ、"End: true"扱いになるらしい。

↑誤り

> Fail 状態は常にステートマシンを終了するため、Next フィールドはなく、End フィールドも不要です。

Fail or Succeed ステートでは End がいらない、ということらしい。

ResultPath の文法がわかりにくい。
迷ったら
[データフローシミュレーター](https://ap-northeast-1.console.aws.amazon.com/states/home?region=ap-northeast-1#/simulator)
で試す。
