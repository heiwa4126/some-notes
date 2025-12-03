# Javascript のメモ

## VSCode で Javascript で型チェック

[チェックを行う js ファイルの先頭に//@ts\-check というコメントをつけるだけです](https://qiita.com/dbgso/items/137237a0d14503bc3daa)

TypeScript 使えない状況に便利。

他:

> tsconfig.json で型チェックをデフォルト有効に

[TypeScript コンパイルなしでこっそり型の恩恵を得る \- OITA: Oika's Information Technological Activities](https://oita.oika.me/2018/12/23/typescript-jsdoc/)

- [@ ts\-check を付けると、VS Code が普通の JavaScript も TypeScript 扱いで見てくれるんだって。 \| Ginpen\.com](https://ginpen.com/2018/08/17/vs-code-reads-js-as-ts/)
- [TypeScript: Documentation \- JS Projects Utilizing TypeScript](https://www.typescriptlang.org/docs/handbook/intro-to-js-ts.html)
- [もう TypeScript の補助輪を外そう 明日は//@ts\-check を使う](https://zenn.dev/asama/articles/0c66573e488b22)
-

## VSCode で補完

TypeScript 使えない状況で。

「型が不明そうなとこに JSDoc を書く」のは基本。

で、
[Visual Studio Code で依存モジュールの型定義を使いたい(Javascript の Node.js で) - Qiita](https://qiita.com/dbgso/items/2ad42139635e45ac150d)

## 分割代入(非構造化) Destructuring assignment

[分割代入 - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)

## `{ name: "Alice", age: 25 }` は Map ではない

Python とは違う。

- [Object - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Object) ← こっち
- [Map - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Map)

```javascript
// オブジェクトからMapを作成
const map = new Map(Object.entries(obj));
```

## Date()の恐怖

```console
$ node

> new Date("2021-01-01")
2021-01-01T00:00:00.000Z

> new Date(2021,1-1,1)
2020-12-31T15:00:00.000Z
```

結果をそろえたいなら、下を

```javascript
new Date(Date.UTC(2021, 1 - 1, 1));
```

にして UTC にそろえる。

## Date()の恐怖 2

```console
$ node

> new Date("2021-1-01")
2020-12-31T15:00:00.000Z

> new Date("2021-01-01")
2021-01-01T00:00:00.000Z
```

V8 系でない処理系では、上のは例外で死ぬこともあるらしい。
けどそっちの方がありがたいよね。

- [Date() コンストラクター - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Date/Date)
- [datestring](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Date/Date#datestring)

> Date コンストラクター(および Date.parse と同等)で日付文字列を解釈する際には、常に入力が ISO 8601 形式 (YYYY-MM-DDTHH:mm:ss.sssZ) であることを確認してください。

- [Date.parse() - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Date/parse)

> 対応するよう明示的に指定されているのは ISO 8601 形式 (YYYY-MM-DDTHH:mm:ss.sssZ) のみです。
> 他の形式は実装で定義されており、すべてのブラウザーで動作するとは限りません。

## ブラウザで使える 「ESM でない方」の呼び名

「モジュールスクリプト」でない方の名前。いくつか呼び方がある。

1. **クラシックスクリプト(Classic Script)**
   - 最も正式な呼び方
   - HTML 仕様でも使われている用語
2. **グローバルスクリプト(Global Script)**
   - グローバルスコープで実行されることを強調した呼び名
3. **非モジュールスクリプト(Non-module Script)**
   - ESM との対比で使われる呼び名

```html
<!-- クラシックスクリプト(ESMでない) -->
<script src="app.js"></script>

<!-- ESM(モジュールスクリプト) -->
<script type="module" src="app.js"></script>
```

かんたんな比較

| クラシックスクリプト | ESM                     |
| -------------------- | ----------------------- |
| グローバルスコープ   | モジュールスコープ      |
| `type`属性不要       | `type="module"`が必要   |
| 即座に実行           | `defer`動作がデフォルト |
| 重複読み込み可能     | 1 回のみ実行            |
