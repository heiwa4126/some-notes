- [PostgreSQLのサンプルデータ](#postgresql%e3%81%ae%e3%82%b5%e3%83%b3%e3%83%97%e3%83%ab%e3%83%87%e3%83%bc%e3%82%bf)
- [PostgreSQLのlibパスは?](#postgresql%e3%81%aelib%e3%83%91%e3%82%b9%e3%81%af)
- [valuntilがNULLの時](#valuntil%e3%81%8cnull%e3%81%ae%e6%99%82)
- [PostgreSQLの認証問題](#postgresql%e3%81%ae%e8%aa%8d%e8%a8%bc%e5%95%8f%e9%a1%8c)

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