# TYpescript のメモ

- [TYpescript のメモ](#typescript-のメモ)
  - [Partial\<T\>](#partialt)
  - [interface と type](#interface-と-type)
  - [hash にタイプ](#hash-にタイプ)
  - [Jupyter で Node.js で TypeScript](#jupyter-で-nodejs-で-typescript)
  - [tsconfig.json の outDir でポピュラーなものは?](#tsconfigjson-の-outdir-でポピュラーなものは)
  - [`npm i typescript -D` しないで Typescript の開発はできますか? 例えば deno や bun を使えば出来る?](#npm-i-typescript--d-しないで-typescript-の開発はできますか-例えば-deno-や-bun-を使えば出来る)
  - [tsc でトランスパイルするときに、インデントをタブにできますか?](#tsc-でトランスパイルするときにインデントをタブにできますか)

## Partial&lt;T&gt;

- [Partial&lt;T&gt; | TypeScript 入門『サバイバル TypeScript』](https://typescriptbook.jp/reference/type-reuse/utility-types/partial)
- https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#mapped-types

React の TypeScript で setState hook の一部を書き換えたいとき:

- [Troubleshooting Handbook: Types | React TypeScript Cheatsheets](https://react-typescript-cheatsheet.netlify.app/docs/basic/troubleshooting/types/#using-partial-types)
- https://reactjs.org/docs/hooks-reference.html#functional-updates の note

## interface と type

[interface と type の違い、そして何を使うべきかについて](https://zenn.dev/luvmini511/articles/6c6f69481c2d17)

よくわからん。とりあえず interface つかう。

## hash にタイプ

[typescript で連想配列の配列を宣言(型指定)したい](https://trueman-developer.blogspot.com/2017/04/typescript.html)

```typescript
let hash: { [key: string]: string } = {};
hash["apple"] = "りんご";
hash["banana"] = "ばなな";
hash["orange"] = "オレンジ";

const hash2: { [key: string]: string } = {
  apple: "りんご",
  banana: "ばなな",
  orange: "オレンジ",
};
```

## Jupyter で Node.js で TypeScript

ちょっとだけ小さいコードの確認用に Jupyter が使えるといいなあ、と思った。

[yunabe/tslab: Interactive JavaScript and TypeScript programming with Jupyter](https://github.com/yunabe/tslab)

あとで試す。

## tsconfig.json の outDir でポピュラーなものは?

outDir オプションは TypeScript のコンパイラが生成する JavaScript ファイルを出力するディレクトリを指定します。一般的によく使われる設定は以下の通りです:

- `./dist`: これは非常に一般的な設定で、コンパイルされた JavaScript ファイルをプロジェクトのルートにある dist ディレクトリに出力します。
- `./build`: これも一般的な設定で、dist の代わりに build ディレクトリを使用します。
- `./out`: これは少しまれですが、一部のプロジェクトでは out ディレクトリを使用します。

これらの設定はプロジェクトやチームの慣習によります。重要なのは、出力ディレクトリが .gitignore ファイルに含まれていて、コンパイルされたファイルがリポジトリにコミットされないようにすることです。

## `npm i typescript -D` しないで Typescript の開発はできますか? 例えば deno や bun を使えば出来る?

できるらしい。よくわからん。試す。

## tsc でトランスパイルするときに、インデントをタブにできますか?

TypeScript コンパイラ tsc は、生成される JavaScript ファイルのインデントスタイルを直接制御するオプションを提供していません。
tsc はデフォルトでスペースを使用してインデントします。

後処理で Prettier 使うとかしかない。
