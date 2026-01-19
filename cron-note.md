systemd.timer とかあるけど、まだまだ現役。

# crontab -e の時刻指定が不安だったら

[Crontab.guru - The cron schedule expression editor](https://crontab.guru/)

これは便利。

# cronのタイムゾーン

cron は現地時間を使用する。これを UTC にするのは結構面倒。

あと、すぐ反映させるなら cron の再起動も必要。
普通はタイムゾーン最初に設定して kernel 更新とかあって再起動するから気が付かないけど。

```bash
sudo timedatectl set-timezone Asia/Tokyo
sudo systemctl restart cron
```
