ssh tips

- [.ssh/configでhostごとのUserがoverrideできない](#sshconfig%E3%81%A7host%E3%81%94%E3%81%A8%E3%81%AEuser%E3%81%8Coverride%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84)
- [ProxyJump](#proxyjump)
- [DynamicForward](#dynamicforward)
- [LocalForward](#localforward)
- [ControlPersist](#controlpersist)


# .ssh/configでhostごとのUserがoverrideできない

だめな例
```
User foo
...
Host h1
  User bar
```

`ssh h1` するとユーザfooでつなぎに行く。

正しい例
```
Host h1
  User bar

Host *
  User foo
```

- [linux - OpenSSH ~/.ssh/config host-specific overrides not working - Super User](https://superuser.com/questions/718346/openssh-ssh-config-host-specific-overrides-not-working)


# ProxyJump

(TODO)

* [OpenSSH 7.3 の ProxyJump 機能の使い方 - TIM Labs](http://labs.timedia.co.jp/2016/08/openssh-73-proxyjump.html)
* [OpenSSH/Cookbook/Proxies and Jump Hosts - Wikibooks, open books for an open world](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)


PuttyにはProxyJumpはないのでProxyCommandで実現する
(OpenSSHでも昔はProxyCommandで実現していた)

* [SSH/多段接続/PuTTYのRemoteCommandを使う - yanor.net/wiki](http://yanor.net/wiki/?SSH/%E5%A4%9A%E6%AE%B5%E6%8E%A5%E7%B6%9A/PuTTY%E3%81%AERemoteCommand%E3%82%92%E4%BD%BF%E3%81%86)
* [SSH/多段接続 - yanor.net/wiki](http://yanor.net/wiki/?SSH/%E5%A4%9A%E6%AE%B5%E6%8E%A5%E7%B6%9A)


# DynamicForward

(TODO)

* [SSHのDynamic ForwardでSOCKS Proxyしてみる - ぱせらんメモ](https://pasela.hatenablog.com/entry/20090217/dynamic_forward)


Puttyもsocks proxyになれる。

* [SSHをSOCKS Proxyにする](https://blog.cles.jp/item/2839)

ただDNSは引けるようになっていないと実用にならない。


# LocalForward

-Lでトンネリング

(TODO)
```
ssh xxx.example.com -L 8080:127.0.0.1:8080 -g -N -f
```
みたいの。-Lは複数使えることなど。
ssh_configにはどう書くのか. RemoteForward など

* [楽しいトンネルの掘り方(オプション: -L, -R, -f, -N -g) — 京大マイコンクラブ (KMC)](https://www.kmc.gr.jp/advent-calendar/ssh/2013/12/09/tunnel2.html)
* [.ssh/config ファイルによるSSHオプション - HEPtech](https://heptech.wpblog.jp/2017/08/10/ssh-options-in-config-file/)


# ControlPersist

(TODO)

* [OpenSSHのセッションを束ねるControlMasterの使いにくい部分はControlPersistで解決できる - Gマイナー志向](https://matsuu.hatenablog.com/entry/20120707/1341677472)
* [Speed Up SSH by Reusing Connections | Puppet](https://puppet.com/blog/speed-up-ssh-by-reusing-connections)