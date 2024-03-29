AzureでRHEL7のメモ

時代は変わる。

- [最近の状況 - GPTでLVMでxfsで](#最近の状況---gptでlvmでxfsで)
  - [拡張](#拡張)
- [chronyでPTPクロックソース](#chronyでptpクロックソース)
- [Azureのパスワード](#azureのパスワード)
- [マシンイメージが古くてyum updateで証明書が古い、って言われるとき](#マシンイメージが古くてyum-updateで証明書が古いって言われるとき)

# 最近の状況 - GPTでLVMでxfsで

ひさしぶりにAzureでRHEL 7.8のVMを作ったら(2020-07、
サイズ: B2S)

GPTでLVMでxfsで、
PVのfreeが大きくて、
自分で割り振れ、だった。

こんな感じ

```
# sgdisk /dev/sda -p
Disk /dev/sda: 134217728 sectors, 64.0 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): F3C2EAFA-31DC-4FF3-8C32-EEBB53BEA855
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 134217694
Partitions will be aligned on 2048-sector boundaries
Total free space is 4029 sectors (2.0 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1026047   500.0 MiB   EF00  EFI System Partition
   2         1026048         2050047   500.0 MiB   0700
   3         2050048         2054143   2.0 MiB     EF02
   4         2054144       134215679   63.0 GiB    8E00

# lsblk -lf
NAME          FSTYPE      LABEL UUID                                   MOUNTPOINT
fd0
sda
sda1          vfat              C13D-C339                              /boot/efi
sda2          xfs               8cc4c23c-fa7b-4a4d-bba8-4108b7ac0135   /boot
sda3
sda4          LVM2_member       zx0Lio-2YsN-ukmz-BvAY-LCKb-kRU0-ReRBzh
rootvg-tmplv  xfs               174c3c3a-9e65-409a-af59-5204a5c00550   /tmp
rootvg-usrlv  xfs               a48dbaac-75d4-4cf6-a5e6-dcd3ffed9af1   /usr
rootvg-optlv  xfs               85fe8660-9acb-48b8-98aa-bf16f14b9587   /opt
rootvg-homelv xfs               b22432b1-c905-492b-a27f-199c1a6497e7   /home
rootvg-varlv  xfs               24ad0b4e-1b6b-45e7-9605-8aca02d20d22   /var
rootvg-rootlv xfs               4f3e6f40-61bf-4866-a7ae-5c6a94675193   /
sdb
sdb1          ext4              1167997e-38d3-4f0c-a3b8-b6c1d49b9394   /mnt

# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sda4
  VG Name               rootvg
  PV Size               <63.02 GiB / not usable 4.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              16132
  Free PE               9732
  Allocated PE          6400
  PV UUID               zx0Lio-2YsN-ukmz-BvAY-LCKb-kRU0-ReRBzh
```

## 拡張

sdkman & gradle & spring boot とかやってたら、
あっというまに/homeが不足したので拡張してみる。

```
$ df -h /home
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-homelv 1014M  984M   30M  98% /home
```

pvdisplayによると
4 MiB \* 9732/1000 = 38.928 GiB
40ギビバイト(ギガバイトじゃなくて)ぐらいFreeある。

/homeを2GiB増やしてみる。

```
lvextend -L +2G /dev/rootvg/homelv
lvs /dev/rootvg/homelv  # 3GiBになったのを確認
xfs_growfs /dev/rootvg/homelv # 最大サイズまで増やす
```

結果:

```
$ df -h /home
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-homelv  3.0G  985M  2.1G  33% /home
```

無事3GBになりました。あとVGのサイズ確認

```sh
sudo vgdisplay
```

9732 -> 9220

(9732-9220)\*4=2024 で 2GiB減ってるのがわかる。

# chronyでPTPクロックソース

いつのまにか
PTP (Precision Time Protocol) クロック ソース
が使えるようになってた。

- [Azure での Linux VM の時刻同期 - Azure Linux Virtual Machines | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync#configuration-options)
- [18.6. ハードウェアのタイムスタンプを使用した Chrony Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-hw_timestamping)

確認:

```
$ lsmod | grep hv_utils
hv_utils               25808  1
ptp                    23551  1 hv_utils
hv_vmbus               96714  7 hv_balloon,hyperv_keyboard,hv_netvsc,hid_hyperv,hv_utils,hyperv_fb,hv_storvsc

$ ls /sys/class/ptp
ptp0

$ cat /sys/class/ptp/ptp0/clock_name
hyperv
```

設定は`/etc/chrony.conf`に

```
# hyperv PTP clock source
refclock PHC /dev/ptp0 poll 3 dpoll -2 offset 0
```

追加して、他のrefclockをコメントアウト。で`systemctl restart chronyd`

設定後:

```
# chronyc sources
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#* PHC0                          0   3   377     9  -4893ns[-8974ns] +/- 1982ns
```

# Azureのパスワード

AzureのLinuxにはシリアルコンソールがあるのだけど、
sshで使ってるとパスワードの設定を忘れがちなので、
作業ユーザにだけはパスワードを設定しておくといいと思う。

ちなみにrootは

```
$ sudo grep root /etc/shadow
root:*LOCK*:14600::::::
```

lockのままにしとくべき(作業ユーザでsudo)。

# マシンイメージが古くてyum updateで証明書が古い、って言われるとき

こんな場合

```
# yum update
Loaded plugins: langpacks, product-id, search-disabled-repos
rhui-microsoft-azure-rhel7                                                                       | 2.1 kB  00:00:00
https://rhui-1.microsoft.com/pulp/repos//content/dist/rhel/rhui/server/7/7Server/x86_64/dotnet/1/debug/repodata/repomd.x
ml: [Errno 14] curl#58 - "SSL peer rejected your certificate as expired."
Trying other mirror.
https://rhui-2.microsoft.com/pulp/repos//content/dist/rhel/rhui/server/7/7Server/x86_64/dotnet/1/debug/repodata/repomd.x
ml: [Errno 14] curl#58 - "SSL peer rejected your certificate as expired."
Trying other mirror.
https://rhui-3.microsoft.com/pulp/repos//content/dist/rhel/rhui/server/7/7Server/x86_64/dotnet/1/debug/repodata/repomd.x
ml: [Errno 14] curl#58 - "SSL peer rejected your certificate as expired."
Trying other mirror.
```

こうする。

```sh
sudo yum update -y --disablerepo='*' --enablerepo='*microsoft*'
```

- [Azure RedHat vm yum update fails with "SSL peer rejected your certificate as expired\." \- Stack Overflow](https://stackoverflow.com/questions/53436443/azure-redhat-vm-yum-update-fails-with-ssl-peer-rejected-your-certificate-as-exp)
- [Update expired RHUI client certificate on a VM](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/redhat-rhui#update-expired-rhui-client-certificate-on-a-vm)

このページいいね: [Red Hat Update Infrastructure \- Azure Virtual Machines \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/redhat-rhui#update-expired-rhui-client-certificate-on-a-vm)
