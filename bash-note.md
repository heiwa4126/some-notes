# bash メモ

.profile や.bash_profile で毎回混乱するので、
きちんと理解する。

- [shebang](#shebang)
- [参考リンク](#参考リンク)
- [.profile, .bash_profile の関係](#profile-bash_profile-の関係)
- [exit code](#exit-code)
- [特定のフォルダの下にあるスクリプトをすべて実行する](#特定のフォルダの下にあるスクリプトをすべて実行する)
- [ファイルから引数を読み込んで処理](#ファイルから引数を読み込んで処理)
- [ps の出力を長くする](#ps-の出力を長くする)
- [tar でリスト](#tar-でリスト)
- [tar で特定のファイルだけ標準出力](#tar-で特定のファイルだけ標準出力)
- [ファイル/ディレクトリの mode を 8 進数で得る](#ファイルディレクトリの-mode-を-8-進数で得る)
- [ディレクトリを指定のモードで作成する](#ディレクトリを指定のモードで作成する)
- [mount でディスクを列挙するのをやめる](#mount-でディスクを列挙するのをやめる)
- [sudo -e](#sudo--e)
- [hex dump](#hex-dump)
- [/root の fsck](#root-の-fsck)
  - [systemd でない場合](#systemd-でない場合)
  - [systemd の場合](#systemd-の場合)
- [同じパスワードでも/etc/shadow で同じ値にならない話](#同じパスワードでもetcshadow-で同じ値にならない話)
- [stderr を less](#stderr-を-less)
- [xargs で入力が空の時エラーにしないオプションは](#xargs-で入力が空の時エラーにしないオプションは)
- [日付でソート](#日付でソート)
- [bash のショートカットキー](#bash-のショートカットキー)
- [`@-`とは](#-とは)
- [usermod -aG](#usermod--ag)
- [lsof の複数条件](#lsof-の複数条件)

## shebang

```sh
#!/usr/bin/env bash
set -euox pipefail
```

`x` は状況に応じて。

## 参考リンク

- man 1 bash
- [Man page of BASH (日本語: JM Project)](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)
- [Bash Reference Manual (GNU project)](https://www.gnu.org/software/bash/manual/bash.html)

## .profile, .bash_profile の関係

引用は
[JM Project の man ページ](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)
、起動(Invocation)のセクションから。

> bash が **対話的(interactive shell)なログインシェル(login shell)** として起動されるか、 --login オプション付きの非対話的シェルとして起動されると...

- 対話的である/対話的でない
- ログインシェルである/ログインシェルでない

の 4 通りが有りうるわけで。

> **ログインシェル(login shell)とは**、0 番目の引き数の最初の文字が - であるシェル、または --login オプション付きで起動されたシェルのことです。

`echo $0`で確認できる。

```
$ echo $0
-bash
$ bash
$ echo $0
bash
$ ps f
  PID TTY      STAT   TIME COMMAND
 2346 pts/0    Ss     0:00 -bash
 2742 pts/0    S      0:00  \_ bash
 2752 pts/0    R+     0:00      \_ ps f
```

- tmux や screen だとまた`-bash`に戻る。
- `sudo -i` は `-bash`
- `sudo su` は `bash`

> /etc/profile ファイルが存在すれば、 bash はまずここからコマンドを読み込んで実行します。

> このファイルを読んだ後、 bash は

1. ~/.bash_profile
2. ~/.bash_login
3. ~/.profile

> をこの順番で探します。 bash は、この中で最初に見つかり、
> かつ読み込みが可能であるファイルから コマンドを読み込んで実行します。
> (見つけたら、他は読まない)

> **ログインシェルでない対話的シェルとして起動されると**、 ~/.bashrc ファイルがあれば、 bash はここからコマンドを読み込み、実行します。

よくあるスケルトンでは.profile 中で.bashrc を読むようなコードが書いてある。

```
## if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
```

引用元: Ubntu 16.04LTS の`/etc/skel/.profile`

> ログインシェルが終了するときには、 ~/.bash_logout ファイルがあれば、 bash はこれを読み込んで実行します

.bash_logout に ssh-agent を殺すような処理を書く例

```
## if this is the last copy of my shell exiting the host and there are any agents running, kill them.
if [ $(w | grep $USER | wc -l) -eq 1 ]; then
   pkill ssh-agent
fi
```

引用元: [Managing multiple SSH agents - Wikitech](https://wikitech.wikimedia.org/wiki/Managing_multiple_SSH_agents)

**非対話的に実行されると** (「例えばシェルスクリプトを実行するために」)、.bashrc も.profile 等も読まない。

ただし、環境変数 BASH_ENV という抜け穴がある。

> 非対話的に実行されると...bash は環境変数 BASH_ENV を調べ、この変数が定義されていればその値を展開し、 得られた値をファイル名とみなして、 そこからコマンドの読み込みと実行を行います。

> ただし、ファイル名を探すために PATH 環境変数の値が使われることはありません。

例外がもう 1 つ

> bash は、リモートシェルデーモン rshd やセキュアシェルデーモン sshd によって実行された場合など、標準入力がネットワーク接続に接続された状態で実行されたかどうかを調べます。
> この方法によって実行されていると bash が判断した場合、
> ~/.bashrc が存在し、かつ読み込み可能であれば、 bash はコマンドをこのファイルから読み込んで実行します。

> sh として呼び出された場合には、この動作は行いません。

## exit code

/bin/sh, /bin/bash を使って起動したプロセスの exit code は
sh が予約している領域があるよ、という話。

> exit codes 1 - 2, 126 - 165, and 255

> 上記の表の通り,Exit Code 1, 2, 126〜165, 255 は特別な意味を持ち,スクリプトやプログラム内で exit に指定するパラメータとしては避けるべきである

- [Exit Codes With Special Meanings](http://tldp.org/LDP/abs/html/exitcodes.html)
- [コマンドラインツールを書くなら知っておきたい Bash の 予約済み Exit Code](https://qiita.com/Linda_pp/items/1104d2d9a263b60e104b)

あと、POSIX では 64 ~ 78 が提案されているので
/usr/include/sysexits.h
これを使うのが行儀がいい(はず)。

- [https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h](https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h)

たとえば python だと os モジュールで os.EX_USAGE などが定義されている。

ただし Windows の os モジュールは os.EX_xxx が無い(POSIX じゃないから)。

参考:

- [Linux: .bashrc と.bash_profile の違いを今度こそ理解する](https://techracho.bpsinc.jp/hachi8833/2019_06_06/66396)

## 特定のフォルダの下にあるスクリプトをすべて実行する

一番かんたんに思いつきそうなのはこれ(実行フラグがついていないものは考えていない)

```
for p in /etc/cron.daily/* ; do   echo "$p";   sh "$p"; done
```

少し考えたのはこれ(並列実行 20 は適当な値)

```
find /etc/cron.daily -type f -perm /+x | xargs -n1 -P20 sh
```

もっと良い方法があると思う。↑ は複雑すぎる。

## ファイルから引数を読み込んで処理

```
yum install $(<list)
```

みたいな記述ができる。

上記は

```
cat list | xargs yum install
```

と同じ

## ps の出力を長くする

shell と関係ないけどよく忘れるのでメモ

```
COLUMNS=999 ps axf
```

とかでもできるけど

```
ps axfww
```

w2 個で制限がなくなる。

参考: [Man page of PS](https://linuxjm.osdn.jp/html/procps/man1/ps.1.html)

## tar でリスト

これも shell と関係ないけどよく忘れるのでメモ。
(TODO: なんでよく忘れるか、を考える)

```
tar ztf foo.tar.gz
```

または

```
tar ztvf foo.tar.gz
```

zcvf,zxvf の c,x のところに t(--list)を使う。

## tar で特定のファイルだけ標準出力

`-O`オプションとファイルの指定

たまたまあった tarball での例

```sh
tar zxvf yum-r8.tar.gz yum/check_update_security/r8.json -O | jq . | less
```

## ファイル/ディレクトリの mode を 8 進数で得る

```
stat -c "%a %n" *
```

- [How can I get octal file permissions from command line? - Ask Ubuntu](https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line)

## ディレクトリを指定のモードで作成する

mkdir の`-m`オプションを使う。

例)

```
mkdir -m 1770 ~/tmp
```

- [Man page of MKDIR](https://linuxjm.osdn.jp/html/GNU_fileutils/man1/mkdir.1.html)

## mount でディスクを列挙するのをやめる

最近は仮想ファイルシステムが多いので、`mount`でディスクを列挙しようとすると目が死ぬ。

`lsblk --fs`
が代わりに使える。
(
`lsblk -f`
に同じ
)

## sudo -e

```bash
sudo -e /etc/foobar.conf
## sudo $EDITOR /etc/foobar.conf に同じ
```

みたいなことができる。かっこいいかもしれない。

## hex dump

```
od -tx1
```

または

```
xxd
```

- [Man page of OD](https://linuxjm.osdn.jp/html/gnumaniak/man1/od.1.html)
- [man xxd (1): 16 進ダンプを作成したり、元に戻したり。](http://ja.manpages.org/xxd)

## /root の fsck

### systemd でない場合

まず

```
fsck -n /
```

でほんとに異常があるのか確認。

本当にファイルシステムに異常があるなら

```
shutdown -F -r now
```

で、再起動時に fsck を実行させる。これは`touch /forcefsck`と同じ。

まだ問題があるようなら、CD boot などで。

参考:

- [Man page of SHUTDOWN](https://linuxjm.osdn.jp/html/SysVinit/man8/shutdown.8.html)

`/forcefsck`は自動的に削除される。

### systemd の場合

ext2,3,4 なら tune2fs の`-c`オプションが使える。

例:

```sh
sudo tune2fs -c1 /dev/sda1
```

で reboot。

xfs なら

```sh
sudo xfs_repair -d /dev/sda1
```

でいいらしい(未確認)。man には「直ちに reboot する」と書いてある。fsck.xfs はダミーのコマンドで、実行しても何も起きない。
[RHEL 8 のこの記事が参考になる](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/checking-an-xfs-file-system-with-xfs-repair_checking-and-repairing-a-file-system)。

参考:

- [tune2fs(8) - Linux man page](https://linux.die.net/man/8/tune2fs)
- [xfs_repair(8): repair XFS filesystem - Linux man page](https://linux.die.net/man/8/xfs_repair)
- [13.4. xfs_repair で XFS ファイルシステムの確認 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/checking-an-xfs-file-system-with-xfs-repair_checking-and-repairing-a-file-system)
- [13.8. e2fsck で ext2、ext3、または ext4 ファイルシステムの修復 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/repairing-an-ext2-ext3-or-ext4-file-system-with-e2fsck_checking-and-repairing-a-file-system)

## 同じパスワードでも/etc/shadow で同じ値にならない話

頭に salt が入ってるから。

実験:

```
$ mkpasswd -m sha-512
パスワード: # "test"とかタイプする。
$6$cgLIIKwI7G3gP5$BB8lv2ywAMpd6aEh7fv7IPgNrFMGzeWh3kHItFgBrSsjW1jBnhMg1jLRxnf20bR4vCGv/P4OZGhFDj7yAUx/e.
$ mkpasswd -m sha-512
パスワード: # 同じく"test"とかタイプする。
$6$w/4/NSMdk$Uhnu9e6ebwfffnD63QwaRtkztr8/fa4y/Bw5maFWsOH9F/qZ9iL6wB3oiNbJieS3RkuE77QIy7l.1o0ty.fJJ0

## saltを指定してみる
$ mkpasswd -m sha-512 -S 00000000
パスワード:
$6$00000000$Ecw0YyyJ4sK4v4s7/V/HvstYmY48Hthq0T3M/Dr70frxMfGTUbP4llrgm2vTwJbQxGGbP2cDUlvl2QeO6tPwo0
$ mkpasswd -m sha-512 -S 00000000
パスワード:
$6$00000000$Ecw0YyyJ4sK4v4s7/V/HvstYmY48Hthq0T3M/Dr70frxMfGTUbP4llrgm2vTwJbQxGGbP2cDUlvl2QeO6tPwo0
## おなじsaltで同じパスワードならハッシュはおなじになる
```

mkpasswd は whois パッケージに入ってる。

参考: [ひつまぶし食べたい: /etc/shadow について勉強してみた](http://hitsumabushi-pc.blogspot.com/2011/12/etcshadow.html)

## stderr を less

よくあるこれなんだけど

標準出力とエラー出力を混ぜて less

```sh
foobar 2>&1 | less
```

標準出力を捨てて、エラー出力だけを less

```sh
foobar 2>&1 > /dev/null | less
```

覚えられない。なんか小さいコマンド作って

```sh
foobar | err2stdout | less
```

みたいにできるといいんだけど。

## xargs で入力が空の時エラーにしないオプションは

`-r`, `--no-run-if-empty`

## 日付でソート

syslog の出力で、先頭が
`Jan 19 23:56:40: ...`
みたいなやつをソートする方法

例)

```
fgrep -h SomeWordToSearch /var/log/messages* | sort -k1M -k2n -k3
```

[Sort logs by date field in bash](https://stackoverflow.com/questions/5242986/sort-logs-by-date-field-in-bash)

降順にするのは `sort -k1Mr -k2nr -k3r` とするか、tac コマンドを使う。

## bash のショートカットキー

- [Readline Interaction \(Bash Reference Manual\)](https://www.gnu.org/software/bash/manual/html_node/Readline-Interaction.html)
- [リードライン相互作用](https://runebook.dev/ja/docs/bash/readline-interaction) - 機械翻訳?

cut & yank あるって知ってました? undo もあるよ。

## `@-`とは

curl で使える構文で、`@file`でファイルから読み込む。で、`@-`で stdin から読み込む。

これと here ドキュメントと組み合わせると

- [bash \- Curl with multiline of JSON \- Stack Overflow](https://stackoverflow.com/questions/34847981/curl-with-multiline-of-json)
- [curl でパフォーマンス測定 \| DevelopersIO](https://dev.classmethod.jp/articles/curl-benchmark/)
- [Bash の便利な構文だがよく忘れてしまうものの備忘録 \- Qiita](https://qiita.com/Ping/items/57fd75465dfada76e633#curl)

みたいなことができる。

## usermod -aG

`-aG` は補助グループを**追加**することができる`usermod`のオプション。
`-G` だと上書き。

以下例

```bash
## useradd test1
## id test1
uid=1001(test1) gid=1001(test1) groups=1001(test1)

## groupadd g1
## groupadd g2
## usermod -G g1 test1
## id test1
uid=1001(test1) gid=1001(test1) groups=1001(test1),1002(g1)
## usermod -G g2 test1
## id test1
uid=1001(test1) gid=1001(test1) groups=1001(test1),1003(g2)
### 追加したg1が消えてしまう

## usermod -aG g1 test1
## id test1
uid=1001(test1) gid=1001(test1) groups=1001(test1),1002(g1),1003(g2)
```

## lsof の複数条件

オプションをただ並べると or 条件になってしまう。
`-a`を使うと AND 条件になるのだけど

> Caution: the -a option causes all list selection options to be ANDed;

「注意:-a オプションは、すべてのリスト選択オプションが AND になります。
選択オプションの間に配置することで、選択されたペアの AND を発生させることはできません。」

```bash
## 例: nginxで使っているunixソケットの一覧。
## `-a`はどこにあっても結果は同じ
lsof -a -c nginx -U
```

参考: [Ubuntu Manpage: lsof - list open files](https://manpages.ubuntu.com/manpages/jammy/en/man8/lsof.8.html)
