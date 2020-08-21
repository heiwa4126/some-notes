# SSL Server Test - 評価"F"からの脱出

Nginx + Let's Encrypt(Certbot)で構築したWebサーバを
[Qualys SSL LABS SSL Server Test](https://www.ssllabs.com/ssltest/)
でチェックしたら**評価F**だったので直す。

- [SSL Server Test - 評価"F"からの脱出](#ssl-server-test---評価fからの脱出)
  - [ステップ](#ステップ)
  - [メモ](#メモ)
  - [参考](#参考)
- [Apache2参考設定](#apache2参考設定)
- [RHEL7でcertbot](#rhel7でcertbot)


## ステップ

Nginxなので以下の通りに設定する。

[NginxでHTTPS：ゼロから始めてSSLの評価をA+にするまで Part 2 – 設定、Ciphersuite、パフォーマンス | POSTD](https://postd.cc/https-on-nginx-from-zero-to-a-plus-part-2-configuration-ciphersuites-and-performance/)

いまのところ
```
  ssl_stapling on;
  ssl_prefer_server_ciphers on;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers 'kEECDH+ECDSA+AES128 kEECDH+ECDSA+AES256 kEECDH+AES128 kEECDH+AES256 kEDH+AES128 kEDH+AES256 DES-CB C3-SHA +SHA !aNULL !eNULL !LOW !kECDH !DSS !MD5 !EXP !PSK !SRP !CAMELLIA !SEED !DHE RSA+AES128';
```
`ssl_ciphers`だけちょっとアレンジした。

これで評価A(DNS CAAがないのでA+にはならない)。
使えないブラウザもなし。

こうすればいきなり評価Aなのだが
```
ssl_protocols TLSv1.2;
ssl_ciphers 'TLSv1.2';
```
見えないブラウザが増えてしまう。

## メモ

ssl_ciphersのチェックは
```
openssl ciphers -v 'ECDH !aNULL !eNULL !RC4 !SHA1' | sort
```
のようにして、問題のある方式がでてこなくなるまで調整する。
`-v`なしだと':'でつないだ1行で出力される。

nginxのconfigのシンタックスチェックは
```
nginx -t
```
で。


## 参考
* [Nginx SSLの評価を「A+」に上げる](https://rin-ka.net/ssl-test/)
* [SSL and TLS Deployment Best Practices · ssllabs/research Wiki](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
* [HTTPS on Nginx: From Zero to A+ (Part 2) - Configuration, Ciphersuites, and Performance - Julian Simioni](https://juliansimioni.com/blog/https-on-nginx-from-zero-to-a-plus-part-2-configuration-ciphersuites-and-performance/)
* [orangejulius/https-on-nginx: Notes for setting up HTTPS on Nginx](https://github.com/orangejulius/https-on-nginx)
* [Webサーバー nginx における SSL証明書設定の安全性向上 ～SSL Server Test で A+ 判定を目指して～ | SaintSouth.NET](https://www.saintsouth.net/blog/safety-of-ssl-certificate-setting-improvements-in-web-server-nginx-to-get-rankaplus-from-ssl-server-test/)


# Apache2参考設定

`/etc/letsencrypt/options-ssl-apache.conf`


[SSL Server Test (Powered by Qualys SSL Labs)](https://www.ssllabs.com/ssltest/index.html)で
Aが取れる設定。

weakなcryptはなくなるけど、つながるクライアントが少し減る。
```
SSLProtocol    all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA
-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:!DSS
```

少し妥協して
```
SSLProtocol    all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite HIGH:!MEDIUM:!aNULL:!MD5:!RC4:!3DES:!CBC
```

ぐらいがいいかもしれない。

# RHEL7でcertbot

[Certbot - Centosrhel7 Apache](https://certbot.eff.org/lets-encrypt/centosrhel7-apache)
にある通り、EPELを有効にして

```sh
sudo yum install certbot python2-certbot-apache
```
すると、`python-zope-interface`パッケージが無いって怒られる。

このパッケージはRHEL7 の optional channelにあるので、
```sh
yum-config-manager --enable rhel-7-server-optional-rpms
# AWSやAzureの場合はこっち↓
yum-config-manager --enable rhui-rhel-7-server-rhui-optional-rpms
```
してから実行すること。

で、`/etc/httpd/conf/http.conf`の最後に
```
<VirtualHost *:80>
ServerName your.site.domain
</VirtualHost>
```
を追加してから、`certbot --apache`

あとはrenewを設定。