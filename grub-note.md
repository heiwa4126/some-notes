RHEL6 は GRUB2 じゃなくて GRUB(0.97)だった。conf は/boot/grub/grub.conf(BIOS)

RHEL7 は GRUB2(2.02)。conf は/boot/grub/grub.conf(BIOS)

EFI では 2 箇所にあって

- /boot/efi/EFI/redhat/grub.cfg (EFI 用)
- /boot/grub2/grub.cfg (BIOS 用)

が自動生成されている(片方ない場合もある)。手で修正するなら両方やっといたほうがいいかも。

`/etc/grub2.cfg`は`/boot/grub2/grub.cfg`への symlink
EFI にもある。

```
# ls /etc/grub* -lad
lrwxrwxrwx  1 root root  22 Sep 30 02:43 /etc/grub2.cfg -> ../boot/grub2/grub.cfg
lrwxrwxrwx  1 root root  31 Sep 30 02:44 /etc/grub2-efi.cfg -> ../boot/efi/EFI/redhat/grub.cfg
drwx------. 2 root root 182 Sep 30 02:43 /etc/grub.d
```

参考:
[26.5. GRUB 2 設定ファイルのカスタマイズ Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-customizing_the_grub_2_configuration_file)

> /etc/default/grub への変更は、以下のように grub.cfg ファイルの再構築を必要とします。

これ訳が変で、「/etc/default/grub への変更を grub.cfg に反映させるには...」ぐらいの意味だと思う。

```sh
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
```
