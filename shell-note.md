shellいろいろtipsメモ

- [非0の戻り値で中断させたい](#非0の戻り値で中断させたい)
- [ファイルの差集合](#ファイルの差集合)
- ['-'で始まる引数](#-で始まる引数)
- [特定PIDのプロセスの下をツリー表示](#特定pidのプロセスの下をツリー表示)
- [dh -h は GiBかGBか](#dh--h-は-gibかgbか)
- [バージョン番号をソートする](#バージョン番号をソートする)
- [dateのformat](#dateのformat)
- [$UID,$GID](#uidgid)
- [bashのpipefailオプション](#bashのpipefailオプション)

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


# 特定PIDのプロセスの下をツリー表示

特定のプロセスが何故か定期的に死ぬので、定期的にpgrepで取って、
子プロセスのツリーをstdoutするスクリプトを書いたときに使ったコード

```sh
pid=$(pgrep -f `*******`)
if [ "$pid" == "" ] ; then
  echo "NO PROCESS"
else
  ps --forest $(ps -e --no-header -o pid,ppid|awk -vp=$pid 'function r(s){print s;s=a[s];while(s){sub(",","",s);t=s;sub(",.*","",t);sub("[0-9]+","",s);r(t)}}{a[$2]=a[$2]","$1}END{r(p)}')
fi
```

出処: [linux - ps: How can i recursively get all child process for a given pid - Super User](https://superuser.com/questions/363169/ps-how-can-i-recursively-get-all-child-process-for-a-given-pid)


# dh -h は GiBかGBか

- `-h`オプションで2進数なのでGiB(2^30 byte)
- `-H`オプションでSI単位。GB(10^9 byte)

慣用としては`GiB`の意味で`GB`が使われることが多いので、困ったもんだ。


# バージョン番号をソートする

これは知らなかった。
```sh
sort -V
# or
sort --version-sort
```

- [バージョン番号のソート](https://rcmdnk.com/blog/2020/09/25/computer-linux-mac/)
- [sort(1) - Linux manual page](https://man7.org/linux/man-pages/man1/sort.1.html)


# dateのformat

よくバックアップ用に日付つきにする時に使うフォーマット。
```
cp -a foo.bar foo.bar.`date +%Y-%m-%d-%H-%M-%S`
```

# $UID,$GID

$UIDはbashのInternal Variables.

- [Bash Variables (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html)
- [Internal Variables](https://tldp.org/LDP/abs/html/internalvariables.html)

で、GIDはない。なので汎用でUID/GIDの値をとりたかったら

```sh
UID2=`id -u`
GID=`id -g`
```
みたいにする。UID2になってるのは以下のようなエラーになるから

```
$ UID=101
-bash: UID: readonly variable
```

# bashのpipefailオプション

- [bashのpipefailオプション - 技術メモのかけら](https://eichisanden.hateblo.jp/entry/2018/01/23/112255)
- [サブシェルやパイプラインの途中で失敗した場合に直ちにエラーコードを返すようにする - Qiita](https://qiita.com/billthelizard/items/224e36ad183bd389831c)
- [Pipelines (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html)
- [The Set Builtin (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

bashの直感を裏切る動作の1つとして、
「パイプの左側でエラーが起きても右側が実行される」
というのがある。

スクリプトになんかエラーがあったら止まる、にしたかったら
`set -e`
ではなく
`set -eo pipeline`
にするがよいです。

```
grep 'foo' bar.txt | sort
```
とかでfooがbar.txtにない場合でも死ぬようになります。