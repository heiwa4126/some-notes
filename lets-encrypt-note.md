# Let's Encrypt のメモ

## ACMEチャレンジ

ACME v2 の正式規格 = [RFC 8555](https://datatracker.ietf.org/doc/html/rfc8555)

ACME v1 は 非標準(Let's Encrypt独自)

## ACME クライアント

[ACME クライアント実装 \- Let's Encrypt](https://letsencrypt.org/ja/docs/client-options/)

Webサーバだったら、
[おすすめのクライアント: Certbot](https://letsencrypt.org/ja/docs/client-options/#%E3%81%8A%E3%81%99%E3%81%99%E3%82%81%E3%81%AE%E3%82%AF%E3%83%A9%E3%82%A4%E3%82%A2%E3%83%B3%E3%83%88-certbot)。確かに導入も自動更新も便利すぎる。

PostfixでSMTP over SSL/TLSで使いたかったら?

## Certbot

Ubuntu で SNAP版の Certbot 使ってるんですが
/var/log/letsencrypt/letsencrypt.log に出るログが

- DEBUG レベルでうるさい
- logrotete しない

のは、どうすれば治る?

設定は
`/etc/letsencrypt/cli.ini` に書く

リファレンスは
[certbot — Certbot 5\.6\.0 documentation](https://eff-certbot.readthedocs.io/en/stable/man/certbot.html)

または `certbot --help all`

cli.ini には `--` を取り除いたやつを書く

なので

```config
quiet = true
max-log-backups = 100
```

のように書いておけばいい。(max-log-backupsのデフォルトは1000)

### (この環境で) renew の成功/失敗を見張るのは

```sh
journalctl -u snap.certbot.renew.service --since "7 days ago"
# snapでもできる
snap logs certbot.renew
```

みたいな。

サービスの確認は

```sh
# timer と service の確認
systemctl list-timers | grep certbot
systemctl status snap.certbot.renew.timer
systemctl status snap.certbot.renew.service
```

### (この環境で) renew が実行された時間と、snap.certbot.renew.timerの時間がぜんぜん違う

`snap.certbot.renew.service` のほう

```console
$ sudo systemctl cat snap.certbot.renew.timer

(略)
[Timer]
Unit=snap.certbot.renew.service
OnCalendar=*-*-* 10:54
OnCalendar=*-*-* 18:19
(略)

$ sudo systemctl cat snap.certbot.renew.service

(略)
[Service]
ExecStart=/usr/bin/snap run --timer="00:00~24:00/2" certbot.renew
(略)

$ LANG=C TZ=UTC journalctl -u snap.certbot.renew.service -r

(略)
May 29 01:54:06 sa5 systemd[1]: snap.certbot.renew.service: Consumed 2.716s CPU time.
May 29 01:54:06 sa5 systemd[1]: Finished snap.certbot.renew.service - Service for snap application certbot.renew.
May 29 01:54:06 sa5 systemd[1]: snap.certbot.renew.service: Deactivated successfully.
May 29 01:54:03 sa5 systemd[1]: Starting snap.certbot.renew.service - Service for snap application certbot.renew...
May 28 19:19:10 sa5 systemd[1]: snap.certbot.renew.service: Consumed 2.722s CPU time.
May 28 19:19:10 sa5 systemd[1]: Finished snap.certbot.renew.service - Service for snap application certbot.renew.
May 28 19:19:10 sa5 systemd[1]: snap.certbot.renew.service: Deactivated successfully.
May 28 19:19:05 sa5 systemd[1]: Starting snap.certbot.renew.service - Service for snap application certbot.renew...
May 28 05:24:23 sa5 systemd[1]: snap.certbot.renew.service: Consumed 2.683s CPU time.
May 28 05:24:23 sa5 systemd[1]: Finished snap.certbot.renew.service - Service for snap application certbot.renew.
May 28 05:24:23 sa5 systemd[1]: snap.certbot.renew.service: Deactivated successfully.
May 28 05:24:19 sa5 systemd[1]: Starting snap.certbot.renew.service - Service for snap application certbot.renew...
May 27 19:19:22 sa5 systemd[1]: Finished snap.certbot.renew.service - Service for snap application certbot.renew.
May 27 19:19:22 sa5 systemd[1]: snap.certbot.renew.service: Deactivated successfully.
May 27 19:19:19 sa5 systemd[1]: Starting snap.certbot.renew.service - Service for snap application certbot.renew...
```

`--timer="00:00~24:00/2"` は 「24時間の中でランダムな2回」 という意味

```text
systemd timer
  → 毎日 10:54 と 18:19 に snap.certbot.renew.service を起動
      ↓
snap run --timer="00:00~24:00/2"
  → snap が「今日はまだ2回実行していないか？」を判断して
    条件を満たさなければ何もせず終了
    条件を満たせば certbot.renew を実行
```

## `certbot renew --dry-run`

HTTP-01 チャレンジは1回ではなくて10回ぐらい、あちこちからくる。

ログを見ると:

- 2600:3000:... 米国西部
- 2406:da18:... アジア太平洋
- 2600:1f14:... 米国東部
- 2600:1f16:... 米国
- 2a05:d016:... ヨーロッパ

といった具合に、5拠点 × 2トークン = 10リクエストが飛んでくる。

これは Let's Encrypt の Multi-Perspective Validation(多視点検証) という仕組みで、
BGPハイジャックなどの攻撃でDNSや経路を一部乗っ取られても、全拠点から同じレスポンスが返ってこないと検証を通さない、
というセキュリティ強化策。

## LEGO

- [Installation :: ACME client and library written in Go\.](https://go-acme.github.io/lego/install/index.html)
- [go\-acme/lego: Let's Encrypt/ACME client and library written in Go](https://github.com/go-acme/lego)
- [サーバ証明書自動更新をACMEクライアント(LEGO)とDNS認証で実現 \| GMOグローバルサインカレッジ](https://college.globalsign.com/blog/acme_ssl_251226/)

DNS-01 チャレンジは `_acme-challenge.example.com TXT "<token>"` を renew のたびに書き換えないといけないので
DynDNS っぽい機構が必須。

Cloudflare の DNSが簡単でタダなのでおすすめ
