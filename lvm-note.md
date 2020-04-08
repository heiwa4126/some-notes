LVMいろいろノート

- [LVMのrootをfsck](#lvm%e3%81%aeroot%e3%82%92fsck)
- [LVMのサイズを広げる](#lvm%e3%81%ae%e3%82%b5%e3%82%a4%e3%82%ba%e3%82%92%e5%ba%83%e3%81%92%e3%82%8b)
- [LVMでsnapshot](#lvm%e3%81%a7snapshot)

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
