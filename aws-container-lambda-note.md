コンテナlambdaのメモ

- [Lambda でのコンテナイメージの使用 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-images.html)
  - [Lambda コンテナイメージの作成 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-create.html)
  - [Lambda コンテナイメージをローカルでテストする \- AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-test.html)
- [コンテナ利用者に捧げる AWS Lambda の新しい開発方式 ! - 変化を求めるデベロッパーを応援するウェブマガジン | AWS](https://aws.amazon.com/jp/builders-flash/202103/new-lambda-container-development/?awsf.filter-name=*all)



- RIC (Runtime Interface Client)
- RIE (Lambda Runtime Interface Emulator)

`public.ecr.aws`レポジトリにあるイメージには
RICとRIE入りのやつと
RIEだけのやつがある。


# SAM/CFn

`PackageType: Image`のときのMetadataのドキュメントは?
[コンテナイメージの構築](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-using-build.html#build-container-image)

Dockerfileを使う方法しかなさそう。

ECRにすでにあるものをコンテナlambdaとして使うことはできるか?
デプロイしてformer2で調べてみる。
(そもそも普通のlambdaでそれはできるか? パーミッションがあれば多分...)
