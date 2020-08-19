- [PostgreSQLのサンプルデータ](#postgresqlのサンプルデータ)
- [PostgreSQLのlibパスは?](#postgresqlのlibパスは)
- [/usr/pgsql-XX/binにパスが通ってない問題](#usrpgsql-xxbinにパスが通ってない問題)
- [valuntilがNULLの時](#valuntilがnullの時)
- [PostgreSQLをインストールする](#postgresqlをインストールする)
- [PostgreSQLの認証問題](#postgresqlの認証問題)
- [Postgres配布のPostgreSQL](#postgres配布のpostgresql)
- [ユーザ一覧](#ユーザ一覧)
- [よくあるテストユーザとテストデータの作り方](#よくあるテストユーザとテストデータの作り方)
- [JDBC](#jdbc)
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
(Postgres配布のパッケージだとpg_configはPATHが通ってないことが多い。`/usr/pgsql-9.6/bin/pg_config`とかにある。)

例:
```
# ls -la `pg_config --libdir`/libpq*
lrwxrwxrwx 1 root root     12 Jul 27 05:10 /usr/lib64/libpq.so -> libpq.so.5.5
lrwxrwxrwx 1 root root     12 Jul 27 02:24 /usr/lib64/libpq.so.5 -> libpq.so.5.5
-rwxr-xr-x 1 root root 197544 Feb 24 13:24 /usr/lib64/libpq.so.5.5
```

シンボリックリンクを除外するなら
```sh
find `pg_config --libdir` -maxdepth 1 -type f -not -type l -name libpq\*
```
長いな。


# /usr/pgsql-XX/binにパスが通ってない問題

`/var/lib/pgsql/.pgsql_profile`に

```
export PATH=$PATH:/usr/pgsql-9.6/bin
```
とか書いておく。

`/var/lib/pgsql`は(大概)postgresユーザのホームディレクトリ。


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


# PostgreSQLをインストールする

インストールそのものは簡単なんだけど、その後の話を含めて。

まずRHEL7系でRHELのレポジトリにある、ちょっと古い(9.2)を入れるところから。

```sh
sudo yum install postgresql-server postgresql postgresql-libs
su - 
su - postgres
initdb
exit # rootへ戻る
systemctl enable postgresql --now
```

initdbの出力メモ
```
$ initdb
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

fixing permissions on existing directory /var/lib/pgsql/data ... ok
creating subdirectories ... ok
selecting default max_connections ... 100
selecting default shared_buffers ... 32MB
creating configuration files ... ok
creating template1 database in /var/lib/pgsql/data/base/1 ... ok
initializing pg_authid ... ok
initializing dependencies ... ok
creating system views ... ok
loading system objects' descriptions ... ok
creating collations ... ok
creating conversions ... ok
creating dictionaries ... ok
setting privileges on built-in objects ... ok
creating information schema ... ok
loading PL/pgSQL server-side language ... ok
vacuuming database template1 ... ok
copying template1 to template0 ... ok
copying template1 to postgres ... ok

WARNING: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    postgres -D /var/lib/pgsql/data
or
    pg_ctl -D /var/lib/pgsql/data -l logfile start
```

この最後のメッセージに従わないこと。上にある通りsystemdで起動すること。

で、このままだと(上の警告にもある通り)
`/var/lib/pgsql/data/pg_hba.conf` が
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```
になってるので、
このホスト上のどんなユーザでも
```sh
psql -h localhost -U postgres
```
で入れてしまうので、適宜治す。それはおいといて、まず動作テスト。

```
# su - postgres
-bash-4.2$ psql
psql (9.2.24)
Type "help" for help.

postgres=# SELECT version();
                                                    version
---------------------------------------------------------------------------------------------------------------
 PostgreSQL 9.2.24 on x86_64-redhat-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-28), 64-bit
(1 row)

postgres=# \q
```

↓次節に続く


# PostgreSQLの認証問題

めんどくさい上に、毎回忘れる。ちゃんと理解してないから。

example

**postgresユーザ以外**で以下のコマンドを実行して
入れないことを確認
```sh
psql -h localhost -U postgres
```

もし入れるようなら
`/var/lib/pgsql/data/pg_hba.conf`(RHELの場合) が
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
```
こんな感じになってるかもしれませんので、こう変える。
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
```
に変えて`sudo systemctl restart postgresql`

上記は
- UNIXのpostgresユーザからは`psql`コマンドだけで、パスワードなしでpostgresロールで入れる。
- 他のUNIXユーザでも`psql -h localhost -U postgres`で、パスワード入れればpostgresロールで入れる。
という設定。


でパスワードを設定する。
```sh
sudo su - postgres
psql -c "alter role postgres with password '{password}'";
```

`{password}`のところは好きに変える。

どのUNIXユーザからでも(postgresユーザ含む)
以下のコマンドを実行して
- パスワードで入れることを確認
- TCPで入れることを確認

``` sh
psql -h localhost -U postgres postgres
```
で、パスワード聞かれたら答えて入れればOK。


で、パスワードなしに接続するには
~/.pgpassに書く。

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


# Postgres配布のPostgreSQL

基本は
[Repo RPMs - PostgreSQL YUM Repository](https://yum.postgresql.org/repopackages/)から
OSのリンクをコピーして
```
yum install <ここにペースト>
yum install postgresqlXX-server postgresqlXX-contrib
su - postgres
initdb
```
でOK.

Debian,Ubuntuだったら
[Apt - PostgreSQL wiki](https://wiki.postgresql.org/wiki/Apt)
から。


# ユーザ一覧

すぐ忘れるのでメモ
- `\du`
- `select usename,passwd,valuntil from pg_user;`


# よくあるテストユーザとテストデータの作り方

初期UNIXユーザを`heiwa`として、

これをやると`heiwa`ユーザ(role)で、
ソケット経由でつなぐことができる。

``` sh
sudo su - postgres
psql
```

で

```sql
create role heiwa password '************';
create database test01 encoding 'utf8';
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
でパスワード入れずにつながることを確認(UNIX socketでpeer認証)。
DBの名前も`heiwa`にすると`psql`だけでOk

```sh
psql -h localhost -U heiwa test01
```
でパスワード入れてつながることを確認(TCP/IPでmd5認証)。


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
--- 同様
select * from words where japanese like '%ん%' order by japanese;
```

# JDBC

- [PostgreSQL JDBC Driver](https://jdbc.postgresql.org/)
- [Connecting to the Database](https://jdbc.postgresql.org/documentation/head/connect.html)

Unix Domain socketでつなぐには
[Connecting to the Database](https://jdbc.postgresql.org/documentation/head/connect.html)の
`Unix sockets`セクション参照。

> Simply add ?socketFactory=org.newsclub.net.unix.socketfactory.PostgresqlAFUNIXSocketFactory&socketFactoryArg=[path-to-the-unix-socket] to the connection URL.
> For many distros the default path is /var/run/postgresql/.s.PGSQL.5432

[junixsocket/PostgresqlAFUNIXSocketFactory.java at master · fiken/junixsocket](https://github.com/fiken/junixsocket/blob/master/junixsocket-common/src/main/java/org/newsclub/net/unix/socketfactory/PostgresqlAFUNIXSocketFactory.java)

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
