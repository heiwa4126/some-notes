# yumメモ

主にyum3の話。

# 利用可能なパッケージのリスト

- マシンリーダブルな出力
- yum.confのexclude=を無視

を目標とする。

```bash
LANG=C
yum --showduplicate --disableexcludes=all list \
 | sed -e "s/[[:space:]]\+/\t/g" | sed -e ':loop; N; $!b loop; ;s/\n[[:space:]]/\t/g' \
 | fgrep -e .noarch -e .x86_64 -e .i686 \
 | sort | uniq
```

この変なコードの説明:

- yum3の幅は80文字でハードコーディングされていて、変な折り返しをする。
- yum3のヘッダ出力は止められない。
- uniqしないとinstalledと全体で2行出る。

できないこと:

- yumの$releaseverをごまかせない。
- 同様にsubscription-manager releaseもごまかせない。

もうあきらめて、
`subscription-manager release --set=7Server`
か
`subscription-manager release --unset`
で、

- yum.confにexclude=がなくて
- /etc/yum/vars/releaseverがなくて
- redhat-releaseが固定されてない

ような環境で

`repoquery -a --showduplicate`

すんのがいちばんいいと思う。
RHEL 6,7,8をカバーするのは面倒だなあ...

参考: [linux - How to generate a list of available updates from yum and export to CSV, including current and updated version of each package? - Stack Overflow](https://stackoverflow.com/questions/50955927/how-to-generate-a-list-of-available-updates-from-yum-and-export-to-csv-includin)

世界中でyumの出力には困ってるらしい。
