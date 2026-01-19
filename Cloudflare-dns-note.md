# Cloudflare DNS のメモ

Cloudflare でカスタムドメインを使う場合、
Workers ではネームサーバごと預けないと威力を発揮しないが、
Pages では CNAME でもいける。

## ↑ の補足

## free 枠での制限

- **DNS クエリの制限:** Cloudflare は無料プランでも DNS クエリ数に制限を設けておらず、無制限
- **DNS レコードの制限:** 無料プランでは、2024 年 9 月 1 日以降に作成されたゾーンは 200 件の DNS レコードまで、2024 年 9 月 1 日以前に作成されたゾーンは 1,000 件までのレコードを追加できる
- **ドメイン数の制限:** Cloudflare アカウントで管理できるドメイン数(ゾーン数)には、無料プランでも特に制限はない

引用元:

- [Does Cloudflare charge for or limit DNS queries?](https://developers.cloudflare.com/dns/troubleshooting/faq/#does-cloudflare-charge-for-or-limit-dns-queries)
- [Features and plans · Cloudflare DNS docs](https://developers.cloudflare.com/dns/reference/all-features/) の "DNS records management" のところ
- [Limits for Free domains or hosting](https://community.cloudflare.com/t/limits-for-free-domains-or-hosting/611536)
- あと Cloudflare Pages で使えるカスタムドメインの上限値
  [Custom domains](https://developers.cloudflare.com/pages/platform/limits/#custom-domains)

## Apex ドメインのフラット化 (apex domain flattening)

**重要:** フラット化は Cloudflare DNS の機能

Apex ドメイン(`www.example.com`ではなく`example.com`のようなやつ)には
CNAME がつけられない。Apex ドメイン以外にルートドメインとかネイキッドドメインと呼ぶこともある。

DNS の仕様で、apex(ルート)には CNAME を設定できないっていう制限がある。
CNAME は他の DNS レコードと共存できないし、
SOA や NS も存在する apex には使えない。

で、「`example.com` を `your-project.pages.dev` に CNAME」
的なことをしたい時、
Cloudflare DNS で `example.com` をそれぞれの CDN の A/AAAA レコードとして返す機能。

で、その IP は Cloudflare のエニーキャスト(Anycast)CDN ネットワークの入口になっている。
Anycast とは、
世界中の多数の CDN エッジノードが、同じ IP アドレスを持っている仕組み。
