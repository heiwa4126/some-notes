# NFSメモ

RHEL7でNFSサーバを動かしたときのメモ

- [NFSメモ](#nfsメモ)
- [準備](#準備)
- [設定](#設定)
- [クライアント側](#クライアント側)
- [ファイアウォール](#ファイアウォール)
- [よく使うコマンド](#よく使うコマンド)
- [参考](#参考)

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
`exportfs -v` 
`exportfs -ra` 

# 参考

- [Stray Penguin - Linux Memo (NFSv4)](http://www.asahi-net.or.jp/~aa4t-nngk/nfsv4.html)
- [Ubuntu14.04でNFSv4を動かしてみる | Siguniang's Blog](https://siguniang.wordpress.com/2015/08/09/setup-nfsv4-on-ubuntu-1404/)
- [8.7.6. RDMA で NFS を有効にする (NFSoRDMA)](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/nfs-serverconfig#nfs-rdma)
- [【iStorage HS】NFSが使用するポートについて](http://info.ace.comp.nec.co.jp/View.aspx?NoClear=on&id=3150110310)
- [Stray Penguin - Linux Memo (NFS)](http://www.asahi-net.or.jp/~aa4t-nngk/nfs.html)

