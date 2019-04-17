- [MTUの確認](#mtu%E3%81%AE%E7%A2%BA%E8%AA%8D)
- [ジャンボフレーム](#%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%9C%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0)
- [ポートの疎通確認](#%E3%83%9D%E3%83%BC%E3%83%88%E3%81%AE%E7%96%8E%E9%80%9A%E7%A2%BA%E8%AA%8D)

# MTUの確認

```
# ping -M do -s 1472 -c 3 192.168.56.75
(省略)
# ping -M do -s 1473 -c 3 192.168.56.75
ping: local error: Message too long, mtu=1500
```
+18 octetsがMTU


# ジャンボフレーム

[ジャンボフレーム - ArchWiki](https://wiki.archlinux.jp/index.php/%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%9C%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0)

引用:
```
以下のように mtu パラメータを付けて ip を実行してください:

# ip link set ethx mtu <size>

ethx は使用するイーサネットアダプタ (eth0, eth1 など) に、<size> は使用したいフレームのサイズ (1500, 4000, 9000) に置き換えてください。

設定が適用されたことは ip link show | grep mtu で確認できます。 
```

うまくいったら、続けて永続化設定もすること。
上のリンクではsystemdを使った例が掲載されている。

NetworkManagerを使っている場合は
[CentOS7 で nmcli を使って NIC の MTU 値を変更する - らくがきちょう](http://sig9.hatenablog.com/entry/2016/12/29/120000)
参照。


# ポートの疎通確認

Linuxでポートの疎通確認を行う際によく用いるのが
```
nc -w1 -vz <host> <port>
```
だがRHEL7/CentOS7では動きません (そんなのばっかりだRH系は)。

代替策として:
* [&quot;nc -z&quot;の代替コマンド - Qiita](https://qiita.com/lumbermill/items/2309b4257d3618b8c501)
* [Test if remote TCP port is open from a shell script - Stack Overflow](https://stackoverflow.com/questions/4922943/test-if-remote-tcp-port-is-open-from-a-shell-script)

```
timeout 1 bash -c 'cat < /dev/null > /dev/tcp/<host>/<port>'
```
というのが使える。

WindowsではPowerShellで
```
Test-NetConnection <host> -Port <port>
```
というのが使えれば使える。動作条件がよくわからない。
オプションは豊富でtracerouteも出来るが、タイムアウトは無いみたい。

* [Test-NetConnection](https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps)
* [Using the PowerShell Test-NetConnection Cmdlet on Windows](https://blog.ipswitch.com/using-powershell-test-netconnection-cmdlet-windows)