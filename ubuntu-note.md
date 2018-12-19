# 概要

Ubuntu,Debainおぼえがき。

AWSやAzureでVM作る時に、毎回やって、毎回忘れるなにかをメモしておく。

- [概要](#概要)
- [タイムゾーン](#タイムゾーン)
- [locale](#locale)
- [EDITORを変更](#editorを変更)
- [デフォルトユーザ](#デフォルトユーザ)
  - [AWS](#aws)
  - [Azure](#azure)
- [userを追加](#userを追加)
    - [ubuntu on AWS編](#ubuntu-on-aws編)
- [sudoでパスワードがいらないのを無効(有効)にする](#sudoでパスワードがいらないのを無効有効にする)
- [絶対いれとくパッケージ](#絶対いれとくパッケージ)
  - [bash-completion](#bash-completion)
- [サービスの再起動が必要かどうか知る](#サービスの再起動が必要かどうか知る)
- [ホストの再起動が必要かどうか知る](#ホストの再起動が必要かどうか知る)
- [Ubuntu/Debianでapt autoremoveでキープされるkernelパッケージの数](#ubuntudebianでapt-autoremoveでキープされるkernelパッケージの数)
- [no_proxy](#no_proxy)
- [Unattended Upgradesの有効/無効](#unattended-upgradesの有効無効)

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

# Unattended Upgradesの有効/無効

Unattended Upgradesを有効にすると、セキュリティアップグレードを勝手に実行する。

起動しっぱなしのサーバたと便利な機能だが、
たまに起動するテスト用サーバだと、ブート直後にアップグレード処理が走って、ものすごく遅いことがある。

* [How to Enable / Disable Unattended Upgrades in Ubuntu 16.04](https://linoxide.com/ubuntu-how-to/enable-disable-unattended-upgrades-ubuntu-16-04/)
* [Disable Automatic Updates on Ubuntu 18.04 Bionic Beaver Linux - LinuxConfig.org](https://linuxconfig.org/disable-automatic-updates-on-ubuntu-18-04-bionic-beaver-linux)
* [6.7. システムを最新の状態に保つ](https://debian-handbook.info/browse/ja-JP/stable/sect.regular-upgrades.html)
* [unattended-upgradesはインストールしただけでは動かない - orangain flavor](https://orangain.hatenablog.com/entry/unattended-upgrades)

`/etc/apt/apt.conf.d/20auto-upgrades` を編集して `APT::Periodic::Unattended-Upgrade` の値を `"0"` に変更すると無効。

