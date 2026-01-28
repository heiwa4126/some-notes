# JSON のメモ

- [jq でフォーマットの変換](#jq-でフォーマットの変換)
- [jq のレシピ](#jq-のレシピ)
- [jq の出力を color で less](#jq-の出力を-color-で-less)
- [JSON でなぜスラッシュにエスケープが要るのか](#json-でなぜスラッシュにエスケープが要るのか)
- [JSON から JavaScript に貼り付けられるコードに変換(あるいはその逆)](#json-から-javascript-に貼り付けられるコードに変換あるいはその逆)
- [JSONの "文字列の中" に生の改行は入れられない](#jsonの-文字列の中-に生の改行は入れられない)

## jq でフォーマットの変換

jq 便利

人間が読みやすいように変換

```sh
jq . data.json
```

圧縮

```sh
jq -c . data.json
```

pipe でも OK

## jq のレシピ

- [シェル芸で使いたい jq イディオム \- Qiita](https://qiita.com/nmrmsys/items/5b4a4bd2e3909db161b1)

## jq の出力を color で less

- [jq '\.' \-C \| less \-R](https://qiita.com/takyam/items/d9636000643f9c3ea3a0)

```sh
jq -C . hoge.json | less -R
```

おまけ:

- [@IT:カラー表示された ls の出力を less で表示するには](https://atmarkit.itmedia.co.jp/flinux/rensai/linuxtips/357colorlsless.html)

yq にはカラー出力がない。bat を使え。

- [kislyuk/yq: Command-line YAML, XML, TOML processor - jq wrapper for YAML/XML/TOML documents](https://github.com/kislyuk/yq)
  - [Color output of keys and values like jq · Issue \#17 · kislyuk/yq](https://github.com/kislyuk/yq/issues/17)
- [sharkdp/bat: A cat\(1\) clone with wings\.](https://github.com/sharkdp/bat)

## JSON でなぜスラッシュにエスケープが要るのか

[javascript - JSON: why are forward slashes escaped? - Stack Overflow](https://stackoverflow.com/questions/1580647/json-why-are-forward-slashes-escaped)

JSON だけ見ると必要なわけではない。が。

> HTML では\<script\>タグ内の文字列に\</を含めることができないためで、万が一、その部分文字列がある場合は、すべてのフォワードスラッシュをエスケープする必要があります。

[JSON のスラッシュ「/」の扱いの仕様と出力結果の相違について](https://social.msdn.microsoft.com/Forums/ja-JP/e025c19e-a357-48ee-99b6-2b04efa6bd88/json?forum=aspnetja)

> '/' は unescape にも escape にも含まれていて、"/" と書いてもよいし "\\/" と書いてもよいことになっています。これは、JavaScript のエスケープシーケンスの処理の都合ですので、そういうものです。

## JSON から JavaScript に貼り付けられるコードに変換(あるいはその逆)

意外と手でやると面倒なので。

- [Convert JSON to Javascript Object Online - ConvertSimple.com](https://www.convertsimple.com/convert-json-to-javascript/)
- [Convert Javascript Object to JSON Online - ConvertSimple.com](https://www.convertsimple.com/convert-javascript-to-json/)

## JSONの "文字列の中" に生の改行は入れられない

絶対に入れられないので、考えるだけ無駄。
`\\\n` のようなのは書けるけど、やりたいことはそうじゃないよね?
