- [journaldのメモ](#journald%E3%81%AE%E3%83%A1%E3%83%A2)
- [loggerコマンド的なもの](#logger%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E7%9A%84%E3%81%AA%E3%82%82%E3%81%AE)
- [参考](#%E5%8F%82%E8%80%83)

# journaldのメモ

`-l`オプションがよくわからない...`-a`も。「フィールド」とは?

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
