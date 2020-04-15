- [PostgreSQLのサンプルデータ](#postgresqlのサンプルデータ)
- [PostgreSQLのlibパスは?](#postgresqlのlibパスは)
- [valuntilがNULLの時](#valuntilがnullの時)
- [PostgreSQLの認証問題](#postgresqlの認証問題)
- [よくあるテストユーザとテストデータの作り方](#よくあるテストユーザとテストデータの作り方)
- [WALアーカイブを消す](#walアーカイブを消す)

# PostgreSQLのサンプルデータ

PostgreSQL Tutorialに適当なサンプルがある。

* [[PostgreSQL] サンプルのデータベースを用意する ｜ DevelopersIO](https://dev.classmethod.jp/etc/postgresql-create-sample-database/)
* [PostgreSQL Sample Database](http://www.postgresqltutorial.com/postgresql-sample-database/)

# PostgreSQLのlibパスは?

libpq.soのあるパスなのかlibpq.so.5までのフルパスなのか
微妙なんだが

`pg_config --libdir`

で出るやつでいいのでは。



# valuntilがNULLの時

ALTER ROLEでパスワードを設定した時、VALID UNTILを指定しないと、pg_userのvaiuntilはNULLになる。

```
postgres=# select usename,valuntil from pg_user where valuntil is NULL;
 usename  | valuntil
----------+----------
 postgres |
(1 行)
```
valuntilがNULLの時のパスワードは決して無効にならない。

* [How long will the PostgreSQL user password expire when the valuntil value in pq_user is NULL? - Stack Overflow](https://stackoverflow.com/questions/45788831/how-long-will-the-postgresql-user-password-expire-when-the-valuntil-value-in-pq)
* [PostgreSQL: Documentation: 11: 52.8. pg_authid](https://www.postgresql.org/docs/current/catalog-pg-authid.html) (rollvaliduntilのところ)

不安ならabstimeのinfinityを設定しておく

* [PostgreSQL: Documentation: 11: 8.5. Date/Time Types](https://www.postgresql.org/docs/current/datatype-datetime.html)
* [PostgreSQL・ロールのパスワード設定](http://www.ajisaba.net/db/postgresql/role_password.html)


# PostgreSQLの認証問題

めんどくさい上に、毎回忘れる。ちゃんと理解してないから。

example

postgresユーザ以外で
peerで入れないことを確認
```sh
psql -h localhost -U postgres
```

```sh
sudo systemctl start postgresql
sudo su - postgres
psql -c "alter role postgres with password '{password}'";
```

`{password}`のところは好きに変える。

パスワードで入れることを確認。
TCPで入れることを確認。
``` sh
psql -h 127.0.0.1 -U postgres postgres
```
で、パスワード聞かれたら答えて入れればOK。


で、.pgpass
```sh
touch ~/.pgpass
chmod 0600 ~/.pgpass
emacs ~/.pgpass
```

```
#hostname:port:database:username:password
localhost:*:postgres:postgres:{password}
```

`{password}`のところはさっきのパスワード。

pg_hba.confを
```
# IPv4 local connections:
#host   all             all             127.0.0.1/32            ident
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
#host   all             all             ::1/128                 ident
host    all             all             ::1/128                 md5
```

identデーモン立ててるクライアントなんか無いだろう。

# よくあるテストユーザとテストデータの作り方

初期ユーザを`heiwa`として、

これをやるとユーザ(role)で、
ソケット経由でつなぐことができる。

``` sh
sudo su - postgres
psql
```

で

```sql
create role heiwa password '************';
create database test01 encoding=utf8;
grant all on database test01 to heiwa;
grant connect on database test01 to heiwa;
alter role heiwa with login;
exit
```

``` sh
exit
```
でheiwaユーザに戻って

``` sh
psql test01
```
でパスワード入れてつながることを確認。

適当なテーブルを作ってみる
```sql
CREATE TABLE words (
id SERIAL NOT NULL,
english varchar(128),
japanese varchar(128),
PRIMARY KEY (id)
);
create unique index on words (english);
insert into words(english,japanese) values('apple','りんご');
insert into words(english,japanese) values('banana','バナナ');
insert into words(english,japanese) values('cherry','さくらんぼ');
insert into words(english,japanese) values('deer','しか');
insert into words(english,japanese) values('eel','うなぎ');
--- 英語にeが入ってるやつを抜き出す
select * from words where english like '%e%';
```



# WALアーカイブを消す

RHEL7標準のpostgresでは`postgresql-contrib`パッケージに`pg_archivecleanup`が入ってる。

`pg_archivecleanup -d {アーカイブディレクトリ} {一番新しい.backup}.backup`

`-d`はデバッグオプションなのでお好みで。ドライランは`-n`

スクリプトにするとこんな感じ。
``` sh
#!/bin/bash -e
ARCDIR=/var/lib/pgsql/data/archivedir

RC=$(cd "$ARCDIR"; ls -1 *.backup 2> /dev/null | wc -l)
if [ "0" == "$RC" ] ; then
  # do notnig
  exit 0
fi

cd "$ARCDIR"
RC=$(ls -t *.backup | head -1)
ls -t *.backup | tail -n +2 | xargs -r rm
cd - &> /dev/null

pg_archivecleanup -d "$ARCDIR" "$RC"
```
