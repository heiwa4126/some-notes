# パスキーのメモ

## Windows Hello で保存されてるパスキー一覧を見るには

Windows 11 の場合:

「設定」アプリ → 「アカウント (Accounts)」 → 「パスキー (Passkeys)」

または Win+R で `ms-settings:savedpasskeys`

もしくは Windows 上の Chrome で <chrome://settings/passkeys> を開く
(Windows 上の Chrome のパスキーのストアは Windows Hello だから)

## 複数デバイスでパスキーを使う

「セキュリティキー(YubiKey 等)を使う」以外の方法

パスキー同期対応の仕組みを使う

- **Apple iCloud キーチェーン**  
  iPhone や Mac でパスキーを作成すると、同じ Apple ID でログインしている端末間で自動同期される
- **Google パスワードマネージャー**  
  Android や Chrome で作成したパスキーは、Google アカウントで同期される
- **Windows Hello + Microsoft アカウント**  
  Windows で作成したパスキーは、Microsoft アカウントで同期

→ つまり、同じエコシステム(Apple, Google, Microsoft)でログインしている複数デバイスなら、パスキーは共有される

たとえば GitHub は複数のパスキーを登録可能なので
nickname に別の名前をつければいい。

### GitHub は複数パスキー登録をサポートしていますが、そうでないサービスの場合は?

「ハードウェアセキュリティキーを使う」以外では「クロスデバイス認証」しかない。
WebAuthn の仕様では「QR コードで別デバイスのパスキーを使う」ことが可能。

例:PC でログイン時に QR コードを表示 → スマホでスキャン → スマホのパスキーで認証

欠点は「**めんどくさい**」こと。

### 複数パスキーをサポートしたサービスがあまりないのはなんで?

Q. パスキーのクロスデバイス認証はめんどくさいので全部のサービスは GitHub のように複数パスキーがもてるようにしてほしいですよね。複数パスキーがあまり見られないのは、なにか欠点があるからですか?

A. 結論から言うと「複数パスキーを持てる設計に大きな欠点があるわけではなく、むしろ推奨されている」のですが、
サービス側の実装コスト・UX 設計の難しさ・認証基盤の古さ が原因で、まだ広く普及していません。

サービス側の実装が地味に面倒らしい。

パスキーは WebAuthn / FIDO2 を使いますが、
複数パスキーを管理するためには、バックエンド側で以下を整える必要があります:

- 複数の credential ID を 1 アカウントに紐付ける DB 設計
- 個々のパスキーの情報(名前、作成日、最終使用日など)の管理
- 削除機能、安全な再登録フロー
- パスキーの登録 UI をわかりやすくする(どのデバイスのパスキーかわかりにくい)

GitHub・Google など大手はここを丁寧に作り込んでいますが、
**中小サービスがここまでやるのは負担が大きい**

他

- “クロスデバイスパスキー”があればいいんじゃね? という考え方
- 複数デバイス登録はユーザーの理解が追いつかない

も原因。

