# dump / restore

RHEL7 系のホストで(EFI で GPT で LVM。FS は ext4 か xfs)
dump と restore を使って
ディザスタリカバリーを行う。

バックアップ先は CIFS または NFS(v3 or v4)

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
  - [インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをインターネットから取得](#インストールされているgrub2-efi-x64-shim-x64-grub2-toolsをインターネットから取得)
  - [GPTディスクを空にする](#GPTディスクを空にする)

# 注意

dump/restore は ext2,3,4 にしか使えない。

xfs 用には xfsdump/xfsrestore がある。オプションはほぼ同じ。

- [Red Hat Enterprise Linux 7 3.7. XFS ファイルシステムのバックアップと復元 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/xfsbackuprestore)
- [xfsdump(8) - Linux man page](https://linux.die.net/man/8/xfsdump)

他のファイルシステム(reiserfs, jfs, btrfs など)の場合、dump/restore は諦めて
Relax-and-Recover (ReaR)
の使用をお勧めする。

- [Red Hat Enterprise Linux 7 第26章 Relax-and-Recover (ReaR) - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear)
- [Relax-and-Recover - Linux Disaster Recovery](http://relax-and-recover.org/)

AWS や Azure での仮想マシンでは
おおむね MBR で非 LVM なので、こんな手間はいらない。
(クラウドなので dump/restore は無いと思うが)

# 例の前提

例なので、適宜読み替えること。

- OS は RHEL7(または CentOS7)
- UEFI
- GPT ディスク
- LVM
- ファイルシステムは全部 ext4(か xfs)
- ホスト名は c71
- ホストの ip は 192.168.56.94/24 (enp0s8)
- バックアップ先は CIFS で//192.168.56.91/dump の下
  - またはバックアップ先は NFSv3 で 192.168.56.91:/export/LinuxDump の下

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

`/boot/efi(sda1)`の FS が vfat で dump/restore できないのがミソ。
(dump/restore の対応 FS は ext と xfs のみ)

あとバックアップ先を CIFS にするのは推奨しない。
DVD の rescue モードには mount.cifs がないので、
restore するとき結構大変。
NFS をお勧めします(できれば NFSv4)。

# dumpの事前準備

各ホストで実行しておくこと。

```
yum install cifs-utils nfs-utils dump xfsdump gdisk
```

# dumpの実行

BMR(Bare Metal Restore)用にフルバックアップ(entire dump)を行う。

マウントされたデバイスも dump でバックアップできるが、
静止点確保(quiescing)のため、rescue モードで起動する。

rescue モードで起動するには

- GRUB メニューで rescue モードで起動する
- インストール CD から起動する

の 2 通りがある。前者のほうがかなり楽。

## GRUBメニューでrescueモードで起動する場合

1. GRUB メニューから e を押して編集モードに入る
2. linuxefi の行の最後に移動し、s を付加、ctl-x を押す。

詳しくは
[26.10. Terminal Menu Editing During Boot - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot)
参照

続けて root のパスワードを要求されるので、それを入力の後、

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

RHEL7(または CentOS7)のインストール CD をホストに挿入し、
CD からブートさせる(ホストによって CD からブートさせる手順は異なる)。

起動したらメニューから

1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 1 continue ->
4. return

で、sh が立ち上がる。

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

# ファイルシステムがXFSの場合は
xfsdump -l 0  -L backup -M backup  -f ./boot.xfs.dump /boot
xfsdump -l 0  -L backup -M backup  -f ./root.xfs.dump /
# のように

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

CD から起動した場合は
[HPのBIOS](#HPのBIOS)
も参照。

# restoreの実行

まっさらなディスクに EFI で GPT で LVM があるシステムを復元するケース。

restore そのものよりも、
GPT ディスクにパーティションを復元、
LVM を設定
そして EFI をインストールするのは
大変難しい。

パーティションを「復元」ではなく、
もとに近いものを作る、
という方針でもいいかもしれないので
臨機応変に行うこと。

REHL7 や CentOS7 の DVD の rescue mode には
mount.cifs が含まれてないので、
cifs マウントできない。(nfs はある)

CIFS からリストアする場合は
[SystemRescueCDの5.3.2](https://osdn.net/projects/systemrescuecd/storage/releases/5.3.2/)
を使う。
(SystemRescueCD の 6 には dump/restore が入ってない。xfs_dump はある)

以下は RHEL7/CentOS7 のインストール CD を使うケースについて書く。

まず
[インストールCDからrescueモードで起動する場合](#インストールCDからrescueモードで起動する場合)を参照して、CD から起動する。

```
loadkeys jp106
export LANG=C

## ここでネットワークを手動設定
ip a ... (略)

# CIFS共有ディスクをマウント(壊さないようroで)
mkdir /mnt/dump
mount -t cifs -o ro,username=foo,password=baz //192.168.56.91/dump /mnt/dump
```

NFS については「[dump(続き)](#dump続き)」を参照。
オプションに ro をつけるのを忘れないこと(`-o ro,vers=3...`)

続き

```
# 保存場所に移動
cd /mnt/dump/c71

# パーティション情報のリストア。ディスクが複数あれば全部
sgdisk --load-backup sgdisk.txt /dev/sda
# ** XFSの注意 **
# RHEL7のsgdiskではxfsパーティションが正しく復元されない
# lsblk-f.txtを参照して、mkfs.xfs & xfs_adminでUUIDとLABELをつけて作り直すこと。
## 例)
## mkfs.xfs -L {label} /dev/mapper/centos_c71-root
## xfs_admin -U {UUID} /dev/mapper/centos_c71-root
# ** LVMの注意 **
# sgdiskのバージョンによってはlvm2の復元も行う。
# 以下のコマンドで、パーティションを確認し、lvmまで復元されているようなら
# vgscanから実行(lvmでxfsの場合は、続けて上の「XFSの注意」に従うこと)
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

# ファイルシステムが作成されていなければ作成する
# sgdisk --load-backupでXFS以外は作成されているはず
mkfs.vfat /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/mapper/centos_c71-root
mkswap /dev/mapper/centos_c71-swap
# ** EFIパーティションの注意 **
# vfatはmkfsの時しかuuidが指定できないので、指定するつもりならここで行うこと
# オプションは-i ABCD1234 (真ん中のハイフンを除く)

# rootをマウントする
mkdir -p /mnt/sysimage
mount -t ext4 /dev/mapper/centos_c71-root /mnt/sysimage
# rootをリストア
cd /mnt/sysimage
restore -rf /mnt/dump/c71/restore.dump
# ** XFSの注意 ***
# xfsrestoreはdestが必要なので
## cd /mnt/sysimage
## xfsrestore -f /mnt/dump/c71/restore.xfs.dump .
# または
## xfsrestore -f /mnt/dump/c71/restore.xfs.dump cd /mnt/sysimage
# のように行うこと。

# bootをマウントする
mount -t ext4 /dev/sda2 boot
# bootをリストア
cd boot
restore -rf /mnt/dump/c71/boot.dump

## /var/crashなどがあればそれも
```

ここで
/mnt/sysimage/etc/fstab
を正しい uuid で修正しておくと、
CD 再起動時に/etc/sysimage の下に
全部のパーティションが適切にマウントされる(はず)なのでおすすめ。

再起動して
RHEL の cd を挿入し
起動したらメニューから

1. Troubleshooting ->
2. Rescue A Red Hat Enterprise Linux system ->
3. 1 continue ->
4. return

rescue モードではいりなおすと、
/mnt/sysimage の下に root と boot と EFI 領域がマウントされているはず。
(`lsblk` で確認)

自動マウントされていなかったら

```
vgscan
vgchange -ay
mount -t ext4 /dev/mapper/VolGroup00-root /mnt/sysimage
mount -t ext4 /dev/mapper/VolGroup00-var_crash /mnt/sysimage/var/crash
mount -t ext4 /dev/sda2 /mnt/sysimage/boot
mount -t vfat /dev/sda1 /mnt/sysimage/boot/efi
mount -t proc proc /mnt/sysimage/proc
mount -t sysfs sys /mnt/sysimage/sys
mount -o bind /dev /mnt/sysimage/dev
```

のようにする(順番が大事)。

続き

```
chroot /mnt/sysimage
loadkeys jp106
export LANG=C

## ここでネットワーク設定
ip a ... (略)

# /etc/fstabのuuidを`blkid`の値に従って確認 and 編集。
# (もしくはtune2fs -UでUUIDのほうを変更するなど)
# ** 必ず ** grub-efiのインストール前に行うこと
vim /etc/fstab

# grub-efiのインストール
yum reinstall grub2-efi-x64 shim-x64 grub2-tools
# x86_64 では-x64付きのパッケージのほうがよい。grub2-efi shimでも動く。
# パッケージの再インストールが必要なのは /boot/efiがvfatでdump/restoreできないから。
#
# ローカルにyumdumloadしておいて
# rpm -ivh --replacepkgs packagename (*.rpmが楽)
# でも行けるので、事前にバージョンを確認してyumdownloaderで落として
# バックアップ先に置いておくと良い。(巻末参照)

# grub.cfgの再生成
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
## CentOSだと/boot/efi/EFI/centos/grub.cfg
## grub.cfg の拡張子は.cfgで.confではないことに注意
```

別マシンに複製した場合は、さらに
/etc/sysconfig/network-script の下や、
/etc/hostname
なども適宜書き換える。
RHEL なら subscription-manager も修正する。
特に
/etc/sysconfig/network-script/ifc\*
に
MAC が入っているので、適切に編集すること。

```
# 終了。再起動
exit
reboot
```

さらに
CD から起動しているので
[HPのBIOS](#HPのBIOS)
を参照して CD を抜く。

# TODO

dump をもう少し簡単に & 自動定期実行できるようにする

- ある程度 daemon を止めて実行する。
- LVM スナップショットと組み合わせる。

# 参考

- [Red Hat Enterprise Linux 7 25.7. GRUB 2 の再インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)
- [Red Hat Labs | Red Hat Customer Portal Labs](https://access.redhat.com/labs/rbra/)
- [Relax and Recover(ReaR) の概要](https://access.redhat.com/ja/solutions/2641301)
- [3.7. XFS ファイルシステムのバックアップと復元 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/xfsbackuprestore)

# メモ

## GPTツールメモ

sgdisk は `yum install gdisk`。
Debian/Ubuntu でも `atp install gdisk`.
バックアップ前に HDD にインストールしておくと少し楽。

sfdisk, cfdisk の新しいバージョンは GPT にも対応している。
RHEL7 のは GPT 対応していないので
sgdisk, cgdisk を使うこと。

ディスクが MBR か GPT か確認するには

```
parted -l /dev/sda
```

が最も汎用的。

MBR のツールと GPT のツールでは若干オプションが異なる。
例えば `sfdisk -l` は `sgdisk -p`.
sgdisk の`-l`は `-b`オプションと対になるバックアップ/ロードバックアップ。

## 他メモ

GPT のパーティションには PARTUUID という ID が付く。

ファイルシステムを作っていないパーティション、
または pvcreate してないパーティション
には UUID(PARTUUID ではなく)はつかない。
これは MBR でも同じ。

/dev/mapper/_ は /dev/dm_ へのシンボリックリンク。
/dev/ボリュームグループ名/\* も。

device-mappar について詳しくは

- [LC2009 Tutorial: device-mapper - T-02-slide.pdf](http://lc.linux.or.jp/lc2009/slide/T-02-slide.pdf)
- [device-mapperの仕組み (1) device-mapperの概要 - テストステ論](https://www.akiradeveloper.com/entry/2013/05/11/220634)

など参照。

## HPのBIOS

HP(ヒューレット・パッカード)の BIOS の乗ったホストで
CD ブートするときに使う
「ワンタイムブート」メニューは、ワンタイムでない。
なんらかの条件で永続する。

CD ブートから、HDD(RAID)ブートに切り替えるときは

1. (CD ブートした状態から)reboot
2. 「ワンタイムブート」メニューで HDD(か RAID)、または UEFI の OS を指定。
3. (HDD から OS が起動した状態から)`eject /dev/sr0`などで CD をイジェクト

という手順をふむこと。

## vfatのUUID

vfat の UUID は「ボリューム シリアル番号」というもので「ラベル」ではない。

vfat の UUID を変更するツールはないので
ファイルシステム作成時に設定するか(mkfs.vfat の-i オプション)、
またはディスクを直接編集して変更すること。

## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをリスト

```
rpm -q --qf='%{name}-%{version}-%{release}.%{arch}.rpm\n' grub2-efi-x64 shim-x64 grub2-tools
```

## インストールされているgrub2-efi-x64 shim-x64 grub2-toolsをインターネットから取得

```
rpm -q  grub2-efi-x64 shim-x64 grub2-tools | xargs yumdownloader
```

## GPTディスクを空にする

RHEL の cd を挿入し
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
