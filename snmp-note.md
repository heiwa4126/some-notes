SNMPの理解がいいかげんなのでまとめる。

- [参考](#参考)
- [RHEL7での導入](#rhel7での導入)
  - [コミュニティ名変更](#コミュニティ名変更)
  - [IPで制限](#ipで制限)


# 参考



# RHEL7での導入

```
yum install net-snmp -y
```

デフォルトの設定のままで起動
```
systemctl start snmpd
```

SNMPトラップデーモンはあとで起動する。コマンドは
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

## コミュニティ名変更

net-snmpのデフォルト設定だと、起動したとたんにコミュニティ名`public`でいろいろ見えることがわかる。

さすがに問題なので、まずコミュニティ名を`foobar`に変えてみる。

```
--- a/snmp/snmpd.conf
+++ b/snmp/snmpd.conf
@@ -38,7 +38,8 @@
 # First, map the community name "public" into a "security name"

 #       sec.name  source          community
-com2sec notConfigUser  default       public
+#com2sec notConfigUser  default       public
+com2sec notConfigUser  default       foobar

 ####
 # Second, map the security name into a group name:
```

で、
```
systemctl restart snmpd
```

publicで見えなくなった/foobarで見える例
```
# snmpwalk -v 2c -c public localhost system
Timeout: No Response from localhost

# snmpwalk -v 2c -c foobar localhost system
(略)
```

設定をまとめると(部分)
```
####
# First, map the community name "public" into a "security name"

#       sec.name       source        community
com2sec notConfigUser  default       foobar

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
snmpget -v 2c -c foobar localhost hrSystemUptime.0
```
1/100sec単位なので63日でカンストすることで有名。


おまけ:
snmpwalkだと出力が長いので、MIB1個だけ取ってみる例
```
snmpget -v 2c -c foobar r1 system.sysDescr.0
```

もっと引数の少ないsnmpstatusというのも
```
snmpget -v 2c -c foobar r1
```



## IPで制限

IP制限は/etc/hosts.{allow,deny}のほうでできるはず。
snmpdがlibwrap使ってるか確認。
```
ldd /usr/sbin/snmpd | grep wrap
```
(iptables, firewalld, ufwでもできるけど...それは後で)

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

TODO: /etc/snmpd.confで制限できるはず(難しい)。