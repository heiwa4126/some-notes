# AWS Lmabdaメモ

- [AWS Lmabdaメモ](#aws-lmabda%e3%83%a1%e3%83%a2)
- [ハンドラのeventに値を渡す](#%e3%83%8f%e3%83%b3%e3%83%89%e3%83%a9%e3%81%aeevent%e3%81%ab%e5%80%a4%e3%82%92%e6%b8%a1%e3%81%99)
- [AWS CodeCommitとCodePiplineでCI/CD](#aws-codecommit%e3%81%a8codepipline%e3%81%a7cicd)
- [AWS Lambdaのデプロイツール](#aws-lambda%e3%81%ae%e3%83%87%e3%83%97%e3%83%ad%e3%82%a4%e3%83%84%e3%83%bc%e3%83%ab)
- [AWS SAM](#aws-sam)
- [2019-11](#2019-11)
- [AWS SAM](#aws-sam-1)


# ハンドラのeventに値を渡す

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



# AWS CodeCommitとCodePiplineでCI/CD

本当はGitHubでやりたいんだけど、まずは練習的に

[AWS CodePipeline を使用して Lambda アプリケーションの継続的な配信パイプラインを構築する - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/build-pipeline.html)

# AWS Lambdaのデプロイツール

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


# AWS SAM

Azure Function Core Tools的なノリに思われる。

 - [Installing the AWS SAM CLI on Linux - AWS Serverless Application Model](https://docs.aws.amazon.com/en_pv/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html) - pip3 --userで入れるのが簡単そう
- [serverless-application-model/examples/apps at master · awslabs/serverless-application-model · GitHub](https://github.com/awslabs/serverless-application-model/tree/master/examples/apps) - サンプル。どうもServerlessとそっくりに見える。
- [Amazon.com: AWS Serverless Application Model: Developer Guide eBook: Amazon Web Services: Kindle Store](https://www.amazon.com/dp/B07P7K9VZB) - Kindle版. $0.
  - [Amazon.co.jpではこちら](https://www.amazon.co.jp/AWS-Serverless-Application-Model-Developer-ebook/dp/B07P7K9VZB/)


# 2019-11

- [新しいサーバーレスアプリ作成機能で CI/CD も作れます | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/new-serverless-app-creation-with-cicd/)
- [AWS Lambdaのアプリケーション作成を使ってCI/CDパイプラインを一気に構築 - Qiita](https://qiita.com/shonansurvivors/items/b223fbb362aed3c1c536)
- [実際に手を動かして学ぶ！AWS Hands-on for Beginners のご紹介 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-hands-on-for-beginners-01/)

GitHubからつなげられるのが嬉しい。

デプロイするのに3分かかる... これは辛い。
SAM環境で十分デバッグしてからでないと。

あといまのところNodejsだけなのも辛い。

# AWS SAM

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
```
SAM CLI now collects telemetry to better understand customer needs.

  You can OPT OUT and disable telemetry collection by setting the
  environment variable SAM_CLI_TELEMETRY=0 in your shell.
  Thanks for your help!
```

```
Telemetry endpoint configured to be https://aws-serverless-tools-telemetry.us-west-2.amazonaws.com/metrics
```

