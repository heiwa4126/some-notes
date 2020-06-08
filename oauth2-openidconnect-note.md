OpenID Connect(OIDC)とOAuth2メモ

# OpenID ConnetcとOAuth2を理解する

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