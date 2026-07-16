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

## Cloudflare で DynDNS

Cloudflare にドメインを登録してあれば、DynDNS っぽく使える。

- [Dynamically update DNS records · Cloudflare DNS docs](https://developers.cloudflare.com/dns/manage-dns-records/how-to/managing-dynamic-ip-addresses/)
- [Cloudflare を ddclient で DDNS 化する](https://zenn.dev/akaregi/articles/4a0db32a4d40a7)
- [Cloudflare を DDNS として利用する \| めもらんだむ](https://chirimenmonster.github.io/2021/09/28/ubuntu-ddclient.html)
- [birkett/CloudFlare\-DDNS\-Updater: Dynamic DNS client for use with CloudFlare](https://github.com/birkett/CloudFlare-DDNS-Updater)
- [ddclient/ddclient: ddclient updates dynamic DNS entries for accounts on a wide range of dynamic DNS services\.](https://github.com/ddclient/ddclient)

こんな感じ↓

1. **DNSレコードの作成**  
   Cloudflare ダッシュボードの DNS 設定画面から、任意のホスト名で A レコードを作成 (IP アドレスはダミーで構いません)。
2. **APIトークンの発行**  
   プロファイルの API トークンページから、「ゾーン DNS を編集する」権限を持つトークンを作成
3. **DDNSクライアントの設定**  
   ルーターの機能や、サーバー機にインストールした ddclient などのツールに、先ほどの API 情報とドメインを登録

### ddclient が Perl製なのがちょっと気に入らない場合

**Python製**

- **[ddupdate](https://github.com/leamas/ddupdate)** — プラグイン式で Cloudflare 対応あり
- **[cloudflare-ddns](https://github.com/timothymiller/cloudflare-ddns)** — Cloudflare 専用、Docker 対応、設定が YAML で簡潔

**Go製**

- **[cloudflare-ddns (favonia)](https://github.com/favonia/cloudflare-ddns)** — Cloudflare 専用でシングルバイナリ、Docker/Kubernetes 対応が充実、IPv4/IPv6 両対応

**Shell Script**

- Cloudflare の API は非常にシンプルなので、`curl` + `jq` で自前スクリプトも現実的です:

```bash
#!/bin/bash
ZONE_ID="your_zone_id"
RECORD_ID="your_record_id"
API_TOKEN="your_api_token"
HOSTNAME="home.example.com"

IP=$(curl -s https://api.ipify.org)

curl -s -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  --data "{\"content\":\"$IP\"}"
```

"api.ipify.org" のとこは状況による。IP がわかるなら(たとえばローカルのみで使う場合)、ここはそれに変える。

```bash
# 特定のインターフェースから取得（例: eth0）
IP=$(ip -4 addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f1)

# またはデフォルトルートのインターフェースを自動検出
IP=$(ip -4 addr show $(ip route show default | awk '/default/ {print $5}') \
  | awk '/inet / {print $2}' | cut -d/ -f1)

# IPv6の場合はリンクローカル、ULA、グローバルが混在するので、フィルタが必要
# グローバルユニキャスト（2000::/3）のみ取得する例
IP=$(ip -6 addr show eth0 | awk '/inet6.*global/ {print $2}' | cut -d/ -f1 | head -1)
```
