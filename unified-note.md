# Unified.jsのメモ

remake/rehype (とretext) などなど

## 参照

- [Use unified - unified](https://unifiedjs.com/learn/guide/using-unified/)
- [最新 remark plugin リスト](https://github.com/remarkjs/remark/blob/HEAD/doc/plugins.md)
- [最新 rehype plugin リスト](https://github.com/rehypejs/rehype/blob/HEAD/doc/plugins.md)

## VFile

VFile は、Node.js においてテキストファイルを表現するために使用される仮想ファイル（virtual file）を表すオブジェクトです。
VFile オブジェクトは、ファイルのパス、内容、メタデータなどの情報を保持します。
VFile オブジェクトは Unified.js と呼ばれるツールキットの一部であり、テキストファイルを扱うツールを構築するために使用されます。

VFile は、Unified.js によって提供されるエコシステムで広く使用されており、
remark や rehype といったテキスト処理ツール、unified-engine といったツールの標準入力や標準出力など、様々な場面で使用されます。

例えば、VFile を使用してファイルを読み込む場合、以下のように書くことができます。

```javascript
const vfile = require("vfile");
const fs = require("fs");

const file = vfile.readSync("path/to/file.md");
console.log(file.contents); // ファイルの内容を出力する
```

また、VFile にはメタデータを追加することができるため、以下のようにファイルの種類やタイトルなどの情報を持たせることもできます。

```javascript
const file = vfile({
  path: "path/to/file.md",
  contents: fs.readFileSync("path/to/file.md", "utf-8"),
  data: {
    title: "My Markdown File",
    type: "blog-post",
    author: "John Doe",
  },
});

console.log(file.data.title); // "My Markdown File" を出力する
```

VFile は、テキストファイルを扱う際に便利な機能を提供するため、
テキスト処理やコンパイルなどのプログラムによる自動化に役立ちます。

# pluginを作る

Rehypeの方を例に (remark, retextにもほぼ同じ項目があります):

- https://github.com/rehypejs/rehype/blob/HEAD/doc/plugins.md#create-plugins
- [Create a plugin - unified](https://unifiedjs.com/learn/guide/create-a-plugin/)

プラグインを作成するには、まず、プラグインの概念について読んでください。
次に、「[Unifiedでプラグインを作成する](https://unifiedjs.com/learn/guide/create-a-plugin/)」というガイドを読んでください。
最後に、[既存のプラグイン](https://github.com/rehypejs/rehype/blob/HEAD/doc/plugins.md)の中から、これから作ろうとしているものに似たものを1つ選び、そこから作業してください。
もし行き詰まったら、ディスカッションは助けを求めるのに良い場所です。

`rehype-` をプレフィックスに持つ名前を選ぶべきです
(`rehype-format`のようなもの)。
rehype().use()で動作しないものは `rehype-`接頭辞を使わないでください: それは「プラグイン」ではないので、ユーザーを混乱させるでしょう。

hast で動作する場合は `hast-util-` を、
任意の unist ツリーで動作する場合は `unist-util-` を、
仮想ファイルで動作する場合は `vfile-` を使用します。

デフォルトのエクスポートを使用してパッケージからプラグインを公開し、
package.jsonに`rehype-plugin`キーワードを追加し、
GitHubのあなたのレポにrehype-pluginトピックを追加し、
[このページ](https://github.com/rehypejs/rehype/blob/HEAD/doc/plugins.md)のプラグインを追加するプルリクエストを作成してください！
