# Amazon SESメモ

メールを送る

- [Amazon SES コンソールを使用して E メールを送信する \- Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/send-an-email-from-console.html)
- [Amazon SES コンソール](https://console.aws.amazon.com/ses/)
- [AWS Simple Email Service (新しいコンソール)](https://console.aws.amazon.com/sesv2/)

# ドメイン認証

ドメインを認証すると、送信アドレスをいちいち認証しなくても、
そのドメインの全アドレスが sender に使えるようになる。

あと IAM にも

ドメインを所有していて、
DNS 設定ができるなら、
TXT レコードと DKIM の CNAME を追加してみる。

- [Amazon SES でのドメインの検証 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-domain-procedure.html)
- [Amazon SES でのドメインの検証 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-domains.html)
- [E メールアドレスおよびドメインの認証の問題 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/troubleshoot-verification.html#troubleshoot-verification-domain)

bind9 を使ってるので
`/etc/bind/zone/example.com.zone`に
表示されたレコードを追加 & `rndc reload`。

```
;; for Amazon SES
$TTL  60
_amazonses.example.com. TXT "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu="
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx._domainkey.example.com CNAME xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.dkim.amazonses.com
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy._domainkey.example.com CNAME yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy.dkim.amazonses.com
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx._domainkey.example.com CNAME xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.dkim.amazonses.com
;; example.com MX 10 inbound-smtp.us-east-1.amazonaws.com
```

(TTL はあとで伸ばす。AWS の route53 でのサンプルでは 1800 になってた)

これで最大 48 時間待てばいいらしい。
-> そんなに待たなかった。2 時間ぐらい?で
Verification は `Status: verified`になった。

これで

> You can send email from any email address on this domain.

となった。

# SESのSMTPインタフェース

このへんから。

- [Amazon SES SMTP 認証情報を取得 - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/smtp-credentials.html)
- [Amazon SES とPostfixの統合 - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/postfix.html)

# Amazon SES メールボックスシミュレーター

バウンスのテストなどに使える email アドレス一覧

[Amazon SES での E メール送信のテスト - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/send-email-simulator.html)

# どこでも好きなアドレスにメールを送る

※ バウンスについてはあとで考える。

- [Moving out of the Amazon SES sandbox - Amazon Simple Email Service](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html)
- [(自動翻訳) Amazon SES サンドボックス外への移動 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/dg/request-production-access.html)

サンドボックスの制限(↑から引用):

- E メールの送信先は、検証済み E メールアドレスおよびドメイン、または Amazon SES メールボックスシミュレーターに制限されます。
- 最大で 24 時間あたり 200 メッセージを送信できます。
- 最大で 1 秒あたり 1 メッセージを送信できます。

これらに加えてサンドボックス内でも外でも適応される制限:

- E メールは、検証済み E メールアドレスまたはドメインからのみ送信できます。

サンドボックス外への移動の申請は自動化できる
(CLI は
[上記](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html)参照)。

[(自動翻訳) Amazon SES サンドボックス外への移動](https://docs.aws.amazon.com/ja_jp/ses/latest/dg/request-production-access.html)
から引用:

```
アカウントの詳細のレビューを送信すると、レビューが完了するまで詳細を編集できなくなります。AWS Support チームは、お客様のリクエストに対して、24 時間以内に一次回答を行います。

迷惑なコンテンツや悪意のあるコンテンツを送信するためにシステムが悪用されないように、各リクエストを慎重に検討する必要があります。可能であれば、24 時間以内にリクエストを承認します。ただし、お客様から追加情報を取得する必要がある場合は、お客様のリクエストの解決に時間がかかる場合があります。お客様のユースケースが AWS の方針と一致しない場合は、リクエストを承認できない場合があります。
```

...なんか EC2 立てて SendGrid 使ったほうが楽かもしれない。

サンドボックスの中外の状態はテナントで 1 個しかないみたい。ドメインを複数ホストしても 1 個。

# SESでメール送るのに最低でも必要なもの

- 検証されたメールアドレス
- または信頼されたドメイン

が必要。

メールアドレスを検証する、は自動ではできない(「届いたメールについてる URL をクリック」式だから。届くメールもかなり SPAM っぽい)。
検証メールは自動で送れる。

[E メールアドレスの検証 \- Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-email-addresses-procedure.html)

```sh
aws sesv2 create-email-identity --email-identity foobarbaz@gmail.com
```

# 返送率と苦情率

- 返送率、バウンス率、 bounce rate
- 苦情率、 complaint rate

[Amazon SES で返送率または苦情率のしきい値に関する通知を設定する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/ses-reputation-dashboard-bounce-rate/)

バウンス率はわかるけど、苦情率って何?

- [Email Definitions: Complaint Rate \| AWS Messaging & Targeting Blog](https://aws.amazon.com/jp/blogs/messaging-and-targeting/email-definitions-complaint-rate/?nc1=h_ls)
- [電子メールの定義：苦情率\| AWSメッセージングおよびターゲティングブログ](https://aws-amazon-com.translate.goog/jp/blogs/messaging-and-targeting/email-definitions-complaint-rate/?_x_tr_sl=en&_x_tr_tl=ja&_x_tr_hl=ja&_x_tr_pto=nui)

なにこれ...「苦情の総数」を知る方法がなんだかダークだ。
