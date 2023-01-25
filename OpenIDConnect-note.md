# OAuth2とOpenConnectID

OAuth 2.0 (Open Authorization) と OpenID Connect (OIDC)は、異なるプロトコルでありますが、同じ目的である、セキュアなユーザー認証とアクセス制御を提供するために開発されています。

OAuth 2.0は、ユーザーのアカウント情報を持つサービスプロバイダー（例えば、GoogleやFacebook）からアクセスするために、他のアプリケーション（クライアント）にアクセス権を与えるための**認可フレームワーク**です。 アクセス権は、アクセス権付与のためのトークンを使用して提供されます。 OAuth 2.0は、APIアクセスやソーシャルログインなどの様々な使用方法があります。

OpenID Connect (OIDC)は、OAuth 2.0の基礎上に構築されており、OAuth 2.0に認証機能を追加したプロトコルです。 OIDCは、ユーザーの身元確認のためのIDトークンを提供します。 IDトークンは、ユーザーの身元を確認するための任意の情報を含むJWT(JSON Web Token)形式のトークンです。 OIDCは、APIアクセスやソーシャルログイン、サインアップ・サインインなどの様々な使用方法があります。

OAuth2はアクセス制御に特化したプロトコルであり、認証には特に焦点を当てていません。一方、OpenID Connectは、**認証に特化したプロトコル**であり、アクセス制御には特に焦点を当てていません。

つまり、OAuth2はアクセス権を与えるための認可フレームワークであり、OpenID Connectはユーザーの身元確認のための認証プロトコルであり、それぞれの使用目的が異なります。 しかし、OIDCはOAuth2の上に構築されており、アクセス権付与を含むため、OAuth2とOIDCを組み合わせることで、より完全な認証とアクセス制御が可能になります。

# AWS上でOpenID Connectプロバイダ

Amazon Web Services (AWS)には、OpenID Connect (OIDC) プロバイダを構築するためのいくつかのオプションがあります。

1.  Amazon Cognito: Amazon Cognitoは、簡単にWebおよびモバイルアプリケーションのユーザー認証とアクセス管理を提供するためのAWSサービスで、OIDCプロバイダの機能を提供します。
2.  AWS Identity and Access Management (IAM): AWS IAMは、AWSリソースへのアクセスを管理するためのサービスで、OIDCプロバイダの機能を拡張するために使用することができます。
3.  AWS Directory Service: AWS Directory Serviceは、AWS上でアクティブディレクトリを構築するためのサービスで、OIDCプロバイダとして使用することができます。
4.  AWS Managed Microsoft AD: AWS Managed Microsoft ADは、AWS上で管理されたMicrosoft Active Directoryを提供するサービスで、OIDCプロバイダとして使用することができます。
5.  EC2インスタンス上に自分で構築することも可能です。

選択するオプションは、アプリケーションの要件やインフラストラクチャの要件によって異なります。例えば、Amazon Cognitoは簡単に使用でき、モバイルアプリケーションやWebアプリケーションに適していますが、AWS IAMはAWSリソースにアクセスを制御するために使用することができます。 AWS Directory ServiceやAWS Managed Microsoft ADは、オンプレミスのアクティブディレクトリとの統合に適しています。EC2インスタンス上に自分で構築する場合は、自分で管理する必要があります。


Amazon Cognitoを使用してOpenID Connect (OIDC) プロバイダを作成する手順は次のようになります。

1. Amazon Cognito コンソールにサインインします。
1. [Manage User Pools] をクリックし、新しいユーザープールを作成します。
1. [App clients] のタブをクリックし、新しいアプリクライアントを作成します。
1. [Domain name] のタブをクリックし、独自のドメイン名を設定します。
1. [Federation] のタブをクリックし、[Identity Providers] を選択します。
1. [OpenID Connect] を選択し、必要な設定を入力します。
1. [Create Provider] をクリックします。
1. [App client settings] のタブをクリックし、新しいアプリクライアントに対してOIDCプロバイダを有効にします。
1. [Callback URL] と [Sign out URL] を設定します。
1. [Allowed OAuth Flows] で "code"と "implicit"を有効にします。
1. [Allowed OAuth Scopes] で "openid"と "email"などを有効にします。
1. [Save Changes] をクリックして設定を保存します。

OIDCプロバイダが作成されました。アプリケーションからCognitoに対して認証リクエストを送信し、IDトークンやアクセストークンを取得して使用することができます。

これらは一般的な手順ですが、詳細については、AWS Cognito のドキュメントを参照してください。


