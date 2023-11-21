# Ubuntu,Debain おぼえがき

AWS や Azure で VM 作る時に、毎回やって、毎回忘れるなにかをメモしておく。

- [Ubuntu,Debain おぼえがき](#ubuntudebain-おぼえがき)
  - [ホスト名の設定](#ホスト名の設定)
  - [タイムゾーン](#タイムゾーン)
  - [locale](#locale)
  - [EDITOR を変更](#editor-を変更)
  - [デフォルトユーザ](#デフォルトユーザ)
    - [AWS](#aws)
    - [Azure](#azure)
    - [cloud-init](#cloud-init)
    - [user を追加](#user-を追加)
      - [ubuntu on AWS 編](#ubuntu-on-aws-編)
    - [sudo でパスワードがいらないのを無効(有効)にする](#sudo-でパスワードがいらないのを無効有効にする)
  - [絶対いれとくパッケージ](#絶対いれとくパッケージ)
    - [bash-completion](#bash-completion)
  - [サービスの再起動が必要かどうか知る (古い)](#サービスの再起動が必要かどうか知る-古い)
  - [ホストの再起動が必要かどうか知る](#ホストの再起動が必要かどうか知る)
  - [auto-upgrades, unattended-upgrades](#auto-upgrades-unattended-upgrades)
  - [Ubuntu/Debian で apt autoremove でキープされる kernel パッケージの数](#ubuntudebian-で-apt-autoremove-でキープされる-kernel-パッケージの数)
  - [no\_proxy](#no_proxy)
  - [参考](#参考)
  - [Unattended Upgrades の有効/無効](#unattended-upgrades-の有効無効)
  - [`A start job is running for wait for network to be configured` で起動が遅い](#a-start-job-is-running-for-wait-for-network-to-be-configured-で起動が遅い)
  - [yum history みたいのを Debian/Ubuntu で](#yum-history-みたいのを-debianubuntu-で)
  - [netplan.io](#netplanio)
  - [Let's Encrypt で証明書が更新されたか知る](#lets-encrypt-で証明書が更新されたか知る)
  - [import debian.deb822](#import-debiandeb822)
  - [ubuntu で IPAfont](#ubuntu-で-ipafont)
  - [netplan で DHCP を renew する](#netplan-で-dhcp-を-renew-する)
  - [friendly-recovery](#friendly-recovery)
  - [インストールされているパッケージの一覧](#インストールされているパッケージの一覧)
  - [パッケージの更新履歴](#パッケージの更新履歴)
  - [/etc/group の編集](#etcgroup-の編集)
  - [xz の zgrep](#xz-の-zgrep)
  - [ppa](#ppa)
  - [パッケージの changelog](#パッケージの-changelog)
  - [Ubuntu 22.04 で python3.8, 3.9 がいるとき](#ubuntu-2204-で-python38-39-がいるとき)
  - [dmesg: read kernel buffer failed: Operation not permitted](#dmesg-read-kernel-buffer-failed-operation-not-permitted)
  - [crypto-policies](#crypto-policies)
  - [needrestart](#needrestart)

## ホスト名の設定

```bash
sudo hostnamectl set-hostname foo
sudo echo "127.0.0.1 foo.example.com foo" >> /etc/hosts
```

Debian/Ubuntu 系ではホスト名は FQDN じゃない。

このあと

```bash
hostname
hostname -f
hostname -d
```

で確認。

## タイムゾーン

timezone を東京にする。

```bash
timedatectl
sudo timedatectl set-timezone Asia/Tokyo
timedatectl
```

参考:
[[Ubuntu16.04] timezone の確認と設定 - Qiita](https://qiita.com/koara-local/items/32b004c0bf80fd70777c)

## locale

よそからつなぐこともあるので、ja_JP.UTF-8 は一応作っておく。

```bash
sudo apt-get install language-pack-ja
```

or

```bash
sudo locale-gen ja_JP.UTF-8
```

さらにデフォルトのロケールを変えたい場合は

```bash
sudo localectl set-locale LANG=ja_JP.UTF-8
```

のように。

## EDITOR を変更

デフォルトのエディタを nano から変える。環境変数 EDITOR を設定する以外の方法。

```bash
update-alternatives --config editor
```

他に

```
select-editor
```

で起動するエディタを選ぶのもできる(ユーザ単位で記憶する)。

`/usr/bin/sensible-editor`を読むと何をやってるかわかる。

```sh
echo 'SELECTED_EDITOR="/usr/bin/emacs"' > ~/.selected_editor
chmod og= ~/.selected_editor
```

みたいな方法でも OK。

## デフォルトユーザ

毎回忘れて困惑する。

### AWS

AMI のデフォルトのユーザー名はだいたい`ec2-user`.

[SSH を使用した Linux インスタンスへの接続 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

で、**Ubuntu だけ例外**で、

> Ubuntu AMI の場合、ユーザー名は ubuntu または root. です。

確認は、
EC2 のマネージメントコンソールで「接続」ボタンを押し
「例:」の@マークの前がそれ。

```
例:

ssh -i "xxx.pem" ubuntu@xxxxxxxxx.ap-xxxxxxx-1.compute.amazonaws.com

ほとんどの場合、上のユーザー名は正確ですが、AMI の使用方法を読んで AMI 所有者がデフォルト AMI ユーザー名を変更していないことを確認してください。
```

### Azure

Azure は初期ユーザが指定できるので楽。
ただ ssh 公開鍵だと、ユーザのパスワードが未設定になるので、
シリアルコンソールがあるのにログインできない、みたいな事態に遭遇する。

パスワードは設定しておいたほうがいいのではないかと思う。
`sudo passwd <initial user>`

### cloud-init

TODO:
Azure も AWS も cloud-init で初期設定ができるんだから、
なんとかする。

### user を追加

デフォルトユーザで作業しない方がいいと思うので。

#### ubuntu on AWS 編

```
adduser yourAccount
```

いくつか質問に答える。さらに sudo できるように

```
usermod -G sudo yourAccount
passwd yourAccount
```

RHEL AMI だと sudo グループのかわりに wheel で

sudo で root になれるかテスト

```
su - yourAccount
sudo -i
```

さらに yourAccount の公開鍵を用意して、
`~yourAccount/.ssh/authorized_keys` を設定。

yourAccount の状態で

```
mkdir ~/.ssh
sensible-editor ~/.ssh/authorized_keys
chmod -R og= ~/.ssh
```

別セッションから ssh で接続テスト。

(TODO:公開鍵を簡単に引っ張ってくる素敵な方法を探す。
S3 に置いて`curl xxxx >> ~/.ssh/authorized_keys`とかが思いつくけど
URL 忘れそう。)

### sudo でパスワードがいらないのを無効(有効)にする

↓ こういう話ももっともだと思うのだが

- [su|sudo|polkit を使うべきでないただ一つの理由(とりあえずの対策を追記)](https://qiita.com/ureorownramogpzq/items/7387ddb5aa414e5607bb)

無いよりはましだと思う。

まず対象のユーザにパスワードが設定されてるかを確認する。

```
grep <target-user> /etc/shadow
```

第 2 フィールドを見て確認。`chage -l <target-user>` も。

パスワードが設定されてなければ `passwd <target-user>`。

次に `grep NOPASSWD /etc/sudoers.d/*` でファイルを見つけ

`visudo -f そのファイル`で`NOPASSWD:`を削除する。

## 絶対いれとくパッケージ

### bash-completion

systemctl のサブコマンドとか覚えきれないので。あと「こんなサブコマンド/オプションがあったのか!」というのがあるので。

RHEL や Cent でも EPEL にあるので、絶対入れるべき。

## サービスの再起動が必要かどうか知る (古い)

sysetmd だとダメみたい。

```sh
sudo apt install debian-goods
sudo checkrestart -a
```

参考:
[Linux のパッケージをアップデートしたあと restart が必要なプロセスを見つける方法](https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)

## ホストの再起動が必要かどうか知る

`/var/run/reboot-required`または`/var/run/reboot-required.pkg`の存在をチェック

これは update-notifier-common パッケージが生成する。
まれにこれが入ってない Ubuntu があったりするので、

```sh
sudo apt install update-notifier-common
```

する。

## auto-upgrades, unattended-upgrades

いろいろ考えたんだけど、

- 自動更新はする
- 再起動しない

がいいのではないか。(20.04LTS ではデフォルトみたい)

`/etc/apt/apt.conf.d/20auto-upgrades`
をさわる。

ログは `/var/log/unattended-upgrades/*`

cron-apt パッケージとの関係があやしいので調査。

## Ubuntu/Debian で apt autoremove でキープされる kernel パッケージの数

なんと、数じゃないらしい。

[server - How does 'apt' decide how many old kernels to keep? - Ask Ubuntu](https://askubuntu.com/questions/620266/how-does-apt-decide-how-many-old-kernels-to-keep)

`/etc/kernel/postinst.d/apt-auto-removal`で自動生成される
`/etc/apt/apt.conf.d/01autoremove-kernels`が消されるカーネル。

## no_proxy

最近の curl では no_proxy 環境変数で proxy 例外が指定できる。

> Since 7.53.0, This option overrides the environment variables that disable the proxy.

(man curl の--noproxy のところから引用)

```
## 1604LTS
$ curl --version
curl 7.47.0

## 1804LTS
$ curl --version
curl 7.58.0
```

とりあえず、

```
no_proxy="localhost, 127.0.0.1, *.yourdomain.com"
```

ぐらいでも結構生活が楽になる。

## 参考

- [[AWS]RHEL7 よくある初期構築設定のコマンド詰め合わせ | DevelopersIO](https://dev.classmethod.jp/cloud/aws/ec2-rehl7-first-buildcmd/)

EC2 のユーザーデータに関して:

- [AWS 勉強会(補足 1) / ユーザーデータで EC2 作成時の初期設定を行う - Qiita](https://qiita.com/zaki-lknr/items/197ea366bd4243b78e69)
- [EC2 インスタンスの初回起動後にユーザーデータを実行する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/execute-user-data-ec2/)
- [Linux インスタンスでの起動時のコマンドの実行 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/user-data.html)

## Unattended Upgrades の有効/無効

Unattended Upgrades(無人更新)を有効にすると、
アップグレードを自動実行する。

起動しっぱなしのサーバだと便利な機能だが、
たまに起動するテスト用サーバだと、
ブート直後にアップグレード処理が走って、ものすごく遅いことがある。

- [How to Enable / Disable Unattended Upgrades in Ubuntu 16.04](https://linoxide.com/ubuntu-how-to/enable-disable-unattended-upgrades-ubuntu-16-04/)
- [Disable Automatic Updates on Ubuntu 18.04 Bionic Beaver Linux - LinuxConfig.org](https://linuxconfig.org/disable-automatic-updates-on-ubuntu-18-04-bionic-beaver-linux)
- [6.7. システムを最新の状態に保つ](https://debian-handbook.info/browse/ja-JP/stable/sect.regular-upgrades.html)
- [unattended-upgrades はインストールしただけでは動かない - orangain flavor](https://orangain.hatenablog.com/entry/unattended-upgrades)

`/etc/apt/apt.conf.d/20auto-upgrades` を編集して `APT::Periodic::Unattended-Upgrade` の値を `"0"` に変更すると無効。

```
## APT::Periodic::Update-Package-Lists "1";
## APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
```

## `A start job is running for wait for network to be configured` で起動が遅い

```
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service
```

引用: [ubuntu がネットワーク待ちで起動が遅い・・・](http://takuya-1st.hatenablog.jp/entry/2017/12/19/211216)

> Systemd では mask という操作を実行できる。mask 操作を行う事で、サービスの起動自体不可能になる(手動実行も不可)。disable の強化版

'/lib/systemd/systemd-networkd-wait-online'が、何を待つのかはよくわからない。
'networkctl'の出力が参考になると思う。

確かに systemd-networkd-wait-online で止まるホストでは SETUP が configuring になるインタフェースがあるなあ。

## yum history みたいのを Debian/Ubuntu で

yum の`yum history info nn`みたいなやつが羨ましくてしらべた。

```
cat /var/log/apt/history.log
```

and

```
cat /var/log/dpkg.log
```

## netplan.io

Ubuntu18 から標準になったので調べておくこと。

とりあえずは:

1. /etc/netplan/\*.yml を修正
1. netplan generate
1. netplan apply

で

- [Examples | netplan.io](https://netplan.io/examples)
- [Netplan の使い方 - kome の備忘録](https://www.komee.org/entry/2018/06/12/181400)
- [Ubuntu 18.04 LTS のネットワーク設定が netplan というものになっているのでその確認とか – Web を汚す Weblog](https://blog.dshimizu.jp/article/1196)

## Let's Encrypt で証明書が更新されたか知る

```
zgrep "Cert is due for renewal" /var/log/letsencrypt/letsencrypt.log*
```

## import debian.deb822

update-notifier-common でエラーが出る

```
update-notifier-common (3.192.1.7) を設定しています ...
Traceback (most recent call last):
  File "/usr/lib/update-notifier/package-data-downloader", line 24, in <module>
    import debian.deb822
ModuleNotFoundError: No module named 'debian'
```

エラーが出ない ubuntu でチェックすると

```
## python3
>>> import debian.deb822
>>> debian.deb822.__file__
'/usr/lib/python3/dist-packages/debian/deb822.py'

## dlocate /usr/lib/python3/dist-packages/debian/deb822.py
python3-debian: /usr/lib/python3/dist-packages/debian/deb822.py
```

この要領でトレースして、

```
apt remove update-notifier-common
apt-get --reinstall install python3-debian python-debian python3-six update-notifier-common
```

自分のところではこれで収まった。

よく出る症状らしくて、
["ImportError: No module named debian.deb822" - Google 検索](https://www.google.com/search?client=firefox-b-d&q=%22ImportError%3A+No+module+named+debian.deb822%22)
だと、たくさん表示される。

代表:
[package management - apt-get broken: No module named debian.deb822 - Ask Ubuntu](https://askubuntu.com/questions/246970/apt-get-broken-no-module-named-debian-deb822)

早く python3 が標準になるといい。

## ubuntu で IPAfont

[amueller/word_cloud: A little word cloud generator in Python](https://github.com/amueller/word_cloud)
を使うときにちょっと調べたのでメモ。

インストールは

```sh
sudo apt install fonts-ipafont
```

フォントの場所は

```
$ dlocate fonts-ipafont | fgrep .ttf | cut -d' ' -f2
/usr/share/fonts/opentype/ipafont-gothic/ipag.ttf
/usr/share/fonts/opentype/ipafont-gothic/ipagp.ttf
/usr/share/fonts/opentype/ipafont-mincho/ipam.ttf
/usr/share/fonts/opentype/ipafont-mincho/ipamp.ttf
```

## netplan で DHCP を renew する

netplan 以外では
[Linux Force DHCP Client (dhclient) to Renew IP Address - nixCraft](https://www.cyberciti.biz/faq/howto-linux-renew-dhcp-client-ip-address/)
が参考になる。

netplan で `dhclient -r; dhclient`すると dhcp で IP とってる nic にエリアスが生える。

## friendly-recovery

メモ

```
$ apt-cache show friendly-recovery

Description-en:
Make recovery boot mode more user-friendly Make the recovery boot mode more user-friendly by providing a menu with luggable options.

リカバリーブートモードをより使いやすくするメニューを提供することで、よりユーザーフレンドリーにします。プラグイン可能なオプションを使用しています。
```

- [Ubuntu – パッケージのファイル一覧: friendly-recovery/xenial/all](https://packages.ubuntu.com/ja/xenial/all/friendly-recovery/filelist)
- [FriendlyRecoverySpec - Ubuntu Wiki](https://wiki.ubuntu.com/FriendlyRecoverySpec)

## インストールされているパッケージの一覧

- `dpkg-query --list` or `dpkg -l` - フォーマットされてるのでスクリプトで扱いにくい(COLUMNS=999 とかする)。早い。
- `apt list` - 普通こっちか。

## パッケージの更新履歴

まず

- /var/log/apt/history.log
- /var/log/dpkg.log

が更新履歴。

で、パッケージにどんな更新があったかは `apt changelog`

例)

```
$ apt changelog libc-bin
Get:1 https://changelogs.ubuntu.com glibc 2.27-3ubuntu1.5 Changelog [809 kB]
Fetched 809 kB in 2s (345 kB/s)

glibc (2.27-3ubuntu1.5) bionic-security; urgency=medium

  * SECURITY UPDATE: infinite loop in iconv
    - debian/patches/any/CVE-2016-10228-pre1.patch: add xsetlocale function
      in support/Makefile, support/support.h, support/xsetlocale.c.
    - debian/patches/any/CVE-2016-10228-1.patch: rewrite iconv option
      parsing in iconv/Makefile, iconv/Versions, iconv/gconv_charset.c,
      iconv/gconv_charset.h, iconv/gconv_int.h, iconv/gconv_open.c,
      iconv/iconv_open.c, iconv/iconv_prog.c, iconv/tst-iconv-opt.c,
      iconv/tst-iconv_prog.sh, intl/dcigettext.c.
    - debian/patches/any/CVE-2016-10228-2.patch: handle translation output
      codesets with suffixes in iconv/Versions, iconv/gconv_charset.c,
      iconv/gconv_charset.h, iconv/gconv_int.h, iconv/iconv_open.c,
      iconv/iconv_prog.c, intl/dcigettext.c, intl/tst-codeset.c.
    - CVE-2016-10228
  * SECURITY UPDATE: buffer over-read in iconv
    - debian/patches/any/CVE-2019-25013.patch: fix buffer overrun in EUC-KR
      conversion module in iconvdata/bug-iconv13.c, iconvdata/euc-kr.c,
      iconvdata/ksc5601.h.
    - CVE-2019-25013
(snip)
```

で、上からも分かる通り
<https://changelogs.ubuntu.com/>
からもわかる。

例)
<https://changelogs.ubuntu.com/changelogs/binary/s/ssh/1:8.9p1-3/>

まあコマンドのほうが全然楽。

## /etc/group の編集

サーバ以降のときに、
単に vigr で/etc/group を編集すると
/etc/group- と統合がとれなくなるので

```sh
grpunconv
vigr
grpconv
```

という手順で修正する。たまにやると忘れる。

もちろん passwd のほうも

```sh
pwunconv
vipw
pwconv
```

## xz の zgrep

`xzgrep` gz,bzip2,xz,lzop,lzma 対応

ただ `lzgrep`が lzo と無関係に altanative になってるので、こっちを使うといいと思われる。

あるいは
[BurntSushi/ripgrep: ripgrep recursively searches directories for a regex pattern while respecting your gitignore](https://github.com/BurntSushi/ripgrep)

## ppa

使ってるもの

- [Emacs stable releases : Kevin Kelley](https://launchpad.net/~kelleyk/+archive/ubuntu/emacs)
- [Git stable releases : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/ppa)
- [Git release candidates : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/candidate)
- [New Python Versions : “deadsnakes” team](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa)

  18.04LTS から 20.04 にするときに調べた

```sh
dpkg-query --show -f '${Maintainer}\t${binary:Package}\n' \
| grep -F -e "Matthias Klose" -e "Kevin Kelley" -e "Jonathan Nieder" \
| sort
```

```
sudo add-apt-repository ppa:kelleyk/emacs
sudo add-apt-repository ppa:git-core/ppa
##
sudo apt install git emacs28-nox
sudo -i ln -sf $(which emacs) /etc/alternatives/editor
```

他 Azure だったら

- [walinuxagent package : Ubuntu](https://launchpad.net/ubuntu/+source/walinuxagent)
  だったのだけど、いつのまにか Ubuntu 本体に取り込まれてる。

## パッケージの changelog

例えば apache2 だったら

```sh
apt-get changelog apache2
# or
apt changelog apache2
```

おまけ:RedHat 系だったら

```sh
rpm -q --changelog httpd
```

## Ubuntu 22.04 で python3.8, 3.9 がいるとき

AWS の lambda とか用。docker でもいいけど遅いような気がする。

3.8 は snap があるけど古すぎる。

```sh
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8 python3.8-venv python3.8-dev -y
sudo apt install python3.9 python3.9-venv python3.9-dev -y
```

pip3.8,3.9 はパッケージがないので慎重になんとかする。
pip, pip3 がシステムワイドの python3.10 を置き換えないように。

とりあえずローカルユーザーでいいなら

```sh
ls -la /usr/bin/pip* ~/.local/bin/pip*
curl -sSL https://bootstrap.pypa.io/get-pip.py -O
python3.8 get-pip.py
python3.9 get-pip.py
python3.10 get-pip.py
# 確認
hash -r
pip -V
pip3 -V
pip3.10 -V
pip3.9 -V
pip3.8 -V

rm get-pip.py
```

venv もテスト

```sh
python3.9 -m venv ~/.venv/39/
. ~/.venv/39/bin/activate
pip -V
deactivate
```

## dmesg: read kernel buffer failed: Operation not permitted

```console
$ LANG=C dmesg
dmesg: read kernel buffer failed: Operation not permitted

$ dmesg
dmesg: カーネルバッファの読み込みに失敗しました: 許可されていない操作です

$ cat /dev/kmsg
cat: /dev/kmsg: 許可されていない操作です
```

これがでたら

```bash
sudo sysctl kernel.dmesg_restrict=0
```

必要なら永続化

- [linux - dmesg: read kernel buffer failed: Permission denied - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/390184/dmesg-read-kernel-buffer-failed-permission-denied)
- [dmesg のアクセス制限を外す方法 - pyopyopyo - Linux とかプログラミングの覚え書き -](https://pyopyopyo.hatenablog.com/entry/2019/02/15/023159)

## crypto-policies

[第 4 章 システム全体の暗号化ポリシーの使用 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/security_hardening/using-the-system-wide-cryptographic-policies_security-hardening)

ubuntu にもあった。

```bash
sudo apt install crypto-policies
```

```console
$ update-crypto-policies --show
DEFAULT
```

で、FUTURE にしてみる。

```console
$ sudo update-crypto-policies --set FUTURE
Setting system policy to FUTURE
Note: System-wide crypto policies are applied on application start-up.
It is recommended to restart the system for the change of policies
to fully take place.

## /etc/crypto-policiesができる。他はかわらん。rebootしろ、とのことなのでrebootする。

$ sudo reboot
```

よくわからん。とりあえず何か変わったようには見えないんだけど。

## needrestart

入れておくと `apt update` した時に、

- 再起動するべきサービスを示した上で対話的に処理したり
- それを自動でやったり
- 何もしない

をやってくれる。

参考:

- [linux - How to stop ubuntu pop-up "Daemons using outdated libraries" when using apt to install or update packages? - Stack Overflow](https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i)
- [Azure で Ubuntu 22.04 を起動すると Daemons using outdated libraries が表示される - 技術的な何か。](https://level69.net/archives/33020)
- [【2022 年版】 Ubuntu 22.04 で apt install すると、Which services should be restarted? ときかれる #Ubuntu22.04 - Qiita](https://qiita.com/nouernet/items/ffe0615c14147863de7a)

設定は

- `/etc/needrestart/needrestart.conf`
- `/etc/needrestart/conf.d/*.conf` - こちらがお勧め
