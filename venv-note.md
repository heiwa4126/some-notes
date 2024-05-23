# python の venv メモ

いろいろあるけど、「最初から入ってる」ってことでまだまだ使う機会は多そう。

- [venv --- Creation of virtual environments](https://docs.python.org/ja/3/library/venv.html)

## symlinks オプションでディスクと時間の節約

```sh
python3 -m venv .venv --symlinks
```

こんな感じ ↓ になる。元の Python にセキュリティ更新があった時でも安心。

```console
$ LANG=C find .venv -type l -ls
   347780      0 lrwxrwxrwx   1 user1    user1           7 May 23 10:24 .venv/bin/python -> python3
   347779      0 lrwxrwxrwx   1 user1    user1          16 May 23 10:24 .venv/bin/python3 -> /usr/bin/python3
   347781      0 lrwxrwxrwx   1 user1    user1           7 May 23 10:24 .venv/bin/python3.10 -> python3
   347776      0 lrwxrwxrwx   1 user1    user1           3 May 23 10:24 .venv/lib64 -> lib
```
