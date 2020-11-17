NTP関係メモ


# systemdのtimesyncd

ntpdやchronyでなくてtimesyncd。
NTPサーバになるつもりがないならこれで十分。

設定ファイルは`/etc/systemd/timesyncd.conf`

複数サーバは` `で区切って。

設定後
```sh
sudo systemctl restart systemd-timesyncd.service
sudo systemctl status systemd-timesyncd.service
sudo systemctl enable systemd-timesyncd.service
```

timedatectlはtimesyncdとは直接関係ない。ntpdやchronyともいっしょに使える。

timedatectl については
[第3章 日付と時刻の設定 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-configuring_the_date_and_time)
を参照。

chronycやntpqに相当するものはないみたい。