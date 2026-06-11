# apt のメモ

## proxy

```sh
sudo edit /etc/apt/apt.conf.d/95proxy
```

```conf
Acquire::http::Proxy "http://proxy.example.com:8080/";
Acquire::https::Proxy "http://proxy.example.com:8080/";
```

## apt って接続に https ではなく http を使ってる?

sourceにhttp:と書いてあればhttpを使う。

Debian/Ubuntuのリポジトリは通常 http://archive.ubuntu.com/ubuntu/ のようにHTTPで配信されており、
セキュリティは別の仕組み(gpg)で担保しています。
