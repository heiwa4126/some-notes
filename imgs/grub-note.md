

RHEL6はGRUB2じゃなくてGRUB(0.97)だった。confは/boot/grub/grub.conf(BIOS)

RHEL7はGRUB2(2.02)。confは/boot/grub/grub.conf(BIOS)

EFIでは2箇所にあって
- /boot/efi/EFI/redhat/grub.cfg (EFI用)
- /boot/grub2/grub.cfg (BIOS用)

が自動生成されている。手で修正するなら両方やっといたほうがいいかも。

`/etc/grub2.cfg`は`/boot/grub2/grub.cfg`へのsymlink
EFIにもある。

```
# ls /etc/grub* -lad
lrwxrwxrwx  1 root root  22 Sep 30 02:43 /etc/grub2.cfg -> ../boot/grub2/grub.cfg
lrwxrwxrwx  1 root root  31 Sep 30 02:44 /etc/grub2-efi.cfg -> ../boot/efi/EFI/redhat/grub.cfg
drwx------. 2 root root 182 Sep 30 02:43 /etc/grub.d
```

参考:
[26.5. GRUB 2 設定ファイルのカスタマイズ Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-customizing_the_grub_2_configuration_file)

> /etc/default/grub への変更は、以下のように grub.cfg ファイルの再構築を必要とします。

これ訳が変で、「/etc/default/grubへの変更をgrub.cfgに反映させるには...」ぐらいの意味だと思う。

```sh
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
```