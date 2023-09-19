systemd .timer のメモ

# 参考リンク

- [systemd.timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [systemd/タイマー - ArchWiki](https://wiki.archlinux.jp/index.php/Systemd/%E3%82%BF%E3%82%A4%E3%83%9E%E3%83%BC)
- [systemdでtimerの作り方（最小限のサンプル） - Qiita](https://qiita.com/aosho235/items/7656d5568af8f48b2dc1)

# ざっくり

.serviceと.timerの2本立て。

リストは

```bash
systemctl list-timers
```

# cronからの移行

[cron を置き換える](https://wiki.archlinux.jp/index.php/Systemd/%E3%82%BF%E3%82%A4%E3%83%9E%E3%83%BC#cron_.E3.82.92.E7.BD.AE.E3.81.8D.E6.8F.9B.E3.81.88.E3.82.8B)

> cron では簡単にできることが、タイマーユニットを使用する場合、難しかったり不可能であったりすることがいくつか存在します

systemd-cron, systemd-cron-next というのもある。

- [systemd-cron/systemd-cron: systemd units to run cron scripts](https://github.com/systemd-cron/systemd-cron)
- [systemd-cron/systemd-cron-next: compatibility layer for crontab-to-systemd timers framework](https://github.com/systemd-cron/systemd-cron-next)
