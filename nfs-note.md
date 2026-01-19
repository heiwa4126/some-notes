# NFSメモ

RHEL7 で NFS サーバを動かしたときのメモ

- [NFSメモ](#nfsメモ)
- [準備](#準備)
- [設定](#設定)
- [クライアント側](#クライアント側)
- [ファイアウォール](#ファイアウォール)
- [よく使うコマンド](#よく使うコマンド)
- [参考](#参考)
- [NFSv3でつなぐ](#nfsv3でつなぐ)
- [NFSv3, v4だけの設定](#nfsv3-v4だけの設定)

# 準備

```bash
sudo yum install nfs-utils
sudo systemctl start nfs
```

RHEL7.1 以降だとこれで動く。
nfs-lock も自動で上がる(参照 : [8.6. NFS の起動と停止 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/s1-nfs-start))。

もちろん設定が必要なので

```bash
sudo systemctl status nfs
```

して、エラーが出てないようなら

```bash
sudo systemctl stop nfs
```

しておく。

# 設定

```bash
sudo mkdir /home/nfs
sudo echo "/home/nfs/ *(rw,async,no_root_squash)" >> /etc/exports
```

接続確認用のザルな設定なので、あとで見直すこと。

# クライアント側

RHEL7 系

```bash
sudo yum install nfs-utils
sudo make /mnt/nfs
sudo mount -t nfs -o nfsvers=4.1 111.222.333.444:/home/nfs/ /mnt/nfs
```

# ファイアウォール

NFS4.1 だったら、
クライアント -> サーバ向きで 2049/tcp,udp を開けとくだけで OK

NFS3 以下だったら諦める w

[9.7.3. ファイアウォール背後での NFS の実行 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/storage_administration_guide/s2-nfs-nfs-firewall-config)

# よく使うコマンド

NFS サーバ側

- `exportfs -v` - 現在 export しているところを表示
- `exportfs -ra` - export を再読込
- `rpcinfo -p` - NFS のバーションを表示 w (本当は「登録済みの RPC プログラムのリストを表示する」)

クライアント側

- `nfsstat -m` - 現在マウントされている NFS のリスト
- `showmount -e <nfs-server>` - NFSv3 がサーバで動いていれば export の一覧が見れる。4 なら`mount server:/ mountpoint`

# 参考

- [Stray Penguin - Linux Memo (NFSv4)](http://www.asahi-net.or.jp/~aa4t-nngk/nfsv4.html)
- [Ubuntu14.04でNFSv4を動かしてみる | Siguniang's Blog](https://siguniang.wordpress.com/2015/08/09/setup-nfsv4-on-ubuntu-1404/)
- [8.7.6. RDMA で NFS を有効にする (NFSoRDMA)](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/nfs-serverconfig#nfs-rdma)
- [【iStorage HS】NFSが使用するポートについて](http://info.ace.comp.nec.co.jp/View.aspx?NoClear=on&id=3150110310)
- [Stray Penguin - Linux Memo (NFS)](http://www.asahi-net.or.jp/~aa4t-nngk/nfs.html)

# NFSv3でつなぐ

いまどき NFSv3 なんてあるのか、と思ってたら結構へんなアプラアンスが v3 だったりして辛い。

例) クライアント側で

```
mount -t nfs -o nfsvers=3 s1:/nas /mnt/nfs/nas
```

(`nfsvers=3`のかわりに`vers=3`でも OK。man nfs(5) 参照)

systemd がちゃんとしていれば
nfslock(nlockmgr),
rpc-statd(status)
それに
rpcbind(portmapper)
も自動で起動しているはず。

`rpcinfo -p`
や
`systemctl status nfslock rpc-statd rpcbind`
で
確認

CD boot (RHEL や Cent の DVD で rescue モード)などの場合は nfslock がないときがある。
その場合は`nolock`オプションをつける。

例)

```
mount -t nfs -o nfsvers=3,nolock 192.168.56.777:/nas /mnt/nfs
```

`chroot /mnt/sysimage`でも nfslock は上がらないので、`nolock`オプションは必要。

nfslock がないと NFSv3 は結構遅いので、
静止点確保して NFSv3 に dump とりたい、とかの場合は

1. GRUB2 から rescue モードで起動(linux16 行の最後に 1 か s のアレで)
2. `systemctl start network`でネットワークつなぐ
3. nfslock ありで NFS マウント(または最初から NFSv4)

がいいとおもう。
`systemctl rescue`は動いたり動かなかったりする(動く場合はこっちが楽)

# NFSv3, v4だけの設定

Ubuntu での例:
[Serve Either NFSv3 or NFSv4 From Ubuntu - Will Haley](https://willhaley.com/blog/ubuntu-nfs-server/)

やってみたけど

```
RPCMOUNTDOPTS="--manage-gids --no-nfs-version 4"
```

で v3 だけにはできなかった。

[mount - Disable NFSv4 (server) on Debian, allow NFSv3 - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/205403/disable-nfsv4-server-on-debian-allow-nfsv3)

```
RPCNFSDCOUNT="8 --no-nfs-version 4"
RPCMOUNTDOPTS="--manage-gids"
```

で v3 だけになった。
