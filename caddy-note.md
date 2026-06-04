# Caddy のメモ

[Let's EncryptでHTTPSを終端させたいだけならNginxよりCaddyを使うと楽だった件 \#Go \- Qiita](https://qiita.com/ssc-ksaitou/items/ee0cda84dcf358a2b5eb)
読んで使ってみようと思った。

- ACME の HTTP-01 チャレンジに内部で対応してる
- 80/tcp は普段は使わなくてもいい。renewal のときに勝手に上がる(FW はあけとく)

などが便利そう。あと Golang なのも

- [caddyserver/caddy: Fast and extensible multi\-platform HTTP/1\-2\-3 web server with automatic HTTPS](https://github.com/caddyserver/caddy)
- [Caddy \- The Ultimate Server with Automatic HTTPS](https://caddyserver.com/)

## install

- [Install — Caddy Documentation](https://caddyserver.com/docs/install)

Ubuntu 24.04 には最初から入ってるけど、2026-06 現在 GitHub 上では v2.11 系。

```console
$ LANG=C apt search caddy
Sorting... Done
Full Text Search... Done
caddy/noble-updates,noble-security 2.6.2-6ubuntu0.24.04.3 amd64
  Fast, lightweight web server with automatic HTTPS
```

<https://caddyserver.com/docs/install#debian-ubuntu-raspbian>

```console
$ LANG=C apt search caddy
Sorting... Done
Full Text Search... Done
caddy/any-version 2.11.4 amd64
  Caddy - Powerful, enterprise-ready, open source web server with automatic HTTPS written in Go
```

## Caddyfile のバリデート

`caddy validate`

Caddyfile のフォーマッターの `Caddy fmt` もある。

## Caddyfile のリロード

`systemctl restart caddy` は当然ながら

`caddy reload` でできる。
`systemctl reload caddy` もできればできる。

## 現在の設定を見る

API を使う
`curl localhost:2019/config/`

caddy reload / caddy adapt 後の最終形がJSON形式で帰る

[GET /config/\[path\]](https://caddyserver.com/docs/api#get-configpath)

## BASIC 認証

`caddy hash-password` でハッシュを生成して
Caddyfile に書く

https://caddyserver.com/docs/caddyfile/directives/basic_auth

## TLS/SSL化

Caddyfile に

```conf
example.com {
    root * /var/www/html
    file_server
}
```

こんなの書くだけ。

証明書の更新期間を設定する方法はない(ハードコーディングされている)。
証明書期限切れの30日前から更新を初めて
チェック間隔は
[renew_interval](https://caddyserver.com/docs/caddyfile/options#renew-interval)
で指定できる。デフォルト10m

## ログ

システムログっぽいのは `journalctl -f -u caddy` で (systemd で起動してる場合)

アクセスログは標準では出ない。
https://caddyserver.com/docs/caddyfile/options#log

例:

```conf
    log {
        output file /var/log/caddy/access.log
        format console
    }
```

`open /var/log/caddy/access.log: permission denied`
が出るときは

```console
# id caddy
uid=999(caddy) gid=988(caddy) groups=988(caddy),33(www-data)
```

なので、www-data で行くとして

```sh
chown root:www-data /var/log/caddy
chmod 775 /var/log/caddy
# もうファイルができてたら
chown root:www-data /var/log/caddy/access.log
chmod 664 /var/log/caddy/access.log
```

log ローテートは自前で出来る
https://caddyserver.com/docs/caddyfile/directives/log#output-modules

例:

```conf
example.com {
    log {
        output file /var/log/caddy/access.log {
            roll_size 10MiB
            roll_keep 10
            roll_keep_for 336h
        }
    }
}
```

ただ過去ログの compress はないので、それは logrotate で

## コンテンツにヘッダを

HTML全部に 'Content-Type "text/html; charset=Shift_JIS"' をつける例

```conf
example.com {
    root * /var/www/html
    file_server

    @html {
        path *.html *.htm /
    }

    # ダメな例
    header @html Content-Type "text/html; charset=Shift_JIS"
    # defer
    header @html >Content-Type "text/html; charset=Shift_JIS"
}
```

Caddy の header には defer 機能があり、> プレフィックスで「最後に書く」動作にできる

https://caddyserver.com/docs/caddyfile/directives/header

## caddyfile には include はある? もしくは1つの設定をほかでも使うことはできる?

ある。**`import`**。Caddyfileの擬似`include`。ファイル取り込みも、再利用スニペット呼び出しもこれ1つ。

`import` は **構文解析前** に展開され、Caddyfileのどこにでも置ける。
[\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import), [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/concepts)

### 1. ファイルを include したい

```conf
import sites-enabled/*
```

- `*` のグロブ可。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)
- パスは **`import` を書いたファイル基準の相対パス**。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import), [\[gediminasz.github.io\]](https://gediminasz.github.io/caddy-v1-docs/docs/import)
- 特定ファイル見つからない → エラー。空グロブはエラーでない。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)

### 2. 1つの設定を他でも使いたい

**スニペット**使う。`(name) { ... }` で定義、`import name` で展開。Caddyfile Concepts でも reusable snippet として説明。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/concepts), [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)

```conf
(common-log) {
    log {
        output file /var/log/caddy/access.log
    }
}

example.com {
    import common-log
    file_server
}

www.example.com {
    import common-log
    reverse_proxy localhost:8080
}
```

### 3. 引数付き再利用もできる

`import snippet arg1 arg2 ...` で、スニペット内から `{args[...]}` 参照可。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)

```conf
(cors) {
    @origin header Origin {args[0]}
    header @origin Access-Control-Allow-Origin "{args[0]}"
}

example.com {
    import cors https://app.example.com
}
```

- 単一: `{args[0]}`
- 全部: `{args[:]}`
- 範囲: `{args[n:m]}` など。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)

### 4. 別ファイル内スニペットを使える?

**使える**。`import` が先に全部展開され、その後スニペットがロードされるから、どのファイルに書いたか実質関係ない。Caddy Community でもメンテナがそう説明。 [\[caddy.community\]](https://caddy.community/t/importing-snippets-from-different-files/25139), [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)

典型形:

```conf
# Caddyfile
import snippets/*
import sites-enabled/*
```

`snippets/common.caddy`:

```conf
(security) {
    header {
        X-Content-Type-Options nosniff
        X-Frame-Options SAMEORIGIN
    }
}
```

`sites-enabled/example.com.caddy`:

```conf
example.com {
    import security
    file_server
}
```

### 5. 注意

Caddyfile は **site block間で自動継承しない**。共通化したいなら `import snippet` で明示再利用。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/concepts)

### 結論

- include 相当 → **`import file-or-glob`**。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import), [\[gediminasz.github.io\]](https://gediminasz.github.io/caddy-v1-docs/docs/import)
- 共通設定再利用 → **スニペット + `import snippet`**。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/concepts), [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)
- 引数付きテンプレ化も可。 [\[caddyserver.com\]](https://caddyserver.com/docs/caddyfile/directives/import)
