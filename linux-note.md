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

# shfmt - shellスクリプトのフォーマッター

- [mvdan/sh: A shell parser, formatter, and interpreter (sh/bash/mksh), including shfmt](https://github.com/mvdan/sh#shfmt)
- [シェルスクリプトのコードを整形してくれるツール `shfmt` | ゲンゾウ用ポストイット](https://genzouw.com/entry/2019/02/15/085003/874/)

Golangなのでビルド&インストールかんたん。
```
go get -u github.com/mvdan/sh/cmd/shfmt
```
もちろん [Releases · mvdan/sh](https://github.com/mvdan/sh/releases) から落として適当な場所に置いてもいい。


オプションも他のフォーマッターとよく似てる。とりあえず
```
shfmt -l -w *.sh
```
でカレントのshを全部再フォーマット。


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