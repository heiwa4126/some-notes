
/etc/hostsもまぜてresolveしてくれるのは便利かなあ(特に逆引き)、
と思ってしばらく使ってみることにする

# status


```sh
systemctl status systemd-resolved -l | cat
resolvectl status
resolvectl dns
resolvectl domain
```
/usr/bin/resolvectlは古いディストリにはついてないこともある。
(`timedatectl`とかといっしょ)
そのときは `systemd-resolve`

```shell
systemd-resolve --status
```
など

[systemd - Why is resolvectl no longer included in Bionic and what's the alternative - Ask Ubuntu](https://askubuntu.com/questions/1149364/why-is-resolvectl-no-longer-included-in-bionic-and-whats-the-alternative)

# etc

forwarderは
/etc/netplan/01-netcfg.yaml (例)
の `nameservers: addresses:` で設定されたやつ。
メカニズムがわからないけど、どこかで横取りするらしい。



自前がコンテンツサーバになってるやつは
`/etc/systemd/resolved.conf.d/cascade.conf` (例)
に
```
[Resolve]
DNS=x.x.x.x x.x.x.y
Domains=~sub1.example.net ~sub2.example.com
```
みたいに書く。スペース区切り。最初の`~`は? globの*みたいなものらしい。

# 参考

- [resolved.conf](https://www.freedesktop.org/software/systemd/man/resolved.conf.html) - 例によってわかりにくいsystemdの公式。
- [systemd-resolved - ArchWiki](https://wiki.archlinux.jp/index.php/Systemd-resolved)