AWS Amplify ライブラリを使用します。 Amplifyは、AWSを使用してモバイルおよびWebアプリケーションを構築するためのJavaScript ライブラリで、Cognitoの認証を簡単に使用することができます。

1.  `npm install aws-amplify` コマンドを使用してAmplifyをインストールします。
2.  AmplifyをReactアプリケーションに統合します。
3.  `amplify configure` コマンドを使用して、AWSアカウントに接続します。
4.  `amplify add auth` コマンドを使用して、Cognitoの認証を設定します。
5.  `amplify push` コマンドを使用して、設定をAWSにアップロードします。
6.  `import { withAuthenticator } from 'aws-amplify-react';` を使用して、Reactコンポーネントを認証に対応させます
7.  `withAuthenticator(App)` を使って、アプリケーションの全体に対して認証を適用します。
8.  `Auth.federatedSignIn({provider: 'Cognito'})` を使って、CognitoのOIDCプロバイダに対してサインインを要求します。
9.  `Auth.currentSession()` を使って、現在のセッション情報を取得します。

これらは一般的な手順ですが、詳細については、AWS Amplify のドキュメントや、Amplify React Components を参照してください。


# EC2上にOpenID Connect (OIDC) プロバイダ

EC2インスタンス上にOpenID Connect (OIDC) プロバイダを作成する手順は次のようになりますが、詳細な手順は変わる可能性があります。

1. EC2インスタンスを起動し、必要なパッケージをインストールします。(例: Apache, PHP, OpenSSL, MySQL)
1. OIDCプロバイダを構築するためのフレームワークをインストールします。 例えば、OpenID Connect Provider (OP) の作成には、php-openid-connect-serverなどのライブラリを使用することができます。
1. OIDCプロバイダの設定を行います。 例えば、クライアントIDとシークレット、リダイレクトURLなどを設定します。
1. OIDCプロバイダのエンドポイントを構築します。 例えば、/authorize、/token、/userinfoなどのエンドポイントを構築します。
1. OIDCプロバイダの認証と認可ロジックを実装します。
1. OIDCプロバイダのデータベースを構築し、クライアント、ユーザー、アクセストークンなどの情報を格納します。
1. アプリケーションとOIDCプロバイダを統合します。 アプリケーションから認証リクエストを送信し、IDトークンやアクセストークンを取得して使用することができます。
1. OIDCプロバイダのセキュリティ設定を行います。 例えば、TLS暗号化や認証に必要なセキュリティ証明書の設定を行います。
1. OIDCプロバイダをテストし、動作を確認します。

これらは一般的な手順ですが、詳細については、各OIDCプロバイダのフレームワークのドキュメントを参照してください。また、セキュリティ面については専門知識が必要なので、適切な対策を行うようにしてください。


[steverhoades/oauth2-openid-connect-server: An OpenID Connect Server plugin for The PHP League's OAuth2 Server](https://github.com/steverhoades/oauth2-openid-connect-server)

Keycloakは、OpenID Connect (OIDC) とSAMLをベースにした認証および認可ソリューションです。KeycloakはJavaで書かれており、オープンソースソフトウェアです。

Keycloakは、Webアプリケーションやモバイルアプリケーションの認証と認可を提供します。 Keycloakは、シングルサインオン (SSO)、マルチファクター認証 (MFA)、統合データベースなどの機能を提供します。

また、Keycloakは、多数のクライアントアダプターと統合されており、Java、JavaScript、Python、C#などの言語で書かれたアプリケーションに統合することができます。

Keycloakは、EC2インスタンス上にインストールして使用することもできます。 インストール手順については、Keycloakのドキュメントを参照してください。

また、AWSには、Cognitoというサービスもあり、認証と認可に利用することができます。

[KeycloakをAWS上に構築してセキュリティ検証してみた - Qiita](https://qiita.com/HiroyaEnd/items/8656583b31bc912eedb2)


# Azureでは

Azure上でOpenID Connect (OIDC) プロバイダを構築する方法は次のようになります。

Azure Active Directory (AAD) を使用します。 AADは、Azureのクラウドベースの認証サービスで、OIDCプロバイダの機能を提供します。

1. Azure ポータルにサインインし、AADを選択します。
1. [アプリの登録] を選択し、新しいアプリケーションを登録します。
1. [証明書とシークレット] を選択し、クライアントシークレットを作成します。
1. [APIアクセス] を選択し、必要なスコープを設定します。
1. [認証] を選択し、リダイレクトURIを設定します。
1. [アプリケーションの設定] を選択し、OpenID Connectの設定を行います。

OIDCプロバイダが構築されました。アプリケーションからAADに対して認証リクエストを送信し、IDトークンやアクセストークンを取得して使用することができます。
