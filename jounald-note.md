- [journaldのメモ](#journaldのメモ)
- [loggerコマンド的なもの](#loggerコマンド的なもの)
- [参考](#参考)

# journaldのメモ

`-l`オプションがよくわからない...
jouranlctlでは`-l (--full)`がデフォルトで、
`--no-full`しないと幅で切り詰めない模様。
`-a`も。「フィールド」とは?

とりあえず全部見るなら`--no-pager`オプションが必要。

特定サービスのログだけ見るとき(networkは例。サービス名を書く)
```
journalctl -lxu network
```
(-lで画面幅でなくなる. -xで最初の行だけでなくなる)

最新10行
```
journalctl -lu network -n 10
```

プライオリティ指定
```
journalctl -lxu network -p err
```

最近のエラー
```
journalctl -exlp err
```

`tail -f`的な
```
journalctl -f
```

* [man journalctl の訳]
(https://sites.google.com/site/kandamotohiro/systemd/man-journalctl-no-yi)
* [Arch Wikiのjournal]
(https://wiki.archlinux.jp/index.php/Systemd#Journal)

# loggerコマンド的なもの

journaldはsyslogも収集してるのでloggerで出せばjournaldにも出る。

logger に `--journald`オプションがあるときもある(man logger)

直接出すなら
[systemd-cat](https://www.freedesktop.org/software/systemd/man/systemd-cat.html)
が面白い。これのサンプル参照。pipeとしても使える。

# 参考

* [Red Hat Enterprise Linux 7 22.10. Journal の使用 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/s1-using_the_journal)
* [man journalctl の訳 - kandamotohiro](https://sites.google.com/site/kandamotohiro/systemd/man-journalctl-no-yi)
