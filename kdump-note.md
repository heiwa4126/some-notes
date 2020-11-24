kdumpのメモ

だいたいのことは
[第7章 カーネルクラッシュダンプガイド Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/kernel_crash_dump_guide)
を参照。

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


# カーネルコマンドラインパラメータ(kernel command-line parameters)

カーネルパラメータとは別物。


現在の設定値は
`cat /proc/cmdline`
で。

参考:
- [https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt](https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt) - 一覧
- [How to view Linux kernel parameters for currently booted system - nixCraft](https://www.cyberciti.biz/faq/display-view-linux-kernel-parameters-for-booted/)
- [第4章 カーネルコマンドラインパラメーターの設定 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel)
