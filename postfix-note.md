# header_checksのメモ

- [Postfix manual \- header_checks\(5\)](http://www.postfix.org/header_checks.5.html)

けっこういろんなとこでフックできるみたい。 regex も pcre も使えるのはえらい

デバッグは

- [Postfix manual \- pcre_table\(5\)](http://www.postfix.org/pcre_table.5.html)
- [Postfix manual \- regexp_table\(5\)](http://www.postfix.org/regexp_table.5.html)

みたいにやる。

ちょっと古い和訳:

- [Postfix manual - postmap(1)](http://www.postfix-jp.info/trans-2.2/jhtml/postmap.1.html)
- [Postfix manual - pcre_table(5)](http://www.postfix-jp.info/trans-2.2/jhtml/pcre_table.5.html)

```
# postmap pcre:/etc/postfix/header_checks1
postmap: fatal: unsupported dictionary type: pcre. Is the postfix-pcre package installed?

# apt install postfix-pcre
...

# postmap pcre:/etc/postfix/header_checks1
postmap: fatal: unsupported dictionary type: pcre does not support bulk-mode creation.
```

postmap でいっぺんに変換はできないらしい。元ファイル編集後は対応する.db を消しておくといいかな。
(この場合 `rm /etc/postfix/header_checks1.db`)

↑これ header_checks1 変更して、postfix 再起動しない、をやってみたんですが、平気で変更が反映されました。
.db 消す必要あるのかな。要調査。

/etc/postfix/main.cf を編集。最後に↓を追加

```
header_checks = pcre:/etc/postfix/header_checks1
```

/etc/postfix/header_checks1 は

```
/^Subject: (.*)/
     replace Subject: [test] $1
```

で、main.cf の変更を反映させるために`systemctl restart postfix`

テストは

```
$ postmap -q 'Subject: test' pcre:/etc/postfix/header_checks1
replace Subject: [test] test
```

と mail コマンドでローカル配送と outbound (gmail つかってみた。最近の Gmail は sendgrid とか通さなくてもおくれるみたい)
