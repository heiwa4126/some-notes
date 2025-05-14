# Certbot メモ

## snap で certbot を入れたとき snap.certbot.renew.timer が入っている

あるホストの様子

```
$ systemctl list-timers | grep -Fi certbot
Thu 2022-06-23 08:01:00 JST 14h left     Wed 2022-06-22 15:43:10 JST 2h 15min ago snap.certbot.renew.timer     snap.certbot.renew.service

$ systemctl status snap.certbot.renew.timer
* snap.certbot.renew.timer - Timer renew for snap application certbot.renew
     Loaded: loaded (/etc/systemd/system/snap.certbot.renew.timer; enabled; vendor preset: enabled)
     Active: active (waiting) since Wed 2022-06-22 09:41:48 JST; 8h ago
    Trigger: Thu 2022-06-23 08:01:00 JST; 14h left
   Triggers: * snap.certbot.renew.service

Jun 22 09:41:48 sa3 systemd[1]: Started Timer renew for snap application certbot.renew.

$ systemctl status snap.certbot.renew.service
* snap.certbot.renew.service - Service for snap application certbot.renew
     Loaded: loaded (/etc/systemd/system/snap.certbot.renew.service; static; vendor preset: enabled)
     Active: inactive (dead) since Wed 2022-06-22 15:43:13 JST; 2h 13min ago
TriggeredBy: * snap.certbot.renew.timer
    Process: 2447 ExecStart=/usr/bin/snap run --timer=00:00~24:00/2 certbot.renew (code=exited, status=0/SUCCESS)
   Main PID: 2447 (code=exited, status=0/SUCCESS)

Jun 22 15:43:10 sa3 systemd[1]: Starting Service for snap application certbot.renew...
Jun 22 15:43:13 sa3 systemd[1]: snap.certbot.renew.service: Succeeded.
Jun 22 15:43:13 sa3 systemd[1]: Finished Service for snap application certbot.renew.

$ journalctl -r -u snap.certbot.renew.service
(略)
```

[LetsEncrypt の自動更新 snap.certbot.renew を確認する - Qiita](https://qiita.com/woonotch/items/b1208dd792be00e6c447)

## certbot のバックログ数を減らす

うまい方法がない。デフォルトで 1000 なので

```bash
sudo systemctl edit --full snap.certbot.renew.service
```

で `ExecStart=`の行に `--max-log-backups 10` とか追加すればいい。のだが snap が更新されたらもう一度やらないと。

```bash
sudo systemctl edit snap.certbot.renew.service
```

で、元の ExecStart=をコピペして、--max-log-backups をつければいいのだけど、
(/etc/systemd/system/snap.certbot.renew.service.d/override.conf)
これも元の snap の ExecStart=行がかわったら反映されないよね...

snap run の --timer オプションって何?
