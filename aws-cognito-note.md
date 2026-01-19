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

(user-attributes は必須項目にあわせて追加)

で、これだとメールが「認証済み」にならない(email_verified がいっぺんに設定できない)ので、

```bash
aws cognito-idp admin-update-user-attributes \
  --user-pool-id <user-pool-id> \
  --username <username> \
  --user-attributes '[{"Name": "email_verified", "Value": "true"}]'
```

sign-up はアプリケーションクライアント ID が引数なのに、
admin-update-user-attributes はプール ID が引数。
変だけど本当。

- [sign-up — AWS CLI 2.1.29 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/2.1.29/reference/cognito-idp/sign-up.html)
- [admin-update-user-attributes — AWS CLI 2.9.19 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/cognito-idp/admin-update-user-attributes.html)

# ExplicitAuthFlows

[AWS::Cognito::UserPoolClient \- AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-cognito-userpoolclient.html#cfn-cognito-userpoolclient-explicitauthflows) のところの機械翻訳(+若干人間)

ユーザープールクライアントにサポートさせたい認証フロー。
ユーザープールの各アプリクライアントでは、
ユーザー名とセキュアリモートパスワード(SRP)、
ユーザー名とパスワード、
Lambda 関数で定義するカスタム認証プロセスなど、
1 つ以上のフローの任意の組み合わせでユーザーにサインインすることができます。

**注意**\
ExplicitAuthFlows に値を指定しない場合、ユーザークライアントは ALLOW_REFRESH_TOKEN_AUTH、
ALLOW_USER_SRP_AUTH、
ALLOW_CUSTOM_AUTH
をサポートします。

有効な値は以下の通り。

- ALLOW_ADMIN_USER_PASSWORD_AUTH :
  管理者ベースのユーザーパスワード認証フローADMIN_USER_PASSWORD_AUTH を使用可能にします。この設定は、昔 **ADMIN_NO_SRP_AUTH** と言われていたものと同じです。
  この認証フローでは、アプリは、パスワードを安全に送信するためにセキュアリモートパスワード(SRP)プロトコルを使用する代わりに、
  リクエスト内で Amazon Cognito にユーザー名とパスワードを渡します。
- ALLOW_CUSTOM_AUTH :
  Lambda トリガーベースの認証を有効にします。
- ALLOW_USER_PASSWORD_AUTH :
  ユーザーパスワードベースの認証を有効にします。
  このフローでは、Amazon Cognito は、SRP プロトコルを使用してパスワードを検証する代わりに、リクエストでパスワードを受信します。
- ALLOW_USER_SRP_AUTH :
  SRP ベースの認証を有効にします。
- ALLOW_REFRESH_TOKEN_AUTH :
  authflow がトークンをリフレッシュすることを有効にします。

環境によっては、
ADMIN*NO_SRP_AUTH、
CUSTOM_AUTH_FLOW_ONLY、
またはUSER_PASSWORD_AUTH
という値が表示されることがあります。
これらのレガシーな ExplicitAuthFlows の値を、
ALLOW_USER_SRP_AUTHのようにALLOW*で始まる値と同時にユーザープールクライアントに割り当てることはできません。

## セキュアリモートパスワード(SRP)プロトコル

> Secure Remote Password (SRP) プロトコルは Internet Standards Working Group Request For Comments 2945 (RFC2945) で記述された公開鍵交換のハンドシェイクの実装です。

[第13章 セキュアリモートパスワードプロトコル JBoss Enterprise Application Platform 5 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/jboss_enterprise_application_platform/5/html/security_guide/chap-secure_remote_password_protocol)

# AWS CognitoをOAuthで使うときのスコープメモ

- [ユーザープールのアプリケーションクライアントの設定 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/cognito-user-pools-app-idp-settings.html) の「許可されている OAuth スコープ」のところ
- [CognitoユーザープールのOAuthスコープ 5パターン | Awstut](https://awstut.com/2022/04/03/cognito-userpool-oauth-scopes/)

スコープが 5 つ(+カスタムスコープ)しかない(とその組み合わせ)。

- Google の場合 - [OAuth 2.0 Scopes for Google APIs  |  Authorization  |  Google Developers](https://developers.google.com/identity/protocols/oauth2/scopes) たくさんあるなあ。この URL っぽいのがスコープ。
- GitHub - [Scopes for OAuth Apps - GitHub Docs](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps) これもたくさんある。
- それ以外では https://oauth.net/2/scope/ からリンクが。

認可サーバ(Cognito の user pool)側で許可するスコープをスペースで区切って設定。
リソースオーナーの認可リクエストでほしいスコープをスペースで区切って要求。
(あたりまえなんだけど、それにもかかわらず間違えたのでメモ)

で、スコープが 5 つしかないので
「S3 読みたい」とかは OAuth でもらったアクセストークンからは出来ない。

ID トークンと STS の
[AssumeRoleWithWebIdentityCommand | STS Client - AWS SDK for JavaScript v3](https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-sts/classes/assumerolewithwebidentitycommand.html)
から session token(とその他)を得て、これをつかって API にアクセスする。

ChatGPT にざっくり書いてもらった AWS SDK for Javascript v3 での例。
id token から、session token(とその他)を得て、S3 バケットからで

(実際に動かしてません。かなり間違ってる)

```javascript
const { S3Client } = require("@aws-sdk/client-s3");
const { StsClient } = require("@aws-sdk/client-sts");

// Initialize the STS client
const sts = new StsClient({
  region: "<region>",
  credentials: {
    accessKeyId: "<accessKeyId>",
    secretAccessKey: "<secretAccessKey>",
  },
});

// Assume a role with the web identity token
const assumeRoleWithWebIdentity = async () => {
  const params = {
    RoleArn: "<roleArn>",
    RoleSessionName: "<roleSessionName>",
    WebIdentityToken: "<webIdentityToken>",
    DurationSeconds: 3600,
  };

  try {
    const data = await sts.assumeRoleWithWebIdentity(params).promise();
    const accessKeyId = data.Credentials.AccessKeyId;
    const secretAccessKey = data.Credentials.SecretAccessKey;
    const sessionToken = data.Credentials.SessionToken;

    // Initialize the S3 client with the assumed role credentials
    const s3 = new S3Client({
      region: "<region>",
      credentials: {
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        sessionToken: sessionToken,
      },
    });

    // Read an object from S3
    const result = await s3
      .getObject({
        Bucket: "<bucketName>",
        Key: "<objectKey>",
      })
      .promise();

    console.log(result);
  } catch (error) {
    console.error(error);
  }
};

assumeRoleWithWebIdentity();
```

AWS CLI だと

```bash
aws sts assume-role-with-web-identity \
    --role-arn <ARN of the IAM Role> \
    --role-session-name <Session name> \
    --web-identity-token <ID Token obtained from Cognito> \
    --duration-seconds <Session duration in seconds>
```

[assume-role-with-web-identity — AWS CLI 2.9.23 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/assume-role-with-web-identity.html)
のところの機械翻訳

モバイルアプリケーションあるいはウェブアプリケーションで、 ウェブ ID プロバイダによる認証を受けたユーザの一時的なセキュリティ証明書のセットを返します。プロバイダの例としては、OAuth 2.0 プロバイダの Login with Amazon や Facebook、 あるいは Google や Amazon Cognito federated identities などの OpenID Connect 互換の ID プロバイダがあります。

この API が返す一時的なセキュリティ認証情報は、アクセスキー ID、シークレットアクセスキー、およびセキュリティトークンで構成されます。アプリケーションは、これらの一時的なセキュリティ証明書を使用して、Amazon Web Services サービス API 操作の呼び出しに署名することができます。
