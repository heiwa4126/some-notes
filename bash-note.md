.profileや.bash_profileで毎回混乱するので、
きちんと理解する。

- [参考リンク](#参考リンク)
- [.profile, .bash_profileの関係](#profile-bash_profileの関係)
- [exit code](#exit-code)
- [特定のフォルダの下にあるスクリプトをすべて実行する](#特定のフォルダの下にあるスクリプトをすべて実行する)
- [ファイルから引数を読み込んで処理](#ファイルから引数を読み込んで処理)
- [psの出力を長くする](#psの出力を長くする)
- [tarでリスト](#tarでリスト)
- [ファイル/ディレクトリのmodeを8進数で得る](#ファイルディレクトリのmodeを8進数で得る)
- [ディレクトリを指定のモードで作成する](#ディレクトリを指定のモードで作成する)
- [mountでディスクを列挙するのをやめる](#mountでディスクを列挙するのをやめる)
- [sudo -e](#sudo--e)
- [hex dump](#hex-dump)
- [/rootのfsck](#rootのfsck)
  - [systemdでない場合](#systemdでない場合)
  - [systemdの場合](#systemdの場合)
- [同じパスワードでも/etc/shadowで同じ値にならない話](#同じパスワードでもetcshadowで同じ値にならない話)
- [stderrをless](#stderrをless)
- [xargsで入力が空の時エラーにしないオプションは](#xargsで入力が空の時エラーにしないオプションは)
- [日付でソート](#日付でソート)
- [bashのショートカットキー](#bashのショートカットキー)


# 参考リンク

- man 1 bash
- [Man page of BASH (日本語: JM Project)](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)
- [Bash Reference Manual (GNU project)](https://www.gnu.org/software/bash/manual/bash.html)

# .profile, .bash_profileの関係

引用は
[JM Projectのmanページ](https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html)
、起動(Invocation)のセクションから。


>bash が **対話的(interactive shell)なログインシェル(login shell)** として起動されるか、 --login オプション付きの非対話的シェルとして起動されると...

- 対話的である/対話的でない
- ログインシェルである/ログインシェルでない

の4通りが有りうるわけで。

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
- tmuxやscreenだとまた`-bash`に戻る。
- `sudo -i` は `-bash`
- `sudo su` は `bash`

> /etc/profile ファイルが存在すれば、 bash はまずここからコマンドを読み込んで実行します。

> このファイルを読んだ後、 bash は
1. ~/.bash_profile
2. ~/.bash_login
3. ~/.profile
> をこの順番で探します。 bash は、この中で最初に見つかり、
> かつ読み込みが可能であるファイルから コマンドを読み込んで実行します。
(見つけたら、他は読まない)

> **ログインシェルでない対話的シェルとして起動されると**、 ~/.bashrc ファイルがあれば、 bash はここからコマンドを読み込み、実行します。

よくあるスケルトンでは.profile中で.bashrcを読むようなコードが書いてある。
```
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
```
引用元: Ubntu 16.04LTSの`/etc/skel/.profile`



> ログインシェルが終了するときには、 ~/.bash_logout ファイルがあれば、 bash はこれを読み込んで実行します

.bash_logoutにssh-agentを殺すような処理を書く例
```
# if this is the last copy of my shell exiting the host and there are any agents running, kill them.
if [ $(w | grep $USER | wc -l) -eq 1 ]; then
   pkill ssh-agent
fi
```
引用元: [Managing multiple SSH agents - Wikitech](https://wikitech.wikimedia.org/wiki/Managing_multiple_SSH_agents)

**非対話的に実行されると** (「例えばシェルスクリプトを実行するために」)、.bashrcも.profile等も読まない。

ただし、環境変数 BASH_ENV という抜け穴がある。
> 非対話的に実行されると...bash は環境変数 BASH_ENV を調べ、この変数が定義されていればその値を展開し、 得られた値をファイル名とみなして、 そこからコマンドの読み込みと実行を行います。

> ただし、ファイル名を探すために PATH 環境変数の値が使われることはありません。

例外がもう1つ

> bash は、リモートシェルデーモン rshd やセキュアシェルデーモン sshd によって実行された場合など、標準入力がネットワーク接続に接続された状態で実行されたかどうかを調べます。
> この方法によって実行されていると bash が判断した場合、
> ~/.bashrc が存在し、かつ読み込み可能であれば、 bash はコマンドをこのファイルから読み込んで実行します。

> sh として呼び出された場合には、この動作は行いません。


# exit code

/bin/sh, /bin/bashを使って起動したプロセスのexit codeは
shが予約している領域があるよ、という話。

> exit codes 1 - 2, 126 - 165, and 255

> 上記の表の通り，Exit Code 1, 2, 126〜165, 255 は特別な意味を持ち，スクリプトやプログラム内で exit に指定するパラメータとしては避けるべきである

- [Exit Codes With Special Meanings](http://tldp.org/LDP/abs/html/exitcodes.html)
- [コマンドラインツールを書くなら知っておきたい Bash の 予約済み Exit Code](https://qiita.com/Linda_pp/items/1104d2d9a263b60e104b)

あと、POSIXでは64～78が提案されているので
/usr/include/sysexits.h
これを使うのが行儀がいい(はず)。
- [https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h](https://opensource.apple.com/source/Libc/Libc-320/include/sysexits.h)

たとえばpythonだとosモジュールでos.EX_USAGEなどが定義されている。

ただしWindowsのosモジュールはos.EX_xxxが無い(POSIXじゃないから)。

参考:
- [Linux: .bashrcと.bash_profileの違いを今度こそ理解する](https://techracho.bpsinc.jp/hachi8833/2019_06_06/66396)


# 特定のフォルダの下にあるスクリプトをすべて実行する

一番かんたんに思いつきそうなのはこれ(実行フラグがついていないものは考えていない)
```
for p in /etc/cron.daily/* ; do   echo "$p";   sh "$p"; done
```

少し考えたのはこれ(並列実行20は適当な値)
```
find /etc/cron.daily -type f -perm /+x | xargs -n1 -P20 sh
```

もっと良い方法があると思う。↑は複雑すぎる。


# ファイルから引数を読み込んで処理

```
yum install $(<list)
```
みたいな記述ができる。

上記は
```
cat list | xargs yum install
```
と同じ


# psの出力を長くする

shellと関係ないけどよく忘れるのでメモ

```
COLUMNS=999 ps axf
```
とかでもできるけど
```
ps axfww
```
w2個で制限がなくなる。

参考: [Man page of PS](https://linuxjm.osdn.jp/html/procps/man1/ps.1.html)


# tarでリスト

これもshellと関係ないけどよく忘れるのでメモ。
(TODO: なんでよく忘れるか、を考える)

```
tar ztf foo.tar.gz
```
または
```
tar ztvf foo.tar.gz
```

zcvf,zxvfのc,xのところにt(--list)を使う。


# ファイル/ディレクトリのmodeを8進数で得る

```
stat -c "%a %n" *
```

* [How can I get octal file permissions from command line? - Ask Ubuntu](https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line)


# ディレクトリを指定のモードで作成する

mkdirの`-m`オプションを使う。

例)
```
mkdir -m 1770 ~/tmp
```

* [Man page of MKDIR](https://linuxjm.osdn.jp/html/GNU_fileutils/man1/mkdir.1.html)


# mountでディスクを列挙するのをやめる

最近は仮想ファイルシステムが多いので、`mount`でディスクを列挙しようとすると目が死ぬ。

`lsblk --fs`
が代わりに使える。
(
`lsblk -f`
に同じ
)

# sudo -e

``` bash
sudo -e /etc/foobar.conf
# sudo $EDITOR /etc/foobar.conf に同じ
```
みたいなことができる。かっこいいかもしれない。


# hex dump

```
od -tx1
```
または
```
xxd
```

- [Man page of OD](https://linuxjm.osdn.jp/html/gnumaniak/man1/od.1.html)
- [man xxd (1): 16 進ダンプを作成したり、元に戻したり。](http://ja.manpages.org/xxd)


# /rootのfsck

## systemdでない場合

まず
```
fsck -n /
```
でほんとに異常があるのか確認。

本当にファイルシステムに異常があるなら
```
shutdown -F -r now
```
で、再起動時にfsckを実行させる。これは`touch /forcefsck`と同じ。

まだ問題があるようなら、CD bootなどで。

参考:
- [Man page of SHUTDOWN](https://linuxjm.osdn.jp/html/SysVinit/man8/shutdown.8.html)

`/forcefsck`は自動的に削除される。


## systemdの場合

ext2,3,4ならtune2fsの`-c`オプションが使える。

例:
```sh
sudo tune2fs -c1 /dev/sda1
```
でreboot。

xfsなら
```sh
sudo xfs_repair -d /dev/sda1
```
でいいらしい(未確認)。manには「直ちにrebootする」と書いてある。fsck.xfsはダミーのコマンドで、実行しても何も起きない。
[RHEL 8のこの記事が参考になる](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/checking-an-xfs-file-system-with-xfs-repair_checking-and-repairing-a-file-system)。



参考:
- [tune2fs(8) - Linux man page](https://linux.die.net/man/8/tune2fs)
- [xfs_repair(8): repair XFS filesystem - Linux man page](https://linux.die.net/man/8/xfs_repair)
- [13.4. xfs_repair で XFS ファイルシステムの確認 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/checking-an-xfs-file-system-with-xfs-repair_checking-and-repairing-a-file-system)
- [13.8. e2fsck で ext2、ext3、または ext4 ファイルシステムの修復 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/managing_file_systems/repairing-an-ext2-ext3-or-ext4-file-system-with-e2fsck_checking-and-repairing-a-file-system)

# 同じパスワードでも/etc/shadowで同じ値にならない話

頭にsaltが入ってるから。

実験:
```
$ mkpasswd -m sha-512
パスワード: # "test"とかタイプする。
$6$cgLIIKwI7G3gP5$BB8lv2ywAMpd6aEh7fv7IPgNrFMGzeWh3kHItFgBrSsjW1jBnhMg1jLRxnf20bR4vCGv/P4OZGhFDj7yAUx/e.
$ mkpasswd -m sha-512
パスワード: # 同じく"test"とかタイプする。
$6$w/4/NSMdk$Uhnu9e6ebwfffnD63QwaRtkztr8/fa4y/Bw5maFWsOH9F/qZ9iL6wB3oiNbJieS3RkuE77QIy7l.1o0ty.fJJ0

# saltを指定してみる
$ mkpasswd -m sha-512 -S 00000000
パスワード:
$6$00000000$Ecw0YyyJ4sK4v4s7/V/HvstYmY48Hthq0T3M/Dr70frxMfGTUbP4llrgm2vTwJbQxGGbP2cDUlvl2QeO6tPwo0
$ mkpasswd -m sha-512 -S 00000000
パスワード:
$6$00000000$Ecw0YyyJ4sK4v4s7/V/HvstYmY48Hthq0T3M/Dr70frxMfGTUbP4llrgm2vTwJbQxGGbP2cDUlvl2QeO6tPwo0
# おなじsaltで同じパスワードならハッシュはおなじになる
```

mkpasswdはwhoisパッケージに入ってる。

参考: [ひつまぶし食べたい: /etc/shadowについて勉強してみた](http://hitsumabushi-pc.blogspot.com/2011/12/etcshadow.html)


# stderrをless

よくあるこれなんだけど

標準出力とエラー出力を混ぜてless
```sh
foobar 2>&1 | less
```

標準出力を捨てて、エラー出力だけをless
```sh
foobar 2>&1 > /dev/null | less
```

覚えられない。なんか小さいコマンド作って
```sh
foobar | err2stdout | less
```
みたいにできるといいんだけど。


# xargsで入力が空の時エラーにしないオプションは

`-r`, `--no-run-if-empty`


# 日付でソート

syslogの出力で、先頭が
`Jan 19 23:56:40: ...`
みたいなやつをソートする方法

例)
```
fgrep -h SomeWordToSearch /var/log/messages* | sort -k1M -k2n -k3
```

[Sort logs by date field in bash](https://stackoverflow.com/questions/5242986/sort-logs-by-date-field-in-bash)

降順にするのは `sort -k1Mr -k2nr -k3r` とするか、tacコマンドを使う。


# bashのショートカットキー

- [Readline Interaction \(Bash Reference Manual\)](https://www.gnu.org/software/bash/manual/html_node/Readline-Interaction.html)
- [リードライン相互作用](https://runebook.dev/ja/docs/bash/readline-interaction) - 機械翻訳?

cut & yank あるって知ってました? undoもあるよ。