以下のメモは嘘が多いです。だんだん嘘を減らしていきます。

[Amazon Cognito コンソール](https://console.aws.amazon.com/cognito/home)

ユーザープールとIDプール

```
Amazon Cognito の主な 2 つのコンポーネントは、ユーザープールと ID プールです。
ユーザープールは、ウェブおよびモバイルユーザーにサインアップとサインインオプションを提供するユーザーディレクトリです。
ID プールは、AWS の他のサービスへのアクセス権をユーザーに付与する AWS 認証情報を提供します。
ユーザープールと ID プールは個別に使用することも、一緒に使用することもできます。
```

- IDプール - CognitoがOpenIDConnectのID providerになるよ [Open ID Connect プロバイダー \(ID プール\)](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/open-id.html)
- ユーザープール - CognitoがOAuth2で認可

IAMでOpenIDConnectのID providerもできるらしい。
[OpenID Connect \(OIDC\) ID プロバイダーの作成](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)


* [Amazon Cognito の使用開始方法 - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/cognito-getting-started.html)
* [一般的な Amazon Cognito シナリオ \- Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/cognito-scenarios.html)

↑Cognitoの「ありがちな使い方」一覧があるので、まずこれを読む。

例えば
[ユーザープールと共に API Gateway と Lambda を使用してリソースにアクセスする](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/cognito-scenarios.html#scenario-api-gateway)


* [Amazon Cognito ユーザープールを API Gateway オーソライザーとしてセットアップする](https://aws.amazon.com/jp/premiumsupport/knowledge-center/api-gateway-cognito-user-pool-authorizer/)
* [ユーザープールベースのマルチテナンシー - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/bp_user-pool-based-multi-tenancy.html)
* [マルチプラットフォームのモバイル・WebアプリのアクセスをコントロールするAmazon Cognito｜コラム｜クラウドソリューション｜サービス｜法人のお客さま｜NTT東日本](https://business.ntt-east.co.jp/content/cloudsolution/column-123.html)
* [Cognitoで認証されたユーザーだけがAPI Gatewayを呼び出せるオーソライザーを使ってみた \| DevelopersIO](https://dev.classmethod.jp/articles/api-gateway-cognito-authorizer/)
* [Amazon API Gateway の Custom Authorizerを使い、User PoolsのユーザでAPI認証を行う \| Serverless Operations](https://serverless.co.jp/blog/262/)
* [Amazon Cognito User Poolsを使って、webサイトにユーザ認証基盤を作る \- Qiita](https://qiita.com/horike37/items/1d522f66452d3abe1203)
* [REST API と Amazon Cognito ユーザープールを統合する \- Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/apigateway-enable-cognito-user-pool.html)
  

IDトークン or アクセストークン
[【OAuth 2\.0 / OIDC】アクセストークンとIDトークンの違い ＋ OIDC誕生の歴史 \- yyh\-gl's Tech Blog](https://yyh-gl.github.io/tech-blog/blog/id_token_and_access_token/#:~:text=2%E3%81%A4%E3%81%AE%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%81%AE%E9%81%95%E3%81%84,-%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B9%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%20%E3%81%A8&text=%E8%AA%8D%E5%8F%AF%E3%81%AB%E4%BD%BF%E3%81%86%E3%81%9F%E3%82%81%E3%81%AE,%E3%81%AE%E3%81%8CID%E3%83%88%E3%83%BC%E3%82%AF%E3%83%B3%E3%81%A7%E3%81%99%E3%80%82)
まずIDトークンで
