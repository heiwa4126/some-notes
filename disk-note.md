# disk にまつわるいろいろ

## dd をマウント

dd でディスクまるごととったイメージに含まれるパーティションをマウントする。

[Raw Disk Image file を Ubuntu でマウントする方法](https://kokufu.blogspot.com/2018/02/raw-disk-image-file-ubuntu.html)

以下 ↑ のコピペ

```console
$ file image.img
image.img: DOS/MBR boot sector
$ parted image.img
WARNING: You are not superuser.  Watch out for permissions.
GNU Parted 3.2
Using /home/yusuke/Documents/Ubuntu/image.img
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) u
Unit?  [compact]? B
(parted) print
Model:  (file)
Disk /home/yusuke/Documents/Ubuntu/image.img: 53687091200B
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start         End           Size          Type      File system     Flags
 1      1048576B      52612300799B  52611252224B  primary   ext4            boot
 2      52613349376B  53687091199B  1073741824B   extended
 5      52614397952B  53684994047B  1070596096B   logical   linux-swap(v1)

(parted) q
```

> u を使ってユニットを byte にしておくと後で計算しなくて良いので楽です

```console
$ sudo mount -t ext4 -o loop,rw,offset=1048576 image.img ~/tmp
```

> offset を指定することで対象のパーティションをマウントすることが出来ます。

## dd2vdi

dd でディスクまるごととったイメージから vdi

[P2V】 VirtualBox に物理マシンを移行する方法](https://toshio-web.com/p2v-virtualbox)
