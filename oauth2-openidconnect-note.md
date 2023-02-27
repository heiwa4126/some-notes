OpenID Connect(OIDC)とOAuth2メモ

- [OpenID ConnectとOAuth2を理解する](#openid-connectとoauth2を理解する)
- [プロバイダ](#プロバイダ)
- [クライアント側](#クライアント側)
  - [Flaskの例](#flaskの例)
- [OpenID Connect(OIDC)とOAuth2のちがい](#openid-connectoidcとoauth2のちがい)
- [OIDCのエンドポイント](#oidcのエンドポイント)
  - [認可エンドポイント(Authorization Endpoint)](#認可エンドポイントauthorization-endpoint)
  - [トークンエンドポイント(Token Endpoint)](#トークンエンドポイントtoken-endpoint)
  - [リダイレクションエンドポイント(Redirection Endpoint)](#リダイレクションエンドポイントredirection-endpoint)
- [おまけ](#おまけ)
- [AWSでApiGWとCognitoでOAuth2](#awsでapigwとcognitoでoauth2)
  - [Amazon API GatewayでCognito認証を設定した場合、CLIでAPIを呼び出す方法を教えてください。](#amazon-api-gatewayでcognito認証を設定した場合cliでapiを呼び出す方法を教えてください)
  - [Api IDではなくOAuth2でAPIを呼び出す方法はありませんか?](#api-idではなくoauth2でapiを呼び出す方法はありませんか)
- [↑のやつを実際に作ってみる](#のやつを実際に作ってみる)
- [ブラウザでPKCE](#ブラウザでpkce)
  - [リフレッシュトークンの寿命って取れるの?](#リフレッシュトークンの寿命って取れるの)

# OpenID ConnectとOAuth2を理解する

まずこれを読む
[一番分かりやすい OAuth の説明 - Qiita](https://qiita.com/TakahikoKawasaki/items/e37caf50776e00e733be)

*The OAuth 2.0 Authorization Framework* の
*Authorization* は「認可」で「認証(Authentication)」ではない。

たしかにOAuth2でアクセストークンをもらえれば
「認可サーバー」で「認証」されたことになるかもしれないけど、
それはなんか変。

> すなわち、認可処理にはその一部として認証処理が含まれているため、話がややこしくなっているのです。

引用元: [認証と認可 - OAuth 2.0 + OpenID Connect のフルスクラッチ実装者が知見を語る - Qiita](https://qiita.com/TakahikoKawasaki/items/f2a0d25a4f05790b3baa#%E8%AA%8D%E8%A8%BC%E3%81%A8%E8%AA%8D%E5%8F%AF)

これも参照:
[OAuth Authorization vs Authentication - Stack Overflow](https://stackoverflow.com/questions/33702826/oauth-authorization-vs-authentication/33704657#33704657)

で、OpenID Connectは
[一番分かりやすい OpenID Connect の説明 - Qiita](https://qiita.com/TakahikoKawasaki/items/498ca08bbfcc341691fe)

「アクセストークン」ではなく「ID トークン」が発行される。

OpenIDでユーザーの認証と「ID トークン」の発行を行うのが「IDプロバイダ」。だが多くの場合OAuthの認可サーバを兼業してるので、「アクセストークン」の同時発行もできる(ときもある)。

「IDトークン」は何の役に立つか、というと ->
[IDトークンが分かれば OpenID Connect が分かる - Qiita](https://qiita.com/TakahikoKawasaki/items/8f0e422c7edd2d220e06)

IDトークンペイロードに(だいたい)emailと名前が入っている。

詳細は
- [RFC 6749 - The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
- [The OAuth 2.0 Authorization Framework](https://openid-foundation-japan.github.io/rfc6749.ja.html) - 日本語訳
- [Final: OpenID Connect Core 1.0 incorporating errata set 1](https://openid.net/specs/openid-connect-core-1_0.html)
- [Final: OpenID Connect Core 1.0 incorporating errata set 1](https://openid-foundation-japan.github.io/openid-connect-core-1_0.ja.html) - 日本語訳
- [JSON Web Signature (JWS)](https://openid-foundation-japan.github.io/draft-ietf-jose-json-web-signature-14.ja.html) - 日本語訳

# プロバイダ


[OpenID Connect、OAuthプロバイダの調査 (作成中) - Qiita](https://qiita.com/okuoku/items/7a84c516e79826b406e0)


# クライアント側

app(native app, web app)やサーババックエンドの側

[OpenID Connect 全フロー解説 - Qiita](https://qiita.com/TakahikoKawasaki/items/4ee9b55db9f7ef352b47)

ほとんどの場合
`response_type=id_token`
で用は足りるのではないか、と思われるけど、
`response_type=code id_token`
を使いましょう。

[GoogleのOAuth 2.0実装におけるToken置換攻撃の防ぎ方 - r-weblife](https://ritou.hatenablog.com/entry/20120702/1341235859)

## Flaskの例

- [GoogleログインでFlaskアプリケーションを作成する](https://www.codeflow.site/ja/article/flask-google-login)
- [Create a Flask Application With Google Login – Real Python](https://realpython.com/flask-google-login/) - ↑はこれのパクリらしい。
- [Basic Flask OpenID Connect example - Stack Overflow](https://stackoverflow.com/questions/29046866/basic-flask-openid-connect-example)
- [How to Add User Authentication to Flask Apps with Okta - Full Stack Python](https://www.fullstackpython.com/blog/add-user-authentication-flask-apps-okta.html)
- [Flask-OIDC — Flask-OIDC 1.1 documentation](https://flask-oidc.readthedocs.io/en/latest/)


# OpenID Connect(OIDC)とOAuth2のちがい

OAuth2は「認可」のプロトコル。
OpenID Connectは「認証+認可(ない場合も)+属性(ない場合も)」ができる。

OAuth2はアクセストークンを操る。
OpenID ConnectはIDトークンとアクセストークンを操る。

OAuth2とOICDでは同じものでも呼び名が違う。

| |OAuth2|OIDC|
|:----|:----|:----|
|人間|resource owner|End-User|
|人間が使う端末|user agent|特になし|
|アクセストークンを発行してもらうもの|client|Relaying Party (RP)|
|アクセストークンを発行するもの|authorization server|OpenID provider(IdP)|
|アクセストークンを使ってアクセスされるもの|resource server|特になし|

> OpenID Connect 1.0 は, OAuth 2.0 プロトコルの上にシンプルなアイデンティティレイヤーを付与したものである

-- [Final: OpenID Connect Core 1.0 incorporating errata set 1](http://openid-foundation-japan.github.io/openid-connect-core-1_0.ja.html)


# OIDCのエンドポイント

OIDCの「フロー」によって3つ全部あったりなかったりする。

## 認可エンドポイント(Authorization Endpoint)

* [Authorization Endpoint](https://datatracker.ietf.org/doc/html/rfc6749#section-3.1)
* [認可エンドポイント \- Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/authorization-endpoint.html)

`OAuth 2.0 endpoint`ともいう。OpenID provider(authorization server)上にある。


## トークンエンドポイント(Token Endpoint)

* [Token Endpoint](https://datatracker.ietf.org/doc/html/rfc6749#section-3.2)
* [トークンエンドポイント \- Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/token-endpoint.html)




## リダイレクションエンドポイント(Redirection Endpoint)

[Redirection Endpoint](https://datatracker.ietf.org/doc/html/rfc6749#section-3.1.2)

`Redirect URI`などともいう。relaying party(client)上にある。


# おまけ

OpenID と OpenID Connectは全然別物

アプリにスキーマを割り当てる(逆か?)にはどうすればいいのか?

なぜ認可リクエストにstateとnonceの2つが?
-> 付加されるところが違う

認可レスポンスがフラグメントのとき
リダイレクションエンドポイントから返されてきた「なにか」は
どうやって認可レスポンスのフラグメントにある認可コード(code)を得るのか?


# AWSでApiGWとCognitoでOAuth2

ChatGPTに聞いてみた

## Amazon API GatewayでCognito認証を設定した場合、CLIでAPIを呼び出す方法を教えてください。

以下の手順に従って、Amazon API GatewayでCognito認証を設定したAPIをCLIから呼び出すことができます。

1. AWS CLIをインストールして、AWSアカウントにサインインする。

1. Amazon API GatewayでCognito認証を設定したAPIを呼び出すために必要な情報を収集する。これには、API GatewayのエンドポイントURL、APIのレソースパス、APIのメソッド、APIキー、アクセストークンなどが含まれます。

1. 以下のAWS CLIコマンドを使用してAPIを呼び出す。

```bash
aws apigateway invoke-method \
  --rest-api-id <api-id> \
  --resource-id <resource-id> \
  --http-method <http-method> \
  --headers "Authorization=<access-token>" \
  --path-parameters "param1=value1" \
  --query-string-parameters "param2=value2"`
```

上記のコマンドは、API GatewayのAPI ID、リソースID、HTTPメソッド、アクセストークン、パスパラメータ、クエリパラメータを指定する必要があります。正確な値は、API Gatewayの管理コンソールから入手できます。


##  Api IDではなくOAuth2でAPIを呼び出す方法はありませんか?

はい、OAuth2認証を使用してAPI GatewayのAPIを呼び出すことができます。この方法では、事前にCognitoユーザープールまたはIdentity Poolを作成し、ユーザーアクセスを認証します。その後、アクセストークンを取得して、API GatewayのAPIを呼び出すことができます。以下は一例です。

1. AWS CLIをインストールして、AWSアカウントにサインインする。
1. AWS CLIからCognitoアクセストークンを取得するために必要な情報を収集する。これには、Cognitoユーザープール名、ユーザー名、パスワード、クライアントIDなどが含まれます。
1. 以下のAWS CLIコマンドを使用してアクセストークンを取得する。

```bash
aws cognito-idp admin-initiate-auth \
  --user-pool-id <user-pool-id> \
  --client-id <client-id> \
  --auth-flow ADMIN_NO_SRP_AUTH \
  --auth-parameters USERNAME=<username>,PASSWORD=<password>
```
またはJavaScriptで
```javascript
const AWS = require("aws-sdk");
const cognitoIdp = new AWS.CognitoIdentityServiceProvider();

const userPoolId = "<user-pool-id>";
const clientId = "<client-id>";
const authFlow = "ADMIN_NO_SRP_AUTH";
const authParameters = {
  USERNAME: "<username>",
  PASSWORD: "<password>",
};

cognitoIdp.adminInitiateAuth({
  UserPoolId: userPoolId,
  ClientId: clientId,
  AuthFlow: authFlow,
  AuthParameters: authParameters,
}, (err, data) => {
  if (err) {
    console.error(err);
    return;
  }
  console.log(data);
});
```
またはPython3で
```python
import boto3

client = boto3.client("cognito-idp")

response = client.admin_initiate_auth(
    UserPoolId="<user-pool-id>",
    ClientId="<client-id>",
    AuthFlow="ADMIN_NO_SRP_AUTH",
    AuthParameters={
        "USERNAME": "<username>",
        "PASSWORD": "<password>",
    },
)

print(response)
```


4.  取得したアクセストークンを使用してAPI GatewayのAPIを呼び出す。

```bash
curl -X <http-method> \
  -H "Authorization: Bearer <access-token>" \
  "<api-endpoint>"
```

上記のコマンドは、HTTPメソッド、API GatewayのエンドポイントURL、アクセストークンを指定する必要があります。正確な値は、API Gatewayの管理コンソールから入手できます。

# ↑のやつを実際に作ってみる

まず手動で作って、SAMかTerraformにする。
1. [Amazon Cognito ユーザープールをオーソライザーとして使用して REST API へのアクセスを制御する](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html)
1. [REST API 用の Amazon Cognito ユーザープールを作成する](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-create-cognito-user-pool.html)
1. [REST API と Amazon Cognito ユーザープールを統合する](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-enable-cognito-user-pool.html)
1. [Amazon Cognito ユーザープールと統合された REST API を呼び出す](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-invoke-api-integrated-with-cognito-user-pool.html)
1. [API Gateway コンソールを使用して REST API 用のクロスアカウントの Amazon Cognito オーソライザーを設定する](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-cross-account-cognito-authorizer.html)

あとこれ

- [Amazon Cognito ユーザープールを API Gateway オーソライザーとしてセットアップする](https://aws.amazon.com/jp/premiumsupport/knowledge-center/api-gateway-cognito-user-pool-authorizer/)
- [Cognitoで認証されたユーザーだけがAPI Gatewayを呼び出せるオーソライザーを使ってみた | DevelopersIO](https://dev.classmethod.jp/articles/api-gateway-cognito-authorizer/)



# ブラウザでPKCE

OAuth 2.0でのPKCE（Proof Key for Code Exchange）は、認可グラントにセキュリティを追加するための技術的手法です。PKCEを使用することで、認可コードフローを使用する際に、悪意のあるサードパーティアプリケーションによる認可コードの盗難やフィッシング攻撃から保護することができます。

ブラウザでOAuthの認可グラントでPKCEを使用する場合、以下の手順に従って実装することができます。

ランダムなバイト列（エントロピー）を生成します。このエントロピーは、認可リクエストごとに異なるものである必要があります。

エントロピーを Base64 エンコードします。これは、エントロピーのランダムなバイト列を Web セーフな文字列に変換するために使用されます。

エントロピーの SHA-256 ハッシュ値を計算し、Base64 エンコードします。この値は、認可コードリクエストの検証に使用されます。

リダイレクトURIに、クエリパラメーターとして code_challenge と code_challenge_method を追加します。 code_challenge は、エントロピーの SHA-256 ハッシュ値をエンコードした値で、 code_challenge_method は、常に "S256" を指定します。

認可エンドポイントにリクエストを送信する前に、クライアントの設定に code_challenge 値を保存します。

認可エンドポイントにリクエストを送信するときに、code_challenge 値を使用して、クエリパラメーター code_challenge を追加します。

認可サーバーは、リダイレクトURIに含まれる code_challenge 値とクライアントの設定に保存されている値を比較します。もし一致しない場合、認可リクエストは失敗します。

これらの手順に従って実装することで、ブラウザでOAuthの認可グラントでPKCEを使用することができます。ただし、PKCEを実装するには、OAuthプロバイダーがPKCEをサポートしている必要があります。PKCEをサポートしていないOAuthプロバイダーの場合、この手法を使用することはできません。


ブラウザでOAuthの認可グラントでPKCEを使う方法は、以下のようになります。

1.  [クライアントは、ランダムな文字列を生成し、それを**コードチャレンジ**と呼びます。**1**](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)
2.  [クライアントは、コードチャレンジをハッシュ化し、それを**コードベリファイア**と呼びます。**1**](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)
3.  [クライアントは、認可サーバーに対して認可リクエストを送ります。このとき、コードチャレンジと**PKCEメソッド**（ハッシュ化の方法）をパラメータとして含めます。**1**](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)[**2**](https://learn.microsoft.com/ja-jp/azure/active-directory/develop/v2-oauth2-auth-code-flow)
4.  [認可サーバーは、クライアントに対して認可コードを返します。**2**](https://learn.microsoft.com/ja-jp/azure/active-directory/develop/v2-oauth2-auth-code-flow)
5.  [クライアントは、認可サーバーに対してトークンリクエストを送ります。このとき、認可コードとコードベリファイアをパラメータとして含めます。**1**](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)[**2**](https://learn.microsoft.com/ja-jp/azure/active-directory/develop/v2-oauth2-auth-code-flow)
6.  [認可サーバーは、コードベリファイアをハッシュ化し、それがコードチャレンジと一致するかどうか検証します。一致すれば、クライアントに対してアクセストークンとリフレッシュトークンを返します。**1**](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)[**2**](https://learn.microsoft.com/ja-jp/azure/active-directory/develop/v2-oauth2-auth-code-flow)

これにより、ブラウザでOAuthの認可グラントでPKCEを使って安全にトークンを取得することができます。



**詳細情報:**[1\. zenn.dev](https://zenn.dev/zaki_yama/articles/oauth2-authorization-code-grant-and-pkce)[2\. learn.microsoft.com](https://learn.microsoft.com/ja-jp/azure/active-directory/develop/v2-oauth2-auth-code-flow)[3\. applis.io](https://applis.io/posts/what-is-pkce)

## リフレッシュトークンの寿命って取れるの?

JWEで暗号化されてるから分からないよなあ... 

ソース: Bing との会話 2023/2/21

OAuth2のリフレッシュトークンの期限切れを知る方法については、ウェブ検索の結果から以下の情報が得られました。¹²³

- リフレッシュトークンを取得するときに、期限切れの時間を保存する方法があります²。しかし、この方法はすべてのOAuth2プロバイダーでサポートされているわけではありません²。
- リフレッシュトークンを使ってアクセストークンを再発行するときに、エラーレスポンスをチェックする方法があります²。エラーコードがinvalid_grantやinvalid_tokenなどの場合は、リフレッシュトークンが期限切れである可能性が高いです²。
- リフレッシュトークンを取得するときに、access_type=offlineやprompt=consentなどのパラメータを付ける方法があります³。これにより、リフレッシュトークンが常に返されるようになります³。

この回答は役に立ちましたか？


1. OAuth 2.0 全フローの図解と動画 - Qiita. https://qiita.com/TakahikoKawasaki/items/200951e5b5929f840a1f アクセス日時 2023/2/21.
2. How to detect when an OAuth2 refresh-token expired. https://stackoverflow.com/questions/57383523/how-to-detect-when-an-oauth2-refresh-token-expired アクセス日時 2023/2/21.
3. google認証のrefresh_tokenの扱いでハマったポイント - Qiita. https://qiita.com/zuxt/items/10cbc7cf6c12371227f3 アクセス日時 2023/2/21.

ログインする時に、
まずトークンエンドポイントに投げてみて
エラーになったら、認可エンドポイント
みたいな方法しかないみたい。
