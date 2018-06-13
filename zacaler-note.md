ZScalerというproxyが来たので、対策

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
