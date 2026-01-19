- [Azureの方針](#azureの方針)
- [AzureのVMインスタンスからメールを送る](#azureのvmインスタンスからメールを送る)
  - [SendGrid編](#sendgrid編)
  - [Postfix編](#postfix編)
  - [exim4の場合は](#exim4の場合は)
- [TIPS: 改行を有効にする。](#tips-改行を有効にする)
- [TIPS: RHEL7のpostfixでうまく動かないとき](#tips-rhel7のpostfixでうまく動かないとき)
- [SendGridポータルの便利リンク](#sendgridポータルの便利リンク)

# Azureの方針

[Azure でのアウトバウンド SMTP 接続のトラブルシューティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-network/troubleshoot-outbound-smtp-connectivity)

# AzureのVMインスタンスからメールを送る

Postfix+SendGrid を使う例。

## SendGrid編

以下の URL を途中まで参照(「SendGrid API キーを確認するには」の前まで)。

[SendGrid 電子メール サービスの使用方法 (.NET) | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/sendgrid-dotnet-how-to-send-email)

> 4.サインアップ フォームに入力し

Name はリソース名。"SendGridxxxx"のような名前をつける。自分の名前は使わないこと。これは SendGrid のユーザ名にはならない。

ただし Password はあとで SendGrid のパスワードになるので絶対に忘れないこと。

> 購入を完了して [管理] をクリック

"Manage"をクリック。SendGrid の管理画面に飛ぶ。
アカウント確認メールが来るので答える。

> SendGrid API キーを確認するには

のところで

SendGrid のマネージャで
Settings > API Keys > Create API Key
で
Restricted Access を選び
Mail Send の Mail Send だけ有効なキーを作る
(ここの UI が変なので苦労すること)。

## Postfix編

以下の URL を参照

[Postfixでメール送信 - ドキュメント | SendGrid](https://sendgrid.kke.co.jp/docs/Integrate/Mail_Servers/postfix.html)

`/etc/postfix/sasl_passwd`に設定する"ユーザ名:パスワード"は、

- ユーザ名 `apikey` <- この 6 文字
- パスワードさっき作った mail send だけ有効な API キー

を指定すること。

## exim4の場合は

[Exim 4 configuration for SendGrid | SendGrid Documentation](https://sendgrid.com/docs/for-developers/sending-email/exim/)

postfix 同様に

- ユーザ名 `apikey` <- この 6 文字
- パスワードさっき作った mail send だけ有効な API キー

にすればできるはず(試してません)。

# TIPS: 改行を有効にする。

初期設定では text/plan で送ったメールが html に変換される。
これがプレーンテクストを 1 個の`<p>`につめこむ変換なので、
HTML メール対応のメールだと、改行が消えてしまう。

[よくある質問 – メール改行トラブル編 | SendGridブログ](https://sendgrid.kke.co.jp/blog/?p=1521)
に従って、
[ポータル](https://app.sendgrid.com/login)から

```
settings -> mail settings -> plain content -> active
```

にしておくといいです。

ただし、おそらく平文にするとビーコンによる既読管理ができなくなると思う。

# TIPS: RHEL7のpostfixでうまく動かないとき

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

# SendGridポータルの便利リンク

- メールのログ - [email activity](https://app.sendgrid.com/email_activity) - `search` か `show all activity`をクリック。
- 過去バウンスされたので送信しない先 - [bounces](https://app.sendgrid.com/suppressions/bounces)
