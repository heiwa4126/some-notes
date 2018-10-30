ZScalerというproxyが来たので、対策

<!-- TOC -->

- [問題](#問題)
- [対策](#対策)
- [参考](#参考)
- [ZScalerの証明書をexportする手順](#zscalerの証明書をexportする手順)
- [Linuxに証明書を追加する手順](#linuxに証明書を追加する手順)
    - [Ubuntuの場合](#ubuntuの場合)
    - [RHEL/CentOS 7](#rhelcentos-7)

<!-- /TOC -->

# 問題

pipやCurlが証明書エラーで使えなくなった。

ZScalerがSSL通信を解答して、ZScalerの証明書で再び暗号化してくるから。

メモ:
ZScalerはagentもチェックしてるみたいで、有名ブラウザとCurlなどでは挙動が違う。

# 対策

ZScalerの証明書をexportして、
CA bundleを作る。
(CentOSの
`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`
にcatして作った)

そのファイルのパスをいくつかの環境変数に設定してやる。

|製品|環境変数|
| ---- | ---- |
|Python|REQUESTS_CA_BUNDLE|
|Curl|CURL_CA_BUNDLE|
|OpenSSL|SSL_CERT_FILE|

CA bundleにしないと
ZScalerがZScalerで署名してくるものと、
そうでないものが入り混じってくるので
**辛い**。

あとroot証明書が自動更新されないのが**危ない**。

# 参考

- [Python requestsライブラリは認証局の証明書をどう管理する? ｜ Developers.IO](https://dev.classmethod.jp/server-side/python/how-to-manage-ca-root-certs-for-requets-library/)

# ZScalerの証明書をexportする手順

(TODO)
Windowsでマウスをカチカチしてpem形式でexport。ああ面倒。


# Linuxに証明書を追加する手順

curlとかでhttpsがエラーになる。curlだけなら-kをつけて証明書エラーを無視すればOKだが、そうもいかないでしょ。

## Ubuntuの場合

参考:
* [Certificates](https://help.ubuntu.com/lts/serverguide/certificates-and-security.html.en)
* [ubuntuに自己認証局の証明書を登録 | misty-magic.h](https://mistymagich.wordpress.com/2012/01/17/ubuntu%E3%81%AB%E8%87%AA%E5%B7%B1%E8%AA%8D%E8%A8%BC%E5%B1%80%E3%81%AE%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%82%92%E7%99%BB%E9%8C%B2/)

1. `/usr/share/ca-certificates`
に
`zscaler`ディレクトリを作成。
1. `/usr/share/ca-certificates/zscaler`に
`ZscalerRootCertificate.cer`ファイルを置く。
1. `/etc/ca-certificates.conf`の末尾に
`zscaler/ZscalerRootCertificate.cer`
を追加。
1. `update-ca-certificates`を実行

## RHEL/CentOS 7

(TODO)
