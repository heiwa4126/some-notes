# リンク

## 概要

- [「パスキー」って一体何だ？　パスワード不要の世界がやってくる（1/4 ページ） - ITmedia NEWS](https://www.itmedia.co.jp/news/articles/2301/23/news086.html)
- サンプル - [Passkeys.io – A Passkey Authentication Demo](https://www.passkeys.io/)

## 自前で試す

- [パスワードレスな認証を実現する認証ミドルウェアのhanko | フューチャー技術ブログ](https://future-architect.github.io/articles/20220902a/)
- [Hanko - Open source authentication beyond passwords](https://www.hanko.io/)

# ざっくり

> パスキーは、パスワードを使わない認証方式を検討する業界団体「FIDO Alliance」が仕様を策定した技術。Web技術の標準化団体であるW3Cも協力していて、端的にいえば「FIDO2」「WebAuthn」「パスキー」という3つの技術を組み合わせたものだ。

FIDO2 (Fast IDentity Online)はWebAuthn (Web Authentication)とFIDO CTAP (Client to Authenticator Protocol)の2つの仕様から構成されています。

# 実装状況

[Android と Chrome でパスキーをサポート | Authentication | Google Developers](https://developers.google.com/identity/passkeys/supported-environments)

> パスキーは、同じエコシステム内の複数のデバイス間で同期できます。たとえば、iOS または macOS の Safari で作成されたパスキーは、iCloud キーチェーンに保存されます。Android 版 Chrome で作成されたパスキーは、Google パスワード マネージャーに保存されます。

> macOS と Windows 版 Chrome では、パスキーの保存はローカル デバイスのみとなります。

例えばWindowsだったらパスキーはローカルのWindows Helloに入る。Microsoftアカウントで同期、とかは無い(いまのところ)。
そのかわりWindowsではChromeでもEdgeでもFirefoxでも全部Helloのパスキーが共通で使える。

# Go言語による実装

WebAuthn

- [go-webauthn/webauthn: Webauthn/FIDO2 library in golang](https://github.com/go-webauthn/webauthn)
- [duo-labs/webauthn: WebAuthn (FIDO2) server library written in Go](https://github.com/duo-labs/webauthn)

FIDO CTAP

# Javaによる実装

FIDO2 (Fast IDentity Online)を実装するためのWebAuthn (Web Authentication)やFIDO CTAP (Client to Authenticator Protocol)仕様を使用したJava用のライブラリがいくつかあります。一部の人気のあるライブラリは以下のとおりです。

- "github.com/jchambers/jose4j"は、JWT (JSON Web Tokens)やその他のJSONベースの署名や暗号化フォーマットを扱うためのJavaライブラリです。このライブラリは、WebAuthn認証を実装するために使用できます。
- "org.fidoalliance.fido2-java-client"は、WebAuthnやCTAPのためのFIDO2クライアントプロトコルのJava実装です。
- "com.github.webauthn4j"は、WebAuthnやCTAP2プロトコルのJava実装です。
- "org.fidoalliance.fido2-java-ctap"は、FIDO2 CTAP2プロトコルのJava実装です。

これらのライブラリを使用して、FIDO2認証サービスを作成でき、アプリケーションに統合して、ユーザーに対する安全な認証を提供することができます。

これらのライブラリは異なる開発者や組織によって維持されていることに注意してください。それぞれ異なる実装、更新、サポートを持っている可能性があります。

# FIDOとFIDO2

FIDO (Fast IDentity Online)は、パスワードに代わる新しい認証方式を提供するために開発された仕様で、FIDO2はFIDOの最新バージョンです。

FIDOは、指紋認証、顔認証、トークンなどの認証要素を使用し、FIDO準拠のセキュリティトークンやスマートフォンなどのFIDO認証デバイスによって提供されます。FIDO2は、FIDOに基づいて開発され、より柔軟性の高い認証方法を提供します。

FIDO2は、FIDOに加えて、WebAuthn (Web Authentication) 仕様とFIDO CTAP (Client to Authenticator Protocol) 仕様を提供します。WebAuthnは、WebブラウザーやWebアプリケーション上でのユーザー認証を安全に行うための仕様で、FIDO CTAPはWebAuthnに依存しないFIDOデバイスを制御するためのAPIです。

FIDO2は、FIDOの認証方法を拡張し、WebブラウザーやWebアプリケーション上での認証を可能にし、柔軟性の高い認証方式を提供します。

# FIDOとWebAuthen

FIDO (Fast IDentity Online) と WebAuthn (Web Authentication)は、異なる仕様でありますが、同じ目的である、パスワードに代わる新しい認証方式を提供するために開発されています。

FIDOは、指紋認証、顔認証、トークンなどの認証要素を使用し、FIDO準拠のセキュリティトークンやスマートフォンなどのFIDO認証デバイスによって提供されます。FIDO認証デバイスは、アプリケーションに統合し、WebブラウザーなどのWebアプリケーションからのアクセスを認証するために使用されます。

WebAuthnは、FIDOの一部として開発され、W3C (World Wide Web Consortium)によって標準化されているWebブラウザーやWebアプリケーション上でのユーザー認証を安全に行うための仕様です。WebAuthnは、FIDOの認証方法を拡張し、WebブラウザーやWebアプリケーション上での認証を可能にし、柔軟性の高い認証方式を提供します。

FIDOとWebAuthnの違いは、FIDOは、FIDO準拠のセキュリティトークンやスマートフォンなどのFIDO認証デバイスを使用し、Webアプリケーションに統合したアプリケーションによってユーザー認証を行うことを指します。 WebAuthnは、WebブラウザーやWebアプリケーション上でのユーザー認証を安全に行うための仕様を指します。

# WebAuthn

- [Web Authentication: An API for accessing Public Key Credentials - Level 2](https://www.w3.org/TR/webauthn/) - 仕様
-

(ChatGPTに聞いてみた。なんだかあやしい)

WebAuthn (Web Authentication)は、WebブラウザーやWebアプリケーション上でのユーザー認証を安全に行うための仕様です。FIDO (Fast IDentity Online) の一部として開発され、W3C (World Wide Web Consortium)によって標準化されています。

WebAuthnは、パスワードに代わる新しい認証方式を提供します。代わりに、WebAuthnは、指紋認証、顔認証、トークンなどの認証要素を使用します。これらの認証要素は、FIDO準拠のセキュリティトークンやスマートフォンなどのFIDO認証デバイスによって提供されます。

WebAuthnは、ブラウザーとWebサイト間で安全な認証を行うために、公開鍵暗号を使用します。ブラウザーは、ユーザーの認証デバイスから公開鍵を取得し、Webサイトに送信します。Webサイトは、この公開鍵を使用して、ユーザーの認証デバイスが信頼できることを確認します。

WebAuthnは、パスワードを使用しないため、パスワードのハッキングや漏洩などのセキュリティリスクを軽減します。また、WebAuthnは、二要素認証を簡単に実現するため、さらに高いセキュリティを提供します。

WebAuthnの認証フローは次のようになります。

1.  ユーザーがサインアップまたはサインインを行うためにWebサイトにアクセスします。
2.  Webサイトは、ユーザーのブラウザーに対して認証リクエストを送信します。リクエストには、公開鍵とチャレンジ（ランダムな文字列）が含まれています。
3.  ブラウザーは、ユーザーの認証デバイス（FIDOトークンやスマートフォンなど）に対して認証リクエストを送信します。
4.  認証デバイスは、公開鍵とチャレンジを使用して、署名を生成します。この署名は、認証デバイスが信頼できることを示します。
5.  認証デバイスは、署名と公開鍵をブラウザーに返します。
6.  ブラウザーは、Webサイトに対して署名と公開鍵を送信します。
7.  Webサイトは、署名を検証し、公開鍵を使用して、認証デバイスが信頼できることを確認します。
8.  もし認証が成功した場合、Webサイトは、ユーザーに対してアクセスを許可します。

このように、WebAuthnは、ブラウザーとWebサイト間で安全な認証を行うために、公開鍵暗号を使用します。この方式により、パスワードを使用しないため、パスワードのハッキングや漏洩などのセキュリティリスクを軽減します。また、二要素認証を簡単に実現するため、さらに高いセキュリティを提供します。

- [How_WebAuthn_Works_JP.pdf](https://www.okta.com/sites/default/files/2020-08/How_WebAuthn_Works_JP.pdf) の P.10あたりのフローが参考になるかも。
- [Guide to Web Authentication](https://webauthn.guide/)
- [ウェブ認証 API - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/Web_Authentication_API)

# FIDO UAF, FIDO U2F and FIDO2 (plus FIDO CTAP)

FIDO (Fast IDentity Online)は、パスワードなしでセキュアにオンラインアカウントにアクセスするためのオープン標準です。

FIDO UAF (FIDO Universal Authentication Framework)は、生体認証（指紋認証、顔認証、声認証など）を使用して、ユーザーアカウントにアクセスするためのプロトコルです。

FIDO U2F (FIDO Universal 2nd Factor)は、物理トークン（USBキーやNFCタグなど）を使用して、ユーザーアカウントにアクセスするためのプロトコルです。

FIDO2は、FIDO UAFおよびFIDO U2Fの両方の機能を統合し、Web認証を標準化したプロトコルです。FIDO2は、WebAuthn APIを使用し、ブラウザやアプリから直接生体認証デバイスを呼び出すことができます。

FIDOは、FIDO UAF, FIDO U2F, FIDO2と呼ばれる3つのプロトコルとWebAuthn APIを使用し、パスワードなしでセキュアなオンラインアカウントにアクセスするためのオープン標準です。

FIDO CTAP (Client to Authenticator Protocol)は、FIDO (Fast IDentity Online)プロトコルにおいて、クライアントデバイスから認証デバイスにリクエストを送信するために使用されるプロトコルです。

CTAPは、FIDO U2FおよびFIDO2プロトコルに対応しています。

CTAPは、クライアントデバイスから認証デバイスに対して、生体認証や認証データの読み取りなどの操作を要求するために使用されます。 また、CTAPは、認証デバイスからクライアントデバイスに対して、認証結果などのレスポンスを返すために使用されます。

FIDO CTAPは、FIDO U2FやFIDO2プロトコルに対応した認証デバイスで使用される通信プロトコルであり、クライアントデバイスから認証デバイスへのリクエストや認証デバイスからクライアントデバイスへのレスポンスを定義している。
