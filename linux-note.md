# Linux 雑多メモ

便利なツールなんだけど使用頻度が低いと思い出せないやつなんかをメモ

## neofetch

[GitHub - dylanaraps/neofetch: 🖼️ A command-line system information tool written in bash 3.2+](https://github.com/dylanaraps/neofetch)

ロゴ出すやつ(「情報だすやつ」ですね)。

```console
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

```sh
sudo apt install neofetch
```

## fstab の第 4 フィールドで

noauto も auto もつけなかったら、どっちになるのか?

`defaults`は`rw, suid, dev, exec, auto, nouser, and async`であるとマニュアルには書いてあるけど。

## UNIX 時間を読める形式にする

プログラム言語で関数呼ぶのではなくワンライナーでちょっと変換したいときに。
date コマンドでできる。

例:

```sh
date +'%Y-%m-%d %T' -d '1970-1-1 1604482445 sec'
# ↑はUTC。JSTなら+0900なので↓こんな感じ
date +'%Y-%m-%d %T' -d '1970-1-1 09:00:00 1604482445 sec'
```

## date コマンドいろいろ

UTC で

```sh
date -u '+%Y-%m-%dT%H:%M:%SZ'
```

UTC で 1 時間後

```sh
date --date "1 hour" -u '+%Y-%m-%dT%H:%M:%SZ'
```

[[Shell Script] date コマンドで日時(日付、時刻)計算をする方法 - Life with IT](https://l-w-i.net/t/shell/date_001.txt)

## w で出てくる tty 名のユーザを強制ログアウトさせる

ps で grep して...より早い。

```sh
pkill -9 -t pts/1
```

自分以外だったら sudo で。

`-u`オプションを使ってユーザ名を明示してもいい。

## /usr/lib/firmware がでかい

から始まるディスク容量を増やす作戦

- [arch linux - How do I minimize disk space usage - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/2027/how-do-i-minimize-disk-space-usage)

これとか知らなかった

```sh
journalctl --disk-usage
sudo journalctl --vacuum-size=100M
# or
sudo journalctl --vacuum-time=7d
```

または

```text
/etc/systemd/journald.conf
に
SystemMaxUse=100M
などと書いて
systemctl restart systemd-journald.service
```

参考:

- [man journald.conf の訳 - kandamotohiro](https://sites.google.com/site/kandamotohiro/systemd/man-journald-conf-no-yi)

デフォルト値はファイルシステムの 15%らしい。

## cron.daily はいつ実行される?

ディストリによって起動方法が変わるので

anacron で起動される RHEL7 などでは

```sh
grep daily /etc/anacrontab
```

で確認。

Debian、Ubuntu はデフォルトでは anacron は使わないので(インストールすれば使える)

```sh
grep daily /etc/crontab
```

で。

## ls でディレクトリ名だけ表示する

```sh
ls -d */
# or
ls -ld */
```

[ls でディレクトリ名のみ表示する(grep は使わない) - Qiita](https://qiita.com/github-nakasho/items/1433f6601bb3efc14474#%E3%83%87%E3%82%A3%E3%83%AC%E3%82%AF%E3%83%88%E3%83%AA%E5%90%8D%E3%81%A0%E3%81%91%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%97%E3%81%9F%E3%81%84)

## visudo で/etc/sudoer 以外を編集する

`-f`オプション。こんな感じ

```sh
EDITOR=emacs visudo -f /etc/sudoers.d/heiwa
```

`EDITOR=`は必須じゃありません。

あとファイルの最後に改行が必須(忘れやすい)。

## Errata

- Red Hat : [Red Hat Product Errata - Red Hat Customer Portal](https://access.redhat.com/errata/)
- Ubuntu : [CVEs \| Ubuntu](https://ubuntu.com/security/cve)

## EFI かどうか知る

```bash
ls -lad /sys/firmware/efi
```

## カラーで less

`unbuffer` と `less -R` を組み合わせるのが汎用っぽい。

[less にパイプしても色が消えないようにする方法 - Qiita](https://qiita.com/mkasahara/items/60049ee20956e835738b#%E6%B1%8E%E7%94%A8%E7%9A%84%E3%81%AA%E6%96%B9%E6%B3%95)

```bash
sudo apt install expect
unbuffer ls -al | less -R
```

でもこの例だと失敗する。

[Color output in console - ArchWiki](https://wiki.archlinux.org/title/Color_output_in_console)

## ディストリのバージョンを知る

```
$ lsb_release -ds
Ubuntu 22.04.1 LTS

$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 22.04.1 LTS
Release:        22.04
Codename:       jammy

$ sudo apt-get install lsb-core
# けっこうでかい
```

LSB (Linux Standard Base)

[Linux Standard Base (LSB) とは何か - Qiita](https://qiita.com/kaizen_nagoya/items/bdd121a9e366036cbaba)

## 仮想端末(pty)とは何か?

まず pty がない状態を体験してみる。

```bash
ssh -T localhost
```

[Man page of PTY](https://linuxjm.osdn.jp/html/LDP_man-pages/man7/pty.7.html)

いまいちピンとこないなあ。そもそも「端末」とは何か?

| 特徴     | 疑似端末                                                                                             | 伝統的な端末                                             |
| -------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| 実体     | ソフトウェアによってエミュレートされた仮想的な端末                                                   | 物理的なハードウェアによって実現された端末               |
| 接続方法 | プログラムやユーザーからのリモートアクセス                                                           | コンピューターシステムに直接接続                         |
| 機能     | ターミナルエミュレーション、リモートアクセス、複数のターミナルセッション管理                         | ターミナルエミュレーション、リアルタイム表示、入出力制御 |
| 制約     | 物理的な制約はないが、ソフトウェアによって実現されているため、システムリソースに制限がある場合がある | 物理的な制約があるため、数や配置に制限がある場合がある   |
| 例       | SSH、Telnet、コンソールなど                                                                          | ディスプレイ、キーボード、マウスなど                     |

no-pty だと「対話的なプログラム」が支障をきたす(実行できないわけではない)。

とりあえず重要な点は
**no-pty だからプログラムが実行できない、とかリモート側の出力が帰ってこない、みたいなことは無い**
のでセキュリティを高める意味はあんまりない
ということですかね。

## ファイルの種類を知る

`file` コマンドが有名だけど、さらにかしこいのがある。

- [Magika](https://google.github.io/magika/)
  - [google/magika: Detect file content types with deep learning](https://github.com/google/magika)

## dmidecode

- [「Linux」でシステムの情報を収集したいときに使用すべきコマンド 5 選 - ZDNET Japan](https://japan.zdnet.com/article/35220602/)
- [【 dmidecode 】コマンド――ハードウェアの情報を表示する:Linux 基本コマンド Tips(294) - @IT](https://atmarkit.itmedia.co.jp/ait/articles/1904/04/news018.html)
