- [MTUの確認](#mtu%E3%81%AE%E7%A2%BA%E8%AA%8D)
- [ジャンボフレーム](#%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%9C%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0)

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


