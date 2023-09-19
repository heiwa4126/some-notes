# JSONのメモ

- [JSONのメモ](#jsonのメモ)
- [jqでフォーマットの変換](#jqでフォーマットの変換)
- [jqのレシピ](#jqのレシピ)
- [jqの出力をcolorでless](#jqの出力をcolorでless)
- [JSONでなぜスラッシュにエスケープが要るのか](#jsonでなぜスラッシュにエスケープが要るのか)

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

- [jq '\.' \-C \| less \-R](https://qiita.com/takyam/items/d9636000643f9c3ea3a0)

```sh
jq -C . hoge.json | less -R
```

おまけ:

- [＠IT：カラー表示されたlsの出力をlessで表示するには](https://atmarkit.itmedia.co.jp/flinux/rensai/linuxtips/357colorlsless.html)

yq にはカラー出力がない。batを使え。

- [kislyuk/yq: Command-line YAML, XML, TOML processor - jq wrapper for YAML/XML/TOML documents](https://github.com/kislyuk/yq)
  - [Color output of keys and values like jq · Issue \#17 · kislyuk/yq](https://github.com/kislyuk/yq/issues/17)
- [sharkdp/bat: A cat\(1\) clone with wings\.](https://github.com/sharkdp/bat)

# JSONでなぜスラッシュにエスケープが要るのか

[javascript - JSON: why are forward slashes escaped? - Stack Overflow](https://stackoverflow.com/questions/1580647/json-why-are-forward-slashes-escaped)

JSONだけ見ると必要なわけではない。が。

> HTMLでは\<script\>タグ内の文字列に\</を含めることができないためで、万が一、その部分文字列がある場合は、すべてのフォワードスラッシュをエスケープする必要があります。

[JSON のスラッシュ「/」の扱いの仕様と出力結果の相違について](https://social.msdn.microsoft.com/Forums/ja-JP/e025c19e-a357-48ee-99b6-2b04efa6bd88/json?forum=aspnetja)

> '/' は unescape にも escape にも含まれていて、"/" と書いてもよいし "\\/" と書いてもよいことになっています。これは、JavaScript のエスケープシーケンスの処理の都合ですので、そういうものです。
