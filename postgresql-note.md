- [PostgreSQLのサンプルデータ](#postgresqlのサンプルデータ)

# PostgreSQLのサンプルデータ

PostgreSQL Tutorialに適当なサンプルがある。

* [[PostgreSQL] サンプルのデータベースを用意する ｜ DevelopersIO](https://dev.classmethod.jp/etc/postgresql-create-sample-database/)
* [PostgreSQL Sample Database](http://www.postgresqltutorial.com/postgresql-sample-database/)

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
