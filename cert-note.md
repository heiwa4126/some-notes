# 証明書関連メモ

- [証明書関連メモ](#証明書関連メモ)
- [CA.pl](#capl)
  - [クライアント証明書](#クライアント証明書)
  - [mutual TLS authentication](#mutual-tls-authentication)
  - [AWS Lambdaで](#aws-lambdaで)
- [他](#他)

# CA.pl

昔っから openssl パッケージについている CA.pl で
プライベート CA(オレオレ認証局)を作ってみるメモ。

- Red Hat 系だと`openssl-perl`パッケージで、パスは`/etc/pki/tls/misc/CA.pl`。
- Debian 系だと`openssl`パッケージに同梱で、パスは`/usr/lib/ssl/misc/CA.pl`

- [4\.9\. Setting Up a Certifying Authority \- Linux Security Cookbook \[Book\]](https://www.oreilly.com/library/view/linux-security-cookbook/0596003919/ch04s09.html)
- [インストール](http://archive.linux.or.jp/JF/JFdocs/SSL-Certificates-HOWTO/x129.html)

CA.pl のパス長いので、
alias か PATH に追加するか、作業ディレクトリに symlink。/usr/local/bin/CA.pl とかに symlink でもいいね。

```sh
ln -sf /usr/lib/ssl/misc/CA.pl .
```

デフォルト設定: `/etc/ssl/openssl.cnf`

Ubuntu での例

```
$ ls -la /etc/ssl/openssl.cnf /usr/lib/ssl/openssl.cnf
-rw-r--r-- 1 root root 10998 Dec 13  2018 /etc/ssl/openssl.cnf
lrwxrwxrwx 1 root root    20 Mar 22 20:42 /usr/lib/ssl/openssl.cnf -> /etc/ssl/openssl.cnf
```

config ファイルは環境変数 OPENSSL_CONFIG から得る。
ローカルにコピーして、
countryName_default とかを書き変える。

```
export OPENSSL_CONFIG="`pwd`/openssl.cnf"
```

```
$ ./CA.pl -newca
CA certificate filename (or enter to create)

Making CA certificate ...
====
openssl req  -new -keyout ./demoCA/private/cakey.pem -out ./demoCA/careq.pem
Generating a RSA private key
......................................................................................+++++
...........+++++
writing new private key to './demoCA/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:JP
State or Province Name (full name) [Some-State]:Tokyo
Locality Name (eg, city) []:Minato-ku
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Iroiro Co
Organizational Unit Name (eg, section) []:Super Secret div.
Common Name (e.g. server FQDN or YOUR name) []:www.example.com
Email Address []:foo@example.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

```
$ tree demoCA/
demoCA/
|-- cacert.pem
|-- careq.pem
|-- certs
|-- crl
|-- crlnumber
|-- index.txt
|-- index.txt.attr
|-- index.txt.old
|-- newcerts
|   `-- 0F33CB476EB6FA690D14DAC7D00BD9D4D5ABAEE1.pem
|-- private
|   `-- cakey.pem
`-- serial
```

Windows なんかでプライベート CA を簡単にインポートできるように DER 形式に変換したバージョンも作っておく。

```
openssl x509 -outform der -in cacert.pem -out cacert.der
```

ふつうにサイト証明書つくってみる.

```sh
mkdir cert1
cd cert1
../CA.pl -newreq
# commonNameだけはちゃんと書くこと
cp newreq.pem ..
cd ..
```

で

```
./CA.pl -sign
```

newcert.pem が生成される。

serial が 1 個増える

```
$ git diff demoCA/serial
diff --git a/demoCA/serial b/demoCA/serial
index ceff5d6..791b9f4 100644
--- a/demoCA/serial
+++ b/demoCA/serial
@@ -1 +1 @@
-0F33CB476EB6FA690D14DAC7D00BD9D4D5ABAEE2
+0F33CB476EB6FA690D14DAC7D00BD9D4D5ABAEE3

$ openssl x509 -noout -in newcert.pem -serial
serial=0F33CB476EB6FA690D14DAC7D00BD9D4D5ABAEE2
```

[サーバ証明書のシリアル番号を確認したい - UPKI-FAQ - meatwiki](https://meatwiki.nii.ac.jp/confluence/pages/viewpage.action?pageId=67622450)

で

```sh
mv newcert.pem cert1
rm newreq.pem
```

いやこれ面倒だな。カレントで作って、最後に pem を 3 つ移動とかがいいか?

## クライアント証明書

[オレオレ認証局でクライアント認証 ～ ウェブの Basic 認証をリプレース \| OPTPiX Labs Blog](https://www.webtech.co.jp/blog/optpix_labs/server/1780/)

CA.pl を使うなら

```sh
./CA.pl -newreq
./CA.pl -sign
./CA.pl -pkcs12
```

で`newcert.p12`ができる。

[PKCS#12形式証明書に関するコマンド - Qiita](https://qiita.com/niko-pado/items/c864ca5b9b22ccaeb0ec)

で、これを使ってみる nginx + curl で。

curl 用に pem 形式のクライアント証明書`curl.pem`を作る。

```sh
openssl pkcs12 -in newcert.p12 -out curl.pem -nodes -clcerts
```

で、

```sh
curl -E ./curl.pem {URL}
```

みたいに。

nginx 側はいろいろあるけど、「特定のディレクトリ以下をクライアント証明が必要」にしてみる

```
# -*- mode: nginx -*-

# ssl_verify_client on;
ssl_verify_client optional;
ssl_client_certificate {CA.plで作ったcacert.pemへのパス};

location /clientauth/ {
  if ($ssl_client_verify != SUCCESS) {
    return 403;
    # ほんとうは 400 Bad Request - No required SSL certificate was sent と返すべき
  }
  alias /somewhere/clientauth/;
  index index.htm;
}
```

[ssl_client_certificate](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_client_certificate)
はサイトごとに 1 つしかもてないみたい。

## mutual TLS authentication

mutual TLS(mTLS または 2way TLS)

[【図解】mutual\-TLS \(mTLS, 2way TLS\),クライアント認証とトークンバインディング over http \| SEの道標](https://milestone-of-se.nesuke.com/nw-basic/tls/mutual-tls-token-binding/)

## AWS Lambdaで

# 他

[秘密鍵からパスフレーズを取り除く - Qiita](https://qiita.com/kadoppe/items/0c289244a3a7286b3d75)
