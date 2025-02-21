# find のメモ

## `-prune`

こんな感じで使うと

```sh
find . -type d -name node_modules -prune
```

`.../node_modules/foo` などが出力されなくなる。
