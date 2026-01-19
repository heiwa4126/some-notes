# remi

```
yum install https://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php72
```

# ubuntuでnginxと

Ubuntu 18.04LTS で

```sh
sudo apt install nginx php-fpm -y
```

- php-fpm の設定ファイル - `/etc/php/7.2/fpm/pool.d/www.conf`
- php-fpm の PHP 設定ファイル - `/etc/php/7.2/fpm/php.ini`と`/etc/php/7.2/fpm/conf.d/*`

なにも変更しなくとも動く。

`/etc/php/7.2/fpm/php.ini`は
`/usr/lib/php/7.2/php.ini-production`のコピー。適宜 develop のほうに変更するなりなんなりする。

/etc/nginx/php.conf に
nginx <-> PHP の設定ファイルを置く。

```
location ~ \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    include fastcgi_params;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_intercept_errors on;
    fastcgi_pass unix:/run/php/php7.2-fpm.sock;
}
```

\*.php のファイルを全部 php-fpm で処理する設定。

で、これを
/etc/nginx/sites-available/\*
で `include php.conf;` する。

HTTP と HTTPS の 2 つ分あるかもなので include にした。

できたら

```
nginx -t
```

でシンタックスチェック。OK なら reload か restart

```sh
systemctl reload nginx
# or
systemctl restart nginx
```

インストールしたままの設定なら document root は`/var/www/html`なので
`/var/www/html/index.php`におなじみの

```php
<?php
phpinfo();
?>
```

を書いて、
`curl 127.0.0.1/index.php`
でテストする。

サービス名が`php7.2-fpm.service`なのがちょっとイヤ。

参考:
[Module ngx_http_fastcgi_module](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
