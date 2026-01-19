OpenLDAP のメモ

# RHEL8だったら

OpenLDAP + nss + sssd ではなくて
Red Hat Directory Server (RHDS) を使いましょう。

- [Product Documentation for Red Hat Directory Server 11 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_directory_server/11)
- [1.2. Directory Server の概要 Red Hat Directory Server 11 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_directory_server/11/html/deployment_guide/introduction_to_directory_services-introduction_to_ds)

# リンク集

- [技術メモメモ: OpenLDAP入門① (OpenLDAP初期構築手順)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldap.html)
- [技術メモメモ: OpenLDAP入門② (OpenLDAPでLDAPSを有効化する)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldapldaps.html)
- [技術メモメモ: OpenLDAP入門③ (LinuxのSSSDを使ってOpenLDAPと認証連携する)](https://tech-mmmm.blogspot.com/2021/12/openldap-linuxsssdopenldap.html)
- [OpenLDAPの設定をしてたら死にそうだった話](http://dmiyakawa.blogspot.com/2012/09/openldap.html)
- [第9章 LDAP サーバー Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/ldap_servers)
- [9.2. OpenLDAP Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/openldap)
- [付録A トラブルシューティング Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/trouble#sssctl)
- [9.2.3.7. レプリケーションの設定 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/s3-setting_up_replication)

# slapd.confがないとき

最近の slapd は
slapd.conf
を読まない。
ConfigDB を読む(/etc/ldap/slapd.d 以下。OLC というらしい)

**「slapd.confを編集して...」と書いてあるweb記事は、
ことごとく古いので参考程度にとどめて起きましょう。
変換して別ディレクトリに出したLDIFを参考にするのはOK。**

ConfigDB は ldap なので ldapadd/ldapmodify で修正できるけど
**そんなのやってられない**ので
slapd.conf を変換する。

Debian/Ubuntu なら

```sh
dpkg-reconfigure slapd
```

で大雑把な設定はできる。

ubuntu

```sh
zcat /usr/share/doc/slapd/examples/slapd.conf.gz > /etc/ldap/slapd.conf
```

最低でも
suffix と rootdn は書き換える。

ドメインが dc=zzz,dc=example,dc=net(zzz.example.net)だったら
s/dc=example,dc=com/dc=zzz,dc=example,dc=net/
的に

テスト

```sh
slaptest -u -d 64 -f /etc/openldap/slapd.conf
```

これでエラーがでなくなるまで修正。

で、変換。

```sh
mkdir -p /tmp/slapd.d
slaptest -f /etc/ldap/slapd.conf -F /tmp/slapd.d
chown -R openldap:openldap /tmp/slapd.d    # これ重要
```

これを /etc/ldap/slapd.d と入れ替える。

/usr/share/doc/slapd
の
README.Debian.gz
参照

## 重要

slapd.conf
に
rootpw
を書いても olcRootPW にしてくれないので

## 参考

[OpenLDAP Software 2.4 Administrator's Guide: Configuring slapd](https://www.openldap.org/doc/admin24/slapdconf2.html)
の
`5.4. Converting old style slapd.conf(5) file to cn=config format`
参照。

## メモ

ConfigDB は

```sh
ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -b cn=config
# or
slapcat -b cn=config
# or
slapcat -n0
```

で見れる
し
/etc/ldap/slapd.d の下のファイル見ても OK。

たとえば

```sh
find /etc/ldap/slapd.d -type f -name \*.ldif -exec grep olcRootPW {} \+
```

`/etc/ldap/slapd.d/cn=config/olcDatabase={1}mdb.ldif` で設定されてるのがわかる。

slapcat はファイルを直接見るので slapd が起動している必要がない。

# slapxxxxとldapxxxxの違いは

slapxxxx は LDAP 使わずにファイルを直接触るので slapd が動いてなくても使える。
slapd が起動してると**厳密には**一貫性がとれなくなる。

# 未整理メモ

すごい苦労したので「先にこれだけ知ってれば随分と違うよ」超肝心なことだけメモ書いときます(2021-12)。

OpenLDAP の Web 記事は [技術メモメモ: OpenLDAP入門① (OpenLDAP初期構築手順)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldap.html) がおすすめ。

最近の slapd は slapd.conf を読まない。ConfigDB を読む(/etc/ldap/slapd.d 以下。OLC というらしい)
「slapd.conf を編集して...」と書いてある web 記事は、ことごとく古いので参考程度に。変換して別ディレクトリに出した LDIF を参考にするのは OK (ex: `slaptest -f /etc/ldap/slapd.conf -F /tmp/slapd.d`)

slapxxxx と ldapxxxx の違いは、
slapxxxx は LDAP 使わずにファイルを直接触るので slapd が動いてなくても使えること。
slapd が起動してると厳密には一貫性がとれなくなる。

`objectClass: posixAccount` だったら uid インデックスだけでも作っておくといい感じ。

ldapi:スキーマは unix socket

# backup

```sh
systemctl stop slapd
slapcat -n0 -l ldap-config-20211221.ldif
slapcat -n2 -l ldap-20211221.ldif
systemctl start slapd
```

- `20211221` はタイムスタンプ
- `-n2`はデフォルトなので不要かも

/var/lib/ldap/DB_CONFIG もあるといいかも
/etc/openldap/certs (CA はそのまま)
/etc/sysconfig/slapd

# restore

```sh
systemctl stop slapd
# Debian, Ubunts
slapadd -n0 -F /etc/ldap/slapd.d -l ldap-config-20211221.ldif
# RHEL
slapadd -n0 -F /etc/openldap/slapd.d -l ldap-config.ldif
slapadd -n2 -F /etc/openldap/slapd.d -l ldap.ldif

# Debian, Ubunts
chown -R openldap:openldap /etc/ldap/slapd.d
chown -R openldap:openldap /var/lib/ldap
# RHEL
chown -R ldap:ldap /etc/openldap/slapd.d /var/lib/ldap

systemctl start slapd
```

- `20211221` はタイムスタンプ
- `-n2`はデフォルトなので不要かも
- RedHat 系だと `openldap:openldap` のかわりに `ldap:ldap`
- RedHat 系だと `/etc/ldap/slapd.d` のかわりに `/etc/openldap/slapd.d`

# sssdのキャッシュ

まるごと消すなら `sssctl cache-remove`\
[付録A トラブルシューティング Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/trouble#debug-sssd-conf)

インストールは
`yum install sssd-tools sssd-dbus`

普通は

```sh
# 特定ユーザだけ消す
sudo sss_cache -u jsmith
# ユーザ関連だけ消す
sudo sss_cache -U
# なにもかも消す
sudo sss_cache -E
```

sss_cahce は sssd-common に入ってるので sssd が動いてるとこならたいてい使える。

[11.2.26. SSSD キャッシュの管理 Red Hat Enterprise Linux 6 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/sssd-cache)

> sss_cache は、有効期限のタイムスタンプを過去に設定することで機能します。これにより、次回は強制的にルックアップされますが、エントリが完全に削除されるわけではないため、クライアントがオフラインになる場合に備えて、エントリは引き続き存在します。

テスト

```
# sssctl user-show user01
Name: user01
Cache entry creation date: 12/22/21 07:12:33
Cache entry last update time: 12/22/21 08:36:19
Cache entry expiration time: 12/22/21 10:06:19
Initgroups expiration time: 12/22/21 10:06:19
Cached in InfoPipe: No

# sss_cache -u user01

# sssctl user-show user01
Name: user01
Cache entry creation date: 12/22/21 07:12:33
Cache entry last update time: 12/22/21 08:36:19
Cache entry expiration time: Expired
Initgroups expiration time: Expired
Cached in InfoPipe: No

# id user01
uid=10001(user01) gid=10000(ldapgrp) groups=10000(ldapgrp)

# sssctl user-show user01
Name: user01
Cache entry creation date: 12/22/21 07:12:33
Cache entry last update time: 12/22/21 08:38:18
Cache entry expiration time: 12/22/21 10:08:18
Initgroups expiration time: 12/22/21 10:08:18
Cached in InfoPipe: No
```

なるほど。
