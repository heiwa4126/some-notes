LVMいろいろノート

- [LVMのrootをfsck](#lvmのrootをfsck)
- [LVMのサイズを広げる](#lvmのサイズを広げる)
- [LVMでsnapshot](#lvmでsnapshot)
- [LVMのコマンド](#lvmのコマンド)
- [LVM snapshotの練習](#lvm-snapshotの練習)
  - [スナップショットから復元](#スナップショットから復元)
  - [スナップショットを削除](#スナップショットを削除)
  - [演習のあとしまつ](#演習のあとしまつ)
  - [スナップショットがあふれた場合](#スナップショットがあふれた場合)
- [lvsコマンドのattrフィールド](#lvsコマンドのattrフィールド)
- [新しいディスクメモ](#新しいディスクメモ)
- [ディスクの追加](#ディスクの追加)

# LVMのrootをfsck

気が付いたら/がread-onlyになってしまったような場合。
(そうじゃない場合は`shutdown -rF now`とか`sudo touch /forcefsck`)

かつLVMのrootをfsckするとき。

1. RHEL(or CentOSの)レスキューディスクから起動
2. mountのオプションを選ぶ画面になったらALT+F2
3. 以下のコマンドをアレンジして実行。
```
loadkeys jp106
vgscan
vhchange -ay
fsck.ext4 -y /dev/mappar/XXXX-root
```

`fsck.ext4`のところは環境にあわせてアレンジ。

マウントするとfsckできないので、こんな感じになる。
read-onlyマウントでもfsckできなかった。

# LVMのサイズを広げる

(未整理)


vgのあるpvを広げるケース。つまり
```
$ lsblk
NAME                     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                        8:0    0   300G  0 disk
├─sda1                     8:1    0   500M  0 part /boot/efi
├─sda2                     8:2    0     1G  0 part /boot
└─sda3                     8:3    0 298.5G  0 part
  ├─VolGroup00-root      253:0    0 278.5G  0 lvm  /
  ├─VolGroup00-swap      253:1    0     4G  0 lvm  [SWAP]
  └─VolGroup00-var_crash 253:2    0    16G  0 lvm  /var/crash
sr0                       11:0    1  1024M  0 rom
```
のような時に、

1. sdaを拡張する
2. 拡張領域をVolGroup00-rootに追加する

というようなVMやCloudでよくあるケースを考える。

何らかの方法でディスクを拡張し、OSもそれを認識した、という状態から。


```
parted /dev/sda
fix
p
resizepart 3 100%
p
q


pvresize /dev/sda3
vgdisplay | grep Free


lvextend -l +100%FREE /dev/mapper/VolGroup00-root
or
lvextend -L +1G /dev/mapper/VolGroup00-root


resize2fs /dev/mapper/VolGroup00-root
or
xfs_growfs
or ...
```

```
# parted /dev/sda
GNU Parted 3.1
/dev/sda を使用
GNU Parted へようこそ！ コマンド一覧を見るには 'help' と入力してください。
(parted) p
エラー: あるべき GPT テーブルのバックアップがディスクの最後にありません。他の OS がディスクはもっと小さいものだと思っているのかもしれません。バックアップを最後に持ってきて（古いバックアップを削除して）修復しますか？
修正/Fix/無視(I)/Ignore/取消(C)/Cancel? F
警告: /dev/sda で利用可能な領域の一部が利用されていません。GPT を修正して全ての領域を利用可能にするか(4194304 ブロック増えます)、このままで続行することができますが、どうしますか？
修正/Fix/無視(I)/Ignore? F
モデル: ATA VBOX HARDDISK (scsi)
ディスク /dev/sda: 10.7GB
セクタサイズ (論理/物理): 512B/512B
パーティションテーブル: gpt
ディスクフラグ:

番号  開始    終了    サイズ  ファイルシステム  名前                  フラグ
 1    1049kB  211MB   210MB   fat16             EFI System Partition  boot
 2    211MB   1285MB  1074MB  ext4
 3    1285MB  8585MB  7300MB                                          lvm

(parted)

```

# LVMでsnapshot

VMでテスト

```
# lsblk -f
NAME                FSTYPE      LABEL UUID                                   MOUNTPOINT
sda
├─sda1              vfat        efi   8EA4-09AF                              /boot/efi
├─sda2              ext4        boot  da20638e-6d5b-4412-b091-5d1a845dab42   /boot
└─sda3              LVM2_member       sPpKdm-n05w-KJo3-tAnJ-K2cH-Vzbh-XgZgxz
  ├─VolGroup00-root ext4        root  979940c6-73bc-4587-8652-d22e47bd7022   /
  └─VolGroup00-swap swap        swap  861754ca-7d31-4bce-aaf8-d5739e648523   [SWAP]

# pvdisplay | grep Free
  Free PE               0
```
で空きがぜんぜん無い。

sdaを1GB広げて
VolGroup00に追加して
拡張分をスナップショット領域にする。

VMマネージャで広げて、
`parted /dev/sda`で`p Fix Fix resizepart 3 100%`で
`pvresize /dev/sda3`

これで
```
# vgdisplay VolGroup00 | grep Free
  Free  PE / Size       256 / 1.00 GiB
```

root用にsnapshot領域を作成
``` sh
lvcreate -s -l 100%FREE -n snap1 /dev/mapper/VolGroup00-root
ls -lad /dev/mapper/VolGroup00-snap1
```

この`/dev/mapper/VolGroup00-snap1`に対してdumpとかを行う。

状態の確認は
```sh
lvdisplay VolGroup00/snap1
# or
lvdisplay /dev/mapper/VolGroup00-snap1
```

特にディスク使用量は
```sh
lvdisplay VolGroup00/snap1 | fgrep 'Allocated to snapshot'
```

`yum clean all ; yum update`とかしてみるといいです。

バックアップが終わったら
スナップショット領域を解放
```
lvremove VolGroup00/snap1 -y
```

リストアの参考:
- [How to Take 'Snapshot of Logical Volume and Restore' in LVM - Part III](https://www.tecmint.com/take-snapshot-of-logical-volume-and-restore-in-lvm/)
- [10.3. スナップショットボリュームのマージ Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/configuring_and_managing_logical_volumes/proc_merging-snapshot-volumes-snapshot-volumes)


# LVMのコマンド

頻繁に使わないし、
名前が似ててよくわかんなくなるので、
メモ。

一覧は
```sh
rpm -ql lvm2 | grep bin/
# or
dpkg -L lvm2 | grep bin/
```

- `pvs` - PVの一覧
- `pvdisplay` - PVの詳細
- `vgs` - VGの一覧
- `vgdisplay` - VGの詳細
- `lvs` - LVの一覧

なぜ `lvdisplay {lv名}`が出来ないのか?
`lvdisplay {lv path}`はできる。

- [scripting - LVM2: Obtaining lv and vg names from path (volume group name and logical volume name) - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/34917/lvm2-obtaining-lv-and-vg-names-from-path-volume-group-name-and-logical-volume)
- [lvdisplay command shows LV Status as NOT available - Red Hat Customer Portal](https://access.redhat.com/solutions/4497071)


# LVM snapshotの練習

参考: [論理ボリュームマネージャーの管理 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/index)


既存のボリュームでやるのは怖いので、新しいLVを作る。

ちょっと空きのあるvgがあったので
```
# vgdisplay --short
  "rootvg" <63.02 GiB [27.00 GiB used / <36.02 GiB free]
```
ここに新しいLVを作る。

```sh
lvcreate -n testlv -L 1G rootvg
mkfs.xfs /dev/rootvg/testlv
mkdir -p /testv
mount -t xfs /dev/rootvg/testlv /testv
```

確認
```
# df -h /testv
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-testlv 1014M   33M  982M   4% /testv
```

これになにか書く
```sh
yes | head -100 > /testv/text1.txt
wc -l /testv/text1.txt
```

スナップショットを100MiB作ってみる(同じVGに空きがあることが必須)
```sh
lvcreate -s -L 100M -n testlv-snap /dev/rootvg/testlv
```

確認
```
# lvs | grep testlv
  testlv      rootvg owi-aos---   1.00g
  testlv-snap rootvg swi-a-s--- 100.00m      testlv 0.01
# lvdisplay /dev/rootvg/testlv-snap
(略)
```

追記して、長さをしらべる
```
yes n | head -100 >> /testv/text1.txt
wc -l /testv/text1.txt
```
200になるはず。

dump(xfs_dump)なら、`/dev/rootvg/testlv-snap`をバックアップすればいい。
ここはread-onlyでマウントしてみる。

``` sh
mkdir -p /mnt/testlv-snap
mount -t auto -o ro,nouuid /dev/rootvg/testlv-snap /mnt/testlv-snap
wc -l /mnt/testlv-snap/text1.txt
```
100になるはず。

**注意:**
XFSだとnouuidオプションをつけないと
dmesgに `Filesystem has duplicate UUID`
が出てマウントできませんでした。

## スナップショットから復元

スナップショットを撮った時点に戻す。
```sh
cd
umount /mnt/testlv-snap /testv
lvconvert --merge /dev/rootvg/testlv-snap
# ↑けっこう時間かかる
mount -t xfs /dev/rootvg/testlv /testv
wc -l /testv/text1.txt
```
100になるはず。
スナップショットボリュームは自動的に削除される。

両方ともアンマウントしないといけないのが辛い。

アンマウントしないでmergeすると

- どちらかのLVがアクティブになり(LVM的に。`lvchange -a`みたいな)
- かつ両LVがマウントされていない

状態になると、マージ処理が実行されるらしい。
(要は再起動しろ、ということ)

参考: [4.4.7. スナップショットボリュームのマージ Red Hat Enterprise Linux 6 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/snapshot_merge)


アンマウントしないでmergeするテスト
```
# lvconvert --merge /dev/rootvg/testlv-snap
  Delaying merge since origin is open.
  Merging of snapshot rootvg/testlv-snap will occur on next activation of rootvg/testlv.
# reboot
(再起動まち)
$ sudo -i
# mount -t xfs /dev/rootvg/testlv /testv
# wc -l /testv/text1.txt
100 /testv/text1.txt
```

## スナップショットを削除

もういちどスナップショットを作って、それを捨てるテスト
```sh
mkdir -p /testv
mount -t xfs /dev/rootvg/testlv /testv
lvcreate -s -L 100M -n testlv-snap /dev/rootvg/testlv
yes n | head -100 >> /testv/text1.txt
wc -l /testv/text1.txt
# 200になるはず
mkdir -p /mnt/testlv-snap
mount -t auto -o ro,nouuid /dev/rootvg/testlv-snap /mnt/testlv-snap
wc -l /mnt/testlv-snap/text1.txt
# 100になるはず
umount /mnt/testlv-snap
```
ここで

```
# lvremove /dev/rootvg/testlv-snap
Do you really want to remove active logical volume rootvg/testlv-snap? [y/n]: (y[return])
Logical volume "testlv-snap" successfully removed
```

## 演習のあとしまつ

```sh
umount /testv
rm -rf /testv /mnt/testlv-snap
lvremove /dev/rootvg/testlv -y
```

## スナップショットがあふれた場合

[スナップショットが溢れるケース - LVMでスナップショットの作成と状態の復元 - Qiita](https://qiita.com/TsutomuNakamura/items/a68377952d07397db448#%E3%82%B9%E3%83%8A%E3%83%83%E3%83%97%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%E3%81%8C%E6%BA%A2%E3%82%8C%E3%82%8B%E3%82%B1%E3%83%BC%E3%82%B9)

> 上記のように、スナップショットからフェイルバックすることができないようになっていることがわかります。
> このような状態になったら、元の状態の復元はあきらめてください・・・・・・。

- あふれないよう注意する。
- あふれそうなら
  - スナップショットをエクステンドする。
  - or スナップショットをバックアップ後、マージするか捨てるか。


# lvsコマンドのattrフィールド

参考: [4.8.2. オブジェクトの選択 Red Hat Enterprise Linux 6 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/report_object_selection)

> 論理ボリュームのステータス。論理ボリュームの属性ビットは以下のようになります。

> pvs、vgs、および lvs 出力の属性フィールドにある文字数は、以降のリリースで増加する可能性があります。

コピペするには長すぎるので↑のリンクを参照。


# 新しいディスクメモ

メモなのでまとまってません。

`/dev/sdc`
cfdisk/cgdiskでパーティション切ってLVM(8E)にする。

テスト用LV`root`を作る。
```sh
pvcreate /dev/sdc1
vgcreate VolGroup00 /dev/sdc1
lvcreate -n root -l 100%FREE VolGroup00
lvscan
# ↑/dev/VolGroup00/rootが出来てるはず
mkfs.ext4 /dev/VolGroup00/root
mkdir -p /mnt/x
mount -t ext4 /dev/VolGroup00/root /mnt/x
ls /mnt/x
# ↑lost+foundディレクトリができてるはず
```

VolGroup00に空きはない。
```
# vgs
  VG         #PV #LV #SN Attr   VSize   VFree
  VolGroup00   1   1   0 wz--n- <14.90g      0
```

`/dev/sdc`が(何らかの手段で)+16G拡張されるとする。
(普通こういうことはしません。LVM的にはvgextendでVGにPVを追加するのが正しい)

VolGroup00を拡張する手順。拡張分全部割り振る。
```sh
echo -e "p\nresizepart 1 100%\np\nq\n" | parted /dev/sdc
pvresize /dev/sdc1
```

VolGroup00に空きが出来た。
```
# vgs
  VG         #PV #LV #SN Attr   VSize   VFree
  VolGroup00   1   1   0 wz--n- <32.00g <17.10g
```

# ディスクの追加

ホストにディスクを追加して、gvに追加、rootを増やす。

初期状態
```
# lsblk -f
NAME                     FSTYPE      LABEL UUID                                   MOUNTPOINT
sda
├─sda1                   ext4              237b4d15-277d-44e6-896f-d58c1b548cc2   /boot
└─sda2                   LVM2_member       qG1KD3-Mui3-pfbB-adEQ-KQFb-Ae2I-P2QCjj
  ├─centos_centos78-root ext4              b6d58d5d-5fac-415f-ba0e-8e3ae6a67ae6   /
  └─centos_centos78-swap swap              83ebd5a2-843a-4458-9f2c-4c67ddb6189f   [SWAP]
sdb
sr0

# pvdisplay --short
  Device "/dev/sda2" has a capacity of 0

# vgdisplay --short
  "centos_centos78" <7.00 GiB [<7.00 GiB used / 0    free]

# df -h /
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/centos_centos78-root  6.0G  1.9G  3.8G  34% /

# lvdisplay /dev/centos_centos78/root | grep Size
  LV Size                <6.20 GiB
```

- rootのlvにsdb(128MB)を追加する
- 事情によりext4
- 訳あってCentOS7

/dev/sdbにID:8eで/dev/sdb1を作る。cfdiskを使うとTUIで便利。

```
# pvcreate /dev/sdb1
  Physical volume "/dev/sdb1" successfully created.
# pvdisplay --short
  Device "/dev/sda2" has a capacity of 0
  Device "/dev/sdb1" has a capacity of <127.97 MiB
# vgextend centos_centos78 /dev/sdb1
  Volume group "centos_centos78" successfully extended
# vgdisplay --short
  "centos_centos78" <7.12 GiB [<7.00 GiB used / 124.00 MiB free]
# lvextend -l +100%FREE /dev/centos_centos78/root
  Size of logical volume centos_centos78/root changed from <6.20 GiB (1586 extents) to <6.32 GiB (1617 extents).
  Logical volume centos_centos78/root successfully resized.
# lvdisplay /dev/centos_centos78/root | grep Size
  LV Size                <6.32 GiB
```

ちょびっとだけ増えた。

```
# resize2fs /dev/centos_centos78/root
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/centos_centos78/root is mounted on /; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/centos_centos78/root is now 1655808 blocks long.
# LANG=C df -h /
Filesystem                        Size  Used Avail Use% Mounted on
/dev/mapper/centos_centos78-root  6.1G  1.9G  3.9G  33% /
```

できあがり。


