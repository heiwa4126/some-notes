# SSL Server Test - 評価"F"からの脱出

Nginx + Let's Encrypt(Certbot)で構築したWebサーバを
[Qualys SSL LABS SSL Server Test](https://www.ssllabs.com/ssltest/)
でチェックしたら**評価F**だったので直す。

[SSL Server Test (Powered by Qualys SSL Labs)](https://www.ssllabs.com/ssltest/)

## 最初のステップ

Nginxなので以下の通りに設定する。

[NginxでHTTPS：ゼロから始めてSSLの評価をA+にするまで Part 2 – 設定、Ciphersuite、パフォーマンス | POSTD](https://postd.cc/https-on-nginx-from-zero-to-a-plus-part-2-configuration-ciphersuites-and-performance/)

いまのところ
```
  ssl_stapling on;
  ssl_prefer_server_ciphers on;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers 'kEECDH+ECDSA+AES128 kEECDH+ECDSA+AES256 kEECDH+AES128 kEECDH+AES256 kEDH+AES128 kEDH+AES256 DES-CB C3-SHA +SHA !aNULL !eNULL !LOW !kECDH !DSS !MD5 !EXP !PSK !SRP !CAMELLIA !SEED !3DES !DHE RSA+AES128';
```
これで評価A。(使えないブラウザが1種類)
- TLS_RSA_WITH_3DES_EDE_CBC_SHA

を追加できれば...

こうすればいきなり評価Aなのだが(DNS CAAがないのでA+にはならない)、
```
ssl_protocols TLSv1.2;
ssl_ciphers 'TLSv1.2';
```
見えないブラウザが増えてしまう。

ssl_ciphersのチェックは
```
openssl ciphers -v 'ECDH !aNULL !eNULL !RC4 !SHA1' | sort
```
のようにして、問題のある方式がでてこなくなるまで調整する。

nginxのconfigのシンタックスチェックは
```
nginx -t
```


参考:
* [Nginx SSLの評価を「A+」に上げる](https://rin-ka.net/ssl-test/)
* [SSL and TLS Deployment Best Practices · ssllabs/research Wiki](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
* [HTTPS on Nginx: From Zero to A+ (Part 2) - Configuration, Ciphersuites, and Performance - Julian Simioni](https://juliansimioni.com/blog/https-on-nginx-from-zero-to-a-plus-part-2-configuration-ciphersuites-and-performance/)
* [Webサーバー nginx における SSL証明書設定の安全性向上 ～SSL Server Test で A+ 判定を目指して～ | SaintSouth.NET](https://www.saintsouth.net/blog/safety-of-ssl-certificate-setting-improvements-in-web-server-nginx-to-get-rankaplus-from-ssl-server-test/)