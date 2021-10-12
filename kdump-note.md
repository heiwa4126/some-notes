kdumpのメモ

だいたいのことは
[第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
を参照。

- [設定](#設定)
  - [参考](#参考)
- [メモリサイズとダンプファイルのサイズ](#メモリサイズとダンプファイルのサイズ)
- [カーネルコマンドラインパラメータ(kernel command-line parameters)](#カーネルコマンドラインパラメータkernel-command-line-parameters)
  - [参考](#参考-1)
- [kdumpが起動しないけどエラーメッセージがあっさりしすぎている](#kdumpが起動しないけどエラーメッセージがあっさりしすぎている)
- [kdumpとセキュアブート](#kdumpとセキュアブート)


# 設定

カーネルコマンドラインパラメータの`crashkernel`と`/etc/kdump.conf`。

サービスは`kdump.service`

テストは
サービスが動いていることを確認
```sh
systemctl is-active kdump
```
その後rootで
```sh
echo 1 > /proc/sys/kernel/sysrq
echo c > /proc/sysrq-trigger
```

## 参考

- [第10章 kdump のインストールと設定 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/installing-and-configuring-kdump_managing-monitoring-and-updating-the-kernel)
- [第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
- [Chapter 7. Kernel crash dump guide Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
- [クラッシュダンプについて: Linuxサービスセット | NEC](https://jpn.nec.com/linux/linux-os/ss/d_dump.html)
- [7.4. kdump 設定のテスト - 第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide#sect-kdump-test)
- [ダンプ解析講座 第2回: ダンプの準備 | 技術文書 | 技術情報 | VA Linux Systems Japan株式会社](https://www.valinux.co.jp/technologylibrary/document/linuxkernel/dump0002)


# メモリサイズとダンプファイルのサイズ

kdumpセカンドカーネル用のメモリサイズとかは、最近はautoでいいみたい。

ダンプファイルのサイズは最大メインメモリの1.2倍。



# カーネルコマンドラインパラメータ(kernel command-line parameters)

カーネルパラメータとは別物。


現在の設定値は
`cat /proc/cmdline`
で。

## 参考

- [https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt](https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt) - 一覧
- [How to view Linux kernel parameters for currently booted system - nixCraft](https://www.cyberciti.biz/faq/display-view-linux-kernel-parameters-for-booted/)
- [第4章 カーネルコマンドラインパラメーターの設定 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel)
- [第10章 kdump のインストールと設定 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/installing-and-configuring-kdump_managing-monitoring-and-updating-the-kernel)
- [第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
- [Chapter 7. Kernel crash dump guide Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
- [クラッシュダンプについて: Linuxサービスセット | NEC](https://jpn.nec.com/linux/linux-os/ss/d_dump.html)
- [7.4. kdump 設定のテスト - 第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide#sect-kdump-test)


# kdumpが起動しないけどエラーメッセージがあっさりしすぎている

[kdump service fails with message "kexec_file_load failed: Required key not available" - Red Hat Customer Portal](https://access.redhat.com/solutions/3683241) の一番下。

/etc/sysconfig/kdump に
```
KEXEC_ARGS="-d"
```
を追加して、
```sh
kdumpctl restart &> /tmp/debug.txt
```

# kdumpとセキュアブート

- [4.5.3 Secure Bootが有効なシステムでKdumpサービスが起動に失敗します - Oracle® Linux 8リリース・ノートfor Oracle Linux 8 - 第4章 既知の問題](https://docs.oracle.com/cd/F22978_01/8/relnotes8.0/ol8-issues-known.html#ol8-issues-29954639)
- [kdump service fails with message "kexec_file_load failed: Required key not available" - Red Hat Customer Portal](https://access.redhat.com/solutions/3683241)
- 


kexdump /sys/firmware/efi/efivars/SecureBoot Operation not permitted