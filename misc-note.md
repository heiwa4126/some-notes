その他いろいろノート

- [UFWのログが多すぎるとき](#ufwのログが多すぎるとき)
- [manページをtextに](#manページをtextに)

# UFWのログが多すぎるとき

/var/log/{syslog,kern.log,ufw.log}に UFW BLOCK が山程出てて、
さすがにもういいんじゃないかと思った。

`sudo ufw logging off`

log レベルを調整できる。詳しくは `man ufw` の LOGGING 項を。

現在のロギング状態は `ufw status verbose` で知れる。

参考

- [Ubuntu Manpage: ufw - program for managing a netfilter firewall](http://manpages.ubuntu.com/manpages/cosmic/man8/ufw.8.html)

# manページをtextに

例

```sh
COLUMNS=80 man ls | col -b | less
```
