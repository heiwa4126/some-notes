# Linux のネットワーク関連のメモ

- [Linux のネットワーク関連のメモ](#linux-のネットワーク関連のメモ)
  - [MTU の確認](#mtu-の確認)
  - [ジャンボフレーム](#ジャンボフレーム)
  - [ポートの疎通確認](#ポートの疎通確認)
  - [ネットワークパフォーマンスをみるツール](#ネットワークパフォーマンスをみるツール)
  - [TCP BBR](#tcp-bbr)
  - [curl のテスト](#curl-のテスト)
  - [Get-NetNeighbor](#get-netneighbor)

## MTU の確認

```terminal
# ping -M do -s 1472 -c 3 192.168.56.75
(省略)

# ping -M do -s 1473 -c 3 192.168.56.75
ping: local error: Message too long, mtu=1500
```

+18 octets が MTU

## ジャンボフレーム

[ジャンボフレーム - ArchWiki](https://wiki.archlinux.jp/index.php/%E3%82%B8%E3%83%A3%E3%83%B3%E3%83%9C%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0)

引用:

```text
以下のように mtu パラメータを付けて ip を実行してください:

# ip link set ethx mtu <size>

ethx は使用するイーサネットアダプタ (eth0, eth1 など) に、<size> は使用したいフレームのサイズ (1500, 4000, 9000) に置き換えてください。

設定が適用されたことは ip link show | grep mtu で確認できます。
```

うまくいったら、続けて永続化設定もすること。
上のリンクでは systemd を使った例が掲載されている。

NetworkManager を使っている場合は
[CentOS7 で nmcli を使って NIC の MTU 値を変更する - らくがきちょう](http://sig9.hatenablog.com/entry/2016/12/29/120000)
参照。

## ポートの疎通確認

いつのまにか

```sh
sudo yum install nmap-ncat -y
```

でふつうに`-z`の使える nc になります

以下古い:

Linux でポートの疎通確認を行う際によく用いるのが

```sh
nc -w1 -vz <host> <port>
```

だが RHEL7/CentOS7 では動きません (そんなのばっかりだ RH 系は)。

代替策として:

- [&quot;nc -z&quot;の代替コマンド - Qiita](https://qiita.com/lumbermill/items/2309b4257d3618b8c501)
- [Test if remote TCP port is open from a shell script - Stack Overflow](https://stackoverflow.com/questions/4922943/test-if-remote-tcp-port-is-open-from-a-shell-script)

```sh
timeout 1 bash -c 'cat < /dev/null > /dev/tcp/<host>/<port>'
```

というのが使える。

Windows では PowerShell で

```sh
Test-NetConnection <host> -Port <port>
```

というのが使えれば使える。動作条件がよくわからない。
オプションは豊富で traceroute も出来るが、タイムアウトは無いみたい。

- [Test-NetConnection](https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps)
- [Using the PowerShell Test-NetConnection Cmdlet on Windows](https://blog.ipswitch.com/using-powershell-test-netconnection-cmdlet-windows)

## ネットワークパフォーマンスをみるツール

TUI

- nload
- iftop

[Linux でネットワークの監視を行えるモニタリングコマンド 20 選 | 俺的備忘録 〜なんかいろいろ〜](https://orebibou.com/2014/09/linux%E3%81%A7%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%81%AE%E7%9B%A3%E8%A6%96%E3%82%92%E8%A1%8C%E3%81%88%E3%82%8B%E3%83%A2%E3%83%8B%E3%82%BF%E3%83%AA%E3%83%B3%E3%82%B0%E3%82%B3/)

実測するなら

- iperf
- netperf

- [ネットワーク測定ツール iperf の使い方 - Qiita](https://qiita.com/takish/items/bff7a1df712d475432df)
- [iperf3 コマンド使い方、オプション一覧 - Qiita](https://qiita.com/yokoc1322/items/bfd8b6e69d6bdb3bb1c6)
- [NetPerf (Windows 版) で VPN のスループットを測ってみた。](http://takaq1.plala.jp/contents/windows/netperf/index.html)

## TCP BBR

[Google Cloud Platform Japan 公式ブログ: 輻輳制御の新アルゴリズム TCP BBR を GCP に導入](https://cloudplatform-jp.googleblog.com/2017/08/TCP-BBR-congestion-control-comes-to-GCP-your-Internet-just-got-faster.html)

Ubuntu 1804LTS だと、カーネルがわりと新しいので、TCP BBR が簡単に切り替えられる。
(Amazon Linux 2 も OK)

使えるアルゴリズムのリスト

```termianl
$ cat /proc/sys/net/ipv4/tcp_available_congestion_control
reno cubic bbr
```

もし bbr がなければ

```sh
sudo modprobe tcp_bbr
```

してみる。

現在のアルゴリズム

```sh
$ cat /proc/sys/net/ipv4/tcp_congestion_control
cubic
```

現在のキューイングアルゴリズム

```sh
$ cat /proc/sys/net/core/default_qdisc
pfifo_fast
```

bbr に一時的にしてみるなら

```sh
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr
```

パーマネントにするなら
適当なエディタで
`/etc/sysctl.d/10-tcp-bbr.conf`のようなファイルを作成。

```conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

ワンライナーなら

```sh
echo -e 'net.core.default_qdisc=fq\nnet.ipv4.tcp_congestion_control=bbr' > /etc/sysctl.d/10-tcp-bbr.conf
```

再起動。

参考:

- [コラム - グーグルのクラウドを支えるテクノロジー | 第 22 回　パケットロスに基づかない新しい輻輳制御の仕組み ― BBR（前編）｜ CTC 教育サービス 研修/トレーニング](https://www.school.ctc-g.co.jp/columns/nakai2/nakai222.html)
- [コラム - グーグルのクラウドを支えるテクノロジー | 第 23 回　パケットロスに基づかない新しい輻輳制御の仕組み ― BBR（後編）｜ CTC 教育サービス 研修/トレーニング](https://www.school.ctc-g.co.jp/columns/nakai2/nakai223.html)
- [RHEL 8 における TCP BBR サポート](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/networking_considerations-in-adopting-rhel-8#tcp_bbr_networking)
- [How to configure TCP BBR as the default congestion control algorithm? - Red Hat Customer Portal](https://access.redhat.com/solutions/3713681)

## curl のテスト

curl でネットのテストをするときに
リダイレクトするサイトを使うと、
body が少ないので、ちょっと楽。

例)

```terminal
$ curl https://google.com/
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>
```

## Get-NetNeighbor

[ASCII.jp：Windows のコマンドで LAN 内のデバイスを探す (1/2)](https://ascii.jp/elem/000/004/066/4066675/)
