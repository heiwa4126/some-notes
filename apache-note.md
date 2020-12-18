
# apache bench (ab)

- [Apache Bench Tutorial - Tutorialspoint](https://www.tutorialspoint.com/apache_bench/index.htm)
- [Apache-bench-quick-guide - Dev Guides](https://www.finddevguides.com/Apache-bench-quick-guide) - 上の日本語訳(らしい)

これ面白いので試す。

> abにはバグがあり、ローカルホストでアプリケーションをテストできない


# ubuntuのApache2でdigest auth

Ubuntu 20.04LTS

```sh
sudo -i
cd /etc/apache2
a2enmod auth_digest
```

認証ファイルつくる。以下はDemoZone1というrealm(領域)にuser1というユーザの
```
htdigest -c /etc/apache2/.digestauth "DemoZone1" user1
```

重要: 二人目以降は`-c`オプションを削除。

TIPS: BASIC認証と違って、認証ファイルは1個でいい。

以下のようなconfを書いて、`<virtual>`内でIncludeする。
```
<Location />
    AuthType Digest
    AuthName "DemoZone1"
    AuthUserFile /etc/apache2/.digestauth
    Require valid-user
</Location>
```
サイト全体に認証が必要になる。

パスは/etc/apache2/より下なら相対で書ける

あいかわらずMS Edgeがdigest認証がダメなことが判明。
over SSLなんでBASIC認証に切り替える。

# ubuntuのApache2でBASIC auth

Ubuntu 20.04LTS

```sh
sudo -i
cd /etc/apache2
a2enmod auth_basic
```

認証ファイルつくる。以下はdemozone1用にというrealm(領域)にuser1というユーザの
```
htpasswd -c /etc/apache2/.basicauth-demozone1 user1
```
重要: 二人目以降は`-c`オプションを削除。
