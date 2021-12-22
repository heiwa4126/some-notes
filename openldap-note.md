OpenLDAPのメモ

# RHEL8だったら

OpenLDAP + nss + sssd ではなくて
Red Hat Directory Server (RHDS) を使いましょう。

* [Product Documentation for Red Hat Directory Server 11 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_directory_server/11)
* [1.2. Directory Server の概要 Red Hat Directory Server 11 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_directory_server/11/html/deployment_guide/introduction_to_directory_services-introduction_to_ds)



# リンク集

* [技術メモメモ: OpenLDAP入門① (OpenLDAP初期構築手順)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldap.html)
* [技術メモメモ: OpenLDAP入門② (OpenLDAPでLDAPSを有効化する)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldapldaps.html)
* [技術メモメモ: OpenLDAP入門③ (LinuxのSSSDを使ってOpenLDAPと認証連携する)](https://tech-mmmm.blogspot.com/2021/12/openldap-linuxsssdopenldap.html)
* [OpenLDAPの設定をしてたら死にそうだった話](http://dmiyakawa.blogspot.com/2012/09/openldap.html)
* [第9章 LDAP サーバー Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/ldap_servers)
* [9.2. OpenLDAP Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/openldap)
* [付録A トラブルシューティング Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/trouble#sssctl)
* [9.2.3.7. レプリケーションの設定 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/s3-setting_up_replication)


# slapd.confがないとき

最近のslapdは
slapd.conf
を読まない。
ConfigDBを読む(/etc/ldap/slapd.d以下。OLCというらしい)

**「slapd.confを編集して...」と書いてあるweb記事は、
ことごとく古いので参考程度にとどめて起きましょう。
変換して別ディレクトリに出したLDIFを参考にするのはOK。**

ConfigDBはldapなのでldapadd/ldapmodifyで修正できるけど
**そんなのやってられない**ので
slapd.confを変換する。

Debian/Ubuntuなら
```sh
dpkg-reconfigure slapd
```
で大雑把な設定はできる。

ubuntu
```sh
zcat /usr/share/doc/slapd/examples/slapd.conf.gz > /etc/ldap/slapd.conf
```
最低でも
suffixとrootdnは書き換える。


ドメインがdc=zzz,dc=example,dc=net(zzz.example.net)だったら
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
これを /etc/ldap/slapd.dと入れ替える。

/usr/share/doc/slapd
の
README.Debian.gz
参照




## 重要

slapd.conf
に
rootpw
を書いてもolcRootPWにしてくれないので


## 参考

[OpenLDAP Software 2.4 Administrator's Guide: Configuring slapd](https://www.openldap.org/doc/admin24/slapdconf2.html)
の
`5.4. Converting old style slapd.conf(5) file to cn=config format`
参照。


## メモ

ConfigDBは
```sh
ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -b cn=config
# or
slapcat -b cn=config
# or
slapcat -n0
```
で見れる
し
/etc/ldap/slapd.dの下のファイル見てもOK。

たとえば
```sh
find /etc/ldap/slapd.d -type f -name \*.ldif -exec grep olcRootPW {} \+
```
`/etc/ldap/slapd.d/cn=config/olcDatabase={1}mdb.ldif` で設定されてるのがわかる。

slapcatはファイルを直接見るのでslapdが起動している必要がない。

# slapxxxxとldapxxxxの違いは

slapxxxxはLDAP使わずにファイルを直接触るのでslapdが動いてなくても使える。
slapdが起動してると**厳密には**一貫性がとれなくなる。


# 未整理メモ

すごい苦労したので「先にこれだけ知ってれば随分と違うよ」超肝心なことだけメモ書いときます(2021-12)。

OpenLDAPのWeb記事は [技術メモメモ: OpenLDAP入門① (OpenLDAP初期構築手順)](https://tech-mmmm.blogspot.com/2021/11/openldap-openldap.html) がおすすめ。

最近のslapdは slapd.conf を読まない。ConfigDBを読む(/etc/ldap/slapd.d以下。OLCというらしい)
「slapd.confを編集して...」と書いてあるweb記事は、ことごとく古いので参考程度に。変換して別ディレクトリに出したLDIFを参考にするのはOK (ex: `slaptest -f /etc/ldap/slapd.conf -F /tmp/slapd.d`)

slapxxxxとldapxxxxの違いは、
slapxxxxはLDAP使わずにファイルを直接触るのでslapdが動いてなくても使えること。
slapdが起動してると厳密には一貫性がとれなくなる。

`objectClass: posixAccount` だったらuidインデックスだけでも作っておくといい感じ。

sssdキャッシュを消すのは `sssctl cache-remove` 
[付録A トラブルシューティング Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/trouble#debug-sssd-conf)


# backup

```sh
systemctl stop slapd
slapcat -n0 -l ldap-config-20211221.ldif
slapcat -n2 -l ldap-20211221.ldif
systemctl start slapd
```

* `20211221` はタイムスタンプ
* `-n2`はデフォルトなので不要かも


# restore

```sh
systemctl stop slapd
slapadd -n0 -F /etc/ldap/slapd.d -l ldap-config-20211221.ldif
chown -R openldap:openldap /etc/ldap/slapd.d
slapadd -n2 -l ldap-20211221.ldif
chown -R openldap:openldap /var/lib/ldap
systemctl start slapd
```

* `20211221` はタイムスタンプ
* `-n2`はデフォルトなので不要かも
* RedHat系だと `openldap:openldap` のかわりに `ldap:ldap`
* RedHat系だと `/etc/ldap/slapd.d` のかわりに `/etc/openldap/slapd.d`
