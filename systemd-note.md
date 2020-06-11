# systemdのメモ

- [systemdのメモ](#systemdのメモ)
- [systemctl list-dependencies](#systemctl-list-dependencies)
- [rescue.target, emergency.target](#rescuetarget-emergencytarget)
- [-l option](#-l-option)
- [systemd-tempfiles](#systemd-tempfiles)
- [systemd-tymesyncd](#systemd-tymesyncd)
- [ユニットファイルの差分編集](#ユニットファイルの差分編集)
- [ブート時最後に実行](#ブート時最後に実行)

# systemctl list-dependencies

ユニットを省略すると`default.target`がデフォルト値

- [【Linuxのサービス依存関係と順序関係】systemctl list-dependencies と systemd-analyze の見方 | SEの道標](https://milestone-of-se.nesuke.com/sv-basic/linux-basic/systemctl-list-dependencies/)
- [Systemdのサービスの依存関係を調べる方法 - ククログ(2015-12-28)](https://www.clear-code.com/blog/2015/12/28.html)

`--after`や`--before`をつけないと

> 依存関係を調べてツリー表示できます。 ここでいう依存関係はRequires=やWants=といった、必要となるunitに着目した依存関係です。

> 他に何のUnitを起動する必要があるかを示しています。
> 階層の深さは起動順序とは関係がありません。
> あくまでどのUnitの起動が必要とされているかを示しているに過ぎません

> *.wants というディレクトリの下に SymbolicLink を配置することで依存関係を示すこともできます。これが依存関係を示す方法の2つ目です。(実は WantedBy= に指定すると .wants ディレクトリに SymbolicLinkを作成する動作になるのでそういう意味では同じかもしれません

`--after`や`--before`をつけると

> --beforeを指定するとunitファイルのBefore=ディレクティブをたどって依存関係を表示します。 同様に--afterを指定するとunitファイルのAfter=ディレクティブをたどって依存関係を表示します。

>  (--after) 階層が深いものほど、先に実行されている必要があります。

> (--before) 起動した後に何を起動する必要があるか

`--all (-a)`オプション

> 全ての Unit で再帰的に依存関係を表示する場合は -a を使います


[NetworkTarget](https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/)
```
systemctl list-dependencies network-online.target
```

# rescue.target, emergency.target

rescueモードは、昔のシングルユーザーモード。
rescueモードはemergencyモードプラスネットワークが使える、ぐらいな感じ?

- [【CentOS7】シングルユーザモード(rescue.target)への移行方法 | server-memo.net](https://www.server-memo.net/tips/server-operation/single-user.html)
- [10.3. systemd ターゲットでの作業 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sect-managing_services_with_systemd-targets)
- [How To Boot Into Rescue Mode Or Emergency Mode In Ubuntu 18.04](https://www.ostechnix.com/how-to-boot-into-rescue-mode-or-emergency-mode-in-ubuntu-18-04/)

> 現在のターゲットを変更し、現行セッションでレスキューモードに入るには、root でシェルプロンプトに以下を入力します。
```
systemctl rescue
# or
systemctl --no-wall rescue
# or
systemctl isolate rescue.target
```
emergency.targetも同様

rootでしかログインできなくなるので、
Ubuntu, Debianでは予めrootのパスワードを設定しておくこと。


GRUBからは

- [CentOS / RHEL 7 : How to boot into Rescue Mode or Emergency Mode – The Geek Diary](https://www.thegeekdiary.com/centos-rhel-7-how-to-boot-into-rescue-mode-or-emergency-mode/)
- [25.10. ブート中のターミナルメニューの編集 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot)
- [How to Boot Ubuntu 18.04 / Debian 9 Server in Rescue (Single User mode) / Emergency Mode](https://www.linuxtechi.com/boot-ubuntu-18-04-debian-9-rescue-emergency-mode/)

`e`でエディトモード。

* 64ビット IBM Power シリーズの場合は linux 行
* x86-64 BIOS ベースシステムの場合は linux16 行
* UEFI システムの場合は linuxefi 行

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


rootディスクをfsckする場合は、rescueモードか、emergencyモードで
```
mount -o ro,remount /
```
してから行う。


[25.10.3. デバッグシェルのブート](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-terminal_menu_editing_during_boot#sec-Booting_to_the_Debug_Shell)
も役に立つ。

# -l option

よく`systemctl status` で `-l`オプションをつけないと全部表示されませんよ、
というメッセージが出るが、
実は `-l (--full)`と`--no-pager`の2つをつけないと、全部表示されない。
`|`すると自動で`--no-pager`は有効になるので、
`systemctl status foobar.service -l | cat`
でもいい。イカれてると思うがそうなんだからしょうがない。

# systemd-tempfiles

再起動時にファイルを作成し、
定期的に削除する。

- [systemd-tmpfiles](https://www.freedesktop.org/software/systemd/man/systemd-tmpfiles.html)
- [tmpfiles.d](https://www.freedesktop.org/software/systemd/man/tmpfiles.d.html#)

↑最新バージョンのman. たいていのディストリではオプションや設定が少ない。


例) /etc/tmpfiles.d/test.conf
```
f /tmp/a 0755 root root - hello
d /tmp/b 0755 root root - -
f /tmp/b/a 0755 root root - world
```
これで、/tmp/a,/tmp/b/aファイルがなければ作られる。

tmpfiles.d/*.confのかける場所は異常に多い。
特に--userが使えるバージョンだと。

よくあるディストリビューションに入ってるバージョンだと
1. /etc/tmpfiles.d/*.conf
2. /run/tmpfiles.d/*.conf
3. /usr/lib/tmpfiles.d/*.conf

同じ名前の.confファイルがあるとオーバライドされる。1.がいちばん強い。

妙なルールがいっぱいあるので
(package.confとpackage-part.confとか)
manを熟読すること。


デバッグは、
```
SYSTEMD_LOG_LEVEL=debug /usr/bin/systemd-tmpfiles --create --remove --boot --exclude-prefix=/dev /etc/tmpfiles.d/test.conf
```
みたいな感じで。


# systemd-tymesyncd

systemdのSNTPクライアント

利点:
- 小さい (サーバ部分がないから)
- セキュア (サーバ部分がないから)

欠点:
- RTCを設定しない (RTCがないホスト、例えばRaspberry Piなどでは利点). 設定してるように見える... TODO
- driftとか設定しない (これもRTCがないホストでは利点かも)

物理サーバでは chronyやntpd、
CloudやIoTならsystemd-tymesyncd(やsntp)
がいいのではないか。
オンプレミスのVMでは状況次第。

参考:
- [systemd-timesyncd - ArchWiki](https://wiki.archlinux.jp/index.php/Systemd-timesyncd)
- [ntpd vs. systemd-timesyncd - How to achieve reliable NTP syncing? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/305643/ntpd-vs-systemd-timesyncd-how-to-achieve-reliable-ntp-syncing)


AWSでの設定
```bash
echo -e "[Time]\nNTP=169.254.169.123" > /etc/systemd/timesyncd.conf
systemctl start systemd-timesyncd
timedatectl set-ntp true
timedatectl set-local-rtc 0
systemctl enable systemd-timesyncd
```

RHEL7, CentOS7, Amazon Linuxではsystemdパッケージに`systemd-timesyncd`が入ってない。
systemdのバージョンが古いらしい。

# ユニットファイルの差分編集

ユニットのパラメータの一部変更ができる。

[systemdで既存のunitを編集する2つの方法 - Qiita](https://qiita.com/nvsofts/items/529e422bb8a326401c39)

例)
```
systemctl edit nginx.service
```
こうすると
`/etc/systemd/system/nginx.service.d`
の下に差分の.confファイルができ、
nginx.serviceの値を一部置き換えてくれる。

`systemctl daemon-reload`が不要


# ブート時最後に実行

```sh
sudo systemctl edit --force --full last.service
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
`systemctl enable last`してrebootするとsyslogに"test!"が最後に出る。


`systemctl list-dependencies`ではわからない。