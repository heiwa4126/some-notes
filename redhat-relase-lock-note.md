# RHELのリリースロック

Red Hat Enterprise Linux のバージョンを固定する話。CentOS は対象外

```
## (たまに起動するホストだと証明書が変な時があるので)
# subscription-manager repos --list-enabled
...
# subscription-manager release
リリースは設定されていません
# subscription-manager release --list
+-------------------------------------------+
          利用可能なリリース
+-------------------------------------------+
7.0
7.1
7.2
7.3
7.4
7.5
7.6
7.7
7Server
## (7ServerのSは大文字)
# subscription-manager release --set=7Server
リリースは次のように設定されています: 7Server
```

# 手動でカーネルアップグレード

yum.conf に

```
exclude=kernel-* kmod-* redhat-release-* perf-* python-perf-*
```

と書いてあるような不快な環境でカーネルを更新するのに役立つ記事。

[第5章 手動のカーネルアップグレード Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/ch-manually_upgrading_the_kernel)
