- [Azureのインスタンスからメールを送る](#azureのインスタンスからメールを送る)
  - [SendGrid編](#sendgrid編)
  - [Postfix編](#postfix編)
  - [exim4](#exim4)
- [改行を有効にする。](#改行を有効にする)
- [RHEL7のpostfixでうまく動かないとき](#rhel7のpostfixでうまく動かないとき)
- [リンク](#リンク)


# Azureのインスタンスからメールを送る

Postfix+SendGridを使う例。

## SendGrid編

以下のURLを途中まで参照(「SendGrid API キーを確認するには」の前まで)。

[SendGrid 電子メール サービスの使用方法 (.NET) | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/sendgrid-dotnet-how-to-send-email)

> 4.サインアップ フォームに入力し

Nameはリソース名。"SendGridxxxx"のような名前をつける。自分の名前は使わないこと。これはSendGridのユーザ名にはならない。

ただしPasswordはあとでSendGridのパスワードになるので絶対に忘れないこと。

> 購入を完了して [管理] をクリック

"Manage"をクリック。SendGridの管理画面に飛ぶ。
アカウント確認メールが来るので答える。

> SendGrid API キーを確認するには

のところで

SendGridのマネージャで
Settings > API Keys > Create API Key
で
Restricted Accessを選び
Mail SendのMail Sendだけ有効なキーを作る
(ここのUIが変なので苦労すること)。


## Postfix編

以下のURLを参照

[Postfixでメール送信 - ドキュメント | SendGrid](https://sendgrid.kke.co.jp/docs/Integrate/Mail_Servers/postfix.html)

`/etc/postfix/sasl_passwd`に設定する"ユーザ名:パスワード"は、
- ユーザ名 `apikey` <- この6文字
- パスワード さっき作ったmail sendだけ有効なAPIキー

を指定すること。

## exim4

[Exim 4 configuration for SendGrid | SendGrid Documentation](https://sendgrid.com/docs/for-developers/sending-email/exim/)

postfix同様に
- ユーザ名 `apikey` <- この6文字
- パスワード さっき作ったmail sendだけ有効なAPIキー

にすればできるはず(試してません)。


# 改行を有効にする。

初期設定ではtext/planで送ったメールがhtmlに変換される。
これがプレーンテクストを1個の`<p>`につめこむ変換なので、
HTMLメール対応のメールだと、改行が消えてしまう。

[よくある質問 – メール改行トラブル編 | SendGridブログ](https://sendgrid.kke.co.jp/blog/?p=1521)
に従って、
[ポータル](https://app.sendgrid.com/login)から
```
settings -> mail settings -> plain content -> active
```
にしておくといいです。

ただし、おそらく平文にするとビーコンによる既読管理ができなくなると思う。

# RHEL7のpostfixでうまく動かないとき

```
Feb 14 04:41:32 XXXXXXXXXXXXXX postfix/smtp[22222]: warning: SASL authentication failure: No worthy mechs found
Feb 14 04:41:32 XXXXXXXXXXXXXX postfix/smtp[22222]: 6F263169B46: SASL authentication failed; cannot authenticate to server smtp.sendgrid.net[161.202.148.179]: no mechanism available
```
みたいなログが出るときには、
たぶんパッケージが足りない。
```
yum install cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain cyrus-sasl-md5
```
で、だいたい大丈夫なはず。

# リンク

メールのログ - [email activity](https://app.sendgrid.com/email_activity)

`search` か `show all activity`をクリック。


過去バウンスされたので送信しない先 - [bounces](https://app.sendgrid.com/suppressions/bounces)
