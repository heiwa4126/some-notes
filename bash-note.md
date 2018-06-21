.profileや.bash_profileで毎回混乱するので、
きちんと理解する。

# 参考
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

