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