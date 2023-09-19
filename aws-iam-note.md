# policyのprincipal

- ワイルドカードは使えない(匿名アクセスを除く)。
- 匿名アクセスは `*`
- AWSアカウントのルートユーザー(
  `arn:aws:iam::123456789012:root` or `123456789012`)を指定すると「123456789012の全ユーザ」の意味になる。
  `arn:aws:iam::123456789012:user/*`(こういう指定はできない)
  的な感じ。理屈に合わないが本当。
- `arn:aws:iam::123456789012:group/`が無い。
- リソースによって指定できるprincipalパターンが微妙に違う。

参考:

- [AWS JSON ポリシーの要素: Principal \- AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_principal.html)
- [Principals - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/s3-bucket-user-policy-specifying-principal-intro.html)
- [例 3: バケット所有者が自分の所有していないオブジェクトに対するアクセス許可を付与する - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example3.html)

まとめると、「あまりふくざつなことはできない」ということですね。

- 制限なし(匿名アクセス,パブリックアクセス)
- AWSアカウント(複数可)
- AWSユーザ(複数可)

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
- すべてのプリンシパル - '\*'

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

# allow1個で、それ以外はdeny?

[ポリシーの評価論理 - AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)

(chatGPT曰く)

Q. AWS IAM Policyのステートメントでallowを1個記述した場合、それ以外のケースはDenyになりますか?

AWS IAMポリシーには、明示的に許可するリソースや操作を指定する「Allowステートメント」と、明示的に拒否するリソースや操作を指定する「Denyステートメント」があります。

IAMポリシーに複数のステートメントが含まれている場合、これらのステートメントは順番に処理されます。最初にマッチするステートメントが適用されます。

つまり、IAMポリシーにAllowステートメントだけが含まれている場合、それ以外のリソースや操作は自動的に拒否されます。一方、IAMポリシーにDenyステートメントだけが含まれている場合、それ以外のリソースや操作は自動的に許可されます。

ただし、複数のAllowステートメントが含まれている場合、それらはAND条件で評価されます。つまり、すべてのAllowステートメントがマッチしなければ、リソースや操作は拒否されます。

同様に、複数のDenyステートメントが含まれている場合、それらはOR条件で評価されます。つまり、どれか1つのDenyステートメントがマッチすれば、リソースや操作は拒否されます。

したがって、IAMポリシーにAllowステートメントだけが含まれている場合、それ以外のリソースや操作は自動的に拒否されますが、Denyステートメントが存在する場合はそれによって拒否される可能性があります。同様に、Denyステートメントだけが含まれている場合、それ以外のリソースや操作は自動的に許可されますが、Allowステートメントが存在する場合はそれによって許可される可能性があります。

AWS IAM（Identity and Access Management）ポリシーの評価ロジックについては、以下のように要約することができます。

IAMポリシーは、AWSリソースへのアクセスを制御するために使用されます。

IAMポリシーには、「Allow」と「Deny」の2つの許可要素があります。ただし、「Deny」は必ずしも必要ではありません。

ポリシーは、昇順で評価されます。つまり、最初に一致したポリシーが適用されます。

ポリシーは、次の順序で評価されます。
a. Explicit Deny
b. Explicit Allow
c. Implicit Deny

Explicit Denyは、ユーザーに明示的に拒否される操作に対して使用されます。このタイプのポリシーが最初に評価され、一致する場合は拒否されます。

Explicit Allowは、ユーザーに明示的に許可される操作に対して使用されます。このタイプのポリシーが2番目に評価されます。

Implicit Denyは、IAMポリシーに記載されていない操作に対して使用されます。つまり、その他の操作はすべて拒否されます。

ポリシーが複数ある場合は、一致するポリシーが最初に評価されます。

最終的に、許可されたアクションのみが実行され、拒否されたアクションは実行されません。

以上が、AWS IAMポリシーの評価ロジックの要約です。

Explicit Deny、Explicit Allow、Implicit Denyは、AWS IAM（Identity and Access Management）ポリシーにおける3つの許可要素の種類を表します。

Explicit Deny：このタイプのポリシーは、ユーザーに明示的に拒否される操作に対して使用されます。つまり、このタイプのポリシーを使用すると、ユーザーが明示的に拒否されたリソースへのアクセスを制限することができます。

Explicit Allow：このタイプのポリシーは、ユーザーに明示的に許可される操作に対して使用されます。つまり、このタイプのポリシーを使用すると、ユーザーが特定のリソースにアクセスできるようにすることができます。

Implicit Deny：このタイプのポリシーは、IAMポリシーに記載されていない操作に対して使用されます。つまり、ポリシーに記載されていない操作はすべて拒否されます。IAMポリシーに許可されていない操作に対しては、このタイプのポリシーが使用されます。

これら3つの要素は、AWS IAMポリシーを評価する際に使用され、ポリシーに記載されたアクションに対するユーザーの許可または拒否を決定します。IAMポリシーは、評価ロジックに従って昇順で評価され、最初に一致した要素が適用されます。Explicit Deny、Explicit Allow、Implicit Denyの特性について理解することで、AWS IAMポリシーを効果的に使用することができます。
