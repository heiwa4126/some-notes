ZScalerというproxyが来たので、対策

# 問題

pipやcuelが証明書エラーで使えなくなった。

ZScalerがSSL通信を解答して、ZScalerの証明書で再び暗号化してくるから。

ZScalerはaganetもチェックしてるみたいで、有名ブラウザとCurlなどでは挙動が違う。

# 対策

ZScalerの証明書をexportして、いくつかの環境変数に設定してやる。

|製品|環境変数|
| ---- | ---- |
|Python|REQUESTS_CA_BUNDLE|
|Curl|CURL_CA_BUNDLE |
|OpenSSL|SSL_CERT_FILE|


# 参考

- [Python requestsライブラリは認証局の証明書をどう管理する? ｜ Developers.IO](https://dev.classmethod.jp/server-side/python/how-to-manage-ca-root-certs-for-requets-library/)

# ZScalerの証明書をexportする手順

(TODO)
Windowsでマウスをカチカチしてpem形式でexport。ああ面倒。
