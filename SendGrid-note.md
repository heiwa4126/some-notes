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

~~Postfixでメールを送るならAPIキーは不要。~~
訂正: API形式の方がセキュア。

[PostfixからSendGridへのリレーをカスタマイズする | SendGridブログ](https://sendgrid.kke.co.jp/blog/?p=8192)
にある、
> [smtp.sendgrid.net]:587 apikey:SendGridのAPIキー

SendGridのマネージャで
Settings > API Keys > Create API Key
Restricted Access で mail sendだけ有効なキーを作ればOK.

こちらのほうが安全

## Postfix編

以下のURLを参照

**記述が古い**
[Postfixでメール送信 - ドキュメント | SendGrid](https://sendgrid.kke.co.jp/docs/Integrate/Mail_Servers/postfix.html)

~~`/etc/postfix/sasl_passwd`に設定する"ユーザ名:パスワード"は、
SendGridの管理画面の左上の自分の名前のプルダウンからAccount Detailsを選び
USERNAMEのところに書いてあるのが、ユーザー名。~~

~~AzureのSendGridリソースのSetteings - ConfigurationsのUSERNAMEでも同じ。~~

~~パスワードはさっき設定したパスワード。~~

`/etc/postfix/sasl_passwd`に設定する"ユーザ名:パスワード"は、
- ユーザ名 `apikey`
- パスワード さっき作ったmail sendだけ有効なAPIキー

を指定すること。

