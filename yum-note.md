# yumメモ

主に yum3 の話。

# 利用可能なパッケージのリスト

- マシンリーダブルな出力
- yum.conf の exclude=を無視

を目標とする。

```bash
LANG=C
yum --showduplicate --disableexcludes=all list \
 | sed -e "s/[[:space:]]\+/\t/g" | sed -e ':loop; N; $!b loop; ;s/\n[[:space:]]/\t/g' \
 | fgrep -e .noarch -e .x86_64 -e .i686 \
 | sort | uniq
```

この変なコードの説明:

- yum3 の幅は 80 文字でハードコーディングされていて、変な折り返しをする。
- yum3 のヘッダ出力は止められない。
- uniq しないと installed と全体で 2 行出る。

できないこと:

- yum の$releasever をごまかせない。
- 同様に subscription-manager release もごまかせない。

もうあきらめて、
`subscription-manager release --set=7Server`
か
`subscription-manager release --unset`
で、

- yum.conf に exclude=がなくて
- /etc/yum/vars/releasever がなくて
- redhat-release が固定されてない

ような環境で

`repoquery -a --showduplicate`

すんのがいちばんいいと思う。
RHEL 6,7,8 をカバーするのは面倒だなあ...

参考: [linux - How to generate a list of available updates from yum and export to CSV, including current and updated version of each package? - Stack Overflow](https://stackoverflow.com/questions/50955927/how-to-generate-a-list-of-available-updates-from-yum-and-export-to-csv-includin)

世界中で yum の出力には困ってるらしい。
