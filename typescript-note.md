# Partial&lt;T&gt;

- [Partial&lt;T&gt; | TypeScript入門『サバイバルTypeScript』](https://typescriptbook.jp/reference/type-reuse/utility-types/partial)
- https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#mapped-types

ReactのTypeScriptでsetState hookの一部を書き換えたいとき：

- [Troubleshooting Handbook: Types | React TypeScript Cheatsheets](https://react-typescript-cheatsheet.netlify.app/docs/basic/troubleshooting/types/#using-partial-types)
- https://reactjs.org/docs/hooks-reference.html#functional-updates の note

# interfaceとtype

[interfaceとtypeの違い、そして何を使うべきかについて](https://zenn.dev/luvmini511/articles/6c6f69481c2d17)

よくわからん。とりあえず interface つかう。

# hashにタイプ

[typescriptで連想配列の配列を宣言（型指定）したい](https://trueman-developer.blogspot.com/2017/04/typescript.html)

```typescript
let hash: { [key: string]: string } = {};
hash['apple'] = 'りんご';
hash['banana'] = 'ばなな';
hash['orange'] = 'オレンジ';

const hash2: { [key: string]: string } = {
  apple: 'りんご',
  banana: 'ばなな',
  orange: 'オレンジ'
};
```

# Jupyter で Node.js で TypeScript

ちょっとだけ小さいコードの確認用にJupyterが使えるといいなあ、と思った。

[yunabe/tslab: Interactive JavaScript and TypeScript programming with Jupyter](https://github.com/yunabe/tslab)

あとで試す。
