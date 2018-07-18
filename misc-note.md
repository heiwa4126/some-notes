firewalldノート。

コマンドがめんどくさくてどうしても覚えられない。
嫌い^3だが仕事で使うからしょうがない。


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

reloadとcomplete-reloadの違いは
reloadだと、通信中のセッションが継続すること。

# man page

- [Documentation - Manual Pages - firewall-cmd | firewalld](http://www.firewalld.org/documentation/man-pages/firewall-cmd.html)


# メモ: Pモードと非Pモード

firewall-cmdに
`--permanent`オプションを付けるとパーマネントモードで実行される。

非パーマネントモード
- 処理は即時反映される
- ホストやfirewalldを再起動すると消える

パーマネントモード
- 処理は即時反映されない。firewalldを再起動または再読込しないと反映されない
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

デフォルトのZoneのみ出力(ほぼ役立たず)
```
# firewall-cmd --list-all
```

特定ゾーンのみ出力
```
# firewall-cmd --zone ZONE名 --list-all
```
activeでなくてもOK

デフォルトのゾーンを表示
```
# firewall-cmd --get-default-zone
```
デフォルトゾーン: ZONEの記述がないインタフェースに適応されるゾーン

新しいゾーンの作成
```
# firewall-cmd --permanent --new-zone=<zone>
```
permanentのみ。
permanentなのでreloadが必要

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
servicesとportsはOR条件

***permanentの場合はreloadを忘れないこと***

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
sourcesはOR条件

リッチルールの例
```
firewall-cmd --zone=test1 --add-rich-rule='rule family="ipv4" source address="192.168.200.0/24" port port="135" protocol="tcp" accept'
```

ZONEのルールが適応される順番は:
- sources AND (ports OR services OR rich-rules)で許可。
- ↑にマッチしない時targetが適応される。

sourcesとrich-rulesの関係が直感に反するので注意すること。
(sourcesで先にフィルタされる)

rich-rulesとsourcesは排他的に使うべきだと思う。


# インタフェースにZONEを割り当てる

ZONEの変更や追加。落とし穴だらけ。

Red Hat 7.3以前では(CentOSでも)
NetworkManagerにバグがあって、
コマンドからでも
`nmcli connection modify <interface profile> connection.zone <zone>`
または
`firewall-cmd --permanent --zone=<zone> --add-interface=<interface device>`

手動で
 `/etc/sysconfig/network-scripts/ifcfg-*`書き換えても
`ZONE=xxxx`が消える。

ZONEが消えるのはNetworkManagerをシャットダウンする時なので、

1. NetworkManager停止
1. ifcfg-* にZONE追加
1. NetworkManager開始
1. firewalld再起動

すればよい。

***NetworkManagerを止めてもネットワークは止まらないのでリモートからでもOK***

NetworkManagerの新しい版(正確なバージョンは不明)では修正されているので、
試してみて、ダメなら上記の手順をふむこと。

バグがない場合の手順例)
```
nmcli connection show # プロファイル名を得る(インタフェース名ではダメ)
nmcli connection modify <profile name> connection.zone <zone>
# ↑nameはスペースが入ってることが多いのでクォートすること
# nameに漢字が入ってることが多いのでnmtuiなどで事前に書き換えると楽
firewall-cmd --get-active-zones
```

zones/*.xml中に`<interface name="string"/>`のような記述があるが、
これは7.3でもまともに動かない。ifcfg-*にZONE書くほうがよい。
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

zoneのlist-allの出力中の"taget: default"について。

```
firewall-cmd --zone=test1 --permanent --set-target={ACCEPT|REJECT|DROP|default}
```
でiptablesのIN_<zone名>の最後にターゲットが追加される。
defaultを指定すると、それが削除され、チェインは呼びさし元に帰り
「デフォルトのルール」が適応される。

「デフォルトのルール」はINPUT chainの最後に書かれるものになるわけだが、

実測では:
- DROP ctstate INVALID (不正なパケットはDROP)
- REJECT reject-with icmp-host-prohibite (「サービスしてない」ICMPをつけてリジェクト)

この「デフォルトのルール」を記述した文書も、
指定する方法も見当たらない。


## メモ: icmp-block-inversion

zoneのlist-allの出力中の"icmp-block-inversion:"について。

設定するとICMPフィルターの設定(icmp-blocks)が逆さまになる。
- icmp-block-inversion: no
  - icmp-blocksに記述されたものがブロック。記述のないものは許可
- icmp-block-inversion: yes
  - icmp-blocksに記述されたものが許可。記述のないものはブロック

例)
```
firewall-cmd --zone=test1 --add-icmp-block=echo-reply # pingされても返事しない
firewall-cmd --zone=test1 --list-all
firewall-cmd --zone=test1 --add-icmp-block-inversion
# ↑返事はするけど、echo-requestがブロックされるので、やはりpingには答えない
```


# サービス

ZONEのルールで直にport番号を書くよりも、サービスを書いたほうが汎用性が高い。


定義されているサービス一覧
```
# firewall-cmd --get-services
```

サービスの情報
```
# firewall-cmd --info-service=snmp
```
(snmpは一例)
firewalldのバージョンが古いと`--info-service`がない時がある。
その場合はXMLを直接読む。

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
shortとdescriptionとadd-portはいっぺんに設定できない... ちょっと間抜け

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

`iptables`を使うw

```
# iptables -nvL | less
```

あたりが便利。