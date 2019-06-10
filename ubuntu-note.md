# Ubuntu,Debain おぼえがき

AWSやAzureでVM作る時に、毎回やって、毎回忘れるなにかをメモしておく。

- [Ubuntu,Debain おぼえがき](#ubuntudebain-%E3%81%8A%E3%81%BC%E3%81%88%E3%81%8C%E3%81%8D)
- [タイムゾーン](#%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%BE%E3%83%BC%E3%83%B3)
- [locale](#locale)
- [EDITORを変更](#editor%E3%82%92%E5%A4%89%E6%9B%B4)
- [デフォルトユーザ](#%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E3%83%A6%E3%83%BC%E3%82%B6)
  - [AWS](#aws)
  - [Azure](#azure)
- [cloud-init](#cloud-init)
- [userを追加](#user%E3%82%92%E8%BF%BD%E5%8A%A0)
    - [ubuntu on AWS編](#ubuntu-on-aws%E7%B7%A8)
- [sudoでパスワードがいらないのを無効(有効)にする](#sudo%E3%81%A7%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89%E3%81%8C%E3%81%84%E3%82%89%E3%81%AA%E3%81%84%E3%81%AE%E3%82%92%E7%84%A1%E5%8A%B9%E6%9C%89%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B)
- [絶対いれとくパッケージ](#%E7%B5%B6%E5%AF%BE%E3%81%84%E3%82%8C%E3%81%A8%E3%81%8F%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8)
  - [bash-completion](#bash-completion)
- [サービスの再起動が必要かどうか知る](#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%81%AE%E5%86%8D%E8%B5%B7%E5%8B%95%E3%81%8C%E5%BF%85%E8%A6%81%E3%81%8B%E3%81%A9%E3%81%86%E3%81%8B%E7%9F%A5%E3%82%8B)
- [ホストの再起動が必要かどうか知る](#%E3%83%9B%E3%82%B9%E3%83%88%E3%81%AE%E5%86%8D%E8%B5%B7%E5%8B%95%E3%81%8C%E5%BF%85%E8%A6%81%E3%81%8B%E3%81%A9%E3%81%86%E3%81%8B%E7%9F%A5%E3%82%8B)
- [Ubuntu/Debianでapt autoremoveでキープされるkernelパッケージの数](#ubuntudebian%E3%81%A7apt-autoremove%E3%81%A7%E3%82%AD%E3%83%BC%E3%83%97%E3%81%95%E3%82%8C%E3%82%8Bkernel%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%81%AE%E6%95%B0)
- [no_proxy](#noproxy)
- [参考](#%E5%8F%82%E8%80%83)
- [Unattended Upgradesの有効/無効](#unattended-upgrades%E3%81%AE%E6%9C%89%E5%8A%B9%E7%84%A1%E5%8A%B9)
- [`A start job is running for wait for network to be configured` で起動が遅い](#a-start-job-is-running-for-wait-for-network-to-be-configured-%E3%81%A7%E8%B5%B7%E5%8B%95%E3%81%8C%E9%81%85%E3%81%84)
- [yum history みたいのを Debian/Ubuntu で](#yum-history-%E3%81%BF%E3%81%9F%E3%81%84%E3%81%AE%E3%82%92-debianubuntu-%E3%81%A7)
- [netplan.io](#netplanio)
- [Let's Encryptで証明書が更新されたか知る](#lets-encrypt%E3%81%A7%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%81%8C%E6%9B%B4%E6%96%B0%E3%81%95%E3%82%8C%E3%81%9F%E3%81%8B%E7%9F%A5%E3%82%8B)
- [import debian.deb822](#import-debiandeb822)

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


# サービスの再起動が必要かどうか知る

```
# checkrestart -a
```

参考:
[Linuxのパッケージをアップデートしたあとrestartが必要なプロセスを見つける方法](https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)


# ホストの再起動が必要かどうか知る

`/var/run/reboot-required`または`/var/run/reboot-required.pkg`の存在をチェック





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