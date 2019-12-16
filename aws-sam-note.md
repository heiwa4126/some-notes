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
**lambda中にバケット名をハードコーディングしなくてすむ**。
lamda側では普通に環境変数とるのと同じように
```python
import os
MY_BUCKET = os.environ['SomeBucket']
```
のように書けばOK


ただlocal invokeはめんどうになる。
```bash
SomeBucket=********** sam local invoke
```
みたいにするか、exportするか。

参考:
- [AWS SAMがめちゃめちゃアップデートされてる件 – ClassmethodサーバーレスAdvent Calendar 2017 #serverless #adventcalendar #reinvent ｜ Developers.IO](https://dev.classmethod.jp/server-side/serverless/20171203-updates-about-aws-serverless-application-model/) - ちょっと古いけど参考になる
- [AWS SAM テンプレートを作成する - AWS CodeDeploy](https://docs.aws.amazon.com/ja_jp/codedeploy/latest/userguide/tutorial-lambda-sam-template.html)
- [Lambda 関数で使用できる環境変数 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-environment-variables.html) - デフォルトの環境変数。かぶらないようにする、または意図的にオーバライドする。


# AWS LambdaとSAMの参考

- [AWS Lambda 関数を使用する際のベストプラクティス - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/best-practices.html)
- [AWS Lambda 環境変数 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/env_variables.html)
- [Lambda 関数で環境変数のクライアント側を暗号化する - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/tutorial-env_console.html)
- [[アップデート]AWS SAMのデプロイが簡単になりました ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/aws-sam-simplifies-deployment/)
- [AWS SAMを使う前にCloudFormationテンプレートを書こう - Qiita](https://qiita.com/izanari/items/78258251cced2f713b33)


# AWS Lambda 関数のバージョン

- [AWS Lambda 関数のバージョン - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-versions.html)
- [AWS Lambda 関数のエイリアス - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-aliases.html)
- [AWS Lambda のバージョン管理の仕組み ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/lambda-versioning/)
- [AWS Lambdaバージョン管理のススメ - Qiita](https://qiita.com/quotto/items/4c364074edc69cb67d70)
- [TECHSCORE｜知っておきたかったAWS SAM の小ネタ4選 | TECHSCORE BLOG](https://www.techscore.com/blog/2018/12/07/aws-sam-tips/) - `--parameter-overrides`の使い所が参考になる。