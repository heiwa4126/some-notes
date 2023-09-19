# Linuxのドライバ関係

# ドライバとバージョンの列挙

`/sys/module/ドライバ名/version`がバージョンなので

```sh
find /sys/module -name version | sort | xargs -n1 -i{} sh -c 'echo {};cat {}'
```

で列挙できる。
