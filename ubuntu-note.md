# Ubuntu,Debain おぼえがき

AWSやAzureでVM作る時に、毎回やって、毎回忘れるなにかをメモしておく。

- [Ubuntu,Debain おぼえがき](#ubuntudebain-%e3%81%8a%e3%81%bc%e3%81%88%e3%81%8c%e3%81%8d)
- [タイムゾーン](#%e3%82%bf%e3%82%a4%e3%83%a0%e3%82%be%e3%83%bc%e3%83%b3)
- [locale](#locale)
- [EDITORを変更](#editor%e3%82%92%e5%a4%89%e6%9b%b4)
- [デフォルトユーザ](#%e3%83%87%e3%83%95%e3%82%a9%e3%83%ab%e3%83%88%e3%83%a6%e3%83%bc%e3%82%b6)
  - [AWS](#aws)
  - [Azure](#azure)
- [cloud-init](#cloud-init)
- [userを追加](#user%e3%82%92%e8%bf%bd%e5%8a%a0)
    - [ubuntu on AWS編](#ubuntu-on-aws%e7%b7%a8)
- [sudoでパスワードがいらないのを無効(有効)にする](#sudo%e3%81%a7%e3%83%91%e3%82%b9%e3%83%af%e3%83%bc%e3%83%89%e3%81%8c%e3%81%84%e3%82%89%e3%81%aa%e3%81%84%e3%81%ae%e3%82%92%e7%84%a1%e5%8a%b9%e6%9c%89%e5%8a%b9%e3%81%ab%e3%81%99%e3%82%8b)
- [絶対いれとくパッケージ](#%e7%b5%b6%e5%af%be%e3%81%84%e3%82%8c%e3%81%a8%e3%81%8f%e3%83%91%e3%83%83%e3%82%b1%e3%83%bc%e3%82%b8)
  - [bash-completion](#bash-completion)
- [サービスの再起動が必要かどうか知る (古い)](#%e3%82%b5%e3%83%bc%e3%83%93%e3%82%b9%e3%81%ae%e5%86%8d%e8%b5%b7%e5%8b%95%e3%81%8c%e5%bf%85%e8%a6%81%e3%81%8b%e3%81%a9%e3%81%86%e3%81%8b%e7%9f%a5%e3%82%8b-%e5%8f%a4%e3%81%84)
- [ホストの再起動が必要かどうか知る](#%e3%83%9b%e3%82%b9%e3%83%88%e3%81%ae%e5%86%8d%e8%b5%b7%e5%8b%95%e3%81%8c%e5%bf%85%e8%a6%81%e3%81%8b%e3%81%a9%e3%81%86%e3%81%8b%e7%9f%a5%e3%82%8b)
- [Ubuntu/Debianでapt autoremoveでキープされるkernelパッケージの数](#ubuntudebian%e3%81%a7apt-autoremove%e3%81%a7%e3%82%ad%e3%83%bc%e3%83%97%e3%81%95%e3%82%8c%e3%82%8bkernel%e3%83%91%e3%83%83%e3%82%b1%e3%83%bc%e3%82%b8%e3%81%ae%e6%95%b0)
- [no_proxy](#noproxy)
- [参考](#%e5%8f%82%e8%80%83)
- [Unattended Upgradesの有効/無効](#unattended-upgrades%e3%81%ae%e6%9c%89%e5%8a%b9%e7%84%a1%e5%8a%b9)
- [A start job is running for wait for network to be configured で起動が遅い](#a-start-job-is-running-for-wait-for-network-to-be-configured-%e3%81%a7%e8%b5%b7%e5%8b%95%e3%81%8c%e9%81%85%e3%81%84)
- [yum history みたいのを Debian/Ubuntu で](#yum-history-%e3%81%bf%e3%81%9f%e3%81%84%e3%81%ae%e3%82%92-debianubuntu-%e3%81%a7)
- [netplan.io](#netplanio)
- [Let's Encryptで証明書が更新されたか知る](#lets-encrypt%e3%81%a7%e8%a8%bc%e6%98%8e%e6%9b%b8%e3%81%8c%e6%9b%b4%e6%96%b0%e3%81%95%e3%82%8c%e3%81%9f%e3%81%8b%e7%9f%a5%e3%82%8b)
- [import debian.deb822](#import-debiandeb822)
- [ubuntuでIPAfont](#ubuntu%e3%81%a7ipafont)

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
