# TOML のメモ

## Even Better TOML のフォーマットの設定

- [Formatter Options | Taplo](https://taplo.tamasfe.dev/configuration/formatter-options.html)
- [Configuration File | Taplo](https://taplo.tamasfe.dev/configuration/file.html)

VSCode の拡張の Even Better TOML で、pyproject.toml を自分好みにする設定。

```json
{
  "evenBetterToml.formatter.compactArrays": false,
  "evenBetterToml.formatter.arrayAutoExpand": true,
  "evenBetterToml.formatter.columnWidth": 30
}
```

`array_auto_expand = true` は、配列が `column_width` の値を超えた場合に自動で複数行に展開するオプションです。

`compact_arrays = false` は、1 行の配列内の要素間に空白を入れるオプションです。

この 2 つのオプションを組み合わせれば、配列が自動で複数行に展開され、かつ各要素が 1 行ずつ表示されるようになります。

[Configuration File | Taplo](https://taplo.tamasfe.dev/configuration/file.html) にある通り、
再起動しないと変更が有効にならないかもしれない。
