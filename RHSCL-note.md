# PHP7.3

RHSCL の PHP7.3 は PHP 本家がサポート終わったあとでも 2024 年 6 月まで Red Hat がサポートする。

[Red Hat Enterprise Linux 7 の Red Hat Software Collections 製品ライフサイクル - Red Hat Customer Portal](https://access.redhat.com/ja/node/4654951)

ただし、mod_php じゃなくて http24 の.so になる()。Red Hat 的には php-fpm を使うのを勧めている。
[How to configure Apache httpd to use PHP from RHSCL - Red Hat Customer Portal](https://access.redhat.com/solutions/2662201)

rh-php73-php パッケージの
`/opt/rh/httpd24/root/usr/lib64/httpd/modules/librh-php73-php7.so`

で、rh-php73-php パッケージは RHSCL の httpd24-httpd パッケージに依存している。

もし RH の http パッケージを使ってるなら、かなり修正が必要かも。(だから RH も FPM 版を勧めてる)

あと
composer を使う場合

[http://blog.derakkilgo.com/2019/05/29/using-php-composer-with-redhat-software-collections/ php composer with RedHat Software Collections | I sketch in code]

こんなラッパーが必要

```sh
#! /bin/bash

#choose which scl package we want to use.
source scl_source enable rh-php73

#pass all shell args to composer.
php /opt/php-composer/composer.phar "$@"
```
