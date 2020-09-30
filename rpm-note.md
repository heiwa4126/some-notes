# RPMメモ

- [RPMメモ](#rpmメモ)
- [rpmbuild関連](#rpmbuild関連)
- [`rpm -qa`の出力をCSVっぽく](#rpm--qaの出力をcsvっぽく)
- [rpmのdry-run](#rpmのdry-run)
- [redhat-release-serverメモ](#redhat-release-serverメモ)

# rpmbuild関連

- [RPM Packaging Guide Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/rpm_packaging_guide/index)
- [RPM Packaging Guide](https://rpm-packaging-guide.github.io/)
- [ソフトウェアのパッケージ化および配布 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html-single/packaging_and_distributing_software/index)


```
sudo yum install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools -y
sudo useradd -s /sbin/nologin mockbuild
```

[Rpmlint Errors - Rosalab Wiki](http://wiki.rosalab.ru/en/index.php/Rpmlint_Errors#subsys-not-used)

# `rpm -qa`の出力をCSVっぽく

`rpm -qa`の出力を分解するのは面倒なので、最初からバラして出す。

queryformatオプションを使う。

例) 典型的例
```
rpm -qa --queryformat '%{NAME},%{VERSION},%{RELEASE},%{ARCH}\n' | sort -t, -k1,4
```
queryformatをつけないときのデフォルトは
`%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}`
なので、それに沿った例。

比較用には
kernelパッケージに配慮して(複数あるから)、
第2フィールドもソート対象にしたいところ。
(あいにく2個しか指定できない。man sortでKEYDDEF参照)


例) インストールした日付順
```
rpm -qa --queryformat '%{NAME},%{INSTALLTIME},%{INSTALLTIME:date}\n' | sort -rn -t, -k2 | cut -d, -f1,3
```

使えるtagの一覧は
```
rpm --querytags
```
で。

[rpm.org - RPM Query Formats](https://rpm.org/user_doc/query_format.html) に良いサンプルがいろいろあります。

こういうやつとか
```
rpm -q --queryformat "[%-80{FILENAMES} %10{FILESIZES}\n]" gcc
```

よくある例: Red Hatでないやつを探せ、みたいなとき
```sh
rpm -qa --queryformat '%{NAME},%{VERSION},%{RELEASE},%{ARCH},"%{VENDOR}",%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort -i -t, -k1,4 | grep -vi 'Red Hat'
```

yumにもqueryformatオプションがあるといいのに。

# rpmのdry-run

`rpm -Uvvh foo.rpm --test`

[linux - Is there a rpm command to check .rpm package installation log - Stack Overflow](https://stackoverflow.com/questions/42917414/is-there-a-rpm-command-to-check-rpm-package-installation-log)


# redhat-release-serverメモ

redhat-release-serverは他に依存がないので、
バージョン表記は自由に変更できる。

例) 7.6以上を7.5にみせかけるとき
```sh
sudo yum downgrade --disableexcludes=all redhat-release-server-7.5-8.el7
```

例) 現在の最新にするとき
```sh
sudo yum update --disableexcludes=all redhat-release-server
```

参考:
```
$ sudo yum --disableexcludes=all --showduplicates list redhat-release-server
Loaded plugins: etckeeper, langpacks, product-id, search-disabled-repos, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

Installed Packages
redhat-release-server.x86_64                            7.9-3.el7                               @rhui-rhel-7-server-rhui-rpms
Available Packages
redhat-release-server.x86_64                            7.0-1.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.1-1.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.2-9.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.3-7.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.4-18.el7                              rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.5-8.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.5-8.el7.1                             rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.6-4.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.7-10.el7                              rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.8-2.el7                               rhui-rhel-7-server-rhui-rpms
redhat-release-server.x86_64                            7.9-3.el7                               rhui-rhel-7-server-rhui-rpms
```
