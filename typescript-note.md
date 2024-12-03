# TypeScript のメモ

- [Partial\<T\>](#partialt)
- [interface と type](#interface-と-type)
- [hash にタイプ](#hash-にタイプ)
- [Jupyter で Node.js で TypeScript](#jupyter-で-nodejs-で-typescript)
- [tsconfig.json の outDir でポピュラーなものは?](#tsconfigjson-の-outdir-でポピュラーなものは)
- [`npm i typescript -D` しないで Typescript の開発はできますか? 例えば deno や bun を使えば出来る?](#npm-i-typescript--d-しないで-typescript-の開発はできますか-例えば-deno-や-bun-を使えば出来る)
- [tsc でトランスパイルするときに、インデントをタブにできますか?](#tsc-でトランスパイルするときにインデントをタブにできますか)
- [Promise.reject()に対応する async function の戻り値は?](#promiserejectに対応する-async-function-の戻り値は)
- [class で private](#class-で-private)
- [TypeScript にのみ存在する標準型](#typescript-にのみ存在する標準型)
  - [参考リンク](#参考リンク)

## Partial&lt;T&gt;

- [Partial&lt;T&gt; | TypeScript 入門『サバイバル TypeScript』](https://typescriptbook.jp/reference/type-reuse/utility-types/partial)
- <https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html#mapped-types>

React の TypeScript で setState hook の一部を書き換えたいとき:

- [Troubleshooting Handbook: Types | React TypeScript Cheatsheets](https://react-typescript-cheatsheet.netlify.app/docs/basic/troubleshooting/types/#using-partial-types)
- <https://reactjs.org/docs/hooks-reference.html#functional-updates> の note

## interface と type

[interface と type の違い、そして何を使うべきかについて](https://zenn.dev/luvmini511/articles/6c6f69481c2d17)

よくわからん。とりあえず interface つかう。

## hash にタイプ

hash というか object。

- [typescript で連想配列の配列を宣言(型指定)したい](https://trueman-developer.blogspot.com/2017/04/typescript.html)
- [TypeScript: Documentation - Mapped Types](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)

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

でも Map()のほうが効率がいいと思う。

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

## Promise.reject()に対応する async function の戻り値は?

`throw new Error('エラーが発生しました');`

自動的に reject された Promise としてラップされる。

## class で private

- `#height = 0;` - JavaScript ネイティブのプライベートフィールドプロパティ [クラス - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Classes)の「プライベートプロパティ」参照
- `private height = 0;` - TypeScript のプライベート修飾子

TypeScript ではおおむね後者で用が足りる。

## TypeScript にのみ存在する標準型

[TypeScript: Documentation - Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)

※ JavaScript の標準組み込みオブジェクトはこちら。[標準組み込みオブジェクト - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects)

ざっくり解説:

1. **`Partial<T>`**  
   指定した型 `T` の全てのプロパティをオプショナル(`undefined` 可能)にする。

2. **`Required<T>`**  
   指定した型 `T` の全てのプロパティを必須にする。

3. **`Readonly<T>`**  
   指定した型 `T` の全てのプロパティを読み取り専用にする。

4. **`Record<K, T>`**  
   キー `K` と値 `T` からなるオブジェクト型を作成する。

5. **`Pick<T, K>`**  
   型 `T` から、指定したキー `K` のプロパティだけを取り出す。

6. **`Omit<T, K>`**  
   型 `T` から、指定したキー `K` のプロパティを除外する。

7. **`Exclude<T, U>`**  
   型 `T` から型 `U` に割り当て可能な型を除外する。

8. **`Extract<T, U>`**  
   型 `T` から型 `U` に割り当て可能な型を抽出する。

9. **`NonNullable<T>`**  
   型 `T` から `null` および `undefined` を除外する。

10. **`Parameters<T>`**  
    関数型 `T` の引数型をタプル型として取得する。

11. **`ConstructorParameters<T>`**  
    コンストラクタ型 `T` の引数型をタプル型として取得する。

12. **`ReturnType<T>`**  
    関数型 `T` の戻り値の型を取得する。

13. **`InstanceType<T>`**  
    コンストラクタ型 `T` のインスタンスの型を取得する。

14. **`ThisParameterType<T>`**  
    型 `T` から `this` パラメータの型を抽出する。

15. **`OmitThisParameter<T>`**  
    型 `T` から `this` パラメータを除去する。

16. **`ThisType<T>`**  
    型 `T` を `this` の型として設定するための特別な型。

17. **`Awaited<T>`**  
    プロミスの戻り値型を取得する(TypeScript 4.5 以降で追加)。

これらの型は、TypeScript が型安全性を向上させるために提供しているツールであり、すべてがコンパイル時に解決され、JavaScript のランタイムには影響を与えません。
特に、ユーティリティ型(`Partial<T>` や `Pick<T>` など)は、コードの保守性や柔軟性を高めるために非常に便利です。

### 参考リンク

- [TypeScript の Partial Type について理解する](https://zenn.dev/tommykw/articles/d7ce0b4efdabc4)
- [超便利な TypeScript の 8 つのユーティリティ型で効率アップ](https://gizanbeak.com/post/ts-utility-types)
