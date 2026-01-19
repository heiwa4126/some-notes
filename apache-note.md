- [apache bench (ab)](#apache-bench-ab)
- [ubuntuのApache2でdigest auth](#ubuntuのapache2でdigest-auth)
- [ubuntuのApache2でBASIC auth](#ubuntuのapache2でbasic-auth)
- [CONNECTメソッドを無効に](#connectメソッドを無効に)

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

認証ファイルつくる。以下は DemoZone1 という realm(領域)に user1 というユーザの

```
htdigest -c /etc/apache2/.digestauth "DemoZone1" user1
```

重要: 二人目以降は`-c`オプションを削除。

TIPS: BASIC 認証と違って、認証ファイルは 1 個でいい。

以下のような conf を書いて、`<virtual>`内で Include する。

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

あいかわらず MS Edge が digest 認証がダメなことが判明。
over SSL なんで BASIC 認証に切り替える。

# ubuntuのApache2でBASIC auth

Ubuntu 20.04LTS

```sh
sudo -i
cd /etc/apache2
a2enmod auth_basic
```

認証ファイルつくる。以下は demozone1 用にという realm(領域)に user1 というユーザの

```
htpasswd -c /etc/apache2/.basicauth-demozone1 user1
```

重要: 二人目以降は`-c`オプションを削除。

# CONNECTメソッドを無効に

> Connection attempts using mod_proxy

があったら、CONNECT を無効にする。

ログでは

```
lzgrep -F CONNECT /var/log/apache2/*
```

とかで。

普通スタティックな WWW サイトだったら GET,HEAD ぐらいしか使わんのでは。(ギリ POST)

- [apache how disable CONNECT method - Google Search](https://www.google.com/search?q=apache+how+disable+CONNECT+method&hl=en&sxsrf=ALiCzsZ3AwrwCuI5Tm7KVUYUQmcAZYI-6Q%3A1653805358617&ei=LhGTYrymJdXFhwOHhZ34BQ&ved=0ahUKEwi89bWHiYT4AhXV4mEKHYdCB18Q4dUDCA4&uact=5&oq=apache+how+disable+CONNECT+method&gs_lcp=Cgdnd3Mtd2l6EAMyBggAEB4QCDoHCCMQsAMQJzoHCAAQRxCwAzoHCCMQsAIQJ0oECEEYAEoECEYYAFDZGliJHmCaImgBcAF4AIABjwGIAfYDkgEDMC40mAEAoAEByAEJwAEB&sclient=gws-wiz)
- [mod proxy - How to disable CONNECT method in Apache 2.4.29 and return 405 status? - Server Fault](https://serverfault.com/questions/896598/how-to-disable-connect-method-in-apache-2-4-29-and-return-405-status)
-
