logrotateのメモ

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