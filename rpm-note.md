# RPMメモ

- [RPMメモ](#rpmメモ)
  - [rpmbuild関連](#rpmbuild関連)
  - [`rpm -qa`の出力をCSVっぽく](#rpm--qaの出力をcsvっぽく)
  - [rpmのdry-run](#rpmのdry-run)
  - [redhat-release-serverメモ](#redhat-release-serverメモ)
  - [rpmのGPGキー](#rpmのgpgキー)
  - [Key ID](#key-id)
    - [実行例1](#実行例1)
    - [実行例2](#実行例2)
    - [メモ](#メモ)

## rpmbuild関連

- [RPM Packaging Guide Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/rpm_packaging_guide/index)
- [RPM Packaging Guide](https://rpm-packaging-guide.github.io/)
- [ソフトウェアのパッケージ化および配布 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html-single/packaging_and_distributing_software/index)

```bash
sudo yum install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools -y
sudo useradd -s /sbin/nologin mockbuild
```

[Rpmlint Errors - Rosalab Wiki](http://wiki.rosalab.ru/en/index.php/Rpmlint_Errors#subsys-not-used)

## `rpm -qa`の出力をCSVっぽく

`rpm -qa`の出力を分解するのは面倒なので、最初からバラして出す。

queryformat オプションを使う。

例) 典型的例

```bash
rpm -qa --queryformat '%{NAME},%{VERSION},%{RELEASE},%{ARCH}\n' | sort -t, -k1,4
```

queryformat をつけないときのデフォルトは
`%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}`
なので、それに沿った例。

比較用には
kernel パッケージに配慮して(複数あるから)、
第 2 フィールドもソート対象にしたいところ。
(あいにく 2 個しか指定できない。man sort で KEYDDEF 参照)

例) インストールした日付順

```bash
rpm -qa --queryformat '%{NAME},%{INSTALLTIME},%{INSTALLTIME:date}\n' | sort -rn -t, -k2 | cut -d, -f1,3
```

使える tag の一覧は

```bash
rpm --querytags
```

で。

[rpm.org - RPM Query Formats](https://rpm.org/user_doc/query_format.html) に良いサンプルがいろいろあります。

こういうやつとか

```bash
rpm -q --queryformat "[%-80{FILENAMES} %10{FILESIZES}\n]" gcc
```

よくある例: Red Hat でないやつを探せ、みたいなとき

```bash
rpm -qa --queryformat '%{NAME},%{VERSION},%{RELEASE},%{ARCH},"%{VENDOR}",%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort -i -t, -k1,4 | grep -vi 'Red Hat'
```

yum にも queryformat オプションがあるといいのに。

## rpmのdry-run

`rpm -Uvvh foo.rpm --test`

[linux - Is there a rpm command to check .rpm package installation log - Stack Overflow](https://stackoverflow.com/questions/42917414/is-there-a-rpm-command-to-check-rpm-package-installation-log)

## redhat-release-serverメモ

redhat-release-server は他に依存がないので、
バージョン表記は自由に変更できる。

例) 7.6 以上を 7.5 にみせかけるとき

```bash
sudo yum downgrade --disableexcludes=all redhat-release-server-7.5-8.el7
```

例) 現在の最新にするとき

```bash
sudo yum update --disableexcludes=all redhat-release-server
```

参考:

```console
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

## rpmのGPGキー

`/etc/pki/rpm-gpg/*`

## Key ID

- `rpm -qi {パッケージ名}` の Signature: にある `Key ID`
- または `rpm -Kv {RPMファイル}` の Signature, の `key ID`

を確認する方法。

Key ID は GPG のキーID なのでキーサーバに問い合わせれば正体がわかる。

### 実行例1

すでにインストール済みのパッケージ`curl` を GPG 署名したのは誰か調べる。

```console
$ rpm -qi curl | grep -Fi "key id"
Signature   : RSA/SHA256, Wed 26 Apr 2023 08:22:47 AM UTC, Key ID 199e2f91fd431d51

$ gpg --keyserver keyserver.ubuntu.com --search-key 199e2f91fd431d51
gpg: data source: http://162.213.33.9:11371
(1)     Red Hat, Inc. (release key 2) <security@redhat.com>
          4096 bit RSA key 199E2F91FD431D51, created: 2009-10-22
Keys 1-1 of 1 for "199e2f91fd431d51".  Enter number(s), N)ext, or Q)uit > Q
```

### 実行例2

ある RPM ファイルを GPG 署名したのは誰か調べる。

```console
$ $ rpm -Kv php-7.2.24-1.el8.remi.x86_64.rpm | grep -Fi "key id"
    Header V4 RSA/SHA256 Signature, key ID 5f11735a: NOKEY
    V4 RSA/SHA256 Signature, key ID 5f11735a: NOKEY

$ gpg --keyserver keyserver.ubuntu.com --search-key 5f11735a
gpg: data source: http://162.213.33.9:11371
(1)     Remi's RPM repository <remi@remirepo.net>
          4096 bit RSA key 555097595F11735A, created: 2018-01-12
Keys 1-1 of 1 for "5f11735a".  Enter number(s), N)ext, or Q)uit > Q
```

### メモ

GPG(PGP)キーサーバでまともに使えるのは `keyserver.ubuntu.com` ぐらいしかない。
