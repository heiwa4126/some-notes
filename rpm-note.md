# RPMメモ

- [RPMメモ](#rpmメモ)
- [rpmbuild関連](#rpmbuild関連)
- [`rpm -qa`の出力をCSVっぽく](#rpm--qaの出力をcsvっぽく)
- [rpmのdry-run](#rpmのdry-run)

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
