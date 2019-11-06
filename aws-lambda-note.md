# AWS Lmabdaメモ

- [AWS Lmabdaメモ](#aws-lmabda%e3%83%a1%e3%83%a2)
- [ハンドラのeventに値を渡す](#%e3%83%8f%e3%83%b3%e3%83%89%e3%83%a9%e3%81%aeevent%e3%81%ab%e5%80%a4%e3%82%92%e6%b8%a1%e3%81%99)
- [AWS CodeCommitとCodePiplineでCI/CD](#aws-codecommit%e3%81%a8codepipline%e3%81%a7cicd)

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

