# NFSメモ

RHEL7でNFSサーバを動かしたときのメモ

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

``` bash
sudo yum install nfs-utils
sudo systemctl start nfs
```

RHEL7.1以降だとこれで動く。
nfs-lockも自動で上がる(参照 : [8.6. NFS の起動と停止 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/s1-nfs-start))。


もちろん設定が必要なので
``` bash
sudo systemctl status nfs
```
して、エラーが出てないようなら
``` bash
sudo systemctl stop nfs
```
しておく。

# 設定

``` bash
sudo mkdir /home/nfs
sudo echo "/home/nfs/ *(rw,async,no_root_squash)" >> /etc/exports
```
接続確認用のザルな設定なので、あとで見直すこと。


# クライアント側

RHEL7系
``` bash
sudo yum install nfs-utils
sudo make /mnt/nfs
sudo mount -t nfs -o nfsvers=4.1 111.222.333.444:/home/nfs/ /mnt/nfs
```

# ファイアウォール

NFS4.1だったら、
クライアント -> サーバ 向きで 2049/tcp,udpを開けとくだけでOK

NFS3以下だったら諦めるw

[9.7.3. ファイアウォール背後での NFS の実行 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/storage_administration_guide/s2-nfs-nfs-firewall-config)

# よく使うコマンド

NFSサーバ側

- `exportfs -v` - 現在exportしているところを表示
- `exportfs -ra` - exportを再読込
- `rpcinfo -p` - NFSのバーションを表示w (本当は「登録済みの RPC プログラムのリストを表示する」)

クライアント側

- `nfsstat -m` - 現在マウントされているNFSのリスト
- `showmount -e <nfs-server>` - NFSv3がサーバで動いていればexportの一覧が見れる。4なら`mount server:/ mountpoint`


# 参考

- [Stray Penguin - Linux Memo (NFSv4)](http://www.asahi-net.or.jp/~aa4t-nngk/nfsv4.html)
- [Ubuntu14.04でNFSv4を動かしてみる | Siguniang's Blog](https://siguniang.wordpress.com/2015/08/09/setup-nfsv4-on-ubuntu-1404/)
- [8.7.6. RDMA で NFS を有効にする (NFSoRDMA)](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/nfs-serverconfig#nfs-rdma)
- [【iStorage HS】NFSが使用するポートについて](http://info.ace.comp.nec.co.jp/View.aspx?NoClear=on&id=3150110310)
- [Stray Penguin - Linux Memo (NFS)](http://www.asahi-net.or.jp/~aa4t-nngk/nfs.html)


# NFSv3でつなぐ

いまどきNFSv3なんてあるのか、と思ってたら結構へんなアプラアンスがv3だったりして辛い。


例) クライアント側で
```
mount -t nfs -o nfsvers=3 s1:/nas /mnt/nfs/nas
```
(`nfsvers=3`のかわりに`vers=3`でもOK。man nfs(5) 参照)

systemdがちゃんとしていれば
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

CD boot (RHELやCentのDVDでrescueモード)などの場合はnfslockがないときがある。
その場合は`nolock`オプションをつける。

例)
```
mount -t nfs -o nfsvers=3,nolock 192.168.56.777:/nas /mnt/nfs
```

`chroot /mnt/sysimage`でもnfslockは上がらないので、`nolock`オプションは必要。

nfslockがないとNFSv3は結構遅いので、
静止点確保してNFSv3にdumpとりたい、とかの場合は

1. GRUB2からrescueモードで起動(linux16行の最後に1かsのアレで)
2. `systemctl start network`でネットワークつなぐ
3. nfslockありでNFSマウント(または最初からNFSv4)

がいいとおもう。
`systemctl rescue`は動いたり動かなかったりする(動く場合はこっちが楽)




# NFSv3, v4だけの設定

Ubuntuでの例:
[Serve Either NFSv3 or NFSv4 From Ubuntu - Will Haley](https://willhaley.com/blog/ubuntu-nfs-server/)

やってみたけど
```
RPCMOUNTDOPTS="--manage-gids --no-nfs-version 4"
```
でv3だけにはできなかった。

[mount - Disable NFSv4 (server) on Debian, allow NFSv3 - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/205403/disable-nfsv4-server-on-debian-allow-nfsv3)

```
RPCNFSDCOUNT="8 --no-nfs-version 4"
RPCMOUNTDOPTS="--manage-gids"
```
でv3だけになった。


