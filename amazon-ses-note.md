# Amazon SESメモ


# ドメイン認証

ドメインを認証すると、送信アドレスをいちいち認証しなくても、
そのドメインの全アドレスがsenderに使えるようになる。

あとIAMにも

ドメインを所有していて、
DNS設定ができるなら、
TXTレコードとDKIMのCNAMEを追加してみる。

- [Amazon SES でのドメインの検証 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-domain-procedure.html)
- [Amazon SES でのドメインの検証 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-domains.html)
- [E メールアドレスおよびドメインの認証の問題 - Amazon Simple Email Service](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/troubleshoot-verification.html#troubleshoot-verification-domain)

bind9を使ってるので
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

(TTLはあとで伸ばす。AWSのroute53でのサンプルでは1800になってた)

これで最大48時間待てばいいらしい。
-> そんなに待たなかった。2時間ぐらい?で 
Verification は `Status: verified`になった。

これで

> You can send email from any email address on this domain.

となった。
