SNMPの理解がいいかげんなのでまとめる。

- [RHEL7での導入](#rhel7%E3%81%A7%E3%81%AE%E5%B0%8E%E5%85%A5)
- [参考](#%E5%8F%82%E8%80%83)
- [コミュニティ名変更](#%E3%82%B3%E3%83%9F%E3%83%A5%E3%83%8B%E3%83%86%E3%82%A3%E5%90%8D%E5%A4%89%E6%9B%B4)
- [IPで制限](#ip%E3%81%A7%E5%88%B6%E9%99%90)
- [一部をsetできるようにしてみる](#%E4%B8%80%E9%83%A8%E3%82%92set%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B)
- [net-snmpのsnmpdはtrap送信もできる](#net-snmp%E3%81%AEsnmpd%E3%81%AFtrap%E9%80%81%E4%BF%A1%E3%82%82%E3%81%A7%E3%81%8D%E3%82%8B)
  - [本物のsnmptrapdを立てる](#%E6%9C%AC%E7%89%A9%E3%81%AEsnmptrapd%E3%82%92%E7%AB%8B%E3%81%A6%E3%82%8B)
  - [認証失敗トラップを追加してみる](#%E8%AA%8D%E8%A8%BC%E5%A4%B1%E6%95%97%E3%83%88%E3%83%A9%E3%83%83%E3%83%97%E3%82%92%E8%BF%BD%E5%8A%A0%E3%81%97%E3%81%A6%E3%81%BF%E3%82%8B)
- [snmptrap](#snmptrap)

# RHEL7での導入

CentOS7でも同じでしょう(多分)。
```
yum install net-snmp -y
```

デフォルトの設定のままで起動
```
systemctl start snmpd
```

SNMPトラップデーモンはあとで起動することにする。コマンドは
```
systemctl start snmptrapd
```

snmpwalkなどツールを導入。
```
yum install net-snmp-utils -y
```

実行してみる
```
snmpwalk -v 2c -c public localhost system
```

よそのホストから (r1は対象ホスト)
```
snmpwalk -v 2c -c public r1 system
```

# 参考

```
snmpd -H 2>&1| less
```
snmpd.confで使えるディレクティブ一覧


# コミュニティ名変更

上の例でnet-snmpのデフォルト設定だと、起動したとたんにコミュニティ名`public`でいろいろ見えることがわかる。

問題になるかもなので、まずコミュニティ名を`swordfish`に変えてみる。

```
--- a/snmp/snmpd.conf
+++ b/snmp/snmpd.conf
@@ -38,7 +38,8 @@
 # First, map the community name "public" into a "security name"

 #       sec.name  source          community
-com2sec notConfigUser  default       public
+#com2sec notConfigUser  default       public
+com2sec notConfigUser  default       swordfish

 ####
 # Second, map the security name into a group name:
```

で、
```
systemctl restart snmpd
```

publicで見えなくなった & swordfishで見える例
```
# snmpwalk -v 2c -c public localhost system
Timeout: No Response from localhost

# snmpwalk -v 2c -c swordfish localhost system
(略)
```

設定をまとめると(部分)
```
####
# First, map the community name "public" into a "security name"

#       sec.name       source        community
com2sec notConfigUser  default       swordfish

####
# Second, map the security name into a group name:

#       groupName      securityModel securityName
group   notConfigGroup v1            notConfigUser
group   notConfigGroup v2c           notConfigUser

####
# Third, create a view for us to let the group have rights to:

# Make at least  snmpwalk -v 1 localhost -c public system fast again.
#       name           incl/excl     subtree         mask(optional)
view    systemview     included      .1.3.6.1.2.1.1
view    systemview     included      .1.3.6.1.2.1.25.1.1

####
# Finally, grant the group read-only access to the systemview view.

#       group          context sec.model sec.level prefix read       write  notif
access  notConfigGroup ""      any       noauth    exact  systemview none   none
```
これで、
v1とv2cで、
systemサブツリー(.1.3.6.1.2.1.1 sysDescr)以下と
システム稼働時間(.1.3.6.1.2.1.25.1.1 hrSystemUptime)
はgetできる、
ただしsetはできない(notConfig)
設定になる。


稼働時間のget
```
snmpget -v 2c -c swordfish localhost hrSystemUptime.0
```
1/100sec単位なので63日でカンストすることで有名。


おまけ:
snmpwalkだと出力が長いので、MIB1個だけ取ってみる例
```
snmpget -v 2c -c swordfish r1 system.sysDescr.0
```

動作確認だけならもっと引数の少ないsnmpstatusというのも
```
snmpget -v 2c -c swordfish r1
```


# IPで制限

/etc/snmpd.confのcom2setのsourceで制限できる。
(iptables, firewalld, ufwでもできるけど...それは後で)

ここではちょっと/etc/hosts.{allow,deny}でやってみる。

snmpdがlibwrap使ってるか確認。
```
ldd /usr/sbin/snmpd | grep wrap
```

/etc/hosts.allowに
```
snmpd : 127.0.0.0/8 172.31.1.0/24
snmpd : all : deny
```
(172.31.1.0/24は自分のネットワークとする)

hosts_accessは設定ファイルを書き込むだけで効く。再起動はいらない
(それだけに危ない。
`ALL : ALL : deny`書いて保存するだけで死ぬ)

tcpmatchで動作確認する(`yum install tcp_wrappers`)
```
# # localhost
# tcpdmatch snmpd 127.0.0.1
client:   address  127.0.0.1
server:   process  snmpd
access:   granted

# # 自分のネットワーク
# tcpdmatch snmpd 172.31.1.1
client:   address  172.31.1.1
server:   process  snmpd
access:   granted

# # 自分のネットワーク以外
# tcpdmatch snmpd 172.31.2.1
client:   address  172.31.2.1
server:   process  snmpd
access:   denied

# # snmpd以外
# tcpdmatch ssh 172.31.2.1
client:   address  172.31.2.1
server:   process  ssh
access:   granted
```

参考: [2.6.2. TCP Wrapper の設定ファイル - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/security_guide/sect-security_guide-tcp_wrappers_and_xinetd-tcp_wrappers_configuration_files)




# 一部をsetできるようにしてみる

参考:
* [Net-SNMP Tutorial -- snmpset](http://net-snmp.sourceforge.net/tutorial/tutorial-5/commands/snmpset.html)
* [TUT:snmpset - Net-SNMP Wiki](http://www.net-snmp.org/wiki/index.php/TUT:snmpset)

適当に書き込み権与えても、実際に書き込めるところは少ないみたい。
簡単に設定できるので有名なのは `sysName (.1.3.6.1.2.1.1.5)` なので、これで試す


localhostからだけはsysNameをsetできる例
```
####
# First, map the community name "public" into a "security name"

#       sec.name       source        community
com2sec configUser     127.0.0.1     swordfish
com2sec notConfigUser  default       swordfish

####
# Second, map the security name into a group name:

#       groupName      securityModel securityName
group   notConfigGroup v1            notConfigUser
group   notConfigGroup v2c           notConfigUser
group   configGroup    v1            configUser
group   configGroup    v2c           configUser

####
# Third, create a view for us to let the group have rights to:

# Make at least  snmpwalk -v 1 localhost -c public system fast again.
#       name           incl/excl     subtree         mask(optional)
view    systemview     included      .1.3.6.1.2.1.1
view    systemview     included      .1.3.6.1.2.1.25.1.1
view    sysname        included      sysName

####
# Finally, grant the group read-only access to the systemview view.

#       group          context sec.model sec.level prefix read        write     notif
access  notConfigGroup ""      any       noauth    exact  systemview  none      none
access  configGroup    ""      any       noauth    exact  systemview  sysname   none
```
コミュニティはconfig,notconfigで同じにしたけど、
変えてもかまわない。

com2secは上から評価され、マッチしたところで終わるらしい。なので
```
#       sec.name       source        community
com2sec notConfigUser  default       swordfish
com2sec configUser     127.0.0.1     swordfish
```
とすると、localhostもnotConfigUserになってしまう。

localhostからsetのテスト
```
$ snmpget -v 2c -c swordfish localhost sysName.0
SNMPv2-MIB::sysName.0 = STRING: swordfish.example.com

$ snmpset -v 2c -c swordfish localhost sysName.0 s test
SNMPv2-MIB::sysName.0 = STRING: test

$ snmpset -v 2c -c swordfish localhost sysName.0 s swordfish.example.com
SNMPv2-MIB::sysName.0 = STRING: swordfish.example.com
```

localhost以外からsetのテスト
```
$ snmpget -v 2c -c swordfish r1 sysName.0
SNMPv2-MIB::sysName.0 = STRING: swordfish.example.com

$ snmpset -v 2c -c swordfish r1 sysName.0 s test
SNMPv2-MIB::sysName.0 = STRING: test

$ snmpset -v 2c -c swordfish r1 sysName.0 s test
Error in packet.
Reason: noAccess
Failed object: SNMPv2-MIB::sysName.0

$ snmpset -v 1 -c swordfish r1 sysName.0 s test
Error in packet.
Reason: (noSuchName) There is no such variable name in this MIB.
Failed object: SNMPv2-MIB::sysName.0
```
1と2cで返事が違うのが面白い。





# net-snmpのsnmpdはtrap送信もできる

ので試してみる。

同じホストで偽snmptrapdを立てる(tmux, screen, 別ターミナルなどで)
```
# nc -l -u -p 162
```

/etc/snmp/snmpd.confの最後の方に
```
# Note also that you typically only want *one* of the settings:
#trapsink   localhost
trap2sink  localhost  foobar
#informsink localhost
```
とか記述して、 `systemctl restart snmpd` すると
netcatの方に何かが出力される。
これはsnmpdの起動時に 1.3.6.1.6.3.1.1.5.1 (coldStart)が送られたもの。

上の設定で3行あるうち「通常は**1つ**の設定のみが必要」と言ってるのは
[Net-SNMP FAQ](http://www.net-snmp.org/docs/FAQ.html#Where_are_these_traps_sent_to_)
なので、参照のこと
(もちろん複数のマネージャに送るなら、複数行書く必要があります)
。

## 本物のsnmptrapdを立てる

/etc/snmp/snmptrapd.conf
```
# Example configuration file for snmptrapd
#
# No traps are handled by default, you must edit this file!
#
# authCommunity   log,execute,net public
# traphandle SNMPv2-MIB::coldStart    /usr/bin/bin/my_great_script cold

authCommunity log foobar
```
foobarというコミュニティ名でトラップが来たら、ログに出す、という例。

`systemctl restart snmptrapd` して
`systemctl restart snmpd` すると
/var/log/message に
```
Dec 19 07:17:51 ip-172-31-1-110 snmptrapd[4439]: 2018-12-19 07:17:51 localhost [UDP: [127.0.0.1]:39708->[127.0.0.1]:162]:#012DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (6) 0:00:00.06#011SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-MIB::coldStart#011SNMPv2-MIB::snmpTrapEnterprise.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
```
みたいのが出たら成功。

参考:
* [SNMPトラップの送信条件、トラップ抑止方法について – SIOS Tech. Lab](https://tech-lab.sios.jp/archives/9260)
* [snmptrapd 設定方法](https://changineer.info/server/monitoring/monitoring_snmptrapd.html#snmptrapdconf)
* [snmpd発のSNMPTrapに関する備忘 : 弾き語って御免](http://blog.livedoor.jp/wibu/archives/52820100.html)
* [Manpage of SNMPD.EXAMPLES](http://www.net-snmp.org/docs/man/snmpd.examples.html)

## 認証失敗トラップを追加してみる

```
trap2sink  localhost foobar
authtrapenable  1
```
で、コミュニティが正しくないとtrap発生、になる。
authtrapenableは1で有効、2で無効。デフォルトは無効。

```
snmpget -v 2c -c swordfishXXX localhost sysName.0
```
などすると、/var/log/syslogには
```
Dec 19 08:02:39 ip-172-31-1-110 snmptrapd[4439]: 2018-12-19 08:02:39 localhost [UDP: [127.0.0.1]:43230->[127.0.0.1]:162]:#012DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (179104) 0:29:51.04#011SNMPv2-MIB::snmpTrapOID.0 = OID: SNMPv2-MIB::authenticationFailure#011SNMPv2-MIB::snmpTrapEnterprise.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
```
のようなのが出る。簡単なのでSNMPマネージャのテストに便利。

# snmptrap

単にマネージャにtrap送るだけなら`snmptrap`コマンドを使う。
問題はOIDがよくわからん、ということ。

man snmptrapには
```
snmptrap -v 1 -c public manager enterprises.spider test-hub 3 0 '' interfaces.iftable.ifentry.ifindex.1 i 1
```
みたいな例がのっています。


参考:
[SNMPTRAPの発報方法(v1～v3) - Qiita](https://qiita.com/mishikawan/items/4cd9192e38501b6dfc1c)

```
snmptrap -v 2c -c foobar localhost '' netSnmpExperimental \
 netSnmpExperimental.1 s "hogehoge1" \
 netSnmpExperimental.2 s "hogehoge2"
```
みたいな例がのってます。


netSnmpExperimentalは
```
$ snmptranslate -On NET-SNMP-MIB::netSnmpExperimental
.1.3.6.1.4.1.8072.9999

$ snmptranslate -Tp .1.3.6.1.4.1.8072.9999
+--netSnmpExperimental(9999)
   |
   +--netSnmpPlaypen(9999)
```
Net-SNMPのテスト用にいろいろできるものらしい。

参考:
[snmptranslate - mib oidと名前の変換 - うまいぼうぶろぐ](https://hogem.hatenablog.com/entry/20100622/1277215889)


もっと短く
```
snmptrap -v 2c -c foobar localhost '' \
 netSnmpExperimental \
 1 s "hogehoge1" \
 2 s "hogehoge2"
```
と書けるなあ。