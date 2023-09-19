[SELinuxとFirewallを有効にしたまま443でsshを受けるように設定する \- Qiita](https://qiita.com/yamada-hakase/items/9121be88c94f79e6cc65)

RHEL8でSElinuxが有効のまま22/tcp以外もlistenするようにしたときのメモ

semanageは

```
yum install policycoreutils-python-utils
```

22/tcpみてみる

```
# semanage port -l | grep 22 | grep ssh
ssh_port_t                     tcp      22
```

```
semanage port -a -t ssh_port_t -p tcp ポート番号
```

使いたいポートが`semanage port -l | grep ポート番号`で出てくるようだったら
`-a`のかわりに`-m`オプション
