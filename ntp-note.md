# NTP 関係メモ

- [NTP 関係メモ](#ntp-関係メモ)
  - [systemd の timesyncd](#systemd-の-timesyncd)

## systemd の timesyncd

ntpd や chrony でなくて timesyncd (SNTP)。
NTP サーバになるつもりがないならこれで十分。

設定ファイルは`/etc/systemd/timesyncd.conf`

複数サーバは ` ` で区切って。

設定後

```sh
sudo systemctl restart systemd-timesyncd.service
sudo systemctl status systemd-timesyncd.service
sudo systemctl enable systemd-timesyncd.service
```

timedatectl は timesyncd とは直接関係ない。ntpd や chrony ともいっしょに使える。

timedatectl については
[第 3 章 日付と時刻の設定 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-configuring_the_date_and_time)
を参照。

chronyc や ntpq に相当するものはないみたい。← 嘘でした。

```bash
timedatectl timesync-status
timedatectl show-timesync
```

がそれ。

timedatectl は systemd-timesyncd の UI も兼ねてる。違う機能が 1 個のコマンドに入ってるのでややこしい。

[timedatectl](https://www.freedesktop.org/software/systemd/man/timedatectl.html)

例えば、systemd-timesyncd が動いていないと

```bash
timedatectl timesync-status
timedatectl show-timesync
```

はエラーになる。

```bash
timedatectl set-ntp false
```

は ntpd, chronyd, systemd-timesyncd を停止する。
これらの.service が ntp であるかどうかはどうやってわかる? time-set.target time-sync.target

systemd-time\*.service 2 つあるね。これは?

- systemd-timedated.service - [systemd-timedated.service](https://www.freedesktop.org/software/systemd/man/systemd-timedated.service.html)
- systemd-timesyncd.service - [systemd-timesyncd.service](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html)

timedated の方は timedatectl のなにからしい。

> systemd-timedated.service は、システムクロックとタイムゾーンを変更したり、ネットワーク時刻の同期を有効/無効にしたりするためのメカニズムとして使用できるシステムサービスです。 systemd-timedated はリクエストに応じて自動的にアクティブになり、使用されない場合は自動的に終了します。

> systemd-timesyncd は、ローカルシステムクロックをリモートネットワークタイムプロトコルサーバーと同期するために使用できるシステムサービスです。 また、クロックが同期されるたびにローカル時間をディスクに保存し、これを使用して、システムにバッテリバッファ付き RTC チップがない場合でも、システムのリアルタイムクロックをその後の再起動時に確実に単調に進めるように進めます。
> systemd-timesyncd サービスは、特に SNTP のみを実装します。 この最小限のサービスは、システムクロックを大きなオフセットに設定するか、小さなデルタにゆっくりと調整します。 より複雑なユースケースは、systemd-timesyncd ではカバーされていません。

Azure では Hyper-V の PHC0 が使えるから、chrony のほうがいいな。
