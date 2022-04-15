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


# 2015-03-31/functions/function/invocations

```sh
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```
の **2015-03-31** とは何?


# SAM/CFn

`PackageType: Image`のときのMetadataのドキュメントは?
[コンテナイメージの構築](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-using-build.html#build-container-image)

Dockerfileを使う方法しかなさそう。

ECRにすでにあるものをコンテナlambdaとして使うことはできるか?
デプロイしてformer2で調べてみる。
(そもそも普通のlambdaでそれはできるか? パーミッションがあれば多分...)


`AWS::Lambda::Function` みてみると

```yaml
# 普通の
   Properties:
      Code: 
        S3Bucket: "awslambda-ap-ne-1-tasks"
        S3Key: !Sub "/snapshots/${AWS::AccountId}/..."
        S3ObjectVersion: "..."
# コンテナの
   Properties:
      Code:
        ImageUri: !Sub "${AWS::AccountId}.dkr.ecr.${AWS::Region}.amazonaws.com/..."
```

ImageUrlにECRのARN書けばいいらしい。

参照:
- [Lambda API の使用](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html#configuration-images-api)
- [AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html#configuration-images-cloudformation)

SAMの `AWS::Serverless::Function` では `ImageUri`はProperties直下にある。

なんとかSAMでできた。ただリージョンは同じでないとダメ。
"Image repository must be in the same region."
と言われる。


# クロスアカウント

よそのアカウントのECRにあるイメージをコンテナlambdaとして使うことはできるか?

- [AWS Lambda は Amazon Elastic Container Registry からのクロスアカウントコンテナイメージのプルをサポートするようになりました](https://aws.amazon.com/jp/about-aws/whats-new/2021/11/aws-lambda-support-cross-account-image-amazon-elastic-container-registry/)
- [Amazon ECR クロスアカウント許可](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html)
