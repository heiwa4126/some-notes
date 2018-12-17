- [ICMP type=13 のブロック](#icmp-type13-のブロック)
  - [確認方法](#確認方法)
  - [テスト](#テスト)
  - [firewalldがある場合](#firewalldがある場合)
  - [RHEL7系でiptablesルール永続化](#rhel7系でiptablesルール永続化)
  - [TODO](#todo)

# ICMP type=13 のブロック

脆弱性診断で CVE-1999-0524
> リモートホストが任意の ICMP タイムスタンプリクエストに応答しています。ICMP タイムスタンプ (タイプ 13) リクエストを送信する事で、攻撃者はターゲット上で設定された日付を確認する事が可能となり、時間ベースの認証プロトコルへの攻撃を実行する恐れがあります。複数の Microsoft Windows ホストは意図的に正しくないタイムスタンプを返しますが、通常、実際のシステム時間の1000秒以内の値である事に注意して下さい。

が出るので対応する。

* [CVE - CVE-1999-0524](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0524)
* [NVD - CVE-1999-0524](https://nvd.nist.gov/vuln/detail/CVE-1999-0524)

普通はホスト単位でブロックするものではないらしいが、客が気にするとか、上司が気にするとか、いろいろあるので。


## 確認方法

```
# nping -c1 --icmp-type 13 -v <hostname or IP address>
```
出典: [How to extend the list of ICMP types for FirewallD](https://access.redhat.com/solutions/2441531)

npingはnmapパッケージに入っている。
```
yum install nmap
```

実行例:
```
# nping -c1 --icmp-type 13 -v ip-172-31-1-110

Starting Nping 0.6.40 ( http://nmap.org/nping ) at 2018-12-17 05:39 UTC
SENT (0.0066s) ICMP [172.31.1.155 > 172.31.1.110 Timestamp request (type=13/code=0) id=39337 seq=1 orig=0 recv=0 trans=0] IP [ttl=64 id=34556 proto=1 csum=0x9891 iplen=40 ]
RCVD (0.0071s) ICMP [172.31.1.110 > 172.31.1.155 Timestamp reply (type=14/code=0) id=39337 seq=1 orig=0 recv=20374573 trans=20374573] IP [ttl=64 id=9740 proto=1 csum=0xf981 iplen=40 ]

Max rtt: 0.395ms | Min rtt: 0.395ms | Avg rtt: 0.395ms
Raw packets sent: 1 (40B) | Rcvd: 1 (40B) | Lost: 0 (0.00%)
Tx time: 0.00114s | Tx bytes/s: 34995.63 | Tx pkts/s: 874.89
Rx time: 1.00172s | Rx bytes/s: 39.93 | Rx pkts/s: 1.00
Nping done: 1 IP address pinged in 1.01 seconds
```
返事があったのがわかる。

## テスト

AWSで試す。のRHEL/Cent7のEC2インスタンスではfirewalldが入ってない。
うかつにfirewalldを有効にして、つながらなくなるのも怖いので、iptablesでまず試す。

現状のルールを確認
```
iptables -nvL
```

ルール追加
```
iptables -A INPUT -p icmp --icmp-type 13 -j DROP
```
必要ならソースやディスティネーションを追加。

再実行
```
# nping -c1 --icmp-type 13 -v ip-172-31-1-110

Starting Nping 0.6.40 ( http://nmap.org/nping ) at 2018-12-17 05:47 UTC
SENT (0.0054s) ICMP [172.31.1.155 > 172.31.1.110 Timestamp request (type=13/code=0) id=12921 seq=1 orig=0 recv=0 trans=0] IP [ttl=64 id=59016 proto=1 csum=0x3905 iplen=40 ]

Max rtt: N/A | Min rtt: N/A | Avg rtt: N/A
Raw packets sent: 1 (40B) | Rcvd: 0 (0B) | Lost: 1 (100.00%)
Tx time: 0.00114s | Tx bytes/s: 35026.27 | Tx pkts/s: 875.66
Rx time: 1.00132s | Rx bytes/s: 0.00 | Rx pkts/s: 0.00
Nping done: 1 IP address pinged in 1.01 seconds
```
dropされるのが確認できた。

## firewalldがある場合

けっこうめんどくさい.

[centos - Block ICMP timestamp & timestamp reply with firewalld - Server Fault](https://serverfault.com/questions/677084/block-icmp-timestamp-timestamp-reply-with-firewalld)

1. ICMPのルールを追加する
2. 有効にする

の2ステップ。

## RHEL7系でiptablesルール永続化

このルールをどうやって永続化させるか...環境によってかなり違いそう。

とりあえずAWSの場合。firewalldを動かさない環境での設定。

標準ではiptablesがサービスになっていない。
```
yum install iptables-services
```

いきなり起動すると
* /etc/sysconfig/iptables

が有効になってしまうので、etckeeperなどを使っていない場合は、適宜バックアップをとって
```
/usr/libexec/iptables/iptables.init save
```
を実行してルールを保存。

安全のためにipv4、ipv6のとも無効にしておく(こうしておけば再起動すればルールは消えるから)。
```
systemctl disable iptables
systemctl disable ip6tables
```

で、
```
systemctl start iptables
```
を実行して、変なことがおきないことを確認。

最後にipv4の方だけ有効にしておく。
```
systemctl enable iptables
```

再起動して確認。


## TODO

- firewalldとiptablesが両方共有効になっているとどうなるかを確認する。
- Debian/Ubuntuは?


