# logrotateのメモ

- [logrotateのメモ](#logrotateのメモ)
- [logrotateをすぐさま実行](#logrotateをすぐさま実行)
- [logoroteのログなど](#logoroteのログなど)
- [参考](#参考)
- [gz以外の圧縮を使う](#gz以外の圧縮を使う)


# logrotateをすぐさま実行

configファイルのdebugするときなど。

```
logrotate -f /etc/logrotate.conf
```

-dオプション,-vオプションも便利 (debug(dry-run) & verbose)
```
logrotate -dv /etc/logrotate.conf 2>&1 | less
```
して、じっくり眺める。

# logoroteのログなど

statusファイル。logorotateが実行された時間がわかる(時間は大概UTCなので注意)。


RedHat系
```
less /var/lib/logrotate/logrotate.status
```

Debian/Ubuntu系
```
less /var/lib/logrotate/status
```

# 参考

* [Linuxのlogrotateを手動実行させる | 俺的備忘録 〜なんかいろいろ〜](https://orebibou.com/2015/08/linux%E3%81%AElogrotate%E3%82%92%E6%89%8B%E5%8B%95%E5%AE%9F%E8%A1%8C%E3%81%95%E3%81%9B%E3%82%8B/)
* [logrotate（ログローテート）の動作確認 | OpenGroove](https://open-groove.net/linux/logrotate-test/)

# gz以外の圧縮を使う

bzip2を使う例: [Maximum Logrotate Compression with bzip2](http://danielsokolowski.blogspot.com/2012/09/maximum-logrotate-compression-with-bzip2.html)

`/etc/logrotate.conf` に記述
```
# use bzip2 whith higher compression than gzip
compresscmd /bin/bzip2
uncompresscmd /bin/bunzip2
compressoptions -9
compressext .bz2
```

xzなら
```
# use xz whith higher compression than gzip
compresscmd /usr/bin/xz
uncompresscmd /usr/bin/unxz
compressoptions -9
compressext .xz
```

zstdを使いたいところだがlessが対応していないのが辛い(結構使うから)。

参照: [Shirouzu Hiroaki（白水啓章）さんのツイート: "logrotate.conf に下記を足して、ログの圧縮をgzipからzstdに変更。 ---- compresscmd /usr/bin/zstd uncompresscmd /usr/bin/zstd compressext .zst"](https://twitter.com/shirouzu/status/1045588414051962880)

zstdはgzip並か、それ以上の圧縮率を、高速・低メモリで行えるので、lessで対応してほしい。