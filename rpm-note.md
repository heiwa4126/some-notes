# RPMメモ

- [RPMメモ](#rpm%e3%83%a1%e3%83%a2)
- [rpmbuild関連](#rpmbuild%e9%96%a2%e9%80%a3)
- [`rpm -qa`の出力をCSVっぽく](#rpm--qa%e3%81%ae%e5%87%ba%e5%8a%9b%e3%82%92csv%e3%81%a3%e3%81%bd%e3%81%8f)

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
