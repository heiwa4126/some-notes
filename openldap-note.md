OpenLDAPのメモ

# slapd.confがないとき

最近のslapdは
slapd.conf
を読まない。
ConfigDBを読む(/etc/ldap/slapd.d)

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
```
で見れる
し
/etc/ldap/slapd.dの下のファイル見てもOK。

たとえば
```sh
find /etc/ldap/slapd.d -type f -name \*.ldif -exec grep olcRootPW {} \+
```
`/etc/ldap/slapd.d/cn=config/olcDatabase={1}mdb.ldif` で設定されてるのがわかる。
