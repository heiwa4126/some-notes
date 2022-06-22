systemd.timerとかあるけど、まだまだ現役。

# crontab -e の時刻指定が不安だったら

[Crontab.guru - The cron schedule expression editor](https://crontab.guru/)

これは便利。

# cronのタイムゾーン

cronは現地時間を使用する。これをUTCにするのは結構面倒。

あと、すぐ反映させるならcronの再起動も必要。

```bash
sudo timedatectl set-timezone Asia/Tokyo
sudo systemctl restart cron
```
