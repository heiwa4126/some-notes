# Ubuntu,Debain おぼえがき

AWSやAzureでVM作る時に、毎回やって、毎回忘れるなにかをメモしておく。

- [Ubuntu,Debain おぼえがき](#ubuntudebain-おぼえがき)
- [ホスト名の設定](#ホスト名の設定)
- [タイムゾーン](#タイムゾーン)
- [locale](#locale)
- [EDITORを変更](#editorを変更)
- [デフォルトユーザ](#デフォルトユーザ)
  - [AWS](#aws)
  - [Azure](#azure)
- [cloud-init](#cloud-init)
- [userを追加](#userを追加)
    - [ubuntu on AWS編](#ubuntu-on-aws編)
- [sudoでパスワードがいらないのを無効(有効)にする](#sudoでパスワードがいらないのを無効有効にする)
- [絶対いれとくパッケージ](#絶対いれとくパッケージ)
  - [bash-completion](#bash-completion)
- [サービスの再起動が必要かどうか知る (古い)](#サービスの再起動が必要かどうか知る-古い)
- [ホストの再起動が必要かどうか知る](#ホストの再起動が必要かどうか知る)
- [auto-upgrades, unattended-upgrades](#auto-upgrades-unattended-upgrades)
- [Ubuntu/Debianでapt autoremoveでキープされるkernelパッケージの数](#ubuntudebianでapt-autoremoveでキープされるkernelパッケージの数)
- [no_proxy](#no_proxy)
- [参考](#参考)
- [Unattended Upgradesの有効/無効](#unattended-upgradesの有効無効)
- [`A start job is running for wait for network to be configured` で起動が遅い](#a-start-job-is-running-for-wait-for-network-to-be-configured-で起動が遅い)
- [yum history みたいのを Debian/Ubuntu で](#yum-history-みたいのを-debianubuntu-で)
- [netplan.io](#netplanio)
- [Let's Encryptで証明書が更新されたか知る](#lets-encryptで証明書が更新されたか知る)
- [import debian.deb822](#import-debiandeb822)
- [ubuntuでIPAfont](#ubuntuでipafont)
- [netplanでDHCPをrenewする](#netplanでdhcpをrenewする)
- [friendly-recovery](#friendly-recovery)
- [インストールされているパッケージの一覧](#インストールされているパッケージの一覧)
- [パッケージの更新履歴](#パッケージの更新履歴)
- [/etc/groupの編集](#etcgroupの編集)
- [xzのzgrep](#xzのzgrep)
- [ppa](#ppa)

# ホスト名の設定

```
sudo hostnamectl set-hostname foo
sudo echo "127.0.0.1 foo.example.com foo" >> /etc/hosts
```
Debian/Ubuntu系ではホスト名はFQDNじゃない。

このあと
```sh
hostname
hostname -f
hostname -d
```
で確認。


# タイムゾーン

timezoneを東京にする。

```
timedatectl
sudo timedatectl set-timezone Asia/Tokyo
timedatectl
```

参考:
[[Ubuntu16.04] timezoneの確認と設定 - Qiita](https://qiita.com/koara-local/items/32b004c0bf80fd70777c)

# locale

よそからつなぐこともあるので、ja_JP.UTF-8は一応作っておく。

```
sudo apt-get install language-pack-ja
```
or
```
sudo locale-gen ja_JP.UTF-8
```

さらにデフォルトのロケールを変えたい場合は
```
sudo localectl set-locale LANG=ja_JP.UTF-8
```
のように。


# EDITORを変更

デフォルトのエディタをnanoから変える。環境変数EDITORを設定する以外の方法。

```
update-alternatives --config editor
```

他に
```
select-editor
```
で起動するエディタを選ぶのもできる(ユーザ単位で記憶する)。

`/usr/bin/sensible-editor`を読むと何をやってるかわかる。

# デフォルトユーザ

毎回忘れて困惑する。

## AWS

AMI のデフォルトのユーザー名はだいたい`ec2-user`.

[SSH を使用した Linux インスタンスへの接続 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

で、**Ubuntuだけ例外**で、
> Ubuntu AMI の場合、ユーザー名は ubuntu または root. です。

確認は、
EC2のマネージメントコンソールで「接続」ボタンを押し
「例:」の@マークの前がそれ。
```
例:

ssh -i "xxx.pem" ubuntu@xxxxxxxxx.ap-xxxxxxx-1.compute.amazonaws.com

ほとんどの場合、上のユーザー名は正確ですが、AMI の使用方法を読んで AMI 所有者がデフォルト AMI ユーザー名を変更していないことを確認してください。
```

## Azure

Azureは初期ユーザが指定できるので楽。
ただssh公開鍵だと、ユーザのパスワードが未設定になるので、
シリアルコンソールがあるのにログインできない、みたいな事態に遭遇する。

パスワードは設定しておいたほうがいいのではないかと思う。
`sudo passwd <initial user>`


# cloud-init

TODO:
AzureもAWSもcloud-initで初期設定ができるんだから、
なんとかする。



# userを追加

デフォルトユーザで作業しない方がいいと思うので。

### ubuntu on AWS編

```
adduser yourAccount
```
いくつか質問に答える。さらにsudoできるように
```
usermod -G sudo yourAccount
passwd yourAccount
```
RHEL AMIだとsudoグループのかわりにwheelで

sudoでrootになれるかテスト
```
su - yourAccount
sudo -i
```

さらに yourAccountの公開鍵を用意して、
`~yourAccount/.ssh/authorized_keys` を設定。

yourAccountの状態で
```
mkdir ~/.ssh
sensible-editor ~/.ssh/authorized_keys
chmod -R og= ~/.ssh
```
別セッションからsshで接続テスト。

(TODO:公開鍵を簡単に引っ張ってくる素敵な方法を探す。
S3に置いて`curl xxxx >> ~/.ssh/authorized_keys`とかが思いつくけど
URL忘れそう。)


# sudoでパスワードがいらないのを無効(有効)にする

↓こういう話ももっともだと思うのだが
- [su|sudo|polkit を使うべきでないただ一つの理由(とりあえずの対策を追記)](https://qiita.com/ureorownramogpzq/items/7387ddb5aa414e5607bb)

無いよりはましだと思う。

まず対象のユーザにパスワードが設定されてるかを確認する。
```
grep <target-user> /etc/shadow
```
第2フィールドを見て確認。`chage -l <target-user>` も。

パスワードが設定されてなければ `passwd <target-user>`。

次に `grep NOPASSWD /etc/sudoers.d/*` でファイルを見つけ

`visudo -f そのファイル`で`NOPASSWD:`を削除する。



# 絶対いれとくパッケージ

## bash-completion

systemctlのサブコマンドとか覚えきれないので。あと「こんなサブコマンド/オプションがあったのか!」というのがあるので。

RHELやCentでもEPELにあるので、絶対入れるべき。


# サービスの再起動が必要かどうか知る (古い)

sysetmdだとダメみたい。

```sh
sudo apt install debian-goods
sudo checkrestart -a
```

参考:
[Linuxのパッケージをアップデートしたあとrestartが必要なプロセスを見つける方法](https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)


# ホストの再起動が必要かどうか知る

`/var/run/reboot-required`または`/var/run/reboot-required.pkg`の存在をチェック

これは update-notifier-common パッケージが生成する。
まれにこれが入ってないUbuntuがあったりするので、
```sh
sudo apt install update-notifier-common
```
する。


# auto-upgrades, unattended-upgrades

いろいろ考えたんだけど、
- 自動更新はする
- 再起動しない

がいいのではないか。(20.04LTSではデフォルトみたい)

`/etc/apt/apt.conf.d/20auto-upgrades`
をさわる。

ログは `/var/log/unattended-upgrades/*`

cron-aptパッケージとの関係があやしいので調査。


# Ubuntu/Debianでapt autoremoveでキープされるkernelパッケージの数

なんと、数じゃないらしい。

[server - How does 'apt' decide how many old kernels to keep? - Ask Ubuntu](https://askubuntu.com/questions/620266/how-does-apt-decide-how-many-old-kernels-to-keep)

`/etc/kernel/postinst.d/apt-auto-removal`で自動生成される
`/etc/apt/apt.conf.d/01autoremove-kernels`が消されるカーネル。


# no_proxy

最近のcurlではno_proxy環境変数でproxy例外が指定できる。

> Since  7.53.0,  This  option  overrides the environment variables that disable the proxy.

(man curlの--noproxyのところから引用)

```
# 1604LTS
$ curl --version
curl 7.47.0

# 1804LTS
$ curl --version
curl 7.58.0
```

とりあえず、
```
no_proxy="localhost, 127.0.0.1, *.yourdomain.com"
```
ぐらいでも結構生活が楽になる。

# 参考

* [[AWS]RHEL7 よくある初期構築設定のコマンド詰め合わせ ｜ DevelopersIO](https://dev.classmethod.jp/cloud/aws/ec2-rehl7-first-buildcmd/)

EC2のユーザーデータに関して:

* [AWS勉強会(補足1) / ユーザーデータでEC2作成時の初期設定を行う - Qiita](https://qiita.com/zaki-lknr/items/197ea366bd4243b78e69)
* [EC2 インスタンスの初回起動後にユーザーデータを実行する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/execute-user-data-ec2/)
* [Linux インスタンスでの起動時のコマンドの実行 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/user-data.html)


# Unattended Upgradesの有効/無効

Unattended Upgrades(無人更新)を有効にすると、
アップグレードを自動実行する。

起動しっぱなしのサーバだと便利な機能だが、
たまに起動するテスト用サーバだと、
ブート直後にアップグレード処理が走って、ものすごく遅いことがある。

* [How to Enable / Disable Unattended Upgrades in Ubuntu 16.04](https://linoxide.com/ubuntu-how-to/enable-disable-unattended-upgrades-ubuntu-16-04/)
* [Disable Automatic Updates on Ubuntu 18.04 Bionic Beaver Linux - LinuxConfig.org](https://linuxconfig.org/disable-automatic-updates-on-ubuntu-18-04-bionic-beaver-linux)
* [6.7. システムを最新の状態に保つ](https://debian-handbook.info/browse/ja-JP/stable/sect.regular-upgrades.html)
* [unattended-upgradesはインストールしただけでは動かない - orangain flavor](https://orangain.hatenablog.com/entry/unattended-upgrades)

`/etc/apt/apt.conf.d/20auto-upgrades` を編集して `APT::Periodic::Unattended-Upgrade` の値を `"0"` に変更すると無効。

```
# APT::Periodic::Update-Package-Lists "1";
# APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
```



# `A start job is running for wait for network to be configured` で起動が遅い

```
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service
```

引用: [ubuntu がネットワーク待ちで起動が遅い・・・](http://takuya-1st.hatenablog.jp/entry/2017/12/19/211216)

> Systemdではmaskという操作を実行できる。mask操作を行う事で、サービスの起動自体不可能になる(手動実行も不可)。disableの強化版


'/lib/systemd/systemd-networkd-wait-online'が、何を待つのかはよくわからない。
'networkctl'の出力が参考になると思う。

確かにsystemd-networkd-wait-onlineで止まるホストではSETUPがconfiguringになるインタフェースがあるなあ。

# yum history みたいのを Debian/Ubuntu で

yumの`yum history info nn`みたいなやつが羨ましくてしらべた。

```
cat /var/log/apt/history.log
```
and
```
cat /var/log/dpkg.log
```


# netplan.io

Ubuntu18から標準になったので調べておくこと。

とりあえずは:
1. /etc/netplan/*.yml を修正
1. netplan generate
1. netplan apply

で

* [Examples | netplan.io](https://netplan.io/examples)
* [Netplanの使い方 - komeの備忘録](https://www.komee.org/entry/2018/06/12/181400)
* [Ubuntu 18.04 LTS のネットワーク設定がnetplanというものになっているのでその確認とか – Webを汚すWeblog](https://blog.dshimizu.jp/article/1196)


# Let's Encryptで証明書が更新されたか知る

```
zgrep "Cert is due for renewal" /var/log/letsencrypt/letsencrypt.log*
```

# import debian.deb822

update-notifier-commonでエラーが出る
```
update-notifier-common (3.192.1.7) を設定しています ...
Traceback (most recent call last):
  File "/usr/lib/update-notifier/package-data-downloader", line 24, in <module>
    import debian.deb822
ModuleNotFoundError: No module named 'debian'
```

エラーが出ないubuntuでチェックすると
```
# python3
>>> import debian.deb822
>>> debian.deb822.__file__
'/usr/lib/python3/dist-packages/debian/deb822.py'

# dlocate /usr/lib/python3/dist-packages/debian/deb822.py
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


早くpython3が標準になるといい。


# ubuntuでIPAfont

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

# netplanでDHCPをrenewする

netplan以外では
[Linux Force DHCP Client (dhclient) to Renew IP Address - nixCraft](https://www.cyberciti.biz/faq/howto-linux-renew-dhcp-client-ip-address/)
が参考になる。

netplanで `dhclient -r; dhclient`するとdhcpでIPとってるnicにエリアスが生える。


# friendly-recovery

メモ

```
$ apt-cache show friendly-recovery

Description-en:
Make recovery boot mode more user-friendly Make the recovery boot mode more user-friendly by providing a menu with luggable options.

リカバリーブートモードをより使いやすくするメニューを提供することで、よりユーザーフレンドリーにします。プラグイン可能なオプションを使用しています。
```

- [Ubuntu – パッケージのファイル一覧: friendly-recovery/xenial/all](https://packages.ubuntu.com/ja/xenial/all/friendly-recovery/filelist)
- [FriendlyRecoverySpec - Ubuntu Wiki](https://wiki.ubuntu.com/FriendlyRecoverySpec)


# インストールされているパッケージの一覧

- `dpkg-query --list` or `dpkg -l` - フォーマットされてるのでスクリプトで扱いにくい(COLUMNS=999とかする)。早い。
- `apt list` - 普通こっちか。


# パッケージの更新履歴

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
https://changelogs.ubuntu.com/
からもわかる。

例)
https://changelogs.ubuntu.com/changelogs/binary/s/ssh/1:8.9p1-3/

まあコマンドのほうが全然楽。


# /etc/groupの編集

サーバ以降のときに、
単に vigrで/etc/groupを編集すると
/etc/group- と統合がとれなくなるので

```sh
grpunconv
vigr
grpconv
```

という手順で修正する。たまにやると忘れる。

もちろんpasswdのほうも

```sh
pwunconv
vipw
pwconv
```

# xzのzgrep

`xzgrep` gz,bzip2,xz,lzop,lzma 対応

ただ `lzgrep`がlzoと無関係にaltanativeになってるので、こっちを使うといいと思われる。

あるいは
[BurntSushi/ripgrep: ripgrep recursively searches directories for a regex pattern while respecting your gitignore](https://github.com/BurntSushi/ripgrep)


# ppa

使ってるもの
- [Emacs stable releases : Kevin Kelley](https://launchpad.net/~kelleyk/+archive/ubuntu/emacs)
- [Git stable releases : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/ppa)
- [Git release candidates : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/candidate)
- [New Python Versions : “deadsnakes” team](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa)


18.04LTSから20.04にするときに調べた
```sh
dpkg-query --show -f '${Maintainer}\t${binary:Package}\n' \
| grep -F -e "Matthias Klose" -e "Kevin Kelley" -e "Jonathan Nieder" \
| sort
```
