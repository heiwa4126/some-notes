# policyのprincipal

* ワイルドカードは使えない(匿名アクセスを除く)。
* 匿名アクセスは `*`
* AWSアカウントのルートユーザー(
    `arn:aws:iam::123456789012:root` or `123456789012`)を指定すると「123456789012の全ユーザ」の意味になる。
`arn:aws:iam::123456789012:user/*`(こういう指定はできない)
 的な感じ。理屈に合わないが本当。
* `arn:aws:iam::123456789012:group/`が無い。
* リソースによって指定できるprincipalパターンが微妙に違う。

参考:
* [AWS JSON ポリシーの要素: Principal \- AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_principal.html)
* [Principals - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/s3-bucket-user-policy-specifying-principal-intro.html)
* [例 3: バケット所有者が自分の所有していないオブジェクトに対するアクセス許可を付与する - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example3.html)


まとめると、「あまりふくざつなことはできない」ということですね。

* 制限なし(匿名アクセス,パブリックアクセス)
* AWSアカウント(複数可)
* AWSユーザ(複数可)

これに加えてS3では


# ロールの信頼ポリシーとはなにか

AssumeRolePolicyDocument

- ポリシー - わかる
- ロール - ポリシーをまとめたやつ - わかる
- ロールの信頼ポリシー? - わからん


信頼ポリシー(trust policy): 「指定された条件でこのロールを引き受けることができるエンティティ(Trusted entities)」

[AWS のサービスにアクセス許可を委任するロールの作成 - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_create_for-service.html)

> サービスがお客様に代わってアクションを実行するために引き受けるロールは、[サービスロール](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_terms-and-concepts.html#iam-term-service-role)と呼ばれます


他に 
[AWS サービスにリンクされたロール](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_terms-and-concepts.html#iam-term-service-role)
がある。サービスにデフォルトでついてるロール? だと思えばいいのかな。

これがわかりやすいか?
[AWS IAMポリシーを理解する | DevelopersIO](https://dev.classmethod.jp/articles/aws-iam-policy/)

- ユーザーベースのポリシー
- リソースベースのポリシー - Principalがあるやつ。例として「バケットポリシー」
- IAMロールの信頼ポリシー - Principalがあるやつ。IAMロールの権限移譲操作に特化したポリシー

> リソースベースのポリシーはS3等の一部のAWSサービスのみに対応しています。
> 対応しているAWSサービスは [IAM と連携する AWS サービス](http://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html) の表において、「リソースベース」がYesになっている行です。

これわかりやすい

- [IAMロール徹底理解 〜 AssumeRoleの正体 | DevelopersIO](https://dev.classmethod.jp/articles/iam-role-and-assumerole/)
- [IAM ロールの PassRole と AssumeRole をもう二度と忘れないために絵を描いてみた | DevelopersIO](https://dev.classmethod.jp/articles/iam-role-passrole-assumerole/)

ほとんどの場合は自分のサービスを書いとけばOK。
たとえば AWS Lambda だったら、

- AWS gatewayから起動されることを許可する
- CloudWatchにlogを書く(ロググループをつくる、ログストリームを作る、ログストリームに書き込む、が最低必要)ことを許可する

「AWS gatewayから起動される」方は
リソースベースのポリシーで
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "lambda:InvokeFunction",
      "Resource": "自分(lambda)のarn”
    }
  ]
}
```
みたいのを。

CloudWatchにlogを書く方は AssumeRolePolicyDocument に
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```
と書かれたロールを与えてやれば(自分がlambdaだから絶対適応される)
「だいたいの場合」OKで、

これに対して、「invokeには Facebookユーザを信頼する」みたいのをリソースベースポリシー追加していく感じ。

...リソースに対してロールじゃなくてポリシーを設定できるようになってればよかったのでは。
ロールにする理由がわかったら追記。

- [AWS Lambda のリソースベースのポリシーを使用する - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/access-control-resource-based.html)
- [AWS Lambda 実行ロール - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-intro-execution-role.html)
- もう1つ - [AWS Lambda アプリケーションに対するアクセス許可の境界の使用 - AWS Lambda](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/permissions-boundary.html)

# Principalに指定できるもの

[AWS JSON ポリシーの要素: Principal - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_principal.html)

まとめるのは難しいので、↑を読む。

- AWSアカウント・プリンシパル - (IAMユーザではなくて)AWSアカウントにいるIAMユーザ全員
- IAM ユーザープリンシパル - 特定のIAMユーザ
- IAM ロールプリンシパル - 特定のIAMロール
- すべてのプリンシパル - '*'
  
あとはよくわからん。

# statementが複数あったとき、それらはorなの?

orらしい?

[複数の否定条件を使ったS3バケットポリシーを正しく理解してますか？ | DevelopersIO](https://dev.classmethod.jp/articles/s3-bucket-policy-multi-condition/)

デフォルトは allowなのdenyなの? 

[ポリシーの評価論理 - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_evaluation-logic.html) ... わからん。

やさしい解説。
[IAM 評価論理ファン必見！AWS ドキュメントにリソースベースポリシー評価論理のプリンシパルごとの違いが記載されました | DevelopersIO](https://dev.classmethod.jp/articles/policies-evaluation-logic-resource-base-policy/) ... わからん。


サンプルがあってよかった。
[アイデンティティベースのポリシーおよびリソースベースのポリシーの評価の例](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_evaluation-logic.html#policies_evaluation_example)


# RBAC, ABAC

- 役割ベースのアクセス制御 (RBAC: Role-Based Access Control)
- 属性ベースのアクセス制御（ABAC: Attribute-Based Access Control)

- [AWSにおけるABACの嬉しさ、辛さを語りました #AKIBAAWS | DevelopersIO](https://dev.classmethod.jp/articles/akibaaws-06-iam-abac/)
- 


# AWS管理ポリシーを検索したり中身を見たり

個別に出すのは簡単なんだけど、フィルタでタイプがURLに入らないとかあって、一覧はめんどくさい。CLIなら。
