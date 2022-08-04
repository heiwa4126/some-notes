# 使ってみよう AWS X-Ray

AWS X-Ray(エクスレイ)は
AWSの観測サービスの1つで
主にプロファイラ、エラー検出などに使います。

今回は AWS X-Ray を軽く触ってみましょう。


## X-Rayの用語

X-Rayで使われる用語は [AWS X-Ray の概念 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-concepts.html) を参照。
とりあえず知っておく用語は以下の2つです。

### トレース

一連のサービス呼び出し・結果の返却(「セグメント」)の塊。たとえば
API GatewayのstageからLambdaが呼び出され、
LambdaがDynamDBを読んで...
の一連のセグメント。

トレース1個分を表示するのが
[X-Rayコンソール](https://console.aws.amazon.com/xray/home#)
の
[traces](https://console.aws.amazon.com/xray/home#/traces)
で、
一定期間のトレースをまとめて表示するのが
[service map](https://console.aws.amazon.com/xray/home#/service-map)


### グループ

グループという名前ですが、実質フィルタ。
トレースに対する条件式を書きます。
前述のX-Rayコンソールのトレースやサービスマップでグループを指定すると、
フィルタされたトレースのみが表示されるようになります。

条件式はここ参照: [フィルタ式を使用したコンソールでのトレースの検索 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-console-filters.html)


## 実際にX-Rayのサンプルを動かしてみる

AWS提供のサンプルには
- [AWS X-Ray サンプルアプリケーション - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-scorekeep.html)
- [aws-samples/eb-java-scorekeep at xray-gettingstarted](https://github.com/aws-samples/eb-java-scorekeep/tree/xray-gettingstarted)

がありますが、ちょっと規模が大きすぎるので、かんたんな同期アプリを作ってみました。

使うツールは
- AWS CLI 2.7.20, AWS SAM 1.53.0 (2022-08時点での最新)
- Python 3.9
- [Lambda Powertools Python](https://awslabs.github.io/aws-lambda-powertools-python/latest/)
- jq, [yq(tomlq)](https://github.com/kislyuk/yq)

といった標準的なものです。

zip(ここからダウンロード)を展開したら、

```bash
sam build
sam deploy --guided
```
でAWSにデプロイできます。

## テストラン

テストは
```bash
./make_env.sh  # デプロイ直後に1回だけ
./remote_test.sh
```
で行います。

このアプリケーションは
API Gateway経由でDynamoDBを読み書きするLambdaで、
- GET /hello で 接続テスト。
- GET /get で DynamoDBから k1=test を読み出し
- GET /put で DynamoDBへ k1=test,v1=タイムスタンプ文字列 を書込(更新)

ただしlambdaのポリシーでdynamodb:UpdateItemが抜けてるので
`GET /put`
は失敗します (`template.yaml`参照)。

`./remote_test.sh` は
1. GET /hello
2. GET /get
3. GET /put (これは失敗する)
4. GET /get

を実行します。

## 「トレース」を見る

`./remote_test.sh` を実行したら、
5分以内に
[X-Rayコンソール](https://console.aws.amazon.com/xray/home#)
を開いてください。

デプロイ先のリージョンを合わせたら
左ペインの
[トレース](https://console.aws.amazon.com/xray/home#/traces)
を選ぶと、テストで実行した4つのトレースが見えるはずです。

「トレースのリスト」を経過時間でソートすると、3番めのトレースが失敗した
`GET /put`
になるはずなので、これを選ぶと、以下のような画面になります。

TODO:IMAGE

下のペインで黄色い警告マーク⚠になっているDynamoDBをクリックして
例外タブを開くと
`... because no identity-based policy allows the dynamodb:UpdateItem action`
(dynamodb:UpdateItemアクションが許可されていないので失敗しました)
と表示されます。


## 「サービスマップ」を見る

続けて左ペインの
[service map](https://console.aws.amazon.com/xray/home#/service-map)
を選んでください。

「データがありません」と表示される場合がありますが、
その時はゆっくり10数えて
「過去5分間」と表示されている隣のリロードボタンを押してください。

過去5分間のトレースが総合されて
以下のような画面になります。

TODO:IMAGE


このサンプルだとサービスマップはこんな程度ですが、
大規模なアプリケーションで、期間を多めにすると、

TODO:IMAGE

(上の図は [Observability](https://catalog.workshops.aws/observability/ja-JP/xray/explore-xray#service-map-on-x-ray) から引用)

のようなマップが得られるはずです。
他サンプルは
[aws xray service map - Google Search](https://www.google.com/search?q=aws+xray+service+map&hl=en&source=lnms&tbm=isch)
参照。

これでいつ起きるかわからないエラーを検出することができます。


## テスト環境の削除

テストが終わったら
```bash
sam destroy --no-prompts
```
でAWS上からテスト環境を削除してください。

削除するまえに
`template.yaml`
の該当部分を修正して(1箇所アンコメントすればいいようにしてあります)
再デプロイしてみるのもいいですね。


## X-Rayの有効・無効の切替

開発環境・検証環境でX-Rayを有効にして、
本番環境で無効にする、のような設定は、
今回サンプルで使った
Lambda Powertools Pythonを使うなら、[Disabling response auto-capture](https://awslabs.github.io/aws-lambda-powertools-python/latest/core/tracer/#disabling-response-auto-capture) からの 3章を参照。

またSAMのCloudFormation的には [SAM CLIのInit時にLambda関数のX-Rayトレースを有効化出来るようになりました | DevelopersIO](https://dev.classmethod.jp/articles/sam-init-enable-x-ray-tracing/) を参照。

コンソールのUIからのenable/disableは、前述の
[SAM CLIのInit時にLambda関数のX-Rayトレースを有効化出来るようになりました | DevelopersIO](https://dev.classmethod.jp/articles/sam-init-enable-x-ray-tracing/)
と
[Amazon API GatewayのアクティブトレーシングサポートAWS X-Ray - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-services-apigateway.html)
を参照


## TODO

今回のサンプルは単純な同期アプリケーションでしたが、
StepFunctionsなどの非同期アプリケーションで試してみたいです。
