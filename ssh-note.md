# ssh tips

- [ssh tips](#ssh-tips)
- [.ssh/configでhostごとのUserがoverrideできない](#sshconfig%e3%81%a7host%e3%81%94%e3%81%a8%e3%81%aeuser%e3%81%8coverride%e3%81%a7%e3%81%8d%e3%81%aa%e3%81%84)
- [ProxyJump](#proxyjump)
- [DynamicForward](#dynamicforward)
- [LocalForward](#localforward)
- [ControlPersist](#controlpersist)
- [各ディストリのsshd_configのCiphersのデフォルト値](#%e5%90%84%e3%83%87%e3%82%a3%e3%82%b9%e3%83%88%e3%83%aa%e3%81%aesshdconfig%e3%81%aeciphers%e3%81%ae%e3%83%87%e3%83%95%e3%82%a9%e3%83%ab%e3%83%88%e5%80%a4)
- [sshの接続でどんなcipherが使われるか確認](#ssh%e3%81%ae%e6%8e%a5%e7%b6%9a%e3%81%a7%e3%81%a9%e3%82%93%e3%81%aacipher%e3%81%8c%e4%bd%bf%e3%82%8f%e3%82%8c%e3%82%8b%e3%81%8b%e7%a2%ba%e8%aa%8d)


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


# 各ディストリのsshd_configのCiphersのデフォルト値

RHEL7 default Ciphers 
```
Ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-cbc
```
(man sshd_config参照)

Ubunts 18.04LTS
```
Cipers  chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
```

RHEL7のは流石にまずいので、弱いのは外すべき。

**ssh_configの設定だけど**
[ssh config最強設定 - Qiita](https://qiita.com/keiya/items/dec9a1142ac701b19bd9)
にあるのが参考になると思う。

以下引用:
```
##### セキュリティ系！重要！！ #####
# 以下は、OpenSSH 6.8を参考にしたもの。 
# NSAフリーなChacha20を優先的に、そのあとは暗号強度の順。aes-cbcはダメらしい
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
```


# sshの接続でどんなcipherが使われるか確認

```
$ ssh -vvv <host>
...
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes[111/343]penssh.com
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
...
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: zlib@openssh.com
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: zlib@openssh.com
```

aesにするとハードウエアアクセラレーションが効く、という話を聞いたので
/etc/sshdのCiphersで並びを変えてみる(man sshd_config)。

```
#Ciphers  chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
Ciphers  aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr
```

...微塵も変わらない... 単に並びを変えただけじゃダメみたい(続く)

