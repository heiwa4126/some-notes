# OAuth2 と OpenConnectID

OAuth 2.0 (Open Authorization) と OpenID Connect (OIDC)は、異なるプロトコルでありますが、同じ目的である、セキュアなユーザー認証とアクセス制御を提供するために開発されています。

OAuth 2.0 は、ユーザーのアカウント情報を持つサービスプロバイダー(例えば、Google や Facebook)からアクセスするために、他のアプリケーション(クライアント)にアクセス権を与えるための**認可フレームワーク**です。 アクセス権は、アクセス権付与のためのトークンを使用して提供されます。 OAuth 2.0 は、API アクセスやソーシャルログインなどの様々な使用方法があります。

OpenID Connect (OIDC)は、OAuth 2.0 の基礎上に構築されており、OAuth 2.0 に認証機能を追加したプロトコルです。 OIDC は、ユーザーの身元確認のための ID トークンを提供します。 ID トークンは、ユーザーの身元を確認するための任意の情報を含む JWT(JSON Web Token)形式のトークンです。 OIDC は、API アクセスやソーシャルログイン、サインアップ・サインインなどの様々な使用方法があります。

OAuth2 はアクセス制御に特化したプロトコルであり、認証には特に焦点を当てていません。一方、OpenID Connect は、**認証に特化したプロトコル**であり、アクセス制御には特に焦点を当てていません。

つまり、OAuth2 はアクセス権を与えるための認可フレームワークであり、OpenID Connect はユーザーの身元確認のための認証プロトコルであり、それぞれの使用目的が異なります。 しかし、OIDC は OAuth2 の上に構築されており、アクセス権付与を含むため、OAuth2 と OIDC を組み合わせることで、より完全な認証とアクセス制御が可能になります。

## AWS 上で OpenID Connect プロバイダ

Amazon Web Services (AWS)には、OpenID Connect (OIDC) プロバイダを構築するためのいくつかのオプションがあります。

1. Amazon Cognito: Amazon Cognito は、簡単に Web およびモバイルアプリケーションのユーザー認証とアクセス管理を提供するための AWS サービスで、OIDC プロバイダの機能を提供しま。
2. AWS Identity and Access Management (IAM): AWS IAM は、AWS リソースへのアクセスを管理するためのサービスで、OIDC プロバイダの機能を拡張するために使用することができます
3. AWS Directory Service: AWS Directory Service は、AWS 上でアクティブディレクトリを構築するためのサービスで、OIDC プロバイダとして使用することができます。
4. AWS Managed Microsoft AD: AWS Managed Microsoft AD は、AWS 上で管理された Microsoft Active Directory を提供するサービスで、OIDC プロバイダとして使用することができま。
5. EC2 インスタンス上に自分で構築することも可能です。

選択するオプションは、アプリケーションの要件やインフラストラクチャの要件によって異なります。例えば、Amazon Cognito は簡単に使用でき、モバイルアプリケーションや Web アプリケーションに適していますが、AWS IAM は AWS リソースにアクセスを制御するために使用することができます。 AWS Directory Service や AWS Managed Microsoft AD は、オンプレミスのアクティブディレクトリとの統合に適しています。EC2 インスタンス上に自分で構築する場合は、自分で管理する必要があります。

Amazon Cognito を使用して OpenID Connect (OIDC) プロバイダを作成する手順は次のようになります。

1. Amazon Cognito コンソールにサインインします。
1. [Manage User Pools] をクリックし、新しいユーザープールを作成します。
1. [App clients] のタブをクリックし、新しいアプリクライアントを作成します。
1. [Domain name] のタブをクリックし、独自のドメイン名を設定します。
1. [Federation] のタブをクリックし、[Identity Providers] を選択します。
1. [OpenID Connect] を選択し、必要な設定を入力します。
1. [Create Provider] をクリックします。
1. [App client settings] のタブをクリックし、新しいアプリクライアントに対して OIDC プロバイダを有効にします。
1. [Callback URL] と [Sign out URL] を設定します。
1. [Allowed OAuth Flows] で "code"と "implicit"を有効にします。
1. [Allowed OAuth Scopes] で "openid"と "email"などを有効にします。
1. [Save Changes] をクリックして設定を保存します。

OIDC プロバイダが作成されました。アプリケーションから Cognito に対して認証リクエストを送信し、ID トークンやアクセストークンを取得して使用することができます。

これらは一般的な手順ですが、詳細については、AWS Cognito のドキュメントを参照してください。

AWS Amplify ライブラリを使用します。 Amplify は、AWS を使用してモバイルおよび Web アプリケーションを構築するための JavaScript ライブラリで、Cognito の認証を簡単に使用することができます。

1. `npm install aws-amplify` コマンドを使用して Amplify をインストールします。
2. Amplify を React アプリケーションに統合します。
3. `amplify configure` コマンドを使用して、AWS アカウントに接続します。
4. `amplify add auth` コマンドを使用して、Cognito の認証を設定します。
5. `amplify push` コマンドを使用して、設定を AWS にアップロードします。
6. `import { withAuthenticator } from 'aws-amplify-react';` を使用して、React コンポーネントを認証に対応させます
7. `withAuthenticator(App)` を使って、アプリケーションの全体に対して認証を適用します。
8. `Auth.federatedSignIn({provider: 'Cognito'})` を使って、Cognito の OIDC プロバイダに対してサインインを要求します。
9. `Auth.currentSession()` を使って、現在のセッション情報を取得します。

これらは一般的な手順ですが、詳細については、AWS Amplify のドキュメントや、Amplify React Components を参照してください。

## EC2 上に OpenID Connect (OIDC) プロバイダ

EC2 インスタンス上に OpenID Connect (OIDC) プロバイダを作成する手順は次のようになりますが、詳細な手順は変わる可能性があります。

1. EC2 インスタンスを起動し、必要なパッケージをインストールします。(例: Apache, PHP, OpenSSL, MySQL)
1. OIDC プロバイダを構築するためのフレームワークをインストールします。 例えば、OpenID Connect Provider (OP) の作成には、php-openid-connect-server などのライブラリを使用することができます。
1. OIDC プロバイダの設定を行います。 例えば、クライアント ID とシークレット、リダイレクト URL などを設定します。
1. OIDC プロバイダのエンドポイントを構築します。 例えば、/authorize、/token、/userinfo などのエンドポイントを構築します。
1. OIDC プロバイダの認証と認可ロジックを実装します。
1. OIDC プロバイダのデータベースを構築し、クライアント、ユーザー、アクセストークンなどの情報を格納します。
1. アプリケーションと OIDC プロバイダを統合します。 アプリケーションから認証リクエストを送信し、ID トークンやアクセストークンを取得して使用することができます。
1. OIDC プロバイダのセキュリティ設定を行います。 例えば、TLS 暗号化や認証に必要なセキュリティ証明書の設定を行います。
1. OIDC プロバイダをテストし、動作を確認します。

これらは一般的な手順ですが、詳細については、各 OIDC プロバイダのフレームワークのドキュメントを参照してください。また、セキュリティ面については専門知識が必要なので、適切な対策を行うようにしてください。

[steverhoades/oauth2-openid-connect-server: An OpenID Connect Server plugin for The PHP League's OAuth2 Server](https://github.com/steverhoades/oauth2-openid-connect-server)

Keycloak は、OpenID Connect (OIDC) と SAML をベースにした認証および認可ソリューションです。Keycloak は Java で書かれており、オープンソースソフトウェアです。

Keycloak は、Web アプリケーションやモバイルアプリケーションの認証と認可を提供します。 Keycloak は、シングルサインオン (SSO)、マルチファクター認証 (MFA)、統合データベースなどの機能を提供します。

また、Keycloak は、多数のクライアントアダプターと統合されており、Java、JavaScript、Python、C#などの言語で書かれたアプリケーションに統合することができます。

Keycloak は、EC2 インスタンス上にインストールして使用することもできます。 インストール手順については、Keycloak のドキュメントを参照してください。

また、AWS には、Cognito というサービスもあり、認証と認可に利用することができます。

[Keycloak を AWS 上に構築してセキュリティ検証してみた - Qiita](https://qiita.com/HiroyaEnd/items/8656583b31bc912eedb2)

## Azure では

Azure 上で OpenID Connect (OIDC) プロバイダを構築する方法は次のようになります。

Azure Active Directory (AAD) を使用します。 AAD は、Azure のクラウドベースの認証サービスで、OIDC プロバイダの機能を提供します。

1. Azure ポータルにサインインし、AAD を選択します。
1. [アプリの登録] を選択し、新しいアプリケーションを登録します。
1. [証明書とシークレット] を選択し、クライアントシークレットを作成します。
1. [API アクセス] を選択し、必要なスコープを設定します。
1. [認証] を選択し、リダイレクト URI を設定します。
1. [アプリケーションの設定] を選択し、OpenID Connect の設定を行います。

OIDC プロバイダが構築されました。アプリケーションから AAD に対して認証リクエストを送信し、ID トークンやアクセストークンを取得して使用することができます。
