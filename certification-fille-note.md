# サーバー証明書のメモ

## SAN(Subject Alternative Name)

現在は SAN が必須扱いで、CN(Common Name) はほぼ無視

SAN には DNS と IP が複数書ける。

## ワイルドカードサービス

で、

- [nip\.io / sslip\.ioへようこそ](https://sslip.io/)
- [cunnie/sslip\.io: Golang\-based DNS server which maps DNS records with embedded IP addresses to those addresses\.](https://github.com/cunnie/sslip.io)

`192-168-1-1.sslip.io` みたいのに `A 192.168.1.1` を返してくれるサービス

なので自前 CA で SAN が

```conf
DNS.1 = *.nip.io
DNS.2 = *.sslip.io
DNS.3 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
```

のようなサーバ証明書を作ってやると、全ホスト対応のサーバ証明書ができて便利。
