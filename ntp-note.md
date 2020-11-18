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

systemd-time*.service 2つあるね。これは?

- systemd-timedated.service - [systemd-timedated.service](https://www.freedesktop.org/software/systemd/man/systemd-timedated.service.html)
- systemd-timesyncd.service - [systemd-timesyncd.service](https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html)

timedatedの方はtimedatectlのなにからしい。

> systemd-timedated.serviceは、システムクロックとタイムゾーンを変更したり、ネットワーク時刻の同期を有効/無効にしたりするためのメカニズムとして使用できるシステムサービスです。 systemd-timedatedはリクエストに応じて自動的にアクティブになり、使用されない場合は自動的に終了します。

> systemd-timesyncdは、ローカルシステムクロックをリモートネットワークタイムプロトコルサーバーと同期するために使用できるシステムサービスです。 また、クロックが同期されるたびにローカル時間をディスクに保存し、これを使用して、システムにバッテリバッファ付きRTCチップがない場合でも、システムのリアルタイムクロックをその後の再起動時に確実に単調に進めるように進めます。
> systemd-timesyncdサービスは、特にSNTPのみを実装します。 この最小限のサービスは、システムクロックを大きなオフセットに設定するか、小さなデルタにゆっくりと調整します。 より複雑なユースケースは、systemd-timesyncdではカバーされていません。

AzureではHyper-VのPHC0が使えるから、chronyのほうがいいな。

