sshfs作業ノート

sshfsはFUSEでssh先のディレクトリをファイルシステムとしてマウントするしかけ。

<!-- TOC -->

- [参考](#参考)
- [パッケージなど](#パッケージなど)
- [設定](#設定)
    - [他メモ](#他メモ)
- [/etc/fstab](#etcfstab)
- [sshfs+autofs](#sshfsautofs)
    - [パッケージ等](#パッケージ等)
    - [autofs設定](#autofs設定)
    - [その他](#その他)

<!-- /TOC -->

# 参考

* [sshfs(1): filesystem client based on ssh - Linux man page](https://linux.die.net/man/1/sshfs)
* [libfuse/sshfs: A network filesystem client to connect to SSH servers](https://github.com/libfuse/sshfs)
* [SSHFS - ArchWiki](https://wiki.archlinux.org/index.php/SSHFS)

# パッケージなど

CentOS/RHEL7の場合
```
# yum install epel-release
# yum install fuse-sshfs
```

Debian/Ubuntu 
```
# apt install sshfs
```


# 設定

sshfsのオプションとFUSEのオプションとsshのオプションが入り乱れてややこしい。

まずsshで接続できるようにする。
とりあえずssh-agentでもForwardAgent yesでもパスフレーズでもパスワードでもいい。
(起動時にマウント、とかはパスフレーズなし公開鍵ペアを使う)

hostAにつなぐとして、
最低の手順は
```
$ mkdir -p ~/mnt/x
$ sshfs hostA: ~/mnt/x
```

アンマウントは
```
$ fusermount -u ~/mnt/x
```

普段使いならこれで十分。scpで向こうからこっちにファイルをコピーするような場合に楽。

rootで接続できるなら(普通はしない)、uid/gidマッピングもできるらしい(試していない)。

## 他メモ

fusermountの-zオプション: lazy unmount

mountの-lオプション同様、使用中でも無理にアンマウントできる。


# /etc/fstab

起動時に自動マウントしてみる(おすすめしない。autofsを使え)。

/etc/fstab例:
```
sshfs#user1@192.168.0.11:/home/user1/share    /mnt/c73    fuse    defaults,allow_other,IdentityFile=/root/.ssh/sshfs_id_rsa,ServerAliveInterval=60    0 0
```

fstabだと.ssh/configは読まないみたいなので、mountとsshfsとFUSEとssh(ssh_config)のオプションをずらずら書く。同じオプションがあったらどうするんだろう。
/etc/fstabは継続行とかが無いので辛い。

`/root/.ssh/sshfs_id_rsa`はパスフレーズ無しで作った秘密鍵。192.168.0.11の`/home/user1/.ssh/authorized_keys`に`sshfs_id_rsa.pub`が追加されている。


# sshfs+autofs

autofsと組み合わせると「オンデマンドで接続できる」「一定時間使用しないと自動でアンマウントする」「接続先サーバが再起動したような場合でも勝手につながる(制限事項山程あり)」のようなことが実現できる。

## パッケージ等

`yum install autofs` または `apt install autofs`

## autofs設定


マスタマップ/etc/auto.masterにincludeされる
`/etc/auto.master.d/*.autofs`に、
autosfが見張るディレクトリを記述する。
(/etc/auto.masterに直接書いてもOKだが、やらない)

参考:
* [Ubuntu Manpage: /etc/auto.master - オートマウントシステムのマスタマップ](http://manpages.ubuntu.com/manpages/bionic/ja/man5/auto.master.5.html)

/etc/auto.master.d/sshfs.autofs例
```
/mnt /etc/auto.sshfs --timeout 5 --ghost
```
* /mntディレクトリの下を、
* /etc/auto.sshf (「マップファイル」)の内容に従って見張る。
* 未使用タイムアウトは5秒(実は5秒はデフォルト値。/etc/autofs.confでオーバライドされてるかも)。
* autofs起動時にマウントしない。(--ghostまたは-g)

という記述。(TODO:/-による「直接マップ」も)


次に「システムマップ」を書く。

参考:
* [Ubuntu Manpage: autofs - オートマウントシステムマップの書式](http://manpages.ubuntu.com/manpages/bionic/ja/man5/autofs.5.html)


(以下は「sunマップ」とよばれる書式)

/etc/auto.sshfs 例
```
c73 -fstype=fuse,defaults,allow_other,IdentityFile=/root/.ssh/sshfs/sshfs_id_rsa,ServerAliveInterval=60 :sshfs\#c73\:
```

* /mnt/c73にアクセスされたら
* fuseファイルシステムを使って(-fstype=fuse)
* それ以下のオプション(defaults,allow_other,IdentityFile=/root/.ssh/sshfs/sshfs_id_rsa,ServerAliveInterval=60)
* location: これ機能が多くて説明が難しい。man 5 autofs参照。 エスケープがどれに対して必要なのかよくわからない。':'と'#'だけ? --debugオプションを使うとどうdequoteされるかがわかる。

```
# zgrep -i dequote /var/log/messages*
Nov  1 17:29:40 c75 automount[1487]: parse_mount: parse(sun): dequote(":sshfs\#c73\:") -> :sshfs#c73:
...
```
(TODO) Hesiodについて調べる。


あとは
```
systemctl restart autofs
```
(または`systemctl reload autofs`)

/mnt/c73は作っておく必要はない(あってもいいらしい)


## その他

--debugオプションはトラブルシューティングに便利。
CentOS/RHELなどでは/etc/sysconfig/autofs中のOPTION環境変数で指定すると/var/log/messageにログが出まくる(2秒に1回ぐらい?)。
マスタマップにも書ける(--ghostや--timeout同様に)。


`mount | fgrep /etc/auto` で autofsが見張っているディレクトリやオプションがわかる。


autofsはもともとNFS用なので、/etc/auto.masterにはNFSやsmbの設定があるかもしれない。sshfsしか使わないなら、それらをコメントアウトしておいたほうがいいと思う。


-n, --negative-timeout, NEGATIVE_TIMEOUTを短めにしてみる。サーバ側がリブートした時再接続が早くなるかも。

>　NEGATIVE_TIMEOUT=value
マウント試行が失敗した時のデフォルト設定の負のタイムアウトです。

引用元: [付録D sysconfig ディレクトリ - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/ch-the_sysconfig_directory)

他参考: 
* auto.master(5) — autofs — Debian jessie — Debian Manpages](https://manpages.debian.org/jessie/autofs/auto.master.5.en.html)

