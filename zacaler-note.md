# ZScaler

ZScalerというproxyが来たので、対策。
proxyというよりは「men-in-middleでSSL通信を盗聴改竄する」やべえ製品ではある。

- [ZScaler](#zscaler)
- [問題](#問題)
- [対策](#対策)
- [参考](#参考)
- [ZScalerの証明書をexportする手順](#zscalerの証明書をexportする手順)
- [Linuxに証明書を追加する手順](#linuxに証明書を追加する手順)
  - [Ubuntuの場合](#ubuntuの場合)
  - [RHEL/CentOS 7の場合](#rhelcentos-7の場合)
- [そのほか](#そのほか)

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

| 製品    | 環境変数           |
| ------- | ------------------ |
| Python  | REQUESTS_CA_BUNDLE |
| Curl    | CURL_CA_BUNDLE     |
| OpenSSL | SSL_CERT_FILE      |

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

curlとかで有名でないホストに対するhttps:がエラーになる。Let's Encryptなんかだとまるでダメ。
curlだけなら-kをつけて証明書エラーを無視すればOKだが、そうもいかないでしょ。

## Ubuntuの場合

参考:

- [Certificates](https://help.ubuntu.com/lts/serverguide/certificates-and-security.html.en)
- [独自(root)CA のインストール方法 - Qiita](https://qiita.com/msi/items/9cb90271836386dafce3)
- [ubuntuに自己認証局の証明書を登録 | misty-magic.h](https://mistymagich.wordpress.com/2012/01/17/ubuntu%E3%81%AB%E8%87%AA%E5%B7%B1%E8%AA%8D%E8%A8%BC%E5%B1%80%E3%81%AE%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%82%92%E7%99%BB%E9%8C%B2/)

1. `/usr/share/ca-certificates`
   に
   `zscaler`ディレクトリを作成。
1. `/usr/share/ca-certificates/zscaler`に
   `ZscalerRootCertificate.cer`ファイルを置く。(拡張子は.crtかも。PEM形式ならOK)
1. `/etc/ca-certificates.conf`の末尾に
   `zscaler/ZscalerRootCertificate.cer`
   を追加。最後に改行が必要。
1. `update-ca-certificates`を実行

`/etc/ssl/certs/ca-certificates.crt`が更新されるらしい

立ち上がってるデーモンは再起動する必要がある(snapdとか)。
めんどくさかったらサーバごとreboot。

## RHEL/CentOS 7の場合

(RHEL 6/Cent 6では手順が違います)

証明書を置くディレクトリが2つあるみたいで、使い分けがよくわからない

- /usr/share/pki/ca-trust-source/
- /etc/pki/ca-trust/source

双方にREADMEがあるので、見比べてみると

```
# diff -u /etc/pki/ca-trust/source/README /usr/share/pki/ca-trust-source/README
-interpreted with a high priority - higher than the ones found in
-/usr/share/pki/ca-trust-source/.
+interpreted with a low priority - lower than the ones found in
+/etc/pki/ca-trust/source/ .
```

優先度が違うらしい。

- (優先度高) /usr/share/pki/ca-trust-source/
- (優先度低) /etc/pki/ca-trust/source

今回は低いほうで試す。手順はREADMEに書いてあるとおり。

1. `/etc/pki/ca-trust/source/anchors/`に
   `ZscalerRootCertificate.cer`ファイルを置く。
1. `update-ca-trust`を実行

結果は`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`に。
(`/etc/pki/tls/certs/ca-bundle.crt`かも? それはRHEL6)

これでcurlで-kなしでもエラーがでなくなる。

参考:

- [Update & Add CA Certificates Bundle in RedHat & CentOS - Tech Journey](https://techjourney.net/update-add-ca-certificates-bundle-in-redhat-centos/)

# そのほか

- [Goodwine/ZScalerSux: This is my extension for Chrome which allows you to save a username and password for your Zscaler login screen to avoid losing as much time as possible.](https://github.com/Goodwine/ZScalerSux)
- [CentOS7の検証: CA証明書の管理方針が変更に - s_tajima:TechBlog](http://s-tajima.hateblo.jp/entry/2014/07/31/152949)
- [RHEL 6 および RHEL 7 で信頼されている CA 証明書の一覧をリセットする](https://access.redhat.com/ja/solutions/2769011)
- [Firefox: How to audit & reset the list of trusted servers/CAs](https://access.redhat.com/solutions/1549043)
