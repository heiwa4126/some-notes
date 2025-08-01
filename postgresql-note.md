# PostgreSQL メモ

- [PostgreSQL のサンプルデータ](#postgresqlのサンプルデータ)
- [PostgreSQL の lib パスは?](#postgresqlのlibパスは)
- [/usr/pgsql-XX/bin にパスが通ってない問題](#usrpgsql-xxbinにパスが通ってない問題)
- [valuntil が NULL の時](#valuntilがnullの時)
- [PostgreSQL をインストールする](#postgresqlをインストールする)
- [PostgreSQL の認証問題](#postgresqlの認証問題)
- [Postgres 配布の PostgreSQL](#postgres配布のpostgresql)
- [ユーザ一覧](#ユーザ一覧)
- [show grants みたいの](#show-grantsみたいの)
- [よくあるテストユーザとテストデータの作り方](#よくあるテストユーザとテストデータの作り方)
- [JDBC](#jdbc)
- [WAL アーカイブとは](#walアーカイブとは)
- [pg_basebackup](#pg_basebackup)
- [サーバから WAL アーカイブを消す](#サーバからwalアーカイブを消す)
  - [.backup ファイルサンプル](#backupファイルサンプル)
- [Slony-I でレプリケーション](#slony-iでレプリケーション)
- [スーパーユーザー権限のロールを作成](#スーパーユーザー権限のロールを作成)
- [RHEL 系で postgres ユーザのプロンプト](#rhel系でpostgresユーザのプロンプト)
- [1 台のホストに 9.6,9.5,9.4](#1台のホストに969594)
- [メタ情報](#メタ情報)
- [docker で postgres](#dockerでpostgres)
- [systemd で起動される postgres の PGDATA を変更する](#systemdで起動されるpostgresのpgdataを変更する)
- [public スキーマー](#publicスキーマー)
- [特定のロールの grant を表示する](#特定のロールのgrantを表示する)

## PostgreSQL のサンプルデータ

PostgreSQL Tutorial に適当なサンプルがある。

- [[PostgreSQL] サンプルのデータベースを用意する ｜ DevelopersIO](https://dev.classmethod.jp/etc/postgresql-create-sample-database/)
- [PostgreSQL Sample Database](http://www.postgresqltutorial.com/postgresql-sample-database/)

## PostgreSQL の lib パスは?

libpq.so のあるパスなのか libpq.so.5 までのフルパスなのか
微妙なんだが

`pg_config --libdir`

で出るやつでいいのでは。
(Postgres 配布のパッケージだと pg_config は PATH が通ってないことが多い。`/usr/pgsql-9.6/bin/pg_config`とかにある。)

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

## /usr/pgsql-XX/bin にパスが通ってない問題

`/var/lib/pgsql/.pgsql_profile`に

```
export PATH=$PATH:/usr/pgsql-9.6/bin
```

とか書いておく。

`/var/lib/pgsql`は(大概)postgres ユーザのホームディレクトリ。

## valuntil が NULL の時

ALTER ROLE でパスワードを設定した時、VALID UNTIL を指定しないと、pg_user の vaiuntil は NULL になる。

```
postgres=# select usename,valuntil from pg_user where valuntil is NULL;
 usename  | valuntil
----------+----------
 postgres |
(1 行)
```

valuntil が NULL の時のパスワードは決して無効にならない。

- [How long will the PostgreSQL user password expire when the valuntil value in pq_user is NULL? - Stack Overflow](https://stackoverflow.com/questions/45788831/how-long-will-the-postgresql-user-password-expire-when-the-valuntil-value-in-pq)
- [PostgreSQL: Documentation: 11: 52.8. pg_authid](https://www.postgresql.org/docs/current/catalog-pg-authid.html) (rollvaliduntil のところ)

不安なら abstime の infinity を設定しておく

- [PostgreSQL: Documentation: 11: 8.5. Date/Time Types](https://www.postgresql.org/docs/current/datatype-datetime.html)
- [PostgreSQL・ロールのパスワード設定](http://www.ajisaba.net/db/postgresql/role_password.html)

## PostgreSQL をインストールする

インストールそのものは簡単なんだけど、その後の話を含めて。

まず RHEL7 系で RHEL のレポジトリにある、ちょっと古い(9.2)を入れるところから。

```sh
sudo yum install postgresql-server postgresql postgresql-libs
su -
su - postgres
initdb
exit # rootへ戻る
systemctl enable postgresql --now
```

initdb の出力メモ

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

この最後のメッセージに従わないこと。上にある通り systemd で起動すること。

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

↓ 次節に続く

## PostgreSQL の認証問題

めんどくさい上に、毎回忘れる。ちゃんと理解してないから。

example

**postgres ユーザ以外**で以下のコマンドを実行して
入れないことを確認

```sh
psql -h localhost -U postgres
```

もし入れるようなら
`/var/lib/pgsql/data/pg_hba.conf`(RHEL の場合) が

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

- UNIX の postgres ユーザからは`psql`コマンドだけで、パスワードなしで postgres ロールで入れる。
- 他の UNIX ユーザでも`psql -h localhost -U postgres`で、パスワード入れれば postgres ロールで入れる。
  という設定。

でパスワードを設定する。

```sh
sudo su - postgres
psql -c "alter role postgres with password '{password}'";
```

`{password}`のところは好きに変える。

どの UNIX ユーザからでも(postgres ユーザ含む)
以下のコマンドを実行して

- パスワードで入れることを確認
- TCP で入れることを確認

```sh
psql -h localhost -U postgres postgres
```

で、パスワード聞かれたら答えて入れれば OK。

で、パスワードなしに接続するには
~/.pgpass に書く。

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

## Postgres 配布の PostgreSQL

基本は
[Repo RPMs - PostgreSQL YUM Repository](https://yum.postgresql.org/repopackages/)から
OS のリンクをコピーして

```
yum install <ここにペースト>
yum install postgresqlXX-server postgresqlXX-contrib
su - postgres
initdb
```

で OK.

Debian,Ubuntu だったら
[Apt - PostgreSQL wiki](https://wiki.postgresql.org/wiki/Apt)
から。

## ユーザ一覧

すぐ忘れるのでメモ

- `\du`
- `select usename,passwd,valuntil from pg_user;`

## show grants みたいの

mysql の`show grants for user`みたいのが無い。
`\l`と`\z`でそこそこ要は足りるけど...

```sql
select rolname, rolsuper, rolcanlogin from pg_roles;
```

はどうか。

## よくあるテストユーザとテストデータの作り方

初期 UNIX ユーザを`heiwa`として、

これをやると`heiwa`ユーザ(role)で、
ソケット経由でつなぐことができる。

```sh
sudo -iu postgres psql
```

で

```sql
create role heiwa password '************';
create database test01 encoding 'utf8';
grant all on database test01 to heiwa;
ALTER DATABASE test01 OWNER TO heiwa; --- Postgre15から必要
grant connect on database test01 to heiwa;
alter role heiwa with login;
\q
```

(TODO: create role で with login を使った方が早いかも。確認後修正)

で heiwa ユーザに戻って

```sh
psql test01
```

でパスワード入れずにつながることを確認(UNIX socket で peer 認証)。
DB の名前も`heiwa`にすると`psql`だけで Ok

```sh
psql -h localhost -U heiwa test01
```

でパスワード入れてつながることを確認(TCP/IP で md5 認証)。

適当なテーブルを作ってみる

```sql
CREATE TABLE words (
id SERIAL NOT NULL,
english varchar(128) unique,
japanese varchar(128),
PRIMARY KEY (id)
);
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

## JDBC

- [PostgreSQL JDBC Driver](https://jdbc.postgresql.org/)
- [Connecting to the Database](https://jdbc.postgresql.org/documentation/head/connect.html)

Unix Domain socket でつなぐには
[Connecting to the Database](https://jdbc.postgresql.org/documentation/head/connect.html)の
`Unix sockets`セクション参照。

> Simply add ?socketFactory=org.newsclub.net.unix.socketfactory.PostgresqlAFUNIXSocketFactory&socketFactoryArg=[path-to-the-unix-socket] to the connection URL.
> For many distros the default path is /var/run/postgresql/.s.PGSQL.5432

[junixsocket/PostgresqlAFUNIXSocketFactory.java at master · fiken/junixsocket](https://github.com/fiken/junixsocket/blob/master/junixsocket-common/src/main/java/org/newsclub/net/unix/socketfactory/PostgresqlAFUNIXSocketFactory.java)

## WAL アーカイブとは

WAL のアーカイブ(をぃ)。チェックポイントで反映済みの WAL。完了した WAL ファイルのアーカイブ。

カレントのベースバックアップ(PG_DATA の下全部)と、すべての WAL のアーカイブがあれば、
PostgreSQL が起動して以来のすべての時点にデータベースを復元できる。
WAL にはすべての redo/undo アクションが入っているから(archive_mode が replica/archive 以上の場合)。

バックアップ先には

- 現在の$PG_DATA の下全部
- 過去の WAL すべて(つまり WAL アーカイブ)

を保存するようにすれば、任意の時点に DB を戻せる。
これを PITR(ポイントインタイムリカバリ)という。

WAL アーカイブ先は
バックアップサーバへ
ネットワークファイルシステムでつないで使うのが
まともな設計。

## pg_basebackup

- [PostgreSQL のバックアップ手法のまとめ - Qiita](https://qiita.com/bwtakacy/items/65260e29a25b5fbde835)
- [pg_basebackup を試す « LANCARD.LAB ｜ランカードコムのスタッフブログ](https://www.lancard.com/blog/2018/03/22/pg_basebackup%E3%82%92%E8%A9%A6%E3%81%99/)
- [第 25 章 バックアップとリストア](https://www.postgresql.jp/document/9.6/html/backup.html)

準備

```sh
sudo -iu postgres
mkdir /tmp/postgres_backup
chown postgres:postgres /tmp/postgres_backup
chmod 0700 /tmp/postgres_backup
```

あと postgres.conf で WAL アーカイブの設定と

```
max_wal_senders = 1
```

さらに pg_hba.conf で replica を設定。以下例:

```
local   replication     postgres                                peer
```

で`pg_ctl reload`

バックアップ

```
pg_basebackup -Ft -z -x -D /tmp/postgres_backup
```

- Ft tar 形式
- z gzip 圧縮
- x `-X fecth`に同じ. 完全なスタンドアローンバックアップを作成
  max_wal_senders=2 にして`-X s`のほうがいいかも。->ダメでした。 WAL streaming can only be used in plain mode だって
- D バックアップするディレクトリ。「存在していて、かつ空」でなければダメ

参照: [pg_basebackup](https://www.postgresql.jp/document/9.6/html/app-pgbasebackup.html)

tarball のリストを出してみる。

```
tar ztvf /tmp/postgres_backup/base.tar.gz
```

ほんとに PGDATA 以下全部(バックアップファイルとかも含めて)入ってるのがわかる。

出来た tarball は
完全なスタンドアローンバックアップなので
適当なところに展開するだけで(
既存と共用するなら`archive_command`のパスを考慮する。
postgres ロールのパスがわからないなら`pg_hba.conf`をいじる、など。
)

## サーバから WAL アーカイブを消す

バックアップ先には WAL すべてを残すとして、サーバ自体に WAL アーカイブすべてを残しておく必要はない。

RHEL7 標準の postgres では`postgresql-contrib`パッケージに`pg_archivecleanup`が入ってる。
Postgre 配布でも`postgresqlXX-contrib`のはず。XX は 96 とか 12 とか

`pg_archivecleanup -d {アーカイブディレクトリ} {一番新しい.backup}.backup`

`-d`はデバッグオプションなのでお好みで。ドライランは`-n`

スクリプトにするとこんな感じ。
`/etc/cron.daily/WALclear`

```sh
#!/bin/bash -e
WALDIR=/var/lib/pgsql/data/pg_xlog
ARCDIR=/var/archive/postgres
PGACLEAN=/usr/bin/pg_archivecleanup
#
RC=$(cd "$WALDIR"; ls -1 *.backup 2> /dev/null)
CNT=$(echo -n "$RC" | wc -l)
if [ "0" == "$CNT" ] ; then
  exit 0 # do notnig
fi
"$PGACLEAN" -d "$ARCDIR" "$(echo -n "$RC"|tail -1)" |& \
    logger -i -t WALclear -pinfo
```

頭 3 つの環境変数は構成によって修正すること。

で、.backup ファイルは`pg_basebackup`を実行したときに出来るので、
バックアップをとらないと WAL アーカイブはどんどん増える。

参考: [25.3.2. ベースバックアップの作成](https://www.postgresql.jp/document/9.6/html/continuous-archiving.html#backup-base-backup)

[postgresql - pg_archivecleanup でファイルの保存期間または日付でクリーンアップを指定する方法](https://stackoverrun.com/ja/q/4609920)
↑ ちょこっとだけ bug がある

6 日より前のアーカイブ済みを消す例。

```sh
PG_ARCH=/usr/pgsql-9.5/bin/pg_archivecleanup
ARCHIVEDIR=.
find $ARCHIVEDIR -mtime +6 -name '*backup' -printf '%f\n' | sort -r | head -1 | xargs $PG_ARCH -d $ARCHIVEDIR
```

`*backup`は消えないので

```sh
find $ARCHIVEDIR -mtime +6 -name '*backup' | sort -r | tail -n +2 | xargs rm -v
```

こんな感じで

まとめると

```sh
#!/bin/bash -e
DAYS=6
ARCDIR=/home/heiwa/works/wala
PG_ARCH=/usr/pgsql-9.5/bin/pg_archivecleanup
LOGGER="logger -i -t WALclear -pinfo"
#
find $ARCDIR -mtime +$DAYS -name '*backup' -printf '%f\n' | sort -r | head -1 |\
    xargs -r $PG_ARCH -d $ARCDIR 2>&1 |\
    $LOGGER

find $ARCDIR -mtime +$DAYS -name '*backup' | sort -r | tail -n +2 |\
    xargs -r rm -v |\
    $LOGGER
```

これを`/etc/cron.daily/WALclear`に置く。変数はアレンジすること。

### .backup ファイルサンプル

```
$ cat data/pg_xlog/000000010000000000000005.00000020.backup
START WAL LOCATION: 0/5000020 (file 000000010000000000000005)
STOP WAL LOCATION: 0/50000A8 (file 000000010000000000000005)
CHECKPOINT LOCATION: 0/5000020
BACKUP METHOD: streamed
BACKUP FROM: master
START TIME: 2020-08-20 05:21:53 UTC
LABEL: pg_basebackup base backup
STOP TIME: 2020-08-20 05:21:57 UTC
```

なんか書いてから`pg_basebackup`すればよかったかな... あとでやりなおす。

## Slony-I でレプリケーション

なぜか客先が Slony-I を使っているので調査。(「スローニ」ロシア語で「象」)

- [Slony-I (トリガーによる行単位レプリケーションツール)](https://www.sraoss.co.jp/tech-blog/pgsql/slony-i/)
- [Slony-I の調査 | | 1Q77](https://blog.1q77.com/2018/12/what-is-slony-i/)
- [Slony-I - Wikipedia](https://ja.wikipedia.org/wiki/Slony-I)
- [Slony-I](https://www.slony.info/)
- [7 分で振り返る PostgreSQL レプリケーション機能の 10 年の歩み（NTT データ テクノロジーカンファレンス 2019 講演資料、201…](https://www.slideshare.net/nttdata-tech/postgresql-replication-10years-nttdata-fujii)
- [PostgreSQL レプリケーション 10 周年！徹底紹介！（PostgreSQL Conference Japan 2019 講演資料）](https://www.slideshare.net/nttdata-tech/postgresql-replication-10years-nttdata-fujii-masao)

なるほどいろいろ事情があるのだなあ。

Postgres 10 からは [論理レプリケーション(ロジカルレプリケーション)](https://www.postgresql.jp/document/10/html/logical-replication.html)
が使えるので Slony は減っていくと思われる。10 以上同士なら動く?

## スーパーユーザー権限のロールを作成

```sql
create role user1 with superuser login password 'SuperSecretPassword';
```

## RHEL 系で postgres ユーザのプロンプト

RHEL 系で
[PostgreSQL のレポジトリ](https://yum.postgresql.org/repopackages/)から
PostgreSQL をインストールすると
プロンプトが

```
$ sudo -iu postgres
-bash-4.2$ echo $PS1
\s-\v\$
```

で、ホスト名が出ない。普通の PS1([\u@\h \W]\$ )とかに変更する。

いろいろ方法はあろうけど

```sh
sudo -iu postgres
echo export PS1=\'[\\u@\\h \\W]\\$ \' >> .bash_profile
```

または

```sh
sudo -iu postgres
cp /etc/skel/.bashrc .
```

して、~postgres/.bash_profile の頭の方に

```sh
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
```

を入れるかで。

## 1 台のホストに 9.6,9.5,9.4

同時起動はしないけど RHEL 系 1 台に 3 つのバージョンが必要だったときのメモ。

[Repo RPMs - PostgreSQL YUM Repository](https://yum.postgresql.org/repopackages/)から。↑ 参照

```sh
yum-config-manager --enable pgdg94
yum install -y \
postgresql96 postgresql96-libs postgresql96-server postgresql96-contrib \
postgresql95 postgresql95-libs postgresql95-server postgresql95-contrib \
postgresql94 postgresql94-libs postgresql94-server postgresql94-contrib
systemctl disable --now postgresql-9.4 postgresql-9.5 postgresql-9.6
```

```
# sudo -iu postgres
[sudo] password for heiwa:
-bash-4.2$ echo $PGDATA
/var/lib/pgsql/9.4/data
```

最後にインストールしたやつのの PGDATA になってる。
~postgres/.bash_profile に記述があるので、よく使うやつに修正(PATH も追加)

各バージョンのバイナリは`/usr/pgsql-9.4/bin`にあるから、
`sudo -iu postgres`して手で PATH 追加していくことにする。

```
sudo -iu postgres
export PATH="/usr/pgsql-9.4/bin/:$PATH"
export PGDATA=/var/lib/pgsql/9.4/data
initdb
(略)
pg_ctl -D "$PGDATA" -l logfile start
psql
(略)
pg_ctl -D "$PGDATA" stop
```

これを 3 バージョンくりかえす。

## メタ情報

pg\_で始まる table はどの database でも一緒。

```sql
-- namespace(schema)一覧
select nspname from pg_namespace;
-- DB一覧。template1, template0は除くべき
select datname, datdba, encoding, datcollate, datctype from pg_database;
-- ロール一覧 \du
select rolname from pg_roles;
------ 以下database単位のもの
-- テーブル一覧
select schemaname, tablename from pg_tables;
---- (たとえばpostgres DB以外の)テーブル一覧
select schemaname, tablename, tableowner from pg_tables where pg_catalog not like 'pg_%';
-- インデックス一覧
select tablename, indexname FROM pg_indexes where indexname not like 'pg_%';
-- データ型
select n.nspname, t.typname
  from pg_type t, pg_namespace n
  where t.typnamespace = n.oid;

-- 関数一覧 \df
select n.nspname, p.proname
  from pg_proc p, pg_namespace n
  where p.pronamespace = n.oid;
-- トリガ関数一覧 トリガ関数にはnamespaceがない
select tgname from pg_trigger;
-- ストアドプロシージャ一覧
select proc.specific_schema as procedure_schema,
       proc.specific_name,
       proc.routine_name as procedure_name,
       proc.external_language,
       args.parameter_name,
       args.parameter_mode,
       args.data_type
from information_schema.routines proc
left join information_schema.parameters args
          on proc.specific_schema = args.specific_schema
          and proc.specific_name = args.specific_name
where proc.routine_schema not in ('pg_catalog', 'information_schema')
      and proc.routine_type = 'PROCEDURE'
order by procedure_schema,
         specific_name,
         procedure_name,
         args.ordinal_position;
-- view 一覧
select table_schema as schema_name,
       table_name as view_name
from information_schema.views
where table_schema not in ('information_schema', 'pg_catalog')
order by schema_name,
         view_name;
-- マテリアライズドビューー一覧
select schemaname as schema_name,
       matviewname as view_name,
       matviewowner as owner,
       ispopulated as is_populated,
       definition
from pg_matviews
order by schema_name,
         view_name;
-- シーケンス一覧 pg_sequencesは10ぐらいから?
SELECT n.nspname,c.relname
  FROM pg_class c, pg_namespace n
  WHERE c.relkind = 'S' and n.oid = c.relnamespace;
-- 照合順序一覧
SELECT n.nspname,c.collname
  FROM pg_collation c, pg_namespace n
  WHERE n.oid = c.collnamespace;
-- 外部テーブル \dE[S+] 他と構造が違う
select * from information_schema.foreign_tables;
-- 全文検索テンプレート (ちょっと他と変えてみた)
SELECT n.nspname||'.'||t.tmplname
  FROM pg_ts_template t, pg_namespace n
  WHERE n.oid = t.tmplnamespace
  ORDER BY n.nspname, t.tmplname;
-- 全文検索パーサー
SELECT n.nspname||'.'||t.prsname
  FROM pg_ts_parser t, pg_namespace n
  WHERE n.oid = t.prsnamespace
  ORDER BY n.nspname, t.prsname;
-- 全文検索設定
SELECT n.nspname||'.'||t.cfgname
  FROM pg_ts_config t, pg_namespace n
  WHERE n.oid = t.cfgnamespace
  ORDER BY n.nspname, t.cfgname;
-- 全文検索辞書
SELECT n.nspname||'.'||t.dictname
  FROM pg_ts_dict t, pg_namespace n
  WHERE n.oid = t.dictnamespace
  ORDER BY n.nspname, t.dictname;
```

別 DB のテーブルの参照はいちおう出来ないことになっている。
(DBLINK や Foreign Data Wrapper を使う)

テーブル名は スキーマ名.テーブル名で。スキーマ名 public は省略できる。
例:

```sql
select * from information_schema.sql_languages;
```

## docker で postgres

./data に DB を永続化する例。

```sh
#!/bin/sh -e
DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
PGDATA=$DIR/data
PASSWD=kawaiikoneko
ID=pg
CUID=`id -u`
CGID=`id -g`

mkdir -p "$PGDATA"
docker run --name "$ID" -d \
  -u $CUID:$CGID \
  -e POSTGRES_PASSWORD=$PASSWD \
  -p 5432:5432 \
  -v $PGDATA:/var/lib/postgresql/data \
  postgres
```

テスト

```sh
docker logs pg
psql -h 127.0.0.1 -U postgres
```

終了

```sh
docker stop pg
docker rm pg
```

参考:

- [postgres - Docker Hub](https://hub.docker.com/_/postgres)

## systemd で起動される postgres の PGDATA を変更する

postgres\*.service ファイルを直接変更しちゃダメ。

(以下の例は RHEL 系の postgres のレポジトリからインストールした 9.5 のもの。
Debian,Ubuntu では微妙に違うかも)

```
sudo systemctl edit postgresql-9.5
```

して

```
[Service]
# Override location of database directory
Environment=PGDATA=/data
```

する。(/data のところは書き換える)

/data のパーミッションは

```
sudo mkdir -p /data -m 0700
sudo chown postgres:postgres /data
```

あと~postgres の.profile や.bash_profile で PGDATA を設定しているなら
それも書き換えたほうが生活が楽。
PATH も

```
export PATH="/usr/pgsql-9.5/bin/:$PATH"
```

など。

## public スキーマー

```text
ERROR:  permission denied for schema public
```

が出たら

[PostgreSQL 15 では public スキーマへの書き込みが制限されます | DevelopersIO](https://dev.classmethod.jp/articles/postgresql-15-revoke-create-on-public-schema/)
127.0.0.1:

## 特定のロールの grant を表示する

```sql
SELECT
  rolname AS role_name,
  datname AS database_name,
  HAS_DATABASE_PRIVILEGE(rolname, datname, 'CONNECT') AS has_connect_privilege,
  HAS_DATABASE_PRIVILEGE(rolname, datname, 'CREATE') AS has_create_privilege,
  HAS_DATABASE_PRIVILEGE(rolname, datname, 'TEMP') AS has_temp_privilege,
  HAS_DATABASE_PRIVILEGE(rolname, datname, 'TEMPORARY') AS has_temporary_privilege
FROM
  pg_roles CROSS JOIN pg_database
WHERE
  rolname = 'heiwa';
```
