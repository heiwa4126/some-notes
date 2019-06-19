# dump / restore

RHEL7系のホストで(EFIでGPTでLVM)
dumpとrestoreを使って
ディザスタリカバリーを行う。

- [dump / restore](#dump--restore)
- [注意](#注意)
- [例の前提](#例の前提)
- [dumpの事前準備](#dumpの事前準備)
- [dumpの実行](#dumpの実行)
  - [GRUBメニューでrescueモードで起動する場合](#GRUBメニューでrescueモードで起動する場合)
  - [インストールCDからrescueモードで起動する場合](#インストールCDからrescueモードで起動する場合)
  - [dump(続き)](#dump続き)
  - [dump(続き2)](#dump続き2)
- [restoreの実行](#restoreの実行)
- [TODO](#TODO)
- [参考](#参考)
- [メモ](#メモ)
  - [GPTツールメモ](#GPTツールメモ)
  - [他メモ](#他メモ)
  - [HPのBIOS](#HPのBIOS)
  - [vfatのUUID](#vfatのUUID)
  - [インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをリスト](#インストールされているgrub2-efi-x64-shim-x64-grub2-toolsをリスト)
  - [インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをインタネットから取得](#インストールされているgrub2-efi-x64-shim-x64-grub2-toolsをインタネットから取得)


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
  - またはバックアップ先はNFSv3で192.168.56.91:/export/LinuxDumpの下

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
(dump/restoreの対応FSはextとxfsのみ)

あとバックアップ先をCIFSにするのはやめといたほうがいい。
DVDのrescueモードにはmount.cifsがないので、
restoreするとき結構大変。
NFSをお勧めします。


# dumpの事前準備

```
yum install cifs-utils nfs-utils dump gdisk
```

# dumpの実行

BMR(Bare Metal Restore)用にフルバックアップ(entire dump)を行う。

マウントされたデバイスもdumpでバックアップできるが、
静止点確保(quiescing)のため、rescueモードで起動する。

rescueモードで起動するには

* GRUBメニューでrescueモードで起動する
* インストールCDから起動する

の2通りがある。前者のほうがかなり楽。

## GRUBメニューでrescueモードで起動する場合

1. GRUBメニューからeを押して編集モードに入る
2. linuxefiの行の最後に移動し、sを付加、ctl-xを押す。

詳しくは
[26.10. Terminal Menu Editing During Boot - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot)
参照

続けてrootのパスワードを要求されるので、それを入力の後、
```
# 日本語キーボードにする
loadkeys jp106
# 英語表示にする
export LANG=C
# ネットワークを有効にする(少し時間がかかる)
systemctl start network
```

「[dump(続き)](#dump続き)」へ進む

## インストールCDからrescueモードで起動する場合

RHEL7(またはCentOS7)のインストールCDをホストに挿入し、
CDからブートさせる(ホストによってCDからブートさせる手順は異なる)。

起動したらメニューから
1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 1 continue ->
4. return

で、shが立ち上がる。

```
# /mnt/sysimageをrootにする
chroot /mnt/sysimage

# 日本語キーボードにする
loadkeys jp106

# 英語表示にする
export LANG=C

# 手動でIPを設定する. 以下は例
ip a add 192.168.56.94/24 dev enp0s8
ip a add 10.0.2.222/24 dev eth0
ip r add default via 10.0.2.2
```
「[dump(続き)](#dump続き)」へ進む


## dump(続き)

バックアップ先をマウントする
```
# マウント先を作る(すでにあるかも)
mkdir -p /mnt/dump

# バックアップ先をマウントする例(CIFSの場合)
mount -t cifs -o username=foo,password=baz //192.168.56.91/dump /mnt/dump

# バックアップ先をマウントする例(NFSv3の場合)
mount -t nfs -o vers=3 192.168.56.91:/export/LinuxDump /mnt/dump

# バックアップ先をマウントする例(CDから起動してnfslockが使えないときのNFSv3の場合)
mount -t nfs -o vers=3,nolock 192.168.56.91:/export/LinuxDump /mnt/dump
```


## dump(続き2)
```
# バックアップ先を作り移動する(c71はホスト名)
mkdir /mnt/dump/c71
cd /mnt/dump/c71

# /bootのdump
dump -z9 -0f ./boot.dump /boot
# /rootのdump
dump -z9 -0f ./root.dump /

## /var/crashなどがあればそれも

# GPTディスクのパーティション情報エクスポート
# ディスクが複数あれば全部やる
sgdisk --backup=sgdisk.txt /dev/sda

# UUIDを保存
blkid > blkid.txt

# ファイルシステムを保存
lsblk -f /dev/sda > lsblk-f.txt

# 使用容量を保存
df -h > df.txt

# fstabを保存
cp /etc/fstab  .

# Volume groupのリストを保存
vgs > vgs.txt

# VG情報をエクスポート
vgcfgbackup -f lvm.txt

# 終了。再起動
reboot

# CDから起動してchrootしている場合は
exit
reboot
```

CDから起動した場合は
[HPのBIOS](#HPのBIOS)
も参照。




# restoreの実行

まっさらなディスクにEFIでGPTでLVMなシステムを復元するケース。

restoreそのものよりも、
GPTディスクにパーティションを復元、
LVMを設定
そして EFIをインストールするのは
大変難しい。

パーティションを「復元」ではなく、
もとに近いものを作る、
という方針でもいいかもしれないので
そこは臨機応変に行うこと。

REHL7やCentOS7のDVDのrescue modeには
mount.cifsが含まれてないので、
cifsマウントできない。(nfsはある)

CIFSからリストアする場合は
[SystemRescueCDの5.3.2](https://osdn.net/projects/systemrescuecd/storage/releases/5.3.2/)
を使う。
(SystemRescueCDの6にはdump/restoreが入ってない。xfs_dumpはあるが)

以下はRHEL7/CentOS7のインストールCDを使うケースについて書く。

[インストールCDからrescueモードで起動する場合](#インストールCDからrescueモードで起動する場合)を参照して、CDから起動する。


```
loadkeys jp106
export LANG=C

## ここでネットワークを手動設定
ip a ... (略)

# CIFS共有ディスクをマウント(壊さないようroで)
mkdir /mnt/dump
mount -t cifs -o ro,username=foo,password=baz //192.168.56.91/dump /mnt/dump
```
NFSについては 「[dump(続き)](#dump続き)」を参照。
オプションにroをつけるのを忘れないこと(`-o ro,vers=3...`)

続き
```
# 保存場所に移動
cd /mnt/dump/c71

# パーティション情報のリストア。ディスクが複数あれば全部
sgdisk --load-backup sgdisk.txt /dev/sda

# sgdiskのバージョンによってはlvm2の復元まで行うものがある。
# 以下のコマンドで、パーティションを確認し、lvmまで復元されているようなら
# vgscanから実行
lsblk

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
# vfatはmkfsの時しかuuidが指定できないので、指定するつもりならここで行うこと
# オプションは-i ABCD1234 (真ん中のハイフンを除く)

# rootをマウントする
mkdir -p /mnt/sysimage
mount -t ext4 /dev/mapper/centos_c71-root /mnt/sysimage
# rootをリストア
cd /mnt/sysimage
restore -rf /mnt/dump/c71/restore.dump

# bootをマウントする
mount -t ext4 /dev/sda2 boot
# bootをリストア
cd boot
restore -rf /mnt/dump/c71/boot.dump

## /var/crashなどがあればそれも
```

ここで
/mnt/sysimage/etc/fstab
を正しいuuidで修正しておくと、
CD再起動時に/etc/sysimageの下に
全部のパーティションが適切にマウントされるので
おすすめ。

再起動して
RHELのcdを挿入し
起動したらメニューから
1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 1 continue ->
4. return

rescueモードではいりなおすと、
/mnt/sysimageの下にrootとbootとEFI領域がマウントされているはず。
(`lsblk` で確認)

されていなかったら
```
vgscan
vgchange -ay
```
し、さらにfstabを確認してCDから再起動。

続き
```
chroot /mnt/sysimage
loadkeys jp106
export LANG=C

## bootとEFI領域をマウント
## (fstabが正しければすでにマウントされている)
## mount -t ext4 /dev/sda2 /boot
## mount -t vfat /dev/sda1 /boot/efi

## ここでネットワーク設定
ip a ... (略)

# /etc/fstabのuuidを`blkid`の値に従って編集。
# (もしくはtune2fs -UでUUIDのほうを変更するなど)
# 必ずgrub-efiのインストール前に行うこと
vim /etc/fstab

# grub-efiのインストール
yum reinstall grub2-efi-x64 shim-x64 grub2-tools
# x86_64 では-x64付きのパッケージのほうがよい。grub2-efi shimでも動く。
# パッケージの再インストールが必要なのは /boot/efiがvfatでdump/restoreできないから。
#
# ローカルにyumdumloadしておいて
# rpm -ivh --replacepkgs packagename
# でも行けるので、バックアップ先に置いておくと良い。

# grub.cfgの再生成
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
## CentOSだと/boot/efi/EFI/centos/grub.cfg
## grub.cfg の拡張子は.cfgで.confではないことに注意
```

別マシンに複製した場合は、さらに
/etc/sysconfig/network-scriptの下や、
/etc/hostname
なども適宜書き換える。
RHELならsubscription-managerも修正する。
特に
/etc/sysconfig/network-script/ifc*
に
MACが入っているので、適切に編集すること。

```
# 終了。再起動
exit
reboot
```

さらに
CDから起動しているので
[HPのBIOS](#HPのBIOS)
を参照してCDを抜く。


# TODO

dumpをもう少し簡単に & 自動定期実行できるようにする
- ある程度daemonを止めて実行する。
- LVMスナップショットと組み合わせる。

などなど。

# 参考

- [Red Hat Enterprise Linux 7 25.7. GRUB 2 の再インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)
- [Red Hat Labs | Red Hat Customer Portal Labs](https://access.redhat.com/labs/rbra/)
- [Relax and Recover(ReaR) の概要](https://access.redhat.com/ja/solutions/2641301)
- [3.7. XFS ファイルシステムのバックアップと復元 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/xfsbackuprestore)


# メモ

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


## HPのBIOS

HP(ヒューレット・パッカード)のBIOSの乗ったホストで
CDブートするときに使う
「ワンタイムブート」メニューは、
実はワンタイムでない。永続する。

CDブートから、HDD(RAID)ブートに切り替えるときは
1. (CDブートした状態から)reboot
2. 「ワンタイムブート」メニューでHDD(かRAID)、またはUEFIのOSを指定。
3. (HDDからOSが起動した状態から)`eject /dev/sr0`などでCDをイジェクト

という手順をふむこと。


## vfatのUUID

vfatのUUIDは「ボリューム シリアル番号」というもので「ラベル」ではない。

vfatのUUIDを変更するツールはないので
ファイルシステム作成時に設定するか(mkfs.vfatの-iオプション)、
またはディスクを直接編集して変更すること。


## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをリスト

```
rpm -q --qf='%{name}-%{version}-%{release}.%{arch}.rpm\n' grub2-efi-x64 shim-x64 grub2-tools
```

## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをインタネットから取得

```
rpm -q  grub2-efi-x64 shim-x64 grub2-tools | xargs yumdownloader
```

## GPTディスクを空にする

RHELのcdを挿入し
起動したらメニューから
1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 3 skip ton shell ->
4. return

```
cgdisk /dev/sda
# 全パーティションで選択&delete。最後にWrite
dd if=/dev/zero of=/dev/sad block=1024k count=10240
# 先頭10GBをゼロクリア
```
