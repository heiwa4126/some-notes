.profileや.bash_profileで毎回混乱するので、
きちんと理解する。

- [参考](#%E5%8F%82%E8%80%83)
- [.profile, .bash_profileの関係](#profile-bashprofile%E3%81%AE%E9%96%A2%E4%BF%82)
- [exit code](#exit-code)
- [特定のフォルダの下にあるスクリプトをすべて実行する](#%E7%89%B9%E5%AE%9A%E3%81%AE%E3%83%95%E3%82%A9%E3%83%AB%E3%83%80%E3%81%AE%E4%B8%8B%E3%81%AB%E3%81%82%E3%82%8B%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%82%92%E3%81%99%E3%81%B9%E3%81%A6%E5%AE%9F%E8%A1%8C%E3%81%99%E3%82%8B)
- [ファイルから引数を読み込んで処理](#%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%8B%E3%82%89%E5%BC%95%E6%95%B0%E3%82%92%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%82%93%E3%81%A7%E5%87%A6%E7%90%86)
- [psの出力を長くする](#ps%E3%81%AE%E5%87%BA%E5%8A%9B%E3%82%92%E9%95%B7%E3%81%8F%E3%81%99%E3%82%8B)
- [tarでリスト](#tar%E3%81%A7%E3%83%AA%E3%82%B9%E3%83%88)

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
