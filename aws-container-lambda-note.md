コンテナ lambda のメモ

- [Lambda でのコンテナイメージの使用 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-images.html)
  - [Lambda コンテナイメージの作成 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-create.html)
  - [Lambda コンテナイメージをローカルでテストする \- AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/images-test.html)
- [コンテナ利用者に捧げる AWS Lambda の新しい開発方式 ! - 変化を求めるデベロッパーを応援するウェブマガジン | AWS](https://aws.amazon.com/jp/builders-flash/202103/new-lambda-container-development/?awsf.filter-name=*all)

- RIC (Runtime Interface Client)
- RIE (Lambda Runtime Interface Emulator)

`public.ecr.aws`レポジトリにあるイメージには
RIC と RIE 入りのやつと
RIE だけのやつがある。

# 2015-03-31/functions/function/invocations

```sh
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

の **2015-03-31** とは何?

# SAM/CFn

`PackageType: Image`のときの Metadata のドキュメントは?
[コンテナイメージの構築](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-using-build.html#build-container-image)

Dockerfile を使う方法しかなさそう。

ECR にすでにあるものをコンテナ lambda として使うことはできるか?
デプロイして former2 で調べてみる。
(そもそも普通の lambda でそれはできるか? パーミッションがあれば多分...)

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

ImageUrl に ECR の ARN 書けばいいらしい。

参照:

- [Lambda API の使用](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html#configuration-images-api)
- [AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html#configuration-images-cloudformation)

SAM の `AWS::Serverless::Function` では `ImageUri`は Properties 直下にある。

なんとか SAM でできた。ただリージョンは同じでないとダメ。
"Image repository must be in the same region."
と言われる。これは API でも同じ。

# クロスアカウント

よそのアカウントの ECR にあるイメージをコンテナ lambda として使うことはできるか?

- [AWS Lambda は Amazon Elastic Container Registry からのクロスアカウントコンテナイメージのプルをサポートするようになりました](https://aws.amazon.com/jp/about-aws/whats-new/2021/11/aws-lambda-support-cross-account-image-amazon-elastic-container-registry/)
- [Amazon ECR クロスアカウント許可](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-images.html)

ECR のポリシーはどこで設定するのか...
[プライベートリポジトリポリシーステートメントの設定 \- Amazon ECR](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/set-repository-policy.html)

[AWS::ECR::RegistryPolicy](https://docs.amazonaws.cn/en_us/AWSCloudFormation/latest/UserGuide/aws-resource-ecr-registrypolicy.html)

[get-repository-policy — AWS CLI 2.5.5 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ecr/get-repository-policy.html)
