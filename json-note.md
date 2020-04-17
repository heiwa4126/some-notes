# JSONのメモ

- [JSONのメモ](#jsonのメモ)
- [jqでフォーマットの変換](#jqでフォーマットの変換)
- [jqのレシピ](#jqのレシピ)

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
  