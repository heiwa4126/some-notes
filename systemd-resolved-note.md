# systemd-resolve メモ

DNS のキャッシュサーバ(コンテンツサーバでないやつ。リゾルバともいう)。

`/etc/hosts` や NSS もまぜて resolve してくれるのは便利かなあ(特に逆引き)、
と思ってしばらく使ってみることにする。

## status

```sh
systemctl status systemd-resolved -l | cat
resolvectl status
resolvectl dns
resolvectl domain
```

/usr/bin/resolvectl は古いディストリにはついてないこともある。
(`timedatectl`とかといっしょ)
そのときは `systemd-resolve`

```sh
systemd-resolve --status
```

など

[systemd - Why is resolvectl no longer included in Bionic and what's the alternative - Ask Ubuntu](https://askubuntu.com/questions/1149364/why-is-resolvectl-no-longer-included-in-bionic-and-whats-the-alternative)

## etc

forwarder は
/etc/netplan/01-netcfg.yaml (例)
の `nameservers: addresses:` で設定されたやつ。
メカニズムがわからないけど、どこかで横取りするらしい。

自前がコンテンツサーバになってて、そっちに参照させたいやつは
`/etc/systemd/resolved.conf.d/cascade.conf` (例)
に

```conf
[Resolve]
DNS=x.x.x.x x.x.x.y
Domains=~sub1.example.net ~sub2.example.com
```

みたいに書く。スペース区切り。最初の`~`は? glob の\*みたいなものらしい。`~`がなければ、書いたホスト名そのもの

## 参考

- [systemd-resolved - ArchWiki](https://wiki.archlinux.jp/index.php/Systemd-resolved)
- [resolved.conf](https://www.freedesktop.org/software/systemd/man/resolved.conf.html) - 例によってわかりにくい systemd の公式文書。

## おまけ: DNS サーバの 3 種類と有名製品

[Comparison of DNS server software - Wikipedia](https://en.wikipedia.org/wiki/Comparison_of_DNS_server_software)

### フルサービスサーバ

- BIND(Berkeley Internet Name Domain)

### コンテンツサーバ

- NSD
- PowerDNS (pdns)

### キャッシュサーバ (caching DNS proxy server)

- Unbound
- dnsmasq
- pdnsd
