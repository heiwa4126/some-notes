# JSONのメモ

- [JSONのメモ](#jsonのメモ)
- [jqでフォーマットの変換](#jqでフォーマットの変換)
- [jqのレシピ](#jqのレシピ)
- [jqの出力をcolorでless](#jqの出力をcolorでless)

# jqでフォーマットの変換

jq便利

人間が読みやすいように変換
```sh
jq . data.json
```

圧縮
```sh
jq -c . data.json
```

pipeでもOK

# jqのレシピ

- [シェル芸で使いたい jqイディオム \- Qiita](https://qiita.com/nmrmsys/items/5b4a4bd2e3909db161b1)


# jqの出力をcolorでless

* [jq '\.' \-C \| less \-R](https://qiita.com/takyam/items/d9636000643f9c3ea3a0)

```sh
jq -C . hoge.json | less -R
```

おまけ:
* [＠IT：カラー表示されたlsの出力をlessで表示するには](https://atmarkit.itmedia.co.jp/flinux/rensai/linuxtips/357colorlsless.html)

yq にはカラー出力がない。batを使え。

* [kislyuk/yq: Command-line YAML, XML, TOML processor - jq wrapper for YAML/XML/TOML documents](https://github.com/kislyuk/yq)
  * [Color output of keys and values like jq · Issue \#17 · kislyuk/yq](https://github.com/kislyuk/yq/issues/17)
* [sharkdp/bat: A cat\(1\) clone with wings\.](https://github.com/sharkdp/bat)