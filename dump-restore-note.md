dumpとrestoreでBMR的な。

VMやcloudの時代であっても、
Veritas NetBackup™, Arcserve UDPのプロプラがあっても、
dump/restoreは基本

- [注意](#%E6%B3%A8%E6%84%8F)
- [例の前提](#%E4%BE%8B%E3%81%AE%E5%89%8D%E6%8F%90)
- [dump](#dump)

# 注意

dump/restoreはext2,3,4にしか使えない。

xfs用にはxfsdump/xfsrestoreがある。オプションはほぼ同じ。

- [Red Hat Enterprise Linux 7 3.7. XFS ファイルシステムのバックアップと復元 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/storage_administration_guide/xfsbackuprestore)
- [xfsdump(8) - Linux man page](https://linux.die.net/man/8/xfsdump)


他のファイルシステムの場合、dump/restoreは諦めて
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
- ホストのipは192.168.56.93/24 (eth1)
- バックアップ先はCIFSで//192.168.56.91/dumpの下

# dump

BMR(Bare Metal Restore )用にフルバックアップ(entire dump)を行う。


マウントされたデバイスはフルバックアップできないので、

バックアップ先はCIFS共有ディスク
//192.168.56.91/dump 
とする。

inet 


RHELのインストールCDから起動

Troubleshooting -> 
Rescue A Red Hat Enterprise Linux system ->
2) Read-only mount -> <return>

loadkeys jp106
ip a add 192.168.56.92/24 dev enp0s8

mkdir /mnt/dump
mount -t cifs -o username=foo,password=baz //192.168.56.91/dump /mnt/dump

mkdir /mnt/dump/c7
cd /mnt/dump/c7

mkdir c7

手動でネットワーク設定
手動でCIFSマウント
