
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
  - [Installing the AWS SAM CLI on Linux - AWS Serverless Application Model](https://docs.aws.amazon.com/en_pv/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html)
- [AWS Lambda のミニマルなデプロイツール lambroll を書いた - 酒日記 はてな支店](https://sfujiwara.hatenablog.com/entry/lambroll)