# MySQLメモ

# RHELでMySQL

MySQLレポジトリからではなくRHELのSCLから入れてみる。

[Red Hat Enterprise Linux 7 で MariaDB をアンインストールし、MySQL をインストールする - Red Hat Customer Portal](https://access.redhat.com/ja/solutions/1549463)

```sh
yum repolist all | grep rhscl
subscription-manager repos --enable=rhel-server-rhscl-7-rpms
export PATH=$PATH:/opt/rh/mysql55/root/usr/bin/
# ↑`.bashprofileや/etc/profile.d/mysql-rscl.shなどに追加
systemctl enable mysql55-mysqld.service --now
```

テスト
```
# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.5.52 MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> select version();
+-----------+
| version() |
+-----------+
| 5.5.52    |
+-----------+
1 row in set (0.00 sec)

mysql> \q
Bye
```