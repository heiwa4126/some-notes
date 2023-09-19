## scriptsのコロン

package.jsonで

```json
"scripts": {
  "build": "webpack",
  "build:dev": "webpack --mode development",
  "build:prod": "webpack --mode production"
}
```

みたいのがあったときに、

```bash
npm run build
```

で、3つを全部実行できる、って話をきいたんで 要確認。

## package.json の binフィールド

binに複数フィールドがある場合の挙動

[node\.js \- Is it possible to run multiple binaries from a single module via npx? \- Stack Overflow](https://stackoverflow.com/questions/53571669/is-it-possible-to-run-multiple-binaries-from-a-single-module-via-npx)

[cowsay/package\.json](https://www.npmjs.com/package/cowsay?activeTab=explore) には binのエントリが2つある

```json
 "bin": {
    "cowsay": "./cli.js",
    "cowthink": "./cli.js"
  },
```

`npx cowsay hi!`

```
 _____
< hi! >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

`npx -p cowsay cowthink hi!`

```
 _____
( hi! )
 -----
        o   ^__^
         o  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

npxは単に「npmjsのパッケージをインストールせずに実行するコマンド」ではない。

npxがコマンドを探すステップは次のようになります:

1. npxが引数として受け取ったコマンド名を、現在のプロジェクトのnode_modules/.binディレクトリにあるファイル名と照合します。
   もし一致するものがあれば、そのファイルを実行します。

2. もし一致するものがなければ、npxはnpmレジストリにそのコマンド名に対応するパッケージがあるかどうかを検索します。もし見つかれば、そのパッケージを一時的にインストールして実行します。

3. もし見つからなければ、npxはPATH環境変数に含まれるディレクトリにそのコマンド名のファイルがあるかどうかを探します。もし見つかれば、そのファイルを実行します。

4. もし見つからなければ、npxはエラーを出力して終了します。

npxのコマンドが `@foo/command` のような場合は、そのコマンドがスコープ付きパッケージを指していると解釈されます。スコープ付きパッケージとは、@で始まる名前空間を持つパッケージのことで、npmレジストリに公開する際に他のパッケージと名前が衝突しないようにするために使われます。例えば、次のようなコマンドを使って、@vue/cliというスコープ付きパッケージからvueコマンドを実行することができます。

```bash
npx @vue/cli create my-app
```

この場合、npxはnpmレジストリから@vue/cliパッケージを一時的にインストールして実行します。

npxのコマンドに'/'が含まれる場合は、
そのコマンドがGitHub上のリポジトリを指していると解釈されます。
例えば、次のようなコマンドを使って、GitHub上のslash-create-templateというリポジトリからスラッシュコマンドを作成することができます。

```bash
npx Snazzah/slash-create-template init
```

この場合、npxはGitHubからそのリポジトリを一時的にダウンロードして実行します。

で、明示しない場合、package.jsonのbinのどのフィールドが実行されるか、
については諸説あってよくわからない(特にスコープ付きパッケージ名の場合)

- [@vue/cli](https://www.npmjs.com/package/@vue/cli?activeTab=explore) だと `vue`
- [@vue/cli-service](https://www.npmjs.com/package/@vue/cli-service?activeTab=explore) だと `vue-cli-service`

まあ

- **binに複数書くのはやめとけ**
- スコープ付きなら衝突防止に vue-cli-service式にしとけ。ただしbin複数の場合npxで実行できなくなる。1個ならこれが安全。
- binにスコープ付きパッケージ名をそのまま書くと(例えば"@vue/cli")、`npm i -g`した時に `cli`という名前になるので注意だ(なので実際の"@vue/cli"では "vue"になってる)

みたいな感じ。

## package.json の binで複数書いてCommonJSとECMAScriptを混在させる

できません。

package.jsonのtypeにあるやつのみ

## package.json の files に package.json を書く必要はありますか?

package.json を files に書く必要はありません。
package.json は常にインクルードされるからです。
他にも README, CHANGES / CHANGELOG / HISTORY, LICENSE / LICENCE, NOTICE などのファイルも常にインクルードされます。

参考: https://docs.npmjs.com/cli/v9/configuring-npm/package-json#files

常にexcludeされるのもあるので上記確認。`.gitignore` も見るのが変。

## package.json の exports の node

[conditional exports](https://nodejs.org/api/packages.html#conditional-exports) で

ここのリストに書かれている順で評価されるらしい。
正直ややこしいので"import"と"require"だけ書いとくことにする。

## package.json の exports vs main

exportsが解釈できるバージョンのnodeならexports優先。
(実験版 >=12.7.0, 安定版 >=14.13.0)

## package.json の exports 内の types を使えるのはどのバージョンのtscからですか?

&gt;= 4.7

あと exportsでサブパスエクスポートを使っている場合は
moduleResolution は node16かnodenextでないと
tscが.d.tsが見つけられず死ぬ。

exportsでサブパスエクスポートを使っていない場合(typesが1個のとき)moduleResolution は node でOK。

以上の話は当然TypeScriptの話で。

ちなみに
package.json の 直下の types を使えるのは、
tscのバージョン1.6から。

まあいろいろとめんどくさいので
自分でTypeScriptでパッケージを作り、
それがサブパスにまたがる場合は、
index.tsに全部exportをまとめてしまうのがいいと思う。

## tsconfigのmoduleResolution

tsconfig の moduleResolution とは、モジュール解決方式を指定するオプションです。
モジュール解決方式とは、インポート文で指定されたモジュールの場所をどのように探すかという方法です。

moduleResolution には、以下の値が設定できます。

- 'node' : Node.js の CommonJS 実装に基づいた方法です。インポート文に相対パスや絶対パスがない場合は、node_modules フォルダを探します。
- 'node16' & 'nodenext' : TypeScript 4.7 以降で使用できる、Node.js の ECMAScript モジュールサポートに基づいた方法です。インポート文にファイル拡張子が必要です。
- 'classic' : TypeScript 1.6 より前に使用されていた方法です。現代のコードではほとんど使われません。

moduleResolution を指定しない場合は、--module commonjs のときは node、
それ以外のときは classic がデフォルト値になります。
ただし、node モジュール解決方式が TypeScript コミュニティで最も一般的であり、推奨されています。

以上が tsconfig の moduleResolution に関する説明です¹[ ^2 ^][ ^3 ^ ]。もっと詳しく知りたい場合は、「node モジュール解決方式の例を見せてください」や「classic モジュール解決方式と node モジュール解決方式の違いを教えてください」などとお尋ねください。

- [TypeScript: TSConfig Option: moduleResolution](https://www.typescriptlang.org/tsconfig/moduleResolution.html)
- [TypeScript: Documentation - Module Resolution](https://www.typescriptlang.org/docs/handbook/module-resolution.html)
- [モジュール解決 | TypeScript 日本語ハンドブック | js STUDIO](https://js.studio-kingdom.com/typescript/handbook/module_resolution)

## TypeScript 5.0 で追加された moduleResorution: bundle

TypeScript 5 で追加された moduleResolution の bundle とは、モジュール解決方式の一種で、
インポート文にファイル拡張子がなくてもモジュールを探すことができる方法です。
この方法は、webpack や rollup などのバンドラーを使用する場合に便利です。

bundle モジュール解決方式では、インポート文に相対パスや絶対パスがある場合は、そのままモジュールを探します。

相対パスや絶対パスがない場合は、以下の順序でモジュールを探します。

- ファイル拡張子が .ts, .tsx, .d.ts の順に付けられたファイル
- package.json の types フィールドや typings フィールドに指定されたファイル (typingsはtypesのalias)
- index.ts, index.tsx, index.d.ts の順に付けられたファイル

もっと詳しく知りたい場合は、「bundle モジュール解決方式の例を見せてください」や「bundle モジュール解決方式と node モジュール解決方式の違いを教えてください」などとお尋ねください。

- [\`\-\-moduleResolution bundler\` \(formerly known as \`hybrid\`\) by andrewbranch · Pull Request \#51669 · microsoft/TypeScript](https://github.com/microsoft/TypeScript/pull/51669)
- [最新版TypeScript\+webpack 5の環境構築まとめ\(React, Three\.jsのサンプル付き\) \- ICS MEDIA](https://ics.media/entry/16329/)

## moduleResolution の nodeモジュール解決方式

moduleResolution の node モジュール解決方式は、
拡張子レスの場合、以下のようにモジュールを探します。

- まず、インポート文に指定された名前に .ts, .tsx, .d.ts, .js, .jsx のいずれかの拡張子を付けてファイルが存在するかどうかを確認します。
- もしファイルが存在しない場合は、インポート文に指定された名前がディレクトリであると仮定して、その中に package.json があるかどうかを確認します。
- もし package.json がある場合は、その中の main プロパティに指定されたファイル名に .ts, .tsx, .d.ts, .js, .jsx のいずれかの拡張子を付けてファイルが存在するかどうかを確認します。
- もし package.json がない場合や main プロパティに指定されたファイルが存在しない場合は、ディレクトリ内に index.ts, index.tsx, index.d.ts, index.js, index.jsx のいずれかのファイルが存在するかどうかを確認します。

## ECMAScript Module Support と CommonJS implementation の違い

(省略w)

## `npm -g install` でインストールされたパッケージの一覧

```bash
npm list -g --depth 0
```
