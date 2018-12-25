journaldのメモ

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