Auth0 は 1 ユーザ 20 個までパスキーを持てるそうです。
[All You Need To Know About Passkeys at Auth0!](https://auth0.com/blog/all-you-need-to-know-about-passkeys-at-auth0)の "Does Auth0 have any limit on the number of passkeys per user?" のところ参照

### 複数パスキーの UI

- **GitHub** - <https://github.com/settings/security>の "passkeys" のところ。鍵の名前を自分で選べる
- **Google** - <https://myaccount.google.com/signinoptions/passkeys>
  鍵の名前は自動設定(例: "Windows Hello", "Teclast T60")
- **Microsoft アカウント** - <https://account.live.com/proofs/> で。「パスキーがなければサインインまたは確認の新しい方法を追加」。なんで live.com のままなの?
- **Amazon** - `アカウントサービス › ログインとセキュリティ › パスキー` のところ
- **Meta(Facebook)** - <https://accountscenter.facebook.com/password_and_security/> のパスキーのところ

## 概要

- [「パスキー」って一体何だ? パスワード不要の世界がやってくる(1/4 ページ) - ITmedia NEWS](https://www.itmedia.co.jp/news/articles/2301/23/news086.html)
- サンプル - [Passkeys.io – A Passkey Authentication Demo](https://www.passkeys.io/)

## 自前で試す

- [パスワードレスな認証を実現する認証ミドルウェアの hanko | フューチャー技術ブログ](https://future-architect.github.io/articles/20220902a/)
- [Hanko - Open source authentication beyond passwords](https://www.hanko.io/)

## ざっくり

> パスキーは、パスワードを使わない認証方式を検討する業界団体「FIDO Alliance」が仕様を策定した技術。Web 技術の標準化団体である W3C も協力していて、端的にいえば「FIDO2」「WebAuthn」「パスキー」という 3 つの技術を組み合わせたものだ。

FIDO2 (Fast IDentity Online)は WebAuthn (Web Authentication)と FIDO CTAP (Client to Authenticator Protocol)の 2 つの仕様から構成されています。

## 実装状況

[Android と Chrome でパスキーをサポート | Authentication | Google Developers](https://developers.google.com/identity/passkeys/supported-environments)

> パスキーは、同じエコシステム内の複数のデバイス間で同期できます。たとえば、iOS または macOS の Safari で作成されたパスキーは、iCloud キーチェーンに保存されます。Android 版 Chrome で作成されたパスキーは、Google パスワード マネージャーに保存されます。

> macOS と Windows 版 Chrome では、パスキーの保存はローカル デバイスのみとなります。

例えば Windows だったらパスキーはローカルの Windows Hello に入る。Microsoft アカウントで同期、とかは無い(いまのところ)。
そのかわり Windows では Chrome でも Edge でも Firefox でも全部 Hello のパスキーが共通で使える。

## Go 言語による実装

WebAuthn

- [go-webauthn/webauthn: Webauthn/FIDO2 library in golang](https://github.com/go-webauthn/webauthn)
- [duo-labs/webauthn: WebAuthn (FIDO2) server library written in Go](https://github.com/duo-labs/webauthn)

FIDO CTAP

## Java による実装

FIDO2 (Fast IDentity Online)を実装するための WebAuthn (Web Authentication)や FIDO CTAP (Client to Authenticator Protocol)仕様を使用した Java 用のライブラリがいくつかあります。一部の人気のあるライブラリは以下のとおりです。

- "github.com/jchambers/jose4j"は、JWT (JSON Web Tokens)やその他の JSON ベースの署名や暗号化フォーマットを扱うための Java ライブラリです。このライブラリは、WebAuthn 認証を実装するために使用できます。
- "org.fidoalliance.fido2-java-client"は、WebAuthn や CTAP のための FIDO2 クライアントプロトコルの Java 実装です。
- "com.github.webauthn4j"は、WebAuthn や CTAP2 プロトコルの Java 実装です。
- "org.fidoalliance.fido2-java-ctap"は、FIDO2 CTAP2 プロトコルの Java 実装です。

これらのライブラリを使用して、FIDO2 認証サービスを作成でき、アプリケーションに統合して、ユーザーに対する安全な認証を提供することができます。

これらのライブラリは異なる開発者や組織によって維持されていることに注意してください。それぞれ異なる実装、更新、サポートを持っている可能性があります。

## FIDO と FIDO2

FIDO (Fast IDentity Online)は、パスワードに代わる新しい認証方式を提供するために開発された仕様で、FIDO2 は FIDO の最新バージョンです。

FIDO は、指紋認証、顔認証、トークンなどの認証要素を使用し、FIDO 準拠のセキュリティトークンやスマートフォンなどの FIDO 認証デバイスによって提供されます。FIDO2 は、FIDO に基づいて開発され、より柔軟性の高い認証方法を提供します。

FIDO2 は、FIDO に加えて、WebAuthn (Web Authentication) 仕様と FIDO CTAP (Client to Authenticator Protocol) 仕様を提供します。WebAuthn は、Web ブラウザーや Web アプリケーション上でのユーザー認証を安全に行うための仕様で、FIDO CTAP は WebAuthn に依存しない FIDO デバイスを制御するための API です。

FIDO2 は、FIDO の認証方法を拡張し、Web ブラウザーや Web アプリケーション上での認証を可能にし、柔軟性の高い認証方式を提供します。

## FIDO と WebAuthen

FIDO (Fast IDentity Online) と WebAuthn (Web Authentication)は、異なる仕様でありますが、同じ目的である、パスワードに代わる新しい認証方式を提供するために開発されています。

FIDO は、指紋認証、顔認証、トークンなどの認証要素を使用し、FIDO 準拠のセキュリティトークンやスマートフォンなどの FIDO 認証デバイスによって提供されます。FIDO 認証デバイスは、アプリケーションに統合し、Web ブラウザーなどの Web アプリケーションからのアクセスを認証するために使用されます。

WebAuthn は、FIDO の一部として開発され、W3C (World Wide Web Consortium)によって標準化されている Web ブラウザーや Web アプリケーション上でのユーザー認証を安全に行うための仕様です。WebAuthn は、FIDO の認証方法を拡張し、Web ブラウザーや Web アプリケーション上での認証を可能にし、柔軟性の高い認証方式を提供します。

FIDO と WebAuthn の違いは、FIDO は、FIDO 準拠のセキュリティトークンやスマートフォンなどの FIDO 認証デバイスを使用し、Web アプリケーションに統合したアプリケーションによってユーザー認証を行うことを指します。 WebAuthn は、Web ブラウザーや Web アプリケーション上でのユーザー認証を安全に行うための仕様を指します。

## WebAuthn

- [Web Authentication: An API for accessing Public Key Credentials - Level 2](https://www.w3.org/TR/webauthn/) - 仕様
-

(ChatGPT に聞いてみた。なんだかあやしい)

WebAuthn (Web Authentication)は、Web ブラウザーや Web アプリケーション上でのユーザー認証を安全に行うための仕様です。FIDO (Fast IDentity Online) の一部として開発され、W3C (World Wide Web Consortium)によって標準化されています。

WebAuthn は、パスワードに代わる新しい認証方式を提供します。代わりに、WebAuthn は、指紋認証、顔認証、トークンなどの認証要素を使用します。これらの認証要素は、FIDO 準拠のセキュリティトークンやスマートフォンなどの FIDO 認証デバイスによって提供されます。

WebAuthn は、ブラウザーと Web サイト間で安全な認証を行うために、公開鍵暗号を使用します。ブラウザーは、ユーザーの認証デバイスから公開鍵を取得し、Web サイトに送信します。Web サイトは、この公開鍵を使用して、ユーザーの認証デバイスが信頼できることを確認します。

WebAuthn は、パスワードを使用しないため、パスワードのハッキングや漏洩などのセキュリティリスクを軽減します。また、WebAuthn は、二要素認証を簡単に実現するため、さらに高いセキュリティを提供します。

WebAuthn の認証フローは次のようになります。

1. ユーザーがサインアップまたはサインインを行うために Web サイトにアクセスします。
2. Web サイトは、ユーザーのブラウザーに対して認証リクエストを送信します。リクエストには、公開鍵とチャレンジ(ランダムな文字列)が含まれています。
3. ブラウザーは、ユーザーの認証デバイス(FIDO トークンやスマートフォンなど)に対して認証リクエストを送信します。
4. 認証デバイスは、公開鍵とチャレンジを使用して、署名を生成します。この署名は、認証デバイスが信頼できることを示します。
5. 認証デバイスは、署名と公開鍵をブラウザーに返します。
6. ブラウザーは、Web サイトに対して署名と公開鍵を送信します。
7. Web サイトは、署名を検証し、公開鍵を使用して、認証デバイスが信頼できることを確認します。
8. もし認証が成功した場合、Web サイトは、ユーザーに対してアクセスを許可します。

このように、WebAuthn は、ブラウザーと Web サイト間で安全な認証を行うために、公開鍵暗号を使用します。この方式により、パスワードを使用しないため、パスワードのハッキングや漏洩などのセキュリティリスクを軽減します。また、二要素認証を簡単に実現するため、さらに高いセキュリティを提供します。

- [How_WebAuthn_Works_JP.pdf](https://www.okta.com/sites/default/files/2020-08/How_WebAuthn_Works_JP.pdf) の P.10 あたりのフローが参考になるかも。
- [Guide to Web Authentication](https://webauthn.guide/)
- [ウェブ認証 API - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/Web_Authentication_API)

## FIDO UAF, FIDO U2F and FIDO2 (plus FIDO CTAP)

FIDO (Fast IDentity Online)は、パスワードなしでセキュアにオンラインアカウントにアクセスするためのオープン標準です。

FIDO UAF (FIDO Universal Authentication Framework)は、生体認証(指紋認証、顔認証、声認証など)を使用して、ユーザーアカウントにアクセスするためのプロトコルです。

FIDO U2F (FIDO Universal 2nd Factor)は、物理トークン(USB キーや NFC タグなど)を使用して、ユーザーアカウントにアクセスするためのプロトコルです。

FIDO2 は、FIDO UAF および FIDO U2F の両方の機能を統合し、Web 認証を標準化したプロトコルです。FIDO2 は、WebAuthn API を使用し、ブラウザやアプリから直接生体認証デバイスを呼び出すことができます。

FIDO は、FIDO UAF, FIDO U2F, FIDO2 と呼ばれる 3 つのプロトコルと WebAuthn API を使用し、パスワードなしでセキュアなオンラインアカウントにアクセスするためのオープン標準です。

FIDO CTAP (Client to Authenticator Protocol)は、FIDO (Fast IDentity Online)プロトコルにおいて、クライアントデバイスから認証デバイスにリクエストを送信するために使用されるプロトコルです。

CTAP は、FIDO U2F および FIDO2 プロトコルに対応しています。

CTAP は、クライアントデバイスから認証デバイスに対して、生体認証や認証データの読み取りなどの操作を要求するために使用されます。 また、CTAP は、認証デバイスからクライアントデバイスに対して、認証結果などのレスポンスを返すために使用されます。

FIDO CTAP は、FIDO U2F や FIDO2 プロトコルに対応した認証デバイスで使用される通信プロトコルであり、クライアントデバイスから認証デバイスへのリクエストや認証デバイスからクライアントデバイスへのレスポンスを定義している。
