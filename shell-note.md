# 非0の戻り値で中断させたい

`set -e`を使う。if文でチェックするよりずっと楽。
`set +e`で戻せる。

```
#!/bin/sh

echo "test 1"
(
  set -x
  true ; echo $?
  true ; echo $?
  false ; echo $?
  true ; echo $?
)

echo "test 2 (set -e)"
(
  set -x
  set -e
  true ; echo $?
  true ; echo $?
  false ; echo $?
  true ; echo $?
)
```

参考:
* [シェルスクリプトを書くときはset -euしておく](https://qiita.com/youcune/items/fcfb4ad3d7c1edf9dc96)
* [シェルスクリプトの set -e は罠いっぱい](https://togetter.com/li/1104655)

