# CLIでユーザ

アプリにもよるけど、おおむねこんな感じ

```bash
aws cognito-idp sign-up \
  --client-id <client-id> \
  --username <username> \
  --password <password> \
  --user-attributes '[{"Name": "email", "Value": "<email-address>"}]' \
  --user-pool-id <user-pool-id>
```
(user-attributesは必須項目にあわせて追加)

で、これだとメールが「認証済み」にならない(email_verifiedがいっぺんに設定できない)ので、

```bash
aws cognito-idp admin-update-user-attributes \
  --user-pool-id <user-pool-id> \
  --username <username> \
  --user-attributes '[{"Name": "email_verified", "Value": "true"}]'
```

sign-up はアプリケーションクライアントIDが引数なのに、
admin-update-user-attributes はプールIDが引数。
変だけど本当。

* [sign-up — AWS CLI 2.1.29 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/2.1.29/reference/cognito-idp/sign-up.html)
* [admin-update-user-attributes — AWS CLI 2.9.19 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/admin-update-user-attributes.html)


# ExplicitAuthFlows

[AWS::Cognito::UserPoolClient \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpoolclient.html#cfn-cognito-userpoolclient-explicitauthflows) のところの機械翻訳(+若干人間)

ユーザープールクライアントにサポートさせたい認証フロー。
ユーザープールの各アプリクライアントでは、
ユーザー名とセキュアリモートパスワード(SRP)、
ユーザー名とパスワード、
Lambda関数で定義するカスタム認証プロセスなど、
1つ以上のフローの任意の組み合わせでユーザーにサインインすることができます。

**注意**  
ExplicitAuthFlowsに値を指定しない場合、ユーザークライアントはALLOW_REFRESH_TOKEN_AUTH、
ALLOW_USER_SRP_AUTH、
ALLOW_CUSTOM_AUTH
をサポートします。

有効な値は以下の通り。

- ALLOW_ADMIN_USER_PASSWORD_AUTH :
管理者ベースのユーザーパスワード認証フローADMIN_USER_PASSWORD_AUTHを使用可能にします。この設定は、昔 **ADMIN_NO_SRP_AUTH** と言われていたものと同じです。
この認証フローでは、アプリは、パスワードを安全に送信するためにセキュアリモートパスワード(SRP)プロトコルを使用する代わりに、
リクエスト内でAmazon Cognitoにユーザー名とパスワードを渡します。
- ALLOW_CUSTOM_AUTH :
Lambdaトリガーベースの認証を有効にします。
- ALLOW_USER_PASSWORD_AUTH :
ユーザーパスワードベースの認証を有効にします。
このフローでは、Amazon Cognitoは、SRPプロトコルを使用してパスワードを検証する代わりに、リクエストでパスワードを受信します。
- ALLOW_USER_SRP_AUTH :
SRP ベースの認証を有効にします。
- ALLOW_REFRESH_TOKEN_AUTH :
authflowがトークンをリフレッシュすることを有効にします。

環境によっては、
ADMIN_NO_SRP_AUTH、
CUSTOM_AUTH_FLOW_ONLY、
またはUSER_PASSWORD_AUTH
という値が表示されることがあります。
これらのレガシーな ExplicitAuthFlows の値を、
ALLOW_USER_SRP_AUTHのようにALLOW_で始まる値と同時にユーザープールクライアントに割り当てることはできません。


## セキュアリモートパスワード(SRP)プロトコル

> Secure Remote Password (SRP) プロトコルは Internet Standards Working Group Request For Comments 2945 (RFC2945) で記述された公開鍵交換のハンドシェイクの実装です。

[第13章 セキュアリモートパスワードプロトコル JBoss Enterprise Application Platform 5 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/jboss_enterprise_application_platform/5/html/security_guide/chap-secure_remote_password_protocol)
