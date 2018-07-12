# Ubuntu心覚え

AWSやAzureでVM作る時に、毎回やって、毎回忘れるなにかをメモしておく。

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
