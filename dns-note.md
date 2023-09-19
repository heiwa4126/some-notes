# DNSメモ

- [DNSメモ](#dnsメモ)
- [プライベートDNSモード または DNS over TLS](#プライベートdnsモード-または-dns-over-tls)
- [リンク](#リンク)

# プライベートDNSモード または DNS over TLS

[「プライベートDNSモード」は何の機能? - いまさら聞けないAndroidのなぜ | マイナビニュース](https://news.mynavi.jp/article/20200411-android_why/)
記事かいた人、実際に試してないでしょ。IPは設定できないです(DNS over TLSだから)。

正解は

- `dns.google`
- または`1dot1dot1dot1.cloudflare-dns.com`
  を入れる。

参考:

- https://developers.google.com/speed/public-dns/docs/using#android
- https://blog.cloudflare.com/enable-private-dns-with-1-1-1-1-on-android-9-pie/

なぜか使いたい`1dot1dot1dot3.cloudflare-dns.com`だと「接続できません」になる。
digでは引けるんだけど...

```sh
$ dig A 1dot1dot1dot3.cloudflare-dns.com

(略)

;; ANSWER SECTION:
1dot1dot1dot3.cloudflare-dns.com. 276 IN A      104.16.248.249
1dot1dot1dot3.cloudflare-dns.com. 276 IN A      104.16.249.249

(略)
```

あれ? 1.1.1.3, 1.0.0.3になってないな... (2020-4-15)

# リンク

- [Introducing 1.1.1.1 for Families](https://blog.cloudflare.com/introducing-1-1-1-1-for-families/)
- [paulmillr/encrypted-dns: Configuration profiles for DNS HTTPS and DNS over TLS for iOS 14 and MacOS Big Sur](https://github.com/paulmillr/encrypted-dns)
- [Set up 1.1.1.1 for Families · Cloudflare 1.1.1.1 docs](https://developers.cloudflare.com/1.1.1.1/1.1.1.1-for-families)
