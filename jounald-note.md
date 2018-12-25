journaldのメモ

特定サービスのログだけ見るとき
```
journalctl -lu network
```
(-lで画面幅でなくなる)

最新10行
```
journalctl -lu network -n 10
```
