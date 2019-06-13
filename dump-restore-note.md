# dump / restore

RHEL7系のホストで(EFIでGPTでLVM)
dumpとrestoreを使って
ディザスタリカバリーを行う。

- [dump / restore](#dump--restore)
- [注意](#%E6%B3%A8%E6%84%8F)
- [例の前提](#%E4%BE%8B%E3%81%AE%E5%89%8D%E6%8F%90)
  - [GPTツールメモ](#gpt%E3%83%84%E3%83%BC%E3%83%AB%E3%83%A1%E3%83%A2)
  - [他メモ](#%E4%BB%96%E3%83%A1%E3%83%A2)
- [dump](#dump)
  - [インストールCDからrescueモードで起動する](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%ABcd%E3%81%8B%E3%82%89rescue%E3%83%A2%E3%83%BC%E3%83%89%E3%81%A7%E8%B5%B7%E5%8B%95%E3%81%99%E3%82%8B)
- [dump(続き)](#dump%E7%B6%9A%E3%81%8D)
- [restore](#restore)
- [TODO](#todo)
- [参考](#%E5%8F%82%E8%80%83)
- [そのほかメモ](#%E3%81%9D%E3%81%AE%E3%81%BB%E3%81%8B%E3%83%A1%E3%83%A2)
  - [vfatのUUID](#vfat%E3%81%AEuuid)
  - [インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをリスト](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8Bgrub2-efi-x64-shim-x64-grub2-tools%E3%82%92%E3%83%AA%E3%82%B9%E3%83%88)
  - [インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをゲット](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8Bgrub2-efi-x64-shim-x64-grub2-tools%E3%82%92%E3%82%B2%E3%83%83%E3%83%88)

# 注意

dump/restoreはext2,3,4にしか使えない。

xfs用にはxfsdump/xfsrestoreがある。オプションはほぼ同じ。

- [Red Hat Enterprise Linux 7 3.7. XFS ファイルシステムのバックアップと復元 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/xfsbackuprestore)
- [xfsdump(8) - Linux man page](https://linux.die.net/man/8/xfsdump)


他のファイルシステム(reiserfs, jfs, btrfs など)の場合、dump/restoreは諦めて
Relax-and-Recover (ReaR)
の使用をお勧めする。
- [Red Hat Enterprise Linux 7 第26章 Relax-and-Recover (ReaR) - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear)
- [Relax-and-Recover - Linux Disaster Recovery](http://relax-and-recover.org/)


# 例の前提

- OSはRHEL7(またはCentOS7)
- UEFI
- GPTディスク
- LVM
- ファイルシステムは全部ext4
- ホスト名はc71
- ホストのipは192.168.56.94/24 (enp0s8)
- バックアップ先はCIFSで//192.168.56.91/dumpの下

以下のようなディスク構成を想定
```
# lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                   8:0    0    8G  0 disk
├─sda1                8:1    0  200M  0 part /boot/efi
├─sda2                8:2    0    1G  0 part /boot
└─sda3                8:3    0  6.8G  0 part
  ├─centos_c71-root 253:0    0    6G  0 lvm  /
  └─centos_c71-swap 253:1    0  820M  0 lvm  [SWAP]
sr0                  11:0    1 1024M  0 rom
```

`/boot/efi(sda1)`のFSがvfatでdump/restoreできないのがミソ。
(dump/restoreはextとxfsのみ)

あとバックアップ先をCIFSにするのはやめといたほうがいい。
DVDのrescueモードにはmount.cifsがないので、
restoreするとき結構大変。
NFSをお勧めします。


## GPTツールメモ

sgdiskは `yum install gdisk`。
Debian/Ubuntuでも `atp install gdisk`.
バックアップ前にHDDにインストールしておくと少し楽。

sfdisk, cfdiskの新しいバージョンはGPTにも対応している。
RHEL7のはGPT対応していないので
sgdisk, cgdiskを使うこと。

ディスクがMBRかGPTか確認するには
```
parted -l /dev/sda
```
が最も汎用的。

MBRのツールとGPTのツールでは若干オプションが異なる。
例えば `sfdisk -l` は `sgdisk -p`.
sgdiskの`-l`は `-b`オプションと対になるバックアップ/ロードバックアップ。

## 他メモ

GPTのパーティションにはPARTUUIDというIDが付く。

ファイルシステムを作っていないパーティション、
またはpvcreateしてないパーティション
にはUUID(PARTUUIDではなく)はつかない。
これはMBRでも同じ。

/dev/mapper/* は /dev/dm* へのシンボリックリンク。
/dev/ボリュームグループ名/* も。

device-mapparについて詳しくは
* [LC2009 Tutorial: device-mapper - T-02-slide.pdf](http://lc.linux.or.jp/lc2009/slide/T-02-slide.pdf)
* [device-mapperの仕組み (1) device-mapperの概要 - テストステ論](https://www.akiradeveloper.com/entry/2013/05/11/220634)

など参照。


# dump

BMR(Bare Metal Restore)用にフルバックアップ(entire dump)を行う。

マウントされたデバイスもdumpでバックアップできるが、
「静止点」確保のため、インストールCDからrescueモードで起動する。


## インストールCDからrescueモードで起動する

RHEL7(またはCentOS)のインストールCDをホストに挿入し、
CDからブートさせる(ホストによってCDからブートさせる手順は異なる)。

起動したらメニューから
1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 2 Read-only mount ->
4. return

で、shが立ち上がる。

```
# 日本語キーボードにする
loadkeys jp106

# 手動でIPを設定する. 以下は例
ip a add 192.168.56.94/24 dev enp0s8
ip a add 10.0.2.222/24 dev eth0
ip r add default via 10.0.2.2

# バックアップ先をマウントする
mkdir /mnt/dump
mount -t cifs -o username=foo,password=baz //192.168.56.91/dump /mnt/dump
```

# dump(続き)

```
# バックアップ先を作り移動する(c71はホスト名)
mkdir /mnt/dump/c71
cd /mnt/dump/c71

# /bootのdump
dump -z9 -0f ./boot.dump /mnt/sysimage/boot
# /rootのdump
dump -z9 -0f ./root.dump /mnt/sysimage
## 必要なら他のドライブも

# GPTディスクのパーティション情報エクスポート
# ディスクが複数あれば全部やる
sgdisk --backup=sgdisk.txt /dev/sda

# UUIDを保存
blkid > blkid.txt

# Volume groupのリストを保存
vgs > vgs.txt

# VG情報をエクスポート
vgcfgbackup -f lvm.txt
```

# restore

まっさらなディスクに復元する。

restoreそのものよりも、
GPTディスクにパーティションを復元、
LVMを設定 そして EFIをインストールするのは
大変難しい。

パーティションを「復元」ではなく、
もとに近いものを作る、
という方針でもいいかもしれないので
そこは臨機応変に行うこと。

REHL7やCentOS7のDVDのrescue modeには
mount.cifsが含まれてないので、
cifsマウントできない。(nfsはある)

[SystemRescueCDの5.3.2](https://osdn.net/projects/systemrescuecd/storage/releases/5.3.2/)
を使う。
(SystemRescueCDの6にはdump/restoreが入ってない。xfs_dumpはあるが)

```
## ここでネットワークを手動設定
ip a ... (略)

# CIFS共有ディスクをマウント(壊さないようroで)
mkdir /mnt/dump
mount -t cifs -o ro,username=foo,password=baz //192.168.56.91/dump /mnt/dump

# 保存場所に移動
cd /mnt/dump/c71

# パーティション情報のリストア。ディスクが複数あれば全部
sgdisk --load-backup sgdisk.txt /dev/sda

# blkid.txtの中でtypeがLVM2_memberのものの
# uuidとdevice(/dev/sda3)を指定して実行
# いくつもあれば全部やる。コマンドが長いので、別のホストで編集すると楽
pvcreate \
  --restorefile lvm.txt \
  --uuid TIKJAP-7qXR-yVcJ-m7Dc-teuO-vAu0-eESUI3  \
  /dev/sda3
# 指定するUUIDはlvm.txtの physical_volumes にあるやつ


# vgs.txtにあるVGを全部繰り返す
vgcfgrestore -f lvm.txt centos_c71

# VGを再スキャンし、全部アクティブ化
vgscan
vgchange -ay

# ファイルシステムを作成する
mkfs.vfat /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/mapper/centos_c71-root
mkswap /dev/mapper/centos_c71-swap

# rootをマウントする
mount -t ext4 /dev/mapper/centos_c71-root /mnt/sysimage

# rootをリストア
cd /mnt/sysimage
restore -rf /mnt/dump/c71/restore.dump

# bootをマウントする
mount -t ext4 /dev/sda2 boot

# bootをリストア
cd boot
restore -rf /mnt/dump/c71/boot.dump
```

ここで再起動して
RHELのcdを挿入し
起動したらメニューから
1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 1 continue -> (**read only mouuntではない**)
4. return

rescueモードではいりなおすと、
/mnt/sysimageの下にrootとbootがマウントされているはず。
(`lsblk` で確認)

されていなかったら
```
vgscan
vgchange -ay
```
して再起動。

続き
```
chroot /mnt/sysimage

# EFI領域をマウント
# (すでにマウントされている場合もある)
mount -t vfat /dev/sda1 /boot/efi

## ここでネットワーク設定
ip a ... (略)

# grub-efiのインストール
yum reinstall grub2-efi-x64 shim-x64 grub2-tools
# x86_64 では-x64付きのパッケージのほうがよい。grub2-efi shimでも動く。
# パッケージの再インストールが必要なのは /boot/efiがvfatだから
# rpm -ivh --replacepkgs packagename
# でも行けるはず。

# grub.cfgの再生成
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
## CentOSだと/boot/efi/EFI/centos/grub.cfg
## grub.cfg の拡張子は.cfgで.confではないことに注意
```

最後に
/etc/fstabのuuidを`blkid`の値に従って編集。
(もしくはtune2fs -UでUUIDのほうを変更するなど)

別マシンに複製した場合は、
/etc/sysconfig/network-scriptの下や、
/etc/hostname
なども書き換える。
RHELならsubscription-managerも修正する。

/etc/sysconfig/network-script/ifc*にはMACも入ってたりするので注意。

# TODO

dumpをもう少し簡単に & 自動定期実行できるようにする
- ある程度daemonを止めて実行する。
- LVMスナップショットと組み合わせる。

などなど。

# 参考

- [Red Hat Enterprise Linux 7 25.7. GRUB 2 の再インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)
- [Red Hat Labs | Red Hat Customer Portal Labs](https://access.redhat.com/labs/rbra/)
- [Relax and Recover(ReaR) の概要](https://access.redhat.com/ja/solutions/2641301)


# そのほかメモ

## vfatのUUID

vfatのUUIDは「ボリューム シリアル番号」というやつで「ラベル」ではない。

vfatのUUIDを変更するツールはないので
ファイルシステム作成時に設定するか(mkfs.vfatの-iオプション)、
ディスクを直接編集して変更すること。


## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをリスト

```
rpm -q --qf='%{name}-%{version}-%{release}.%{arch}.rpm\n' grub2-efi-x64 shim-x64 grub2-tools
```

## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをゲット

```
rpm -q  grub2-efi-x64 shim-x64 grub2-tools | xargs yumdownloader
```
