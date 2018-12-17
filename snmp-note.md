SNMPの理解がいいかげんなのでまとめる。

- [参考](#参考)
- [RHEL7での導入](#rhel7での導入)


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

よそのホストから　(r1は対象ホスト)
```
snmpwalk -v 2c -c public r1 system
```

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