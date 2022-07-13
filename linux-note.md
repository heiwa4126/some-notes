# Linux雑多メモ

便利なツールなんだけど使用頻度が低いと思い出せないやつなんかをメモ

# neofetch

[GitHub - dylanaraps/neofetch: 🖼️ A command-line system information tool written in bash 3.2+](https://github.com/dylanaraps/neofetch)

ロゴ出すやつ(「情報だすやつ」ですね)。

```
$ neofetch
            .-/+oossssoo+/-.               heiwa4126@sever1
        `:+ssssssssssssssssss+:`           ---------
      -+ssssssssssssssssssyyssss+-         OS: Ubuntu 18.04.4 LTS x86_64
    .ossssssssssssssssssdMMMNysssso.       Host: KVM RHEL 6.2.0 PC
   /ssssssssssshdmmNNmmyNMMMMhssssss/      Kernel: 4.15.0-99-generic
  +ssssssssshmydMMMMMMMNddddyssssssss+     Uptime: 10 days, 15 hours, 20 mins
 /sssssssshNMMMyhhyyyyhmNMMMNhssssssss/    Packages: 1330
.ssssssssdMMMNhsssssssssshNMMMdssssssss.   Shell: bash 4.4.20
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Terminal: /dev/pts/0
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   CPU: Westmere E56xx/L56xx/X56xx (Nehalem-C) (2) @ 2.400GHz
ossyNMMMNyMMhsssssssssssssshmmmhssssssso   GPU: Vendor 1234 Device 1111
+sssshhhyNMMNyssssssssssssyNMMMysssssss+   Memory: 170MiB / 985MiB
.ssssssssdMMMNhsssssssssshNMMMdssssssss.
 /sssssssshNMMMyhhyyyyhdNMMMNhssssssss/
  +sssssssssdmydMMMMMMMMddddyssssssss+
   /ssssssssssshdmNNNNmyNMMMMhssssss/
    .ossssssssssssssssssdMMMNysssso.
      -+sssssssssssssssssyyyssss+-
        `:+ssssssssssssssssss+:`
            .-/+oossssoo+/-.
```

インストールは
```
sudo apt install neofetch
```

# fstabの第4フィールドで

noautoもautoもつけなかったら、どっちになるのか?

`defaults`は`rw, suid, dev, exec, auto, nouser, and async`であるとマニュアルには書いてあるけど。


# UNIX時間を読める形式にする

プログラム言語で関数呼ぶのではなくワンライナーでちょっと変換したいときに。
dateコマンドでできる。

例:
```sh
date +'%Y-%m-%d %T' -d '1970-1-1 1604482445 sec'
# ↑はUTC。JSTなら+0900なので↓こんな感じ
date +'%Y-%m-%d %T' -d '1970-1-1 09:00:00 1604482445 sec'
```

# dateコマンドいろいろ

UTCで
```
date -u '+%Y-%m-%dT%H:%M:%SZ'
```

UTCで1時間後
```
date --date "1 hour" -u '+%Y-%m-%dT%H:%M:%SZ'
```

[[Shell Script] dateコマンドで日時(日付、時刻)計算をする方法 - Life with IT](https://l-w-i.net/t/shell/date_001.txt)

# wで出てくるtty名のユーザを強制ログアウトさせる

psでgrepして...より早い。

```sh
pkill -9 -t pts/1
```
自分以外だったらsudoで。

`-u`オプションを使ってユーザ名を明示してもいい。


# /usr/lib/firmwareがでかい

から始まるディスク容量を増やす作戦

- [arch linux - How do I minimize disk space usage - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/2027/how-do-i-minimize-disk-space-usage)


これとか知らなかった
```
journalctl --disk-usage
sudo journalctl --vacuum-size=100M
# or
sudo journalctl --vacuum-time=7d
```

または
```
/etc/systemd/journald.conf
に
SystemMaxUse=100M
などと書いて
systemctl restart systemd-journald.service
```

参考:
- [man journald.conf の訳 - kandamotohiro](https://sites.google.com/site/kandamotohiro/systemd/man-journald-conf-no-yi)

デフォルト値はファイルシステムの15%らしい。


# cron.dailyはいつ実行される?

ディストリによって起動方法が変わるので

anacronで起動されるRHEL7などでは
```sh
grep daily /etc/anacrontab
```
で確認。

Debian、Ubuntuはデフォルトではanacronは使わないので(インストールすれば使える)
```sh
grep daily /etc/crontab
```
で。


# lsでディレクトリ名だけ表示する

```sh
ls -d */
# or
ls -ld */
```

[lsでディレクトリ名のみ表示する(grepは使わない) - Qiita](https://qiita.com/github-nakasho/items/1433f6601bb3efc14474#%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E5%90%8D%E3%81%A0%E3%81%91%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%97%E3%81%9F%E3%81%84)


# visudoで/etc/sudoer以外を編集する

`-f`オプション。こんな感じ

```sh
EDITOR=emacs visudo -f /etc/sudoers.d/heiwa
```

`EDITOR=`は必須じゃありません。

あとファイルの最後に改行が必須(忘れやすい)。


# Errata

- Red Hat : [Red Hat Product Errata - Red Hat Customer Portal](https://access.redhat.com/errata/)
- Ubuntu : [CVEs \| Ubuntu](https://ubuntu.com/security/cve)


# EFIかどうか知る

```bash
ls -lad /sys/firmware/efi
```


# カラーでless

`unbuffer` と `less -R` を組み合わせるのが汎用っぽい。

[less にパイプしても色が消えないようにする方法 - Qiita](https://qiita.com/mkasahara/items/60049ee20956e835738b#%E6%B1%8E%E7%94%A8%E7%9A%84%E3%81%AA%E6%96%B9%E6%B3%95)

```bash
sudo apt install expect
unbuffer ls -al | less -R
```
でもこの例だと失敗する。
