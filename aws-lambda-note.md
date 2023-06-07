# AWS Lmabdaメモ

- [AWS Lmabdaメモ](#aws-lmabdaメモ)
  - [AWS Lambdaで使える言語のバージョン](#aws-lambdaで使える言語のバージョン)
  - [ハンドラのeventに値を渡す](#ハンドラのeventに値を渡す)
  - [AWS CodeCommitとCodePiplineでCI/CD](#aws-codecommitとcodepiplineでcicd)
  - [AWS Lambdaのデプロイツール](#aws-lambdaのデプロイツール)
  - [AWS SAM](#aws-sam)
    - [2019-11](#2019-11)
  - [AWS SAM part2](#aws-sam-part2)
  - [API Gatewayの「リソース」と「ステージ」](#api-gatewayのリソースとステージ)
  - [API GatewayのサンプルPetStoreについて](#api-gatewayのサンプルpetstoreについて)
  - [API Gateway ステージ変数](#api-gateway-ステージ変数)
  - [コールドスタート vs ウォームスタート](#コールドスタート-vs-ウォームスタート)
  - [既存のLambdaのコードを取得する](#既存のlambdaのコードを取得する)
  - [既存のLambda layerのコードを取得する](#既存のlambda-layerのコードを取得する)

## AWS Lambdaで使える言語のバージョン

[Lambda runtimes - AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)

2023-06に調べたところ、Python 3.10がサポートされてるので
もうUbuntu 22.04LTSにpython3.9や3.8入れなくともいい。

Nodeは18。LTSってことかな...

## ハンドラのeventに値を渡す

Cloud watch Eventのスケジュール実行で

[CloudWatch Management Console](https://ap-northeast-1.console.aws.amazon.com/cloudwatch/home?region=ap-northeast-1#rules:)

ルールの作成または編集
「ステップ 1: ルールの作成」で「ターゲット」で「定数 (JSON テキスト)」を設定すると

それがまるごとハンドラのevent変数に入って呼ばれる。

これ設定するとlambdaのdesigner画面から

- イベントの削除
- イベントの有効/無効の切り替え
ができなくなる。バグっぽい。

ruleの画面からは有効/無効の切り替え、イベントの削除はできるので、
そっちでやること。

## AWS CodeCommitとCodePiplineでCI/CD

本当はGitHubでやりたいんだけど、まずは練習的に

[AWS CodePipeline を使用して Lambda アプリケーションの継続的な配信パイプラインを構築する - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/build-pipeline.html)

## AWS Lambdaのデプロイツール

Azure functionsみたいにGitHubにpushすれば自動でデプロイ、
のようなのがあるといいんだけれど、
AWS LambdaとAzure functionsって
根本的に思想が違うので
そういうわけにはいかず
さまざまなデプロイツールが乱立してる感じ。

- [Serverless - The Serverless Application Framework powered by AWS Lambda, API Gateway, and more](https://serverless.com/)
- [Apex – Serverless Infrastructure](http://apex.run/) - 開発終了
- [Chalice](https://chalice.readthedocs.io/en/latest/) - Pythonのフレームワーク
- [AWS SAM](https://aws.amazon.com/jp/serverless/sam/)
  - [AWS Serverless Application Repository とは - AWS Serverless Application Repository](https://docs.aws.amazon.com/ja_jp/serverlessrepo/latest/devguide/what-is-serverlessrepo.html)
  - [GitHub - awslabs/aws-sam-cli: CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM](https://github.com/awslabs/aws-sam-cli)
  - [SAM init コマンドを使用した AWS SAM CLI によるシンプルなサーバレスアプリケーションの構築](https://aws.amazon.com/jp/about-aws/whats-new/2018/04/aws-sam-cli-releases-new-init-command/)
- [AWS Lambda のミニマルなデプロイツール lambroll を書いた - 酒日記 はてな支店](https://sfujiwara.hatenablog.com/entry/lambroll)

## AWS SAM

Azure Function Core Tools的なノリに思われる。

- [Installing the AWS SAM CLI on Linux - AWS Serverless Application Model](https://docs.aws.amazon.com/en_pv/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html) - pip3 --userで入れるのが簡単そう
- [serverless-application-model/examples/apps at master · awslabs/serverless-application-model · GitHub](https://github.com/awslabs/serverless-application-model/tree/master/examples/apps) - サンプル。どうもServerlessとそっくりに見える。
- [Amazon.com: AWS Serverless Application Model: Developer Guide eBook: Amazon Web Services: Kindle Store](https://www.amazon.com/dp/B07P7K9VZB) - Kindle版. $0.
  - [Amazon.co.jpではこちら](https://www.amazon.co.jp/AWS-Serverless-Application-Model-Developer-ebook/dp/B07P7K9VZB/)

### 2019-11

- [新しいサーバーレスアプリ作成機能で CI/CD も作れます | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/new-serverless-app-creation-with-cicd/)
- [AWS Lambdaのアプリケーション作成を使ってCI/CDパイプラインを一気に構築 - Qiita](https://qiita.com/shonansurvivors/items/b223fbb362aed3c1c536)
- [実際に手を動かして学ぶ！AWS Hands-on for Beginners のご紹介 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-hands-on-for-beginners-01/)

GitHubからつなげられるのが嬉しい。

デプロイするのに3分かかる... これは辛い。
SAM環境で十分デバッグしてからでないと。

あといまのところNodejsだけなのも辛い。

## AWS SAM part2

[AWS SAM で Hello World する - Qiita](https://qiita.com/mokuo/items/3348f19d12cb9b17295d)

生成されるREADME.mdが親切。

[Tutorial: Deploying a Hello World Application - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html)

これは読むこと
[AWS Black Belt Online Seminar - AWS Serverless Application Model (AWS SAM) - サービスカットシリーズ](https://d1.awsstatic.com/webinars/jp/pdf/services/20190814_AWS-Blackbelt_SAM_rev.pdf)

- templaye.ymlはCloudFormationそのものではない。

[Telemetry in the AWS SAM CLI - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-telemetry.html)

ここ以下にexampleがまとまっている。
[serverless-application-model/examples at 870bdd3493a74b89b351f7f669476708295fea5b · awslabs/serverless-application-model](https://github.com/awslabs/serverless-application-model/tree/870bdd3493a74b89b351f7f669476708295fea5b/examples)

`Type: Schedule`の例
[CloudWatch イベント アプリケーションの AWS SAM テンプレート - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/with-scheduledevents-example-use-app-spec.html)

`sam init --name sam-schedule-app --runtime python3.6 --app-template template`
[AWS SAM Template Concepts - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template-basics.html)

samのデフォルトで指定できそうなテンプレートは
このへん
[awslabs/aws-sam-cli-app-templates](https://github.com/awslabs/aws-sam-cli-app-templates)
hello-worldしかない...

しょうがないのでtemplate.yaml
[AWS SAM Template Concepts - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-template-basics.html)

[serverless-application-model/2016-10-31.md at master · awslabs/serverless-application-model](https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md)

[Python の AWS Lambda 関数ログ作成 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/python-logging.html)

テレメトリーがだいたいタイムアウトで失敗する
[Telemetry in the AWS SAM CLI - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-telemetry.html)

```text
SAM CLI now collects telemetry to better understand customer needs.

  You can OPT OUT and disable telemetry collection by setting the
  environment variable SAM_CLI_TELEMETRY=0 in your shell.
  Thanks for your help!
```

```text
Telemetry endpoint configured to be https://aws-serverless-tools-telemetry.us-west-2.amazonaws.com/metrics
```

## API Gatewayの「リソース」と「ステージ」

(TODO)

## API GatewayのサンプルPetStoreについて

[チュートリアル: サンプルをインポートして REST API を作成する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-create-api-from-example.html)

OpenAPIのモデルはAPI Gatewayポータルで見れる

/のGET
普通ならlambdaがあるところに「Mock エンドポイント」がある。
[API Gateway でモック 統合を設定する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/how-to-mock-integration.html)

文字通り、開発前にコードレスでモックのREST APIを作る機能らしい。
OpenAPI定義ファイルについて学ばないといけないのがめんどそう。

> Swagger 3.0 から OpenAPI に名前が変わったため、 OpenAPI 3.0 は Swagger 3.0 でもあります。

- [OpenAPI \(Swagger\) 超入門 \- Qiita](https://qiita.com/teinen_qiita/items/e440ca7b1b52ec918f1b)
- [Swagger Editor](https://editor.swagger.io/)
- [OpenAPI (Swagger) の基本的なあれこれ - ばうあーろぐ](https://girigiribauer.com/tech/20190318/)

/petsのPOSTは
`http://petstore.execute-api.ap-northeast-1.amazonaws.com/petstore/pets`

## API Gateway ステージ変数

こんなのあるなんて知らなかった

- [REST API デプロイのステージ変数のセットアップ \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/stage-variables.html)
- [Amazon API Gateway のステージ変数の使用 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/amazon-api-gateway-using-stage-variables.html)

## コールドスタート vs ウォームスタート

- [Lambdaの実行時間について | Oji-Cloud](https://oji-cloud.net/2019/07/15/post-2418/)
- [AWS における サーバーレスの基礎からチューニングまで](https://www.slideshare.net/shimy_net/aws-79149218)
- [Keeping Functions Warm \- How To Fix AWS Lambda Cold Start Issues](https://www.serverless.com/blog/keep-your-lambdas-warm)
- [New for AWS Lambda – Predictable start\-up times with Provisioned Concurrency \| AWS Compute Blog](https://aws.amazon.com/jp/blogs/compute/new-for-aws-lambda-predictable-start-up-times-with-provisioned-concurrency/)
- [Operating Lambda: Performance optimization – Part 1 | AWS Compute Blog](https://aws.amazon.com/jp/blogs/compute/operating-lambda-performance-optimization-part-1/)

## 既存のLambdaのコードを取得する

引用元 [コンソールで確認できないLambda関数のコードを確認する \| DevelopersIO](https://dev.classmethod.jp/articles/confirm-lambda-code/)

コンソールからexportできる。アクション -> 関数のエクスポート

CLIからなら

```sh
#!/bin/sh -ue
LAMBDA_NAME=myPythonHello

aws lambda get-function --function-name  "$LAMBDA_NAME" \
  | jq .Code.Location -r \
  | xargs curl -o code.zip
```

みたいな感じで。

## 既存のLambda layerのコードを取得する

できるの?

[AWS Lambda Layersのアーカイブファイルをダウンロードする | ヤマムギ](https://www.yamamanx.com/aws-lambda-layers-archive/)
