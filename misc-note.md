その他いろいろノート

# UFWのログが多すぎるとき

/var/log/{syslog,kern.log,ufw.log}にUFW BLOCKが山程出てて、
さすがにもういいんじゃないかと思った。

`sudo ufw logging off`

logレベルを調整できる。詳しくは `man ufw` のLOGGING項を。


参考
* [Ubuntu Manpage: ufw - program for managing a netfilter firewall](http://manpages.ubuntu.com/manpages/cosmic/man8/ufw.8.html)