# AWS SAM と AWS Lambda のメモ

- [AWS SAM と AWS Lambda のメモ](#aws-sam-と-aws-lambda-のメモ)
  - [outputs をメモするのを忘れたら](#outputs-をメモするのを忘れたら)
  - [template.yaml でリソースを作り、lamda にそれのアクセス権を与える](#templateyaml-でリソースを作りlamda-にそれのアクセス権を与える)
  - [template.yaml で作っていないリソースに対して、lamda にアクセス権を与える](#templateyaml-で作っていないリソースに対してlamda-にアクセス権を与える)
  - [SAM のアップロード用 S3 bucket が同じ名前になるのはなんで?](#sam-のアップロード用-s3-bucket-が同じ名前になるのはなんで)
  - [AWS Lambda と SAM の参考](#aws-lambda-と-sam-の参考)
  - [AWS Lambda 関数のバージョン](#aws-lambda-関数のバージョン)
  - [まずはここかから](#まずはここかから)
  - [API Gateway にカスタムドメインを](#api-gateway-にカスタムドメインを)
  - [CFn の変数](#cfn-の変数)
  - [log](#log)
  - [SAM の template.yaml で Fn::Transeform が使えない](#sam-の-templateyaml-で-fntranseform-が使えない)
  - [SAM の自動テスト](#sam-の自動テスト)
  - [SAM の policy のテンプレート](#sam-の-policy-のテンプレート)
  - [SAM で layer を使う](#sam-で-layer-を使う)
  - [他人の SAM を参考にする](#他人の-sam-を参考にする)
  - [layer](#layer)
    - [注意](#注意)
  - [CloudWatch Events で定期実行する SAM プロジェクト](#cloudwatch-events-で定期実行する-sam-プロジェクト)
  - [テンプレート](#テンプレート)
  - [AWS::Serverless::HttpApi](#awsserverlesshttpapi)
  - [SAM で認証認可が必要な lambda を書く](#sam-で認証認可が必要な-lambda-を書く)
    - [SSL クライアント証明書も使えるらしい](#ssl-クライアント証明書も使えるらしい)
    - [API キー](#api-キー)
    - [Lambda オーソライザー](#lambda-オーソライザー)
    - [Cognito](#cognito)
  - [AWS::Serverless::Function が自動的につくるリソース](#awsserverlessfunction-が自動的につくるリソース)
  - [sam local invoke](#sam-local-invoke)
    - [オプション -n (--env-vars)](#オプション--n---env-vars)
    - [オプション -e (--event)](#オプション--e---event)
    - [オプション --region](#オプション---region)
  - [HelloWorldFunction may not have authorization defined, Is this okay?](#helloworldfunction-may-not-have-authorization-defined-is-this-okay)
  - [Functions の Policies に ManagedPolicy を書く方法](#functions-の-policies-に-managedpolicy-を書く方法)
  - [aws-sam-cli-managed-default というスタック](#aws-sam-cli-managed-default-というスタック)
  - [sam deploy でデプロイする](#sam-deploy-でデプロイする)
  - [AWS::Partition 疑似パラメータ](#awspartition-疑似パラメータ)

## outputs をメモするのを忘れたら

```bash
sam list stack-outputs
## またはJSON形式で出力
sam list stack-outputs --output json
```

list サブコマンドのサブコマンドは他にも

- endpoints- Get a summary of the cloud endpoints in the stack.
- resources - Get a list of resources that will be deployed to...
- stack-outputs - Get the stack outputs as defined in the...

があって、いずれも結構便利。[sam リスト - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-list.html)

## template.yaml でリソースを作り、lamda にそれのアクセス権を与える

例えば「S3 バケツを作って、それに対する読み書きできるようにする」方法

- [AWS SAM Policy Templates - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-templates.html)
- [AWS サーバーレスアプリケーションモデル (AWS SAM) の使用 - AWS Serverless Application Repository](https://docs.aws.amazon.com/ja_jp/serverlessrepo/latest/devguide/using-aws-sam.html)

template.yaml の Resources の部分だけ抜粋

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
論理名 SomeTestFunctionRole が
デフォルトのポリシー`AWSLambdaBasicExecutionRole`に
インラインポリシー`SomeTestFunctionRolePolicy0`を追加して生成される。
(名前は Policy 連番らしい)

上の例の`S3CrudPolicy`が **Policy Template**.

- [Policy Template List - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-template-list.html#cloudwatch-put-metric-policy)

また、`Environment`のところで AWS Lambda 環境変数として
S3 バケット名が生成されるので、
**lambda 中にバケット名をハードコーディングしなくてすむ**。
lamda 側では普通に環境変数とるのと同じように

```python
import os
MY_BUCKET = os.environ['SomeBucket']
```

のように書けば OK

ただ local invoke はめんどうになる。

```bash
SomeBucket=********** sam local invoke
```

みたいにするか、export するか。

参考:

- [AWS SAM がめちゃめちゃアップデートされてる件 – Classmethod サーバーレス Advent Calendar 2017 #serverless #adventcalendar #reinvent ｜ Developers.IO](https://dev.classmethod.jp/server-side/serverless/20171203-updates-about-aws-serverless-application-model/) - ちょっと古いけど参考になる
- [AWS SAM テンプレートを作成する - AWS CodeDeploy](https://docs.aws.amazon.com/ja_jp/codedeploy/latest/userguide/tutorial-lambda-sam-template.html)
- [Lambda 関数で使用できる環境変数 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-environment-variables.html) - デフォルトの環境変数。かぶらないようにする、または意図的にオーバライドする。

## template.yaml で作っていないリソースに対して、lamda にアクセス権を与える

stack 外にあるリソースにアクセスするケース。

案 1:

```yaml
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

管理ポリシー AWSLambdaBasicExecutionRole に
インラインポリシー policy1 を追加したロールを作り、
Lamda へ`Role:`でアタッチする。

問題は**SAM ポリシーテンプレートと混ぜられない**こと。

- [AWS::Serverless::Function - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html)

上の例でいいなら
[Policy Template List - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-policy-template-list.html#secrets-manager-get-secret-value-policy)
が ARN で設定できるのでそれを使うのも。
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

ただ、世の中には"LB のルールの順番を入れ替える lambda"みたいのもあって
さすがにそういうのはポリシーテンプレートにはない。

なんかうまい方法はないですかねえ。

## SAM のアップロード用 S3 bucket が同じ名前になるのはなんで?

どこにデータ持ってるのか?
(TODO)

## AWS Lambda と SAM の参考

- [AWS Lambda 関数を使用する際のベストプラクティス - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/best-practices.html)
- [AWS Lambda 環境変数 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/env_variables.html)
- [Lambda 関数で環境変数のクライアント側を暗号化する - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/tutorial-env_console.html)
- [[アップデート]AWS SAM のデプロイが簡単になりました ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/aws-sam-simplifies-deployment/)
- [AWS SAM を使う前に CloudFormation テンプレートを書こう - Qiita](https://qiita.com/izanari/items/78258251cced2f713b33)

## AWS Lambda 関数のバージョン

- [AWS Lambda 関数のバージョン - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-versions.html)
- [AWS Lambda 関数のエイリアス - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/configuration-aliases.html)
- [AWS Lambda のバージョン管理の仕組み ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/lambda-versioning/)
- [AWS Lambda バージョン管理のススメ - Qiita](https://qiita.com/quotto/items/4c364074edc69cb67d70)
- [TECHSCORE ｜知っておきたかった AWS SAM の小ネタ 4 選 | TECHSCORE BLOG](https://www.techscore.com/blog/2018/12/07/aws-sam-tips/) - `--parameter-overrides`の使い所が参考になる。

## まずはここかから

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

[aws\-sam\-cli の新機能 Local Lambda Endpoint と sam logs を試す \- Qiita](https://qiita.com/hayao_k/items/244e74c6c0f8935c2f36)

## API Gateway にカスタムドメインを

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

けっこう難しかった。とりあえず ACM 証明書先に作っといてやってみた(若干ディレイがあるのと、そもそも他で証明書作ってる場合がありそうだし)。

ACM(AWS Certificate Manager)は

- [\[アップデート\] CloudFormation で AWS Certificate Manager の DNS 検証を自動化できるようになりました \| DevelopersIO](https://dev.classmethod.jp/articles/acm-extends-automation-certificate-issuance-via-cloudformation/)
- [AWS::CertificateManager::Certificate - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-certificatemanager-certificate.html)

ACM もできた。

- create-stack 時に時間が結構掛かる(これ重要)
- delete-stack 時に cname が消えない

IAM と role

[AWS SAM テンプレートのポリシーとロールを使用して Lambda 関数に権限を付与する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/lambda-sam-template-permissions/)

api-id
[API Gateway Amazon リソースネーム \(ARN\) リファレンス \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/arn-format-reference.html)

API ID を得るには

```
aws apigateway get-rest-apis
```

[aws apigateway get\-rest\-apis](https://stackoverflow.com/questions/34433224/how-to-get-the-id-of-a-api-from-aws-api-gateway)

ステージ変数
[Amazon API Gateway のステージ変数の使用 - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/amazon-api-gateway-using-stage-variables.html)

[API Gateway リソースポリシーを使用して API へのアクセスを制御する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-resource-policies.html)

[CustomStatements](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis-resource-policies.html)

## CFn の変数

SAM の`Output:`でスタック変数を設定できるんだけど、これ lambda とかから見えるのか?

`Export`で、クロススタック参照として使う例

- [チュートリアル: 別の AWS CloudFormation スタックのリソース出力を参照する - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/walkthrough-crossstackref.html)
- [出力 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html)

ほかは

- 応答として返す (スタック呼び出しについて記述)
- AWS CloudFormation コンソールで表示する

しかないみたい。

まあ lambda なら Environ で渡せば OK

## log

logGroup の RetentionInDays を設定したいとき。
[amazon cloudwatchlogs - Set expiration of CloudWatch Log Group for Lambda Function - Stack Overflow](https://stackoverflow.com/questions/45364967/set-expiration-of-cloudwatch-log-group-for-lambda-function)

```yaml
Resources:
  # ...
  HelloWorldFunctionLogGroup:
    Type: AWS::Logs::LogGroup
    DependsOn: HelloWorldFunction
    Properties:
      RetentionInDays: 7
      LogGroupName: !Join ["", ["/aws/lambda/", !Ref HelloWorldFunction]]
```

これ LogGroupName がデフォルトと一緒なので、
あとから追加するとエラーになる(スタック消して作りなおし)。

最初に書くか、別のパスにするか。

```yaml
LogGroupName: !Join [
  "/",
  ["/aws/lambda", !Ref AWS::StackName, !Ref HelloWorldFunction],
]
```

みたいにするといいとおもう。

あと Log 書いとくと、stack 消したときにロググループも消えるので便利。
あと RetentionInDays は任意の値を設定できるわけじゃないのに注意。
[AWS::Logs::LogGroup - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-logs-loggroup.html#cfn-logs-loggroup-retentionindays)

> 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653

あと Log 書いとくと、stack 消したときにロググループも消えるので便利。

[【小ネタ】AWS SAM で Lambda 関数を作成する場合は CloudWatch Logs の Log Group も同時に作った方がいいという話 | DevelopersIO](https://dev.classmethod.jp/articles/should-create-cloudwatch-logs-log-group-when-creating-lambda-with-aws-sam/)

## SAM の template.yaml で Fn::Transeform が使えない

少なくとも resource:の下で使おうとすると死ぬ。

どうも SAM から CloudFormation の変換がまるごと Fn::Transeform になってるらしい。

これね。[AWS::Serverless transform - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/transform-aws-serverless.html)

## SAM の自動テスト

参考リンク:

- [[AWS] Lambda 関数のユニットテストをローカル環境で実行してみよう - Qiita](https://qiita.com/herohit-tool/items/68b414fa85b6beea7e50)
- [自動テストとの統合 - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-using-automated-tests.html) - ちょっと違うんだけど参考になる

必要なモジュール(適宜 venv などしてください)

```sh
pip install -r tests/requirements.txt --user -U
## or
pip install pytest pytest-mock mocker moto --user -U
```

`tests/requirements.txt`には boto 入ってるので、そのへんアレンジ

テストの実行

```sh
## ユニットテスト
python -m pytest tests/unit -v
## 統合テスト(deploy後)
AWS_SAM_STACK_NAME=スタック名 python3 -m pytest tests/integration -v
```

integration の方、`sam init`のままだとデフォルト以外の region のサポートがない。
ちょっとコード追加する必要がある。

## SAM の policy のテンプレート

便利。使いそうなやつだいたいある。
[ポリシーテンプレート - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-policy-template-list.html)

## SAM で layer を使う

- [Building layers \- AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/building-layers.html#building-applications-examples)
- [AWS::Serverless::LayerVersion - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-layerversion.html)

あまり layer のことわかってなかったので

- [Creating and sharing Lambda layers - AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html?icmpid=docs_lambda_help)
- [Using layers with your Lambda function - AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/invocation-layers.html)
- [aws-lambda-developer-guide/sample-apps/blank-python at main · awsdocs/aws-lambda-developer-guide](https://github.com/awsdocs/aws-lambda-developer-guide/tree/main/sample-apps/blank-python)

## 他人の SAM を参考にする

基本は
[AWS Serverless Application Model Developer Guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)

GitHub なら [Search · filename:template.yaml AWS::Serverless](https://github.com/search?q=filename%3Atemplate.yaml+AWS%3A%3AServerless) で検索。(わりと玉石混交)

## layer

[AWS::Lambda::LayerVersion - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-layerversion.html#cfn-lambda-layerversion-content)
[Creating and sharing Lambda layers - AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html#invocation-layers-cloudformation)

python3.8 で、このスタックでのみ使うレイヤーを作る例。

まずレイヤーを作る。中身は requests。好きなだけモジュールはまとめられる(サイズ制限があるかも)

```sh
mkdir -p ./layers/python
cd ./layers/python
pip3.8 install -U requests
## ↑ここは必要に応じて変える
cd ..
zip -r python.zip python/
cd ..
```

で、template.yml で

```yaml
resources:
  # 略
  layers:
    Type: AWS::Serverless::LayerVersion
    Properties:
      LayerName: PythonCommon-xGjbVnJyDP0uZ # TODO:名前をなんとかする
      LicenseInfo: MIT
      Description: Dependencies for SAM sample app.
      ContentUri: layers/.
      RetentionPolicy: Delete
      CompatibleRuntimes:
        - python3.8
```

で、この function を使うリソースで、requirements.txt から requests を消して

```yaml
resources:
  # 略
  foobarFunction:
    Properties:
      Layers:
        - !Ref layers
    # 以下略
```

### 注意

layer の中身なんかが変わるたびに、あたらしいバージョンが増えていく。
prod と devel 的なことができるわけだけど、気がついたらサイズがすごいことになるかもしれない。

## CloudWatch Events で定期実行する SAM プロジェクト

[CloudWatch Events アプリケーションの AWS SAM テンプレート - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/with-scheduledevents-example-use-app-spec.html)

こんなかんじで OK

```yaml
Resources:
  HelloWorldFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: hello_world/
      Handler: app.lambda_handler
      Runtime: python3.8
      Events:
        HelloWorldScheduledEvent:
          Type: Schedule
          Properties:
            Schedule: rate(1 minute)
```

いま気がついたんだけど`Events:`って複数イベント書けそう。
定期実行と URL で実行を 1 つの関数でできるのでは。

- [Python の Lambda 関数ハンドラー - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/python-handler.html)

あと API Gateway がない SAM プロジェクトだと

```sh
sam local start-api
```

は動かない。

> Error: Template does not have any APIs connected to Lambda functions

とか言われます。

## テンプレート

sam init で

```termianl
AWS quick start application templates:
        1 - Hello World Example
        2 - EventBridge Hello World
        3 - EventBridge App from scratch (100+ Event Schemas)
        4 - Step Functions Sample App (Stock Trader)
        5 - Elastic File System Sample App
Template selection:
```

って出るやつ。

[aws/aws-sam-cli-app-templates](https://github.com/aws/aws-sam-cli-app-templates)

例えば `Hello World Example` はこれ。(Python 3.8 版)
[aws\-sam\-cli\-app\-templates/python3\.8/cookiecutter\-aws\-sam\-hello\-python/\{\{cookiecutter\.project_name\}\} at master · aws/aws\-sam\-cli\-app\-templates](https://github.com/aws/aws-sam-cli-app-templates/tree/master/python3.8/cookiecutter-aws-sam-hello-python/%7B%7Bcookiecutter.project_name%7D%7D)

4 番の「Stock Trader」がおもしろそう
[を使用して Step Functions ステートマシンを作成する AWS SAM - AWS Step Functions](https://docs.aws.amazon.com/ja_jp/step-functions/latest/dg/tutorial-state-machine-using-sam.html)

## AWS::Serverless::HttpApi

- [HTTP API と REST API 間で選択する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-vs-rest.html)
- [AWS::Serverless::HttpApi \- AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-httpapi.html)
- [Amazon API Gateway HTTP API チュートリアル - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-http-tutorials.html)
- [HTTP API の操作 - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api.html)

## SAM で認証認可が必要な lambda を書く

SAM がどうこう以前に、API Gateway の認証認可がややこしい。

使える認証一覧

- [Controlling access to API Gateway APIs - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis.html)
- [API Gateway での HTTP API へのアクセスの制御と管理 - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-access-control.html)
- [API Gateway での REST API へのアクセスの制御と管理 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-control-access-to-api.html)

HTTP API にはリソースポリシー(IP 元で制限)がないのか... そもそも https でもないし、とりあえず REST API から調べる。

### SSL クライアント証明書も使えるらしい

- [API Gateway にクライアント証明書による認証を設定してみる | DevelopersIO](https://dev.classmethod.jp/articles/api-gateway-support-mutual-tls-auth/)
- [Amazon API Gateway が相互 TLS 認証のサポートを開始](https://aws.amazon.com/jp/about-aws/whats-new/2020/09/amazon-api-gateway-supports-mutual-tls-authentication/)
- [REST API の相互 TLS 認証の設定 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/rest-api-mutual-tls.html)
- [HTTP API の相互 TLS 認証の設定 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-mutual-tls.html)
- [【図解】mutual\-TLS \(mTLS, 2way TLS\),クライアント認証とトークンバインディング over http \| SE の道標](https://milestone-of-se.nesuke.com/nw-basic/tls/mutual-tls-token-binding/)
- [Automating mutual TLS setup for Amazon API Gateway \| AWS Compute Blog](https://aws.amazon.com/jp/blogs/compute/automating-mutual-tls-setup-for-amazon-api-gateway/)

ACM でプライベート CA つくって、クライアント証明書だせるのか...

- [AWS::ACMPCA::CertificateAuthority](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-acmpca-certificateauthority-subject.html)
- [ACM プライベート CA とは何ですか。 - AWS Certificate Manager Private Certificate Authority](https://docs.aws.amazon.com/ja_jp/acm-pca/latest/userguide/PcaWelcome.html)
- [プライベート証明書の取得 - AWS Certificate Manager Private Certificate Authority](https://docs.aws.amazon.com/ja_jp/acm-pca/latest/userguide/PcaGetCert.html)

ただなんだか値段が高いらしい(ひとつにつき、400USD/月。[\[新機能\]ACM Private Certificate Authority を試してみた \| DevelopersIO](https://dev.classmethod.jp/articles/tried-acm-private-certificate-authority/))ので CA.pl で地道にやる。

### API キー

- [API キーの例 - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis-keys.html)
- [API key example - AWS Serverless Application Model](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis-keys.html)
- [ApiFunctionAuth - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-property-function-apifunctionauth.html)
- [amazon web services - Can you create Usage Plan with Cloud Formation? - Stack Overflow](https://stackoverflow.com/questions/39910734/can-you-create-usage-plan-with-cloud-formation)

Usage Plan って何?

- [API Gateway の API キーと使用量プランについて調べてみた | DevelopersIO](https://dev.classmethod.jp/articles/try-api-gateway-usage-plan/)

ApiKey 意外とむずかしい。
Lambda オーソライザーか cognito のほうが楽かも...調べる

(戻ってきた)
API キーがなぜ API Gateway のオーソライザーの中にないか? どうもこれは OpenAPI(swaggr)の規格だかららしい。
[API キーを使用する理由と条件  |  OpenAPI を使用した Cloud Endpoints  |  Google Cloud](https://cloud.google.com/endpoints/docs/openapi/when-why-api-key?hl=ja) ← これわかりやすい。Google の翻訳は良い。

↑ から引用 ↓

- API キーは、API の呼び出し元のプロジェクト（アプリケーションまたはサイト）を識別します。
- 認証トークンは、アプリまたはサイトを利用するユーザー（個人）を識別します

### Lambda オーソライザー

[API Gateway Lambda オーソライザーを使用する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html)
[Lambda オーソライザー - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis-lambda-authorizer.html)
ほか参考
[AWS SAM を利用して API Gateway と Lambda Authorizer\(Golang\)の構築をやってみた \- カミナシ開発者ブログ](https://kaminashi-developer.hatenablog.jp/entry/2021/03/30/111529)
[API Gateway Lambda オーソライザーでアクセス制御する - Qiita](https://qiita.com/favolabo/items/369631ca7696fad9307a)

- TOKEN オーソライザー
- REQUEST オーソライザー

> トークンベース の Lambda オーソライザー (TOKEN オーソライザーとも呼ばれる) は、JSON ウェブトークン (JWT) や OAuth トークンなどのベアラートークンで発信者 ID を受け取ります。
> リクエストパラメータベースの Lambda オーソライザー (REQUEST オーソライザーとも呼ばれます) は、ヘッダー、クエリ文字列パラメータ、stageVariables、および $context 変数の組み合わせで発信者 ID を受け取ります。

WebSocket API では、リクエストパラメータベースのオーソライザーのみがサポートされています。

まずこれからやってみる。
[API Gateway Lambda オーソライザーを使用する \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html#api-gateway-lambda-authorizer-create)

ex1-lambda-authorizer TOKEN
ex2-lambda-authorizer REQUEST
PetStore (6059g6rlr4) [チュートリアル: サンプルをインポートして REST API を作成する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-create-api-from-example.html)

JWT(JSON Web Token ジョット)
[rfc7519](https://datatracker.ietf.org/doc/html/rfc7519)

だいたいわかったと思う。
REQUEST オーソライザーのほうがかんたんなので、
なにか特殊なヘッダを追加してやらないとエラーになる lambda を書いてみる。

サンプルはここにある。けど TOKEN だけだな。
[GitHub - awslabs/aws-apigateway-lambda-authorizer-blueprints: Blueprints and examples for Lambda-based custom Authorizers for use in API Gateway.](https://github.com/awslabs/aws-apigateway-lambda-authorizer-blueprints)

レスポンスを組み立てるのがめんどくさそう。

- [Amazon API Gateway Lambda オーソライザーへの入力 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-lambda-authorizer-input.html) - TOKEN と REQUEST
- [Amazon API Gateway Lambda オーソライザーからの出力 \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-lambda-authorizer-output.html) - 共通らしい

その前に Cognito 調べてみる。

(戻ってきた)
これを参考に SAM 書いてみる
[API Gateway の Lambda オーソライザーから後続の Lambda にデータを引き渡す | DevelopersIO](https://dev.classmethod.jp/articles/lambda-authorizer/)

### Cognito

[Amazon Cognito ユーザープールをオーソライザーとして使用して REST API へのアクセスを制御する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html)

> API で Amazon Cognito ユーザープールを使用するには、COGNITO_USER_POOLS タイプのオーソライザーを作成してから、そのオーソライザーを使用する API メソッドを構成する

[ユーザープールの開始方法。 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/getting-started-with-cognito-user-pools.html)
[ユーザーアカウントのサインアップと確認 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/signing-up-users-in-your-app.html)
[管理者としてのユーザーアカウントの作成 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/how-to-create-user-accounts.html)

もっとかんたんかと思ったら異常にめんどくさい。

## AWS::Serverless::Function が自動的につくるリソース

指定すればそれになるけど、指定しない場合は自動でつくってくれるのが
`ServerlessRestApi`などだけど、これのドキュメントが見当たらないのでさがしてみた。

[Fix Documentation: Document the default LogicalIds created by SAM · Issue #70 · aws/serverless-application-model](https://github.com/aws/serverless-application-model/issues/70)

なんかこれしか見つからない... 困ったもんだ。

CFn の分はここに。
[擬似パラメータ参照 - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html)

## sam local invoke

[sam local invoke - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-local-invoke.html)

### オプション -n (--env-vars)

[関数のローカルでの呼び出し - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html#serverless-sam-cli-using-invoke-environment-file)

これはわかりやすい。lambda に環境変数で何か渡してる場合はここで設定。

### オプション -e (--event)

内部で url 見てルーティングしてる時など。必要なとこだけあれば OK

### オプション --region

sam local invoke は
samconfig.toml に書いてある region を見てくれない。

## HelloWorldFunction may not have authorization defined, Is this okay?

じゃあなにをすればこれを聞かれないのか? という話
[AWS SAM HelloWorldFunction may not have authorization defined, Is this okay - Google Search](https://www.google.com/search?q=AWS+SAM+HelloWorldFunction+may+not+have+authorization+defined%2C+Is+this+okay&hl=en)

AWS::Serverless::Api の Auth プロパティを設定する。
AWS::Serverless::Function の Events:の Type:Api でも。
(していできるものがちがう)

> API でグローバルオーソライザーを指定しており、特定の関数を公開する場合は、Authorizer を NONE に設定して上書きします。

- [AWS::Serverless::Api - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-resource-api.html#sam-api-auth)
- [API Gateway API へのアクセスの制御 - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis.html)
- [ApiAuth - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-property-api-apiauth.html)
- [Api \- AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/sam-property-function-api.html#sam-function-api-auth)
- [Lambda オーソライザーの例 - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-controlling-access-to-apis-lambda-authorizer.html)
- [API Gateway Lambda オーソライザーを使用する - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html)

めんどくさいときは実は None が指定できるらしい
[How to set authorization to queryESFunction in Amazon ElasticSearch while deploying the application? - Stack Overflow](https://stackoverflow.com/questions/64414472/how-to-set-authorization-to-queryesfunction-in-amazon-elasticsearch-while-deploy)
→
やってみたらできませんでした。Invalid value for 'Auth' property

## Functions の Policies に ManagedPolicy を書く方法

AWS::Serverless::Function の Properties: で

```yaml
Policies:
  # AWS管理ポリシーは文字列を書く
  ## - AWSLambdaBasicExecutionRole は自動で追加される
  - AWSLambdaExecute
  # AWS SAMポリシーテンプレート書く
  - CloudWatchPutMetricPolicy: {}
  # このテンプレートのユーザ管理ポリシーは!Refで書く
  - !Ref SomeManagedPolicy1
  - !Ref SomeManagedPolicy2
  # inline policyを書く
  - Statement:
      - Condition: ...
        Action: ...
        Resouce: ...
        Effect: Allow
```

(順不同)

参考:

- [AWS SAM ポリシーテンプレート - AWS Serverless Application Model](https://docs.aws.amazon.com/ja_jp/serverless-application-model/latest/developerguide/serverless-policy-templates.html)
- [Possible to attach customer-managed policies? · Issue #76 · aws/serverless-application-model](https://github.com/aws/serverless-application-model/issues/76)
- [AWS SAM がめちゃめちゃアップデートされてる件 – Classmethod サーバーレス Advent Calendar 2017 #serverless #adventcalendar #reinvent | DevelopersIO](https://dev.classmethod.jp/articles/20171203-updates-about-aws-serverless-application-model/)

## aws-sam-cli-managed-default というスタック

aws-sam-cli-managed-default というスタックがあるか?
aws-sam-cli-managed-default には S3 bucket とその policy の 2 個。
その S3 bucket に SAM が入る。

aws-sam-cli-managed-default スタックがあれば
output の SourceBucket からバケット名を得る、みたいな感じらしい。

このスタックがなくても SAM は S3 バケットを作る。
バケット名のポストフィックスの乱数みたいのが何からできてるかよくわからん。

> Saved arguments to config file
> Running 'sam deploy' for future deployments will use the parameters saved above.
> The above parameters can be changed by modifying samconfig.toml
> Learn more about samconfig.toml syntax at
> <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-config.html>

## sam deploy でデプロイする

`sam build` できない環境で(たとえば target が python 3.8 なのに 3.7 しかない)、
さらに
`sam deploy --guided` もできない環境で (aws-sam-cli-managed-default スタックが作れない & SAM の S3 バケットがわからない)
sam の project を zip でかためたやつを持っていって `sam deploy`する話。

`sam build`はあらかじめやっておく。で zip。

SAM の S3 バケットは、

aws-sam-cli-managed-default stack はあるか。

なければ

```json
{
  "AWSTemplateFormatVersion": "2010-09-09",
  "Transform": "AWS::Serverless-2016-10-31",
  "Description": "Managed Stack for AWS SAM CLI",
  "Metadata": {
    "SamCliInfo": {
      "version": "1.33.0",
      "installationId": "c61a8b52-fb4c-4488-a5ea-de314c54ad2b"
    }
  },
  "Resources": {
    "SamCliSourceBucket": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "VersioningConfiguration": { "Status": "Enabled" },
        "Tags": [{ "Key": "ManagedStackSource", "Value": "AwsSamCli" }]
      }
    },
    "SamCliSourceBucketBucketPolicy": {
      "Type": "AWS::S3::BucketPolicy",
      "Properties": {
        "Bucket": { "Ref": "SamCliSourceBucket" },
        "PolicyDocument": {
          "Statement": [
            {
              "Action": ["s3:GetObject"],
              "Effect": "Allow",
              "Resource": {
                "Fn::Join": [
                  "",
                  [
                    "arn:",
                    { "Ref": "AWS::Partition" },
                    ":s3:::",
                    { "Ref": "SamCliSourceBucket" },
                    "/*"
                  ]
                ]
              },
              "Principal": { "Service": "serverlessrepo.amazonaws.com" },
              "Condition": {
                "StringEquals": {
                  "aws:SourceAccount": { "Ref": "AWS::AccountId" }
                }
              }
            }
          ]
        }
      }
    }
  },
  "Outputs": { "SourceBucket": { "Value": { "Ref": "SamCliSourceBucket" } } }
}
```

こんなテンプレートで aws-sam-cli-managed-default stack を作る。
<https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/using-cfn-cli-creating-stack.html>

aws-sam-cli-managed-default stack の output の SourceBucket からバケット名をとる。

という手順で。

でこれで samconfig.toml を書き換えて、`sam deploy`。

`sam deploy --guided` は便利なんだが、対話的にオペレーションが必要。\
`sam deploy` だと SAM の S3 バケットがあったりなかったりしてうまくいかない。

非対話にしたい場合は、

1. samconfig.toml から s3_bucket="..."を取り除いて
2. `sam deploy --resolve-s3`

でいける。`aws-sam-cli-managed-default` stack も(つまり SAM 用 S3 バケットも)つくってくれる。

ただし、上の手法だと samconfig.toml にバケット名を書き戻してくれないので、

- 毎回 `--resolve-s3` つきで deploy
- または手で samconfig.toml に書き込む
- または 1 回だけ`sam deploy --guided` (samconfig.toml を更新してくれる)

のいずれかを実行すること。

## AWS::Partition 疑似パラメータ

[AWS::Partition](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html#cfn-pseudo-param-partition)

意外と重要かもしれない。
template.yaml に "aws:" って書いてあるところ全部治すべき。

似たものに
[AWS::URLSuffix](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/pseudo-parameter-reference.html#cfn-pseudo-param-urlsuffix)
がある、こっちはあんまりないかも。
