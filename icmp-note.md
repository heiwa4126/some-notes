- [ICMP type=13 のブロック](#icmp-type13-のブロック)
  - [確認方法](#確認方法)

# ICMP type=13 のブロック

脆弱性診断で CVE-1999-0524
> リモートホストが任意の ICMP タイムスタンプリクエストに応答しています。ICMP タイムスタンプ (タイプ 13) リクエストを送信する事で、攻撃者はターゲット上で設定された日付を確認する事が可能となり、時間ベースの認証プロトコルへの攻撃を実行する恐れがあります。複数の Microsoft Windows ホストは意図的に正しくないタイムスタンプを返しますが、通常、実際のシステム時間の1000秒以内の値である事に注意して下さい。

が出るので対応する

* [CVE - CVE-1999-0524](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-1999-0524)
* [NVD - CVE-1999-0524](https://nvd.nist.gov/vuln/detail/CVE-1999-0524)


## 確認方法

```
# nping -c1 --icmp-type 13 -v <hostname or IP address>
```
出典: [How to extend the list of ICMP types for FirewallD](https://access.redhat.com/solutions/2441531)

npingはnmapパッケージに入っている。