LVMいろいろノート

- [LVMのrootをfsck](#lvm%E3%81%AEroot%E3%82%92fsck)
- [LVMのサイズを広げる -](#lvm%E3%81%AE%E3%82%B5%E3%82%A4%E3%82%BA%E3%82%92%E5%BA%83%E3%81%92%E3%82%8B)

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

# LVMのサイズを広げる -  

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






