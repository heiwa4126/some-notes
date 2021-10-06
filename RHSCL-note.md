# PHP7.3

RHSCLのPHP7.3はPHP本家がサポート終わったあとでも2024年6月までRed Hatがサポートする。

[Red Hat Enterprise Linux 7 の Red Hat Software Collections 製品ライフサイクル - Red Hat Customer Portal](https://access.redhat.com/ja/node/4654951)


ただし、mod_phpじゃなくてhttp24の.soになる()。Red Hat的にはphp-fpmを使うのを勧めている。
[How to configure Apache httpd to use PHP from RHSCL - Red Hat Customer Portal](https://access.redhat.com/solutions/2662201)

rh-php73-phpパッケージの
`/opt/rh/httpd24/root/usr/lib64/httpd/modules/librh-php73-php7.so`

で、rh-php73-phpパッケージはRHSCLのhttpd24-httpdパッケージに依存している。

もしRHのhttpパッケージを使ってるなら、かなり修正が必要かも。(だからRHもFPM版を勧めてる)

あと
composerを使う場合

[http://blog.derakkilgo.com/2019/05/29/using-php-composer-with-redhat-software-collections/ php composer with RedHat Software Collections | I sketch in code]

こんなラッパーが必要
```sh
#! /bin/bash

#choose which scl package we want to use.
source scl_source enable rh-php73

#pass all shell args to composer.
php /opt/php-composer/composer.phar "$@"
```