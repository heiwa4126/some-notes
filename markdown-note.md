# markdown のメモ

## GitHub で Reference-style links が使える

最初から
GFM ([GitHub Flavored Markdown](https://github.github.com/gfm/))
では
Reference-style links(参照スタイルリンク)
が使えたらしい。

- [4\.7 Link reference definitions](https://github.github.com/gfm/#link-reference-definitions)
- [6\.6 Links](https://github.github.com/gfm/#links)

わかりやすい例: [Markdown の参照リンク](https://zenn.dev/inoy/articles/11db8791cde1b0)

[remark-gfm]
でも Reference-style links はサポートされている模様

参照はどこに書いてもいい。

「Reference-style link を自動的に文章末尾にまとめて表示する機能」はない。
(「作ればある」らしい)

### 参照名の規則

- 大文字・小文字を区別しない(`[GitHub]`と`[github]` は同じ)
- 空白や改行を含めてもよい(ただし、内部的には正規化される)
- 正規化の方法:
  1.  先頭と末尾の空白を削除
  2.  連続する空白を 1 つにまとめる
  3.  大文字を小文字に変換

参照名が同じ場合は最後に定義されたものが優先。

### GFM 対応パッケージ

#### TypeScript/JavaScript

[remark-gfm]: https://www.npmjs.com/package/remark-gfm 'remark plugin to support GFM (autolink literals, footnotes, strikethrough, tables, tasklists)'

- [remark-gfm]
- こっちも参照 [remark - markdown processor powered by plugins](https://remark.js.org/)

#### Python

[executablebooks/markdown-it-py](https://github.com/executablebooks/markdown-it-py)
に
GFM 対応プラグイン(`markdown-it-py[plugins]`)

[Markdown-It-Py Plugin Extensions — mdit-py-plugins](https://mdit-py-plugins.readthedocs.io/en/latest/)
