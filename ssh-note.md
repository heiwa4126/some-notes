ssh tips

- [.ssh/configでhostごとのUserがoverrideできない](#sshconfig%E3%81%A7host%E3%81%94%E3%81%A8%E3%81%AEuser%E3%81%8Coverride%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84)
- [ProxyJump](#proxyjump)
- [DynamicForward](#dynamicforward)
- [LocalForward](#localforward)


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

# DynamicForward

(TODO)

* [SSHのDynamic ForwardでSOCKS Proxyしてみる - ぱせらんメモ](https://pasela.hatenablog.com/entry/20090217/dynamic_forward)

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