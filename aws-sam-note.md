# AWS SAM と AWS Lambdaのメモ

# template.yamlでリソースを作り、lamdaにそれのアクセス権を与える

例えば「S3バケツを作って、それに対する読み書きできるようにする」方法

- [AWS SAM Policy Templates - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-templates.html)

template.yamlのResourcesの部分だけ抜粋
```yaml
Resources:
  SomeBucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: Private
      PublicAccessBlockConfiguration:
        BlockPublicAcls: True
        BlockPublicPolicy: True
        IgnorePublicAcls: True
        RestrictPublicBuckets: True

  SomeTestFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: s3_test/
      Handler: app.lambda_handler
      Runtime: python3.8
      Environment:
        Variables:
          S3Bucket: !Ref SomeBucket
      Policies:
      - S3CrudPolicy:
          BucketName: !Ref SomeBucket
```
こうすると`Policies`のところで
論理名SomeTestFunctionRoleが
デフォルトのポリシー`AWSLambdaBasicExecutionRole`に
インラインポリシー`SomeTestFunctionRolePolicy0`を追加して生成される。
(名前はPolicy連番らしい)

上の例の`S3CrudPolicy`が **Policy Template**.

- [Policy Template List - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-template-list.html#cloudwatch-put-metric-policy)


また、`Environment`のところでAWS Lambda環境変数として
S3バケット名が生成されるので、
Lambda中にバケット名をハードコーディングしなくてすむ。

ただlocal invokeはめんどうになる。
```bash
SomeBucket=********** sam local invoke
```
みたいにするか、exportするか。

参考:
- [AWS SAMがめちゃめちゃアップデートされてる件 – ClassmethodサーバーレスAdvent Calendar 2017 #serverless #adventcalendar #reinvent ｜ Developers.IO](https://dev.classmethod.jp/server-side/serverless/20171203-updates-about-aws-serverless-application-model/) - ちょっと古いけど参考になる
- [AWS SAM テンプレートを作成する - AWS CodeDeploy](https://docs.aws.amazon.com/ja_jp/codedeploy/latest/userguide/tutorial-lambda-sam-template.html)


# AWS Lambdaの参考

- [AWS Lambda 関数を使用する際のベストプラクティス - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/best-practices.html)
- [AWS Lambda 環境変数 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/env_variables.html)