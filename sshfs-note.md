# sshfs作業ノート

sshfs は FUSE で ssh 先のディレクトリをファイルシステムとしてマウントするしかけ。

- [sshfs作業ノート](#sshfs%E4%BD%9C%E6%A5%AD%E3%83%8E%E3%83%BC%E3%83%88)
- [参考](#%E5%8F%82%E8%80%83)
- [パッケージなど](#%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%81%AA%E3%81%A9)
- [設定](#%E8%A8%AD%E5%AE%9A)
  - [他メモ](#%E4%BB%96%E3%83%A1%E3%83%A2)
- [/etc/fstab](#etcfstab)
- [sshfs+autofs](#sshfsautofs)
  - [パッケージ等](#%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E7%AD%89)
  - [autofs設定](#autofs%E8%A8%AD%E5%AE%9A)
  - [その他](#%E3%81%9D%E3%81%AE%E4%BB%96)

# 参考

- [sshfs(1): filesystem client based on ssh - Linux man page](https://linux.die.net/man/1/sshfs)
- [libfuse/sshfs: A network filesystem client to connect to SSH servers](https://github.com/libfuse/sshfs)
- [SSHFS - ArchWiki](https://wiki.archlinux.org/index.php/SSHFS)

# パッケージなど

CentOS/RHEL7 の場合

```
# yum install epel-release
# yum install fuse-sshfs
```

Debian/Ubuntu

```
# apt install sshfs
```

# 設定

sshfs のオプションと FUSE のオプションと ssh のオプションが入り乱れてややこしい。

まず ssh で接続できるようにする。
とりあえず ssh-agent でも ForwardAgent yes でもパスフレーズでもパスワードでもいい。
(起動時にマウント、とかはパスフレーズなし公開鍵ペアを使う)

hostA につなぐとして、
最低の手順は

```
$ mkdir -p ~/mnt/x
$ sshfs hostA: ~/mnt/x
```

アンマウントは

```
$ fusermount -u ~/mnt/x
```

普段使いならこれで十分。scp で向こうからこっちにファイルをコピーするような場合に楽。

root で接続できるなら(普通はしない)、uid/gid マッピングもできるらしい(試していない)。

## 他メモ

fusermount の-z オプション: lazy unmount

mount の-l オプション同様、使用中でも無理にアンマウントできる。

# /etc/fstab

起動時に自動マウントしてみる(おすすめしない。autofs を使え)。

/etc/fstab 例:

```
sshfs#user1@192.168.0.11:/home/user1/share    /mnt/c73    fuse    defaults,allow_other,IdentityFile=/root/.ssh/sshfs_id_rsa,ServerAliveInterval=60    0 0
```

fstab だと.ssh/config は読まないみたいなので、mount と sshfs と FUSE と ssh(ssh_config)のオプションをずらずら書く。同じオプションがあったらどうするんだろう。
/etc/fstab は継続行とかが無いので辛い。

`/root/.ssh/sshfs_id_rsa`はパスフレーズ無しで作った秘密鍵。192.168.0.11 の`/home/user1/.ssh/authorized_keys`に`sshfs_id_rsa.pub`が追加されている。

# sshfs+autofs

autofs と組み合わせると「オンデマンドで接続できる」「一定時間使用しないと自動でアンマウントする」「接続先サーバが再起動したような場合でも勝手につながる(制限事項山程あり)」のようなことが実現できる。

## パッケージ等

`yum install autofs` または `apt install autofs`

## autofs設定

マスタマップ/etc/auto.master に include される
`/etc/auto.master.d/*.autofs`に、
autosf が見張るディレクトリを記述する。
(/etc/auto.master に直接書いても OK だが、やらない)

参考:

- [Ubuntu Manpage: /etc/auto.master - オートマウントシステムのマスタマップ](http://manpages.ubuntu.com/manpages/bionic/ja/man5/auto.master.5.html)

/etc/auto.master.d/sshfs.autofs 例

```
/mnt /etc/auto.sshfs --timeout 5 --ghost
```

- /mnt ディレクトリの下を、
- /etc/auto.sshf (「マップファイル」)の内容に従って見張る。
- 未使用タイムアウトは 5 秒(実は 5 秒はデフォルト値。/etc/autofs.conf でオーバライドされてるかも)。
- autofs 起動時にマウントしない。(--ghost または-g)

という記述。(TODO:/-による「直接マップ」も)

次に「システムマップ」を書く。

参考:

- [Ubuntu Manpage: autofs - オートマウントシステムマップの書式](http://manpages.ubuntu.com/manpages/bionic/ja/man5/autofs.5.html)

(以下は「sun マップ」とよばれる書式)

/etc/auto.sshfs 例

```
c73 -fstype=fuse,defaults,allow_other,IdentityFile=/root/.ssh/sshfs/sshfs_id_rsa,ServerAliveInterval=60 :sshfs\#c73\:
```

- /mnt/c73 にアクセスされたら
- fuse ファイルシステムを使って(-fstype=fuse)
- それ以下のオプション(defaults,allow_other,IdentityFile=/root/.ssh/sshfs/sshfs_id_rsa,ServerAliveInterval=60)
- location: これ機能が多くて説明が難しい。man 5 autofs 参照。 エスケープがどれに対して必要なのかよくわからない。':'と'#'だけ? --debug オプションを使うとどう dequote されるかがわかる。

```
# zgrep -i dequote /var/log/messages*
Nov  1 17:29:40 c75 automount[1487]: parse_mount: parse(sun): dequote(":sshfs\#c73\:") -> :sshfs#c73:
...
```

(TODO) Hesiod について調べる。

あとは

```
systemctl restart autofs
```

(または`systemctl reload autofs`)

/mnt/c73 は作っておく必要はない(あってもいいらしい)

## その他

--debug オプションはトラブルシューティングに便利。
CentOS/RHEL などでは/etc/sysconfig/autofs 中の OPTION 環境変数で指定すると/var/log/message にログが出まくる(2 秒に 1 回ぐらい?)。
マスタマップの行にも書ける(--ghost や--timeout 同様に)。これ便利。

`mount | fgrep /etc/auto` で autofs が見張っているディレクトリやオプションがわかる。

autofs はもともと NFS 用なので、/etc/auto.master には NFS や smb の設定があるかもしれない。
sshfs しか使わないなら、それらをコメントアウトしておいたほうがいいと思う。

-n, --negative-timeout, NEGATIVE_TIMEOUT を短めにしてみる。サーバ側がリブートした時再接続が早くなるかも。

> NEGATIVE_TIMEOUT=value
> マウント試行が失敗した時のデフォルト設定の負のタイムアウトです。

引用元: [付録D sysconfig ディレクトリ - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/ch-the_sysconfig_directory)

他参考:

- auto.master(5) — autofs — Debian jessie — Debian Manpages](https://manpages.debian.org/jessie/autofs/auto.master.5.en.html)
