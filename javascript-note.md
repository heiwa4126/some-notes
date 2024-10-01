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
