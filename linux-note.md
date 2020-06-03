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

Golangなのでインストールかんたん。

```
go get -u github.com/mvdan/sh/cmd/shfmt
```

オプションも他のフォーマッターとよく似てる。とりあえず
```
shfmt -l -w *.sh
```
でカレントのshを全部再フォーマット。