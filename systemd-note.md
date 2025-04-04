# systemd のメモ

- [systemctl list-dependencies](#systemctl-list-dependencies)
- [rescue.target, emergency.target](#rescuetarget-emergencytarget)
- [-l option](#-l-option)
- [systemd-tempfiles](#systemd-tempfiles)
- [ドロップインディレクトリ](#ドロップインディレクトリ)
- [systemd-tymesyncd](#systemd-tymesyncd)
- [ユニットファイルの差分編集](#ユニットファイルの差分編集)
- [ブート時最後に実行](#ブート時最後に実行)
- [ブート時最初に実行](#ブート時最初に実行)
- [シャットダウン時に実行](#シャットダウン時に実行)
- [ブート時最後に実行して、失敗したらリトライする](#ブート時最後に実行して失敗したらリトライする)
- [@のついたユニットファイル](#のついたユニットファイル)
- [systemctl list-timers](#systemctl-list-timers)
- [systemd のユーザーモード](#systemd-のユーザーモード)
- [.service ファイルを書く](#service-ファイルを書く)
- [override.conf の自動化](#overrideconf-の自動化)
- [systemctl --failed](#systemctl---failed)
- [~/.config/systemd/user/](#configsystemduser)

## systemctl list-dependencies

ユニットを省略すると`default.target`がデフォルト値

- [【Linux のサービス依存関係と順序関係】systemctl list-dependencies と systemd-analyze の見方 | SE の道標](https://milestone-of-se.nesuke.com/sv-basic/linux-basic/systemctl-list-dependencies/)
- [Systemd のサービスの依存関係を調べる方法 - ククログ(2015-12-28)](https://www.clear-code.com/blog/2015/12/28.html)

`--after`や`--before`をつけないと

> 依存関係を調べてツリー表示できます。 ここでいう依存関係は Requires=や Wants=といった、必要となる unit に着目した依存関係です。

> 他に何の Unit を起動する必要があるかを示しています。
> 階層の深さは起動順序とは関係がありません。
> あくまでどの Unit の起動が必要とされているかを示しているに過ぎません

> \*.wants というディレクトリの下に SymbolicLink を配置することで依存関係を示すこともできます。これが依存関係を示す方法の 2 つ目です。(実は WantedBy= に指定すると .wants ディレクトリに SymbolicLink を作成する動作になるのでそういう意味では同じかもしれません

`--after`や`--before`をつけると

> --before を指定すると unit ファイルの Before=ディレクティブをたどって依存関係を表示します。 同様に--after を指定すると unit ファイルの After=ディレクティブをたどって依存関係を表示します。

> (--after) 階層が深いものほど、先に実行されている必要があります。

> (--before) 起動した後に何を起動する必要があるか

`--all (-a)`オプション

> 全ての Unit で再帰的に依存関係を表示する場合は -a を使います

[NetworkTarget](https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/)

```
systemctl list-dependencies network-online.target
```

## rescue.target, emergency.target

rescue モードは、昔のシングルユーザーモード。
rescue モードは emergency モードプラスネットワークが使える、ぐらいな感じ?

- [【CentOS7】シングルユーザモード(rescue.target)への移行方法 | server-memo.net](https://www.server-memo.net/tips/server-operation/single-user.html)
- [10.3. systemd ターゲットでの作業 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-managing_services_with_systemd-targets)
- [How To Boot Into Rescue Mode Or Emergency Mode In Ubuntu 18.04](https://www.ostechnix.com/how-to-boot-into-rescue-mode-or-emergency-mode-in-ubuntu-18-04/)

> 現在のターゲットを変更し、現行セッションでレスキューモードに入るには、root でシェルプロンプトに以下を入力します。

```
systemctl rescue
## or
systemctl --no-wall rescue
## or
systemctl isolate rescue.target
```

emergency.target も同様

root でしかログインできなくなるので、
Ubuntu, Debian では予め root のパスワードを設定しておくこと。

GRUB からは

- [CentOS / RHEL 7 : How to boot into Rescue Mode or Emergency Mode – The Geek Diary](https://www.thegeekdiary.com/centos-rhel-7-how-to-boot-into-rescue-mode-or-emergency-mode/)
- [25.10. ブート中のターミナルメニューの編集 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot)
- [How to Boot Ubuntu 18.04 / Debian 9 Server in Rescue (Single User mode) / Emergency Mode](https://www.linuxtechi.com/boot-ubuntu-18-04-debian-9-rescue-emergency-mode/)

`e`でエディトモード。

- 64 ビット IBM Power シリーズの場合は linux 行
- x86-64 BIOS ベースシステムの場合は linux16 行
- UEFI システムの場合は linuxefi 行

の最後に以下のパラメーターを追加

```
 systemd.unit=rescue.target
または
 1
または
 s
または
 single
```

をつけて起動。

root ディスクを fsck する場合は、rescue モードか、emergency モードで

```
mount -o ro,remount /
```

してから行う。

[25.10.3. デバッグシェルのブート](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot#sec-Booting_to_the_Debug_Shell)
も役に立つ。

## -l option

よく`systemctl status` で `-l`オプションをつけないと全部表示されませんよ、
というメッセージが出るが、
実は `-l (--full)`と`--no-pager`の 2 つをつけないと、全部表示されない。
`|`すると自動で`--no-pager`は有効になるので、
`systemctl status foobar.service -l | cat`
でもいい。イカれてると思うがそうなんだからしょうがない。

## systemd-tempfiles

再起動時にファイルを作成し、
定期的に削除する。

- [systemd-tmpfiles](https://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html)
- [tmpfiles.d](https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html#)

↑ 最新バージョンの man. たいていのディストリではオプションや設定が少ない。

例) /etc/tmpfiles.d/test.conf

```
f /tmp/a 0755 root root - hello
d /tmp/b 0755 root root - -
f /tmp/b/a 0755 root root - world
```

これで、/tmp/a,/tmp/b/a ファイルがなければ作られる。

tmpfiles.d/\*.conf のかける場所は異常に多い。
特に--user が使えるバージョンだと。

よくあるディストリビューションに入ってるバージョンだと

1. /etc/tmpfiles.d/\*.conf
2. /run/tmpfiles.d/\*.conf
3. /usr/lib/tmpfiles.d/\*.conf

同じ名前の.conf ファイルがあるとオーバライドされる。1.がいちばん強い。

妙なルールがいっぱいあるので
(package.conf と package-part.conf とか)
man を熟読すること。

デバッグは、

```
SYSTEMD_LOG_LEVEL=debug /usr/bin/systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev /etc/tmpfiles.d/test.conf
```

みたいな感じで。

## ドロップインディレクトリ

ユニットファイルに手を加えることなく設定を上書きや追加できる。

[systemd.unit](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)

> Along with a unit file foo.service, a "drop-in" directory foo.service.d/ may exist. All files with the suffix ".conf" from this directory will be parsed after the unit file itself is parsed. This is useful to alter or add configuration settings for a unit, without having to modify unit files. Drop-in files must contain appropriate section headers. For instantiated units, this logic will first look for the instance ".d/" subdirectory (e.g. "foo@bar.service.d/") and read its ".conf" files, followed by the template ".d/" subdirectory (e.g. "foo@.service.d/") and the ".conf" files there. Moreover for units names containing dashes ("-"), the set of directories generated by truncating the unit name after all dashes is searched too. Specifically, for a unit name foo-bar-baz.service not only the regular drop-in directory foo-bar-baz.service.d/ is searched but also both foo-bar-.service.d/ and foo-.service.d/. This is useful for defining common drop-ins for a set of related units, whose names begin with a common prefix. This scheme is particularly useful for mount, automount and slice units, whose systematic naming structure is built around dashes as component separators. Note that equally named drop-in files further down the prefix hierarchy override those further up, i.e. foo-bar-.service.d/10-override.conf overrides foo-.service.d/10-override.conf.

[第 598 回 systemd ユニットの設定を変える:Ubuntu Weekly Recipe | gihyo.jp ... 技術評論社](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0598?page=2)

- ドロップインディレクトリには複数"drop-in"ファイルを置ける
- ドロップインディレクトリは複数ある
- 評価は「ファイル名順」

## systemd-tymesyncd

systemd の SNTP クライアント

利点:

- 小さい (サーバ部分がないから)
- セキュア (サーバ部分がないから)

欠点:

- RTC を設定しない (RTC がないホスト、例えば Raspberry Pi などでは利点). 設定してるように見える... TODO
- drift とか設定しない (これも RTC がないホストでは利点かも)

物理サーバでは chrony や ntpd、
Cloud や IoT なら systemd-tymesyncd(や sntp)
がいいのではないか。
オンプレミスの VM では状況次第。

参考:

- [systemd-timesyncd - ArchWiki](https://wiki.archlinux.jp/index.php/Systemd-timesyncd)
- [ntpd vs. systemd-timesyncd - How to achieve reliable NTP syncing? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/305643/ntpd-vs-systemd-timesyncd-how-to-achieve-reliable-ntp-syncing)

AWS での設定

```bash
echo -e "[Time]\nNTP=169.254.169.123" > /etc/systemd/timesyncd.conf
systemctl start systemd-timesyncd
timedatectl set-ntp true
timedatectl set-local-rtc 0
systemctl enable systemd-timesyncd
systemctl restart systemd-timesyncd
```

169.254.169.123 については
[Amazon Time Sync Service で時間を維持する | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/keeping-time-with-amazon-time-sync-service/)
を参照。

RHEL7, CentOS7, Amazon Linux では systemd パッケージに`systemd-timesyncd`が入ってない。
systemd のバージョンが古いらしい。

## ユニットファイルの差分編集

ユニットのパラメータの一部変更ができる。

[systemd で既存の unit を編集する 2 つの方法 - Qiita](https://qiita.com/nvsofts/items/529e422bb8a326401c39)

例)

```sh
systemctl edit nginx.service
```

こうすると
`/etc/systemd/system/nginx.service.d`
の下に差分の.conf ファイルができ、
nginx.service の値を一部置き換えてくれる。

`systemctl daemon-reload`が不要

## ブート時最後に実行

```sh
sudo systemctl edit --force --full last-on-boot.service
```

中身はこんな感じ。

```
[Unit]
Description=test

[Service]
Type=idle
ExecStart=/usr/bin/logger "test!"

[Install]
WantedBy=multi-user.target
```

`systemctl enable last-on-boot`して reboot すると syslog に"test!"が最後に出る。
status は dead になる。

あとは ExecStart=を弄ってください。

`systemctl list-dependencies`ではわからない。

## ブート時最初に実行

「最初の方に」しか無理みたい。

```
[Unit]
Description=test
Before=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/logger "O.K. Go!"

[Install]
WantedBy=default.target
```

## シャットダウン時に実行

おおむねこんな感じ。

```
[Unit]
Description=test!

[Service]
Type=oneshot
RemainAfterExit=true
ExecStop=/usr/bin/logger "Good-bye!"

[Install]
WantedBy=multi-user.target
```

**active になっていると、シャットダウン時に実行される。**
なので書いたら、`systemctl enable xxx.service --now`とかすること。

また上の例だと syslog が先に死んでると結果が/va/log 以下に残らないので
`journalctl -u xxx.service`とかで確認。

「シャットダウン時に**最初に**実行」は考え中

## ブート時最後に実行して、失敗したらリトライする

(考え中)

## @のついたユニットファイル

ubuntu で postgresql-11 をインストールしたら

```
$ LANG=C ls /lib/systemd/system/postgresql* -la
-rw-r--r-- 1 root root  337 Nov 22  2018 /lib/systemd/system/postgresql.service
-rw-r--r-- 1 root root 1580 Nov 22  2018 /lib/systemd/system/postgresql@.service

$ dlocate /lib/systemd/system/postgresql*.service
postgresql-common: /lib/systemd/system/postgresql@.service
postgresql-common: /lib/systemd/system/postgresql.service

$ systemctl status postgresql\*
● postgresql@11-main.service - PostgreSQL Cluster 11-main
   Loaded: loaded (/lib/systemd/system/postgresql@.service; indirect; vendor preset: enabled)
(略)
```

この@とはなにか?

- [OpenVpn の systemd ユニットファイル - Qiita](https://qiita.com/11ohina017/items/cb30075719eab97fdaa5#%E3%82%A2%E3%83%83%E3%83%88%E3%83%9E%E3%83%BC%E3%82%AF%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6)

> @がついたユニットファイルは systemctl の実行時に@の後ろに文字列を指定すると、ユニットファイルに定義した%i を@の後ろに設定した文字列で置換できる。

[systemd.unit](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Description)

> A template unit must have a single "@" at the end of the name (right before the type suffix). The name of the full unit is formed by inserting the instance name between "@" and the unit type suffix. In the unit file itself, the instance parameter may be referred to using "%i" and other specifiers, see below.

`/lib/systemd/system/postgresql@.service`
から引用。

> The actual instances will be called "postgresql@version-cluster", e.g. "postgresql@9.3-main".
> The variable %i expands to "version-cluster",
> %I expands to "version/cluster". (%I breaks for cluster names containing dashes.)

なんか
[systemd.unit](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Specifiers)
に書いてあることとちがうのがやだなあ。

- "%i" Instance name
- "%I" Unescaped instance name

`escape`がなにかよくわからない。[systemd.unit](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#String%20Escaping%20for%20Inclusion%20in%20Unit%20Names)か?

> given a string, any "/" character is replaced by "-"...

どっちかの説明がサカサマだ。

## systemctl list-timers

systemd の cron みたいなやつ。\*.timer を列挙する。

## systemd のユーザーモード

参考:

- マニュアル - [systemd.unit](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)
- [ユーザー毎の systemd を使ってシステム全体設定と個人用設定を分ける。 - それマグで!](https://takuya-1st.hatenablog.jp/entry/2019/08/09/004829)

systemd には user モードというのがあって(pip の--user みたいなやつ)

1. `~/.config/systemd/user.control`フォルダに unit ファイル書く
1. `systemctl --user daemon-reload`で読み込む
1. あとは普通に start やら enable やらする。(--user つけて)

実行されるのはユーザがログインしたとき。

## .service ファイルを書く

非パッケージ版の Tomcat9 を非 root ユーザで起動する必要があったので、
そのときのメモ。

```
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
User=tomcat
Group=tomcat
Type=forking

ExecStart=/etc/tomcat9/bin/startup.sh
ExecStop=/etc/tomcat9/bin/shutdown.sh
Environment="CATALINA_PID=/etc/tomcat9/tomcat9.pid"

[Install]
WantedBy=multi-user.target
```

## override.conf の自動化

`systemctl edit`の入力を stdin にする例。

```sh
echo -e '[Service]\n# Override location of database directory\nEnvironment=PGDATA=/data4' \
 | SYSTEMD_EDITOR=tee systemctl edit postgresql-9.5.service
```

非 root からなら

```sh
echo -e '[Service]\n# Override location of database directory\nEnvironment=PGDATA=/data4' \
 | sudo SYSTEMD_EDITOR=tee systemctl edit postgresql-9.5.service
```

参考:

- [pipe input into systemctl edit / System Administration / Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=195782)
- [systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html)の Environ のところ。

override をつかうと Drop-In:のところに表示される。

```
$ sudo systemctl status postgresql-9.5
● postgresql-9.5.service - PostgreSQL 9.5 database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql-9.5.service; disabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/postgresql-9.5.service.d
           └─override.conf
   Active: active (running) since Tue 2021-06-22 14:01:41 UTC; 5s ago
     Docs: https://www.postgresql.org/docs/9.5/static/
  Process: 2883 ExecStart=/usr/pgsql-9.5/bin/pg_ctl start -D ${PGDATA} -s -w -t 300 (code=exited, status=0/SUCCESS)
  Process: 2878 ExecStartPre=/usr/pgsql-9.5/bin/postgresql95-check-db-dir ${PGDATA} (code=exited, status=0/SUCCESS)
 Main PID: 2886 (postgres)
   CGroup: /system.slice/postgresql-9.5.service
           ├─2886 /usr/pgsql-9.5/bin/postgres -D /var/lib/pgsql/9.5/data
           ├─2887 postgres: logger process
           ├─2889 postgres: checkpointer process
           ├─2890 postgres: writer process
           ├─2891 postgres: wal writer process
           ├─2892 postgres: autovacuum launcher process
           └─2893 postgres: stats collector process

$ sudo cat /etc/systemd/system/postgresql-9.5.service.d/override.conf
[Service]
## Override location of database directory
Environment=PGDATA=/var/lib/pgsql/9.5/data
```

## systemctl --failed

よく使ってたんだけど `systemctl --help` で出てこない。

(`systemctl  list-unit-files --state=failed`と同じ? 出力が微妙に違うし)

その上こんな話まで。
[systemd \- systemctl \-\-failed not listing failed instantiated service \- Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/396075/systemctl-failed-not-listing-failed-instantiated-service)

まあ

```console
$ systemctl --failed
0 loaded units listed. Pass --all to see loaded but inactive units, too.
```

と出てくるとおりに

今後は

```sh
systemctl --failed --all
```

とする。

## ~/.config/systemd/user/

[サーバー起動時に非 root ユーザーで systemd を使ってサービスを立ち上げる - Qiita](https://qiita.com/k0kubun/items/3c94473506e0e370a227)

いろいろ制約があってややこしい。基本「ユーザがログインしたときに起動」
