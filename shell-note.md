- [非0の戻り値で中断させたい](#非0の戻り値で中断させたい)
- [ファイルの差集合](#ファイルの差集合)
- ['-'で始まる引数](#-で始まる引数)

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


# ファイルの差集合

sortedな2つのテキストファイルa,bの差集合などを求める。差集合はちょっとすぐ出てこないのでメモ


論理和(OR)
```
cat a b | sort | uniq
```

論理積(AND)
```
cat a b | sort | uniq -d
```

排他的論理和(XOR)
```
cat a b | sort | uniq -u
```

差集合(A-B)
```
(cat a b | sort -u; cat b) | sort | uniq -u
```
a・bの和集合とbの排他的論理和

もう１つはcomm(compare two sorted files line by line)コマンドを使う方法
```
comm -23 a b
```
aにだけあるものが1列目、bにだけあるものが2列目、ab両方にあるのが3列目、として
「表示させない列」をオプションで指定する。


出典:
* [uniqコマンドを使って、論理和・論理積・排他的論理和・差集合を得る方法 - くんすとの備忘録](https://kunst1080.hatenablog.com/entry/2015/01/25/011158)
* [bash, Linux: Set difference between two text files - Stack Overflow](https://stackoverflow.com/questions/2509533/bash-linux-set-difference-between-two-text-files)
* [Man page of COMM](https://linuxjm.osdn.jp/html/GNU_coreutils/man1/comm.1.html)


# '-'で始まる引数

`--`(no more option)を使う。

[linux - How to cd into a directory with this name "-2" (starting with the hyphen)? - Server Fault](https://serverfault.com/questions/462739/how-to-cd-into-a-directory-with-this-name-2-starting-with-the-hyphen)

例:
``` bash
# systemctl list-dependencies --after -- -.mount
-.mount
* `-system.slice
```