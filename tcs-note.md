# moduleResolution (import/requireの拡張子の話)

## まずtscでない場合

||**拡張子あり** | **拡張子なし** |
| --- | --- | --- |
| (Node.jsの)CommonJS | 可能 | 可能 |
| (Node.jsの)ECMAScript | 可能(\*1) | 可能(\*2) |
| ブラウザ | 可能 | 可能 |
| その他 | 依存 | 依存 |

\*1: ECMAScriptの場合、importされるファイルが ".js" で終わっていない場合は、 ".js" が付けられたパスを探す。
ただし、 ".js" が見つからない場合は、 ".mjs" が付けられたパスを探す。

\*2: ECMAScriptの場合、importされるファイルがパスを指定しない場合、 "./"、 "../"、 "/"で始まるパスである場合は、 ".js" が付けられたパスを探す。ただし、 ".js" が見つからない場合は、 ".mjs" が付けられたパスを探す。ただし、モジュール解決アルゴリズムがNode.jsの場合、 ".js" が見つからない場合は、 ".json" が付けられたパスを探す。

ブラウザのJavaScriptのimportについては、これが仕様。
[import - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)

これによると「拡張子は省略できない」が基本で、ブラウザによって拡張子省略時に".js"を付加するものがあるらしい。


## Node.jsで package.jsonのextendsがある場合

package.jsonのextendsがある場合、モジュールの解決方法は、extendsされた設定を先に解析してから、ローカルのtsconfig.jsonの設定で上書きされます。つまり、extendsされた設定で moduleResolution が指定されている場合、ローカルの設定で上書きすることができます。


## tscの拡張子の扱い

拡張子の扱いは、tscコンパイラの moduleResolution オプションによって制御されます。このオプションは、以下の値を取ることができます。

| **moduleResolutionオプションの値** | **説明** |
| --- | --- |
| Classic | 拡張子ありのファイルを優先する。 |
| Node | Node.jsと同様に拡張子のないファイルを優先する。 |
| ブラウザ | 拡張子のないファイルを優先する。 |



[TypeScript: Documentation - Module Resolution](https://www.typescriptlang.org/docs/handbook/module-resolution.html)

importのモジュールリファレンス部分
- 相対 ("/", "./", "../"で始まる) - パスとみなされ、インポート元のファイルに対して相対的に解決
- 非相対 - モジュールリファレンス部はモジュールとみなされる。




## tsc で moduleResolution が classicの場合

**node_modulesを見に行かない。**

非相対モジュールリファレンスの場合の例

`/root/src/folder/A.ts` の中に
```typescript
import { b } from "moduleB"
```
があれば

1.  `/root/src/folder/moduleB.ts`
2.  `/root/src/folder/moduleB.d.ts`
3.  `/root/src/moduleB.ts`
4.  `/root/src/moduleB.d.ts`
5.  `/root/moduleB.ts`
6.  `/root/moduleB.d.ts`
7.  `/moduleB.ts`
8.  `/moduleB.d.ts`

をこの順で探す。


## Node.jsでrequireを使う場合

非相対モジュールリファレンスの場合の例

`node_modules`を順に上に再帰的にあがっていくしかけ。

`/root/src/moduleA.js` の中で
```javascript
var x = require("moduleB");
```
があれば

1.  `/root/src/node_modules/moduleB.js`
2.  `/root/src/node_modules/moduleB/package.json` (if it specifies a `"main"` property)
3.  `/root/src/node_modules/moduleB/index.js`  
4.  `/root/node_modules/moduleB.js`
5.  `/root/node_modules/moduleB/package.json` (if it specifies a `"main"` property)
6.  `/root/node_modules/moduleB/index.js`  
7.  `/node_modules/moduleB.js`
8.  `/node_modules/moduleB/package.json` (if it specifies a `"main"` property)
9.  `/node_modules/moduleB/index.js`



## tsc で moduleResolution が nodeの場合

非相対モジュールリファレンスの場合の例

`/root/src/folder/A.ts` の中に
```typescript
import { b } from "moduleB"
```
があれば
1.  `/root/src/node_modules/moduleB.ts`
2.  `/root/src/node_modules/moduleB.tsx`
3.  `/root/src/node_modules/moduleB.d.ts`
4.  `/root/src/node_modules/moduleB/package.json` (if it specifies a `types` property)
5.  `/root/src/node_modules/@types/moduleB.d.ts`
6.  `/root/src/node_modules/moduleB/index.ts`
7.  `/root/src/node_modules/moduleB/index.tsx`
8.  `/root/src/node_modules/moduleB/index.d.ts`  
9.  `/root/node_modules/moduleB.ts`
10.  `/root/node_modules/moduleB.tsx`
11.  `/root/node_modules/moduleB.d.ts`
12.  `/root/node_modules/moduleB/package.json` (if it specifies a `types` property)
13.  `/root/node_modules/@types/moduleB.d.ts`
14.  `/root/node_modules/moduleB/index.ts`
15.  `/root/node_modules/moduleB/index.tsx`
16.  `/root/node_modules/moduleB/index.d.ts`
17.  `/node_modules/moduleB.ts`
18.  `/node_modules/moduleB.tsx`
19.  `/node_modules/moduleB.d.ts`
20.  `/node_modules/moduleB/package.json` (if it specifies a `types` property)
21.  `/node_modules/@types/moduleB.d.ts`
22.  `/node_modules/moduleB/index.ts`
23.  `/node_modules/moduleB/index.tsx`
24.  `/node_modules/moduleB/index.d.ts`

の順で探す。

## モジュール解決のトレース

`tsc --traceResolution`


## tscがpackage.jsonのexportsを見に行く仕掛け

[TypeScript: Documentation - TypeScript 4.7](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#packagejson-exports-imports-and-self-referencing)
