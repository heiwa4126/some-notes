Red Hat系メモ

# インストール済みパッケージ一覧

複数のホストで同じパッケージにしたいときなど。

yum-utilsパッケージで
```
repoquery -a --installed
```

`rpm -qa`だと、バージョン名が入って、そのままyumで使えない。

`yum list installed`だと長いパッケージ名を勝手に折り返す。
[yum listの出力を折り返さない - (っ´∀｀)っ ゃー | 一撃](https://nullpopopo.blogcube.info/2015/05/yumlist-sed.html)
```
$ yum list | sed -e "s/[[:space:]]\+/\t/g" | sed -e ':loop; N; $!b loop; ;s/\n[[:space:]]/\t/g'
```

のような方法もあるが、覚えられない。