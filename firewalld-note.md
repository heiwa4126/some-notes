firewalld ノート

コマンドがめんどくさくてどうしても覚えられない。
嫌い^3 だが仕事で使うからしょうがない。

- [よく使うコマンド](#よく使うコマンド)
  - [firewalldが動作しているか確認](#firewalldが動作しているか確認)
  - [firewalldの再起動](#firewalldの再起動)
  - [firewalldの再読込](#firewalldの再読込)
- [man page](#man-page)
- [メモ: Pモードと非Pモード](#メモ-pモードと非pモード)
- [ゾーン](#ゾーン)
- [インタフェースにZONEを割り当てる](#インタフェースにzoneを割り当てる)
- [ゾーン情報の保存先](#ゾーン情報の保存先)
  - [メモ: "taget: default"](#メモ-taget-default)
  - [メモ: icmp-block-inversion](#メモ-icmp-block-inversion)
- [サービス](#サービス)
- [めんどくさいときは](#めんどくさいときは)

# よく使うコマンド

## firewalldが動作しているか確認

```
$ systemctl status firewalld
```

または

```
# firewall-cmd --stat
```

## firewalldの再起動

```
# systemctl restart firewalld
```

## firewalldの再読込

実によく使うコマンド

```
# firewall-cmd --reload
```

または

```
# firewall-cmd --complete-reload
```

reload と complete-reload の違いは
reload だと、通信中のセッションが継続すること。

# man page

- [Documentation - Manual Pages - firewall-cmd | firewalld](http://www.firewalld.org/documentation/man-pages/firewall-cmd.html)

# メモ: Pモードと非Pモード

firewall-cmd に
`--permanent`オプションを付けるとパーマネントモードで実行される。

非パーマネントモード

- 処理は即時反映される
- ホストや firewalld を再起動すると消える

パーマネントモード

- 処理は即時反映されない。firewalld を再起動または再読込しないと反映されない
- ホストを再起動しても消えない

# ゾーン

全ゾーン出力

```
# firewall-cmd --list-all-zones
```

実際に使われている("active"な)ゾーンと、インタフェースを出力

```
# firewall-cmd --get-active-zone
```

デフォルトの Zone のみ出力(ほぼ役立たず)

```
# firewall-cmd --list-all
```

特定ゾーンのみ出力

```
# firewall-cmd --zone ZONE名 --list-all
```

active でなくても OK

デフォルトのゾーンを表示

```
# firewall-cmd --get-default-zone
```

デフォルトゾーン: ZONE の記述がないインタフェースに適応されるゾーン

新しいゾーンの作成

```
# firewall-cmd --permanent --new-zone=<zone>
```

permanent のみ。
permanent なので reload が必要

ゾーンの作成例

```
firewall-cmd --permanent --new-zone=test1
firewall-cmd --reload
firewall-cmd --zone=test1 --list-all
firewall-cmd --zone=test1 --add-service=ssh # 非[P]でsshを追加
firewall-cmd --zone=test1 --list-all
firewall-cmd --permanent --zone=test1 --list-all # [P]なのでsshが表示されない
```

許可するサービスとポートの追加

```
firewall-cmd --permanent --zone=test1 \
 --add-service=ssh \
 --add-port=1234/tcp
```

いっぺんに追加しても、バラで追加しても。
services と ports は OR 条件

**_permanentの場合はreloadを忘れないこと_**

許可するサービスとポートの追加

```
firewall-cmd --permanent --zone=test1 \
 --add-service=ssh \
 --add-port=1234/tcp
```

許可するアドレスの追加

```
firewall-cmd --permanent --zone=test1 \
 --add-source=111.222.111.0/24 \
 --add-source=111.222.222.0/24
```

sources は OR 条件

リッチルールの例

```
firewall-cmd --zone=test1 --add-rich-rule='rule family="ipv4" source address="192.168.200.0/24" port port="135" protocol="tcp" accept'
```

ZONE のルールが適応される順番は:

- sources AND (ports OR services OR rich-rules)で許可。
- ↑にマッチしない時 target が適応される。

sources と rich-rules の関係が直感に反するので注意すること。
(sources で先にフィルタされる)

rich-rules と sources は排他的に使うべきだと思う。

# インタフェースにZONEを割り当てる

ZONE の変更や追加。落とし穴だらけ。

Red Hat 7.3 以前では(CentOS でも)
NetworkManager にバグがあって、
コマンドからでも
`nmcli connection modify <interface profile> connection.zone <zone>`
または
`firewall-cmd --permanent --zone=<zone> --add-interface=<interface device>`

手動で
`/etc/sysconfig/network-scripts/ifcfg-*`書き換えても
`ZONE=xxxx`が消える。

ZONE が消えるのは NetworkManager をシャットダウンする時なので、

1. NetworkManager 停止
1. ifcfg-\* に ZONE 追加
1. NetworkManager 開始
1. firewalld 再起動

すればよい。

**_NetworkManagerを止めてもネットワークは止まらないのでリモートからでもOK_**

NetworkManager の新しい版(正確なバージョンは不明)では修正されているので、
試してみて、ダメなら上記の手順をふむこと。

バグがない場合の手順例)

```
nmcli connection show # プロファイル名を得る(インタフェース名ではダメ)
nmcli connection modify <profile name> connection.zone <zone>
# ↑nameはスペースが入ってることが多いのでクォートすること
# nameに漢字が入ってることが多いのでnmtuiなどで事前に書き換えると楽
firewall-cmd --get-active-zones
```

zones/*.xml 中に`<interface name="string"/>`のような記述があるが、
これは 7.3 でもまともに動かない。ifcfg-*に ZONE 書くほうがよい。
`firewall-cmd --permanent --zone=<zone> --add-interface=<interface device>`
だと両方に書き込むみたいだけど、混乱の元かも。

# ゾーン情報の保存先

`/etc/firewalld/zones/<zone名>.xml`

追加したゾーンと
プリセットのゾーンを変更した場合は↑に保存される。

プリセットのゾーンは
`/usr/lib/firewalld/zones/<zone名>.xml`

例)

```
# sshとsnmp追加
firewall-cmd --permanent --zone=test1 --add-service=ssh --add-service=snmp
# pingに答えない
firewall-cmd --permanent --zone=test1 --add-icmp-block=echo-reply

cat /etc/firewalld/zones/test1.xml

<?xml version="1.0" encoding="utf-8"?>
<zone>
  <service name="ssh"/>
  <service name="snmp"/>
  <icmp-block name="echo-reply"/>
</zone>
```

## メモ: "taget: default"

zone の list-all の出力中の"taget: default"について。

```
firewall-cmd --zone=test1 --permanent --set-target={ACCEPT|REJECT|DROP|default}
```

で iptables の IN\_<zone 名>の最後にターゲットが追加される。
default を指定すると、それが削除され、チェインは呼びさし元に帰り
「デフォルトのルール」が適応される。

「デフォルトのルール」は INPUT chain の最後に書かれるものになるわけだが、

実測では:

- DROP ctstate INVALID (不正なパケットは DROP)
- REJECT reject-with icmp-host-prohibite (「サービスしてない」ICMP をつけてリジェクト)

この「デフォルトのルール」を記述した文書も、
指定する方法も見当たらない。

## メモ: icmp-block-inversion

zone の list-all の出力中の"icmp-block-inversion:"について。

設定すると ICMP フィルターの設定(icmp-blocks)が逆さまになる。

- icmp-block-inversion: no
  - icmp-blocks に記述されたものがブロック。記述のないものは許可
- icmp-block-inversion: yes
  - icmp-blocks に記述されたものが許可。記述のないものはブロック

例)

```
firewall-cmd --zone=test1 --add-icmp-block=echo-reply # pingされても返事しない
firewall-cmd --zone=test1 --list-all
firewall-cmd --zone=test1 --add-icmp-block-inversion
# ↑返事はするけど、echo-requestがブロックされるので、やはりpingには答えない
```

# サービス

ZONE のルールで直に port 番号を書くよりも、サービスを書いたほうが汎用性が高い。

定義されているサービス一覧

```
# firewall-cmd --get-services
```

サービスの情報

```
# firewall-cmd --info-service=snmp
```

(snmp は一例)
firewalld のバージョンが古いと`--info-service`がない時がある。
その場合は XML を直接読む。

プリセットのサービスは `/usr/lib/firewalld/services/<service名>.xml`

追加した `/etc/firewalld/services/<service名>.xml`

以下作業中

```
firewall-cmd --permanent --new-service oracle12
firewall-cmd --permanent --service=oracle12 --set-short="oracle 12c"
firewall-cmd --permanent --service=oracle12 --set-description="Oracle Database 12c"
firewall-cmd --permanent --service=oracle12 \
 --add-port=1521/tcp \
 --add-port=5500/tcp
```

short と description と add-port はいっぺんに設定できない... ちょっと間抜け

```
firewall-cmd --permanent --new-service clusterpro_webmanager
firewall-cmd --permanent --service=clusterpro_webmanager --set-short="CLUSTERPRO WebManager"
firewall-cmd --permanent --service=clusterpro_webmanager --set-description="CLUSTERPRO WebManager"
firewall-cmd --permanent --service=clusterpro_webmanager --add-port=29003/tcp
```

設定したら

```
firewall-cmd --reload
```

でリロード。

# めんどくさいときは

`iptables`を使う w

```
# iptables -nvL | less
```

あたりが便利。
