# shell いろいろ tips メモ

- [shell いろいろ tips メモ](#shell-いろいろ-tips-メモ)
  - [非 0 の戻り値で中断させたい](#非-0-の戻り値で中断させたい)
  - [ファイルの差集合](#ファイルの差集合)
  - ['-'で始まる引数](#-で始まる引数)
  - [特定 PID のプロセスの下をツリー表示](#特定-pid-のプロセスの下をツリー表示)
  - [dh -h は GiB か GB か](#dh--h-は-gib-か-gb-か)
  - [バージョン番号をソートする](#バージョン番号をソートする)
  - [date の format](#date-の-format)
  - [$UID,$GID](#uidgid)
  - [bash の pipefail オプション](#bash-の-pipefail-オプション)
  - [exit code の標準](#exit-code-の標準)
  - [/dev/null](#devnull)
  - [shell-quote](#shell-quote)
  - [df の出力を json で](#df-の出力を-json-で)
  - [shfmt - shell スクリプトのフォーマッター](#shfmt---shell-スクリプトのフォーマッター)
  - [shellcheck](#shellcheck)
    - [SC2155 の直し方](#sc2155-の直し方)
      - [Problematic code in the case of `export`:](#problematic-code-in-the-case-of-export)
        - [Correct code:](#correct-code)
  - [メモ](#メモ)
  - [壊れた symlink をみつける](#壊れた-symlink-をみつける)
  - [shell で絶対パス](#shell-で絶対パス)
  - [PATH で重複を除去する](#path-で重複を除去する)

## 非 0 の戻り値で中断させたい

`set -e`を使う。if 文でチェックするよりずっと楽。
`set +e`で戻せる。

```sh
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

- [シェルスクリプトを書くときは set -eu しておく](https://qiita.com/youcune/items/fcfb4ad3d7c1edf9dc96)
- [シェルスクリプトの set -e は罠いっぱい](https://togetter.com/li/1104655)

## ファイルの差集合

sorted な 2 つのテキストファイル a,b の差集合などを求める。差集合はちょっとすぐ出てこないのでメモ

論理和(OR)

```sh
cat a b | sort | uniq
```

論理積(AND)

```sh
cat a b | sort | uniq -d
```

排他的論理和(XOR)

```sh
cat a b | sort | uniq -u
```

差集合(A-B)

```sh
(cat a b | sort -u; cat b) | sort | uniq -u
```

a・b の和集合と b の排他的論理和

もう 1 つは comm(compare two sorted files line by line)コマンドを使う方法

```sh
comm -23 a b
```

a にだけあるものが 1 列目、b にだけあるものが 2 列目、ab 両方にあるのが 3 列目、として
「表示させない列」をオプションで指定する。

出典:

- [uniq コマンドを使って、論理和・論理積・排他的論理和・差集合を得る方法 - くんすとの備忘録](https://kunst1080.hatenablog.com/entry/2015/01/25/011158)
- [bash, Linux: Set difference between two text files - Stack Overflow](https://stackoverflow.com/questions/2509533/bash-linux-set-difference-between-two-text-files)
- [Man page of COMM](https://linuxjm.osdn.jp/html/GNU_coreutils/man1/comm.1.html)

## '-'で始まる引数

`--`(no more option)を使う。

[linux - How to cd into a directory with this name "-2" (starting with the hyphen)? - Server Fault](https://serverfault.com/questions/462739/how-to-cd-into-a-directory-with-this-name-2-starting-with-the-hyphen)

例:

```bash
## systemctl list-dependencies --after -- -.mount
-.mount
* `-system.slice
```

## 特定 PID のプロセスの下をツリー表示

特定のプロセスが何故か定期的に死ぬので、定期的に pgrep で取って、
子プロセスのツリーを stdout するスクリプトを書いたときに使ったコード

```sh
pid=$(pgrep -f `*******`)
if [ "$pid" == "" ] ; then
  echo "NO PROCESS"
else
  ps --forest $(ps -e --no-header -o pid,ppid|awk -vp=$pid 'function r(s){print s;s=a[s];while(s){sub(",","",s);t=s;sub(",.*","",t);sub("[0-9]+","",s);r(t)}}{a[$2]=a[$2]","$1}END{r(p)}')
fi
```

出処: [linux - ps: How can i recursively get all child process for a given pid - Super User](https://superuser.com/questions/363169/ps-how-can-i-recursively-get-all-child-process-for-a-given-pid)

## dh -h は GiB か GB か

- `-h`オプションで 2 進数なので GiB(2^30 byte)
- `-H`オプションで SI 単位。GB(10^9 byte)

慣用としては`GiB`の意味で`GB`が使われることが多いので、困ったもんだ。

## バージョン番号をソートする

これは知らなかった。

```sh
sort -V
## or
sort --version-sort
```

- [バージョン番号のソート](https://rcmdnk.com/blog/2020/09/25/computer-linux-mac/)
- [sort(1) - Linux manual page](https://man7.org/linux/man-pages/man1/sort.1.html)

## date の format

よくバックアップ用に日付つきにする時に使うフォーマット。

```sh
cp -a foo.bar foo.bar.`date +%Y-%m-%d-%H-%M-%S`
```

## $UID,$GID

$UID は bash の Internal Variables.

- [Bash Variables (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html)
- [Internal Variables](https://tldp.org/LDP/abs/html/internalvariables.html)

で、GID はない。なので汎用で UID/GID の値をとりたかったら

```sh
UID2=`id -u`
GID=`id -g`
```

みたいにする。UID2 になってるのは以下のようなエラーになるから

```terminal
$ UID=101
-bash: UID: readonly variable
```

## bash の pipefail オプション

- [bash の pipefail オプション - 技術メモのかけら](https://eichisanden.hateblo.jp/entry/2018/01/23/112255)
- [サブシェルやパイプラインの途中で失敗した場合に直ちにエラーコードを返すようにする - Qiita](https://qiita.com/billthelizard/items/224e36ad183bd389831c)
- [Pipelines (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html)
- [The Set Builtin (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

bash の直感を裏切る動作の 1 つとして、
「パイプの左側でエラーが起きても右側が実行される」
というのがある。

スクリプトになんかエラーがあったら止まる、にしたかったら
`set -e`
ではなく
`set -eo pipefail`
にするがよいです。

```sh
grep 'foo' bar.txt | sort
```

とかで foo が bar.txt にない場合でも死ぬようになります。

[パイプラインの左側でエラーが発生したら処理を止めたい \- はい!今やってます!](https://yuji-ueda.hatenadiary.jp/entry/2019/11/15/180743)

## exit code の標準

exit code は以下の標準を使いましょう。

- [Exit Codes With Special Meanings](http://tldp.org/LDP/abs/html/exitcodes.html)
- POSIX 標準 - [https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h](https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h)

## /dev/null

test1.sh

```sh
##!/bin/sh -ue
echo stdout
echo stderr 1>&2
```

で、

```sh
## stdout/stderrともサプレス
./test1.sh &> /dev/null
## stderrのみ表示
./test1.sh > /dev/null
## stdoutのみ表示
./test1.sh 2> /dev/null
```

詳しくは:

- [Redirections (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)
- [Bash - Redirections - コマンドが実行される前に、シェルによって解釈される特別な表記法を使用して、その入力と出力を redirected できます。リダイレクトにより、コマンドのファイ - 日本語](https://runebook.dev/ja/docs/bash/redirections#Redirections)

Windows でもできるみたいよ。
[bat ファイルでコマンドの実行結果を出力しないようにする方法 \- Qiita](https://qiita.com/uhooi/items/b8b25761a5c4efe9025a)

## shell-quote

シェルのエスケープ処理はややこしくて、2 段階以上になるともう人間の手には負えない。
そこでなにかクォートしてくれるユーティリティをかますとご安全。

いくつかあるけど Ubuntu のパッケージ(libstring-shellquote-perl)にもある
[shell\-quote \- quote arguments for safe use, unmodified in a shell command \- metacpan\.org](https://metacpan.org/dist/String-ShellQuote/view/shell-quote)
など。

サンプルは

```sh
ssh host touch 'hi there'           # fails
```

これだと意外なことに hi と there の 2 つファイルができてしまう。
そこで

```sh
cmd=`shell-quote touch 'hi there'`
ssh host "$cmd"
```

とするとちゃんと`hi there`ができます。

## df の出力を json で

[bash - Store output diskspace df -h JSON - Stack Overflow](https://stackoverflow.com/questions/35211716/store-output-diskspace-df-h-json)

このワンライナーがいい感じ

```sh
df -Ph | awk '/^\// {print $1"\t"$2"\t"$4}' | python -c 'import json, fileinput; print json.dumps({"diskarray":[dict(zip(("mount", "spacetotal", "spaceavail"), l.split())) for l in fileinput.input()]}, indent=2)'
```

## shfmt - shell スクリプトのフォーマッター

- [mvdan/sh: A shell parser, formatter, and interpreter (sh/bash/mksh), including shfmt](https://github.com/mvdan/sh#shfmt)
- [シェルスクリプトのコードを整形してくれるツール `shfmt` | ゲンゾウ用ポストイット](https://genzouw.com/entry/2019/02/15/085003/874/)

Golang なのでビルド&インストールかんたん。

```sh
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

もちろん [Releases · mvdan/sh](https://github.com/mvdan/sh/releases) から落として適当な場所に置いてもいい。

オプションも他のフォーマッターとよく似てる。とりあえず

```sh
shfmt -l -w *.sh
```

でカレントの sh を全部再フォーマット。

ただ
[styleguide | Style guides for Google-originated open-source projects](https://google.github.io/styleguide/shellguide.html#indentation)
みたいにタブじゃなくて 2 spaces にするのはどうしたらいいのか。

`-i 2` か

```sh
shfmt -i 2 -w *.sh
```

で。

## shellcheck

### SC2155 の直し方

[SC2155 · koalaman/shellcheck Wiki](https://github.com/koalaman/shellcheck/wiki/SC2155) から引用

#### Problematic code in the case of `export`:

```sh
export foo="$(mycmd)"
```

##### Correct code:

```sh
foo="$(mycmd)"
export foo
```

## メモ

あとで整理

シェルスクリプトにも lint があります。
[koalaman/shellcheck: ShellCheck, a static analysis tool for shell scripts](https://github.com/koalaman/shellcheck)

- [SC2162 · koalaman/shellcheck Wiki](https://github.com/koalaman/shellcheck/wiki/SC2162)
- [SC2034 · koalaman/shellcheck Wiki](https://github.com/koalaman/shellcheck/wiki/SC2034)

シェルスクリプトには-e オプションと-u オプションをセットしましょう。参考:[Options](https://tldp.org/LDP/abs/html/options.html)
(欠点あり。`cmd1||cmd2` みたいのができなくなります)

## 壊れた symlink をみつける

```sh
find -L . -type l
```

[Linux: 壊れたシンボリックリンクを探す – エラーの向こうへ](https://tech.mktime.com/entry/479)

## shell で絶対パス

[How to obtain the absolute path of a file via Shell (BASH/ZSH/SH)? - Stack Overflow](https://stackoverflow.com/questions/3915040/how-to-obtain-the-absolute-path-of-a-file-via-shell-bash-zsh-sh)

realpath, readlink は coreutils(debian)なのでだいたい入ってるのでは。

## PATH で重複を除去する

.profile や.bashrc の最後に書いて使う

長いが sh の機能しか使わない版(コメント入り):

```sh
# 現在のPATHを取得
current_path=$PATH

# 重複を除去した後のパスを格納する変数
unique_path=""

# 現在のPATHを:で分割し、配列に格納
IFS=':' read -r -a path_array <<< "$current_path"

# パスの配列から重複を除去
for p in "${path_array[@]}"; do
    # 既にunique_pathに含まれていない場合にのみ追加
    if [[ ":$unique_path:" != *":$p:"* ]]; then
        unique_path="$unique_path:$p"
    fi
done

# 先頭の:を除去して修正されたパスを取得
unique_path="${unique_path#:}"

# PATHを更新
export PATH="$unique_path"
```

短いけど外部ツールが要る版:

```sh
export PATH=$(echo $PATH | tr ':' '\n' | awk '!a[$0]++' | tr '\n' ':')
export PATH=${PATH%:}
```

短くて外部ツールを使わない版(bash のみ):

```sh
IFS=: read -ra path_array <<< "$PATH"
unique_path=""
for p in "${path_array[@]}"; do
    [[ ":$unique_path:" != *":$p:"* ]] && unique_path="$unique_path:$p"
done
export PATH=${unique_path#:}
```

上記の altanative:

```sh
IFS=':' read -ra PATH_ARRAY <<< "$PATH"
UNIQUE_PATH=""
for P in "${PATH_ARRAY[@]}"; do
  if [[ ":$UNIQUE_PATH:" != *":$P:"* ]]; then
    UNIQUE_PATH="$UNIQUE_PATH:$P"
  fi
done
export PATH=${UNIQUE_PATH#:}
```

まあこんなスニペット使わずにすむよう、
profile 等を精査しましょう。
