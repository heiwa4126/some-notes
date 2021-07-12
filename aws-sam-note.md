# AWS SAM と AWS Lambdaのメモ

# template.yamlでリソースを作り、lamdaにそれのアクセス権を与える

例えば「S3バケツを作って、それに対する読み書きできるようにする」方法

- [AWS SAM Policy Templates - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-templates.html)
- [AWS サーバーレスアプリケーションモデル (AWS SAM) の使用 - AWS Serverless Application Repository](https://docs.aws.amazon.com/ja_jp/serverlessrepo/latest/devguide/using-aws-sam.html)

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


# template.yamlで作っていないリソースに対して、lamdaにアクセス権を与える

stack外にあるリソースにアクセスするケース。

案1:
``` yaml
Resources:
  SecretTestFunctionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: "sts:AssumeRole"
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
      Policies:
        - PolicyName: policy1
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - "secretsmanager:GetSecretValue"
                Resource: "arn:aws:secretsmanager:ap-northeast-1:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  SecretTestFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: secret_test/
      Handler: app.lambda_handler
      Runtime: python3.6
      Role: !GetAtt SecretTestRole.Arn
```

管理ポリシーAWSLambdaBasicExecutionRoleに
インラインポリシーpolicy1を追加したロールを作り、
Lamdaへ`Role:`でアタッチする。

問題は**SAMポリシーテンプレートと混ぜられない**こと。


- [AWS::Serverless::Function - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html)


上の例でいいなら
[Policy Template List - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-template-list.html#secrets-manager-get-secret-value-policy)
がARNで設定できるのでそれを使うのも。
**たぶんほとんどのケースでカバーできると思う**(たぶんね)。

```yaml
Resources:
  SecretTestFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: secret_test/
      Handler: app.lambda_handler
      Runtime: python3.6
      Policies:
      - AWSSecretsManagerGetSecretValuePolicy:
          SecretArn: "arn:aws:secretsmanager:ap-northeast-1:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

ただ、世の中には"LBのルールの順番を入れ替えるlambda"みたいのもあって
さすがにそういうのはポリシーテンプレートにはない。

なんかうまい方法はないですかねえ。


# SAMのアップロード用S3 bucketが同じ名前になるのはなんで?

どこにデータ持ってるのか?
(TODO)


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


# まずはここかから

- [Linux への AWS SAM CLI のインストール \- AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html)
- [チュートリアル: Hello World アプリケーションのデプロイ \- AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-getting-started-hello-world.html)

チュートリアルの翻訳が変。

[AWS SAMCLI コマンドリファレンス \- AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-command-reference.html)

- sam build
- [sam local invoke](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-invoke.html)
- sam local start-api
-
- sam deploy --guided
- sam build

消すのはないので
```sh
aws cloudformation delete-stack --stack-name sam-app-hello-by-heiwa
```
とかで。

[aws\-sam\-cliの新機能 Local Lambda Endpoint と sam logs を試す \- Qiita](https://qiita.com/hayao_k/items/244e74c6c0f8935c2f36)


# API Gatewayにカスタムドメインを


[REST API のカスタムドメイン名を設定する \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/how-to-custom-domains.html)


DomainName
と
CertificateArn
が必須.

`aws acm list-certificates`

Certificate、まずポータルで作ってみる
[AWS Certificate Manager](https://ap-northeast-1.console.aws.amazon.com/acm/)

参考:
- [How to set up a custom domain name for Lambda & API Gateway with Serverless](https://www.serverless.com/blog/serverless-api-gateway-domain)
- [API Gateway API のカスタムドメイン名を定義する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/custom-domain-name-amazon-api-gateway/)
- [REST API のカスタムドメイン名を設定する \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/how-to-custom-domains.html)


けっこう難しかった。とりあえずACM証明書先に作っといてやってみた(若干ディレイがあるのと、そもそも他で証明書作ってる場合がありそうだし)。

[AWS::CertificateManager::Certificate \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html)