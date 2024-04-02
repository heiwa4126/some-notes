# npm メモ

- [npm メモ](#npm-メモ)
  - [scripts のコロン](#scripts-のコロン)
  - [package.json の bin フィールド](#packagejson-の-bin-フィールド)
  - [package.json の bin で複数書いて CommonJS と ECMAScript を混在させる](#packagejson-の-bin-で複数書いて-commonjs-と-ecmascript-を混在させる)
  - [package.json の files に package.json を書く必要はありますか?](#packagejson-の-files-に-packagejson-を書く必要はありますか)
  - [package.json の exports の node](#packagejson-の-exports-の-node)
  - [package.json の exports vs main](#packagejson-の-exports-vs-main)
  - [package.json の exports 内の types を使えるのはどのバージョンの tsc からですか?](#packagejson-の-exports-内の-types-を使えるのはどのバージョンの-tsc-からですか)
  - [tsconfig の moduleResolution](#tsconfig-の-moduleresolution)
  - [TypeScript 5.0 で追加された moduleResorution: bundle](#typescript-50-で追加された-moduleresorution-bundle)
  - [moduleResolution の node モジュール解決方式](#moduleresolution-の-node-モジュール解決方式)
  - [ECMAScript Module Support と CommonJS implementation の違い](#ecmascript-module-support-と-commonjs-implementation-の違い)
  - [`npm install -g` でインストールされたパッケージの一覧](#npm-install--g-でインストールされたパッケージの一覧)
  - [`npm install -g` のインストール先を per user にする](#npm-install--g-のインストール先を-per-user-にする)
  - [モジュールとパッケージの違い](#モジュールとパッケージの違い)

## scripts のコロン

package.json で

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

で、3 つを全部実行できる、って話をきいたんで 要確認。

## package.json の bin フィールド

bin に複数フィールドがある場合の挙動

[node\.js \- Is it possible to run multiple binaries from a single module via npx? \- Stack Overflow](https://stackoverflow.com/questions/53571669/is-it-possible-to-run-multiple-binaries-from-a-single-module-via-npx)

[cowsay/package\.json](https://www.npmjs.com/package/cowsay?activeTab=explore) には bin のエントリが 2 つある

```json
 "bin": {
    "cowsay": "./cli.js",
    "cowthink": "./cli.js"
  },
```

`npx cowsay hi!`

```output
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

```output
 _____
( hi! )
 -----
        o   ^__^
         o  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

npx は単に「npmjs のパッケージをインストールせずに実行するコマンド」ではない。

npx がコマンドを探すステップは次のようになります:

1. npx が引数として受け取ったコマンド名を、現在のプロジェクトの node_modules/.bin ディレクトリにあるファイル名と照合します。
   もし一致するものがあれば、そのファイルを実行します。

2. もし一致するものがなければ、npx は npm レジストリにそのコマンド名に対応するパッケージがあるかどうかを検索します。もし見つかれば、そのパッケージを一時的にインストールして実行します。

3. もし見つからなければ、npx は PATH 環境変数に含まれるディレクトリにそのコマンド名のファイルがあるかどうかを探します。もし見つかれば、そのファイルを実行します。

4. もし見つからなければ、npx はエラーを出力して終了します。

npx のコマンドが `@foo/command` のような場合は、そのコマンドがスコープ付きパッケージを指していると解釈されます。スコープ付きパッケージとは、@で始まる名前空間を持つパッケージのことで、npm レジストリに公開する際に他のパッケージと名前が衝突しないようにするために使われます。例えば、次のようなコマンドを使って、@vue/cli というスコープ付きパッケージから vue コマンドを実行することができます。

```bash
npx @vue/cli create my-app
```

この場合、npx は npm レジストリから@vue/cli パッケージを一時的にインストールして実行します。

npx のコマンドに'/'が含まれる場合は、
そのコマンドが GitHub 上のリポジトリを指していると解釈されます。
例えば、次のようなコマンドを使って、GitHub 上の slash-create-template というリポジトリからスラッシュコマンドを作成することができます。

```bash
npx Snazzah/slash-create-template init
```

この場合、npx は GitHub からそのリポジトリを一時的にダウンロードして実行します。

で、明示しない場合、package.json の bin のどのフィールドが実行されるか、
については諸説あってよくわからない(特にスコープ付きパッケージ名の場合)

- [@vue/cli](https://www.npmjs.com/package/@vue/cli?activeTab=explore) だと `vue`
- [@vue/cli-service](https://www.npmjs.com/package/@vue/cli-service?activeTab=explore) だと `vue-cli-service`

まあ

- **bin に複数書くのはやめとけ**
- スコープ付きなら衝突防止に vue-cli-service 式にしとけ。ただし bin 複数の場合 npx で実行できなくなる。1 個ならこれが安全。
- bin にスコープ付きパッケージ名をそのまま書くと(例えば"@vue/cli")、`npm i -g`した時に `cli`という名前になるので注意だ(なので実際の"@vue/cli"では "vue"になってる)

みたいな感じ。

## package.json の bin で複数書いて CommonJS と ECMAScript を混在させる

できません。

package.json の type にあるやつのみ

## package.json の files に package.json を書く必要はありますか?

package.json を files に書く必要はありません。
package.json は常にインクルードされるからです。
他にも README, CHANGES / CHANGELOG / HISTORY, LICENSE / LICENCE, NOTICE などのファイルも常にインクルードされます。

参考: https://docs.npmjs.com/cli/v9/configuring-npm/package-json#files

常に exclude されるのもあるので上記確認。`.gitignore` も見るのが変。

## package.json の exports の node

[conditional exports](https://nodejs.org/api/packages.html#conditional-exports) で

ここのリストに書かれている順で評価されるらしい。
正直ややこしいので"import"と"require"だけ書いとくことにする。

## package.json の exports vs main

exports が解釈できるバージョンの node なら exports 優先。
(実験版 >=12.7.0, 安定版 >=14.13.0)

## package.json の exports 内の types を使えるのはどのバージョンの tsc からですか?

&gt;= 4.7

あと exports でサブパスエクスポートを使っている場合は
moduleResolution は node16 か nodenext でないと
tsc が.d.ts が見つけられず死ぬ。

exports でサブパスエクスポートを使っていない場合(types が 1 個のとき)moduleResolution は node で OK。

以上の話は当然 TypeScript の話で。

ちなみに
package.json の 直下の types を使えるのは、
tsc のバージョン 1.6 から。

まあいろいろとめんどくさいので
自分で TypeScript でパッケージを作り、
それがサブパスにまたがる場合は、
index.ts に全部 export をまとめてしまうのがいいと思う。

## tsconfig の moduleResolution

tsconfig の moduleResolution とは、モジュール解決方式を指定するオプションです。
モジュール解決方式とは、インポート文で指定されたモジュールの場所をどのように探すかという方法です。

moduleResolution には、以下の値が設定できます。

- 'node' : Node.js の CommonJS 実装に基づいた方法です。インポート文に相対パスや絶対パスがない場合は、node_modules フォルダを探します。
- 'node16' & 'nodenext' : TypeScript 4.7 以降で使用できる、Node.js の ECMAScript モジュールサポートに基づいた方法です。インポート文にファイル拡張子が必要です。
- 'classic' : TypeScript 1.6 より前に使用されていた方法です。現代のコードではほとんど使われません。

moduleResolution を指定しない場合は、--module commonjs のときは node、
それ以外のときは classic がデフォルト値になります。
ただし、node モジュール解決方式が TypeScript コミュニティで最も一般的であり、推奨されています。

以上が tsconfig の moduleResolution に関する説明です 1[ ^2 ^][ ^3 ^ ]。もっと詳しく知りたい場合は、「node モジュール解決方式の例を見せてください」や「classic モジュール解決方式と node モジュール解決方式の違いを教えてください」などとお尋ねください。

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
- package.json の types フィールドや typings フィールドに指定されたファイル (typings は types の alias)
- index.ts, index.tsx, index.d.ts の順に付けられたファイル

もっと詳しく知りたい場合は、「bundle モジュール解決方式の例を見せてください」や「bundle モジュール解決方式と node モジュール解決方式の違いを教えてください」などとお尋ねください。

- [\`\-\-moduleResolution bundler\` \(formerly known as \`hybrid\`\) by andrewbranch · Pull Request \#51669 · microsoft/TypeScript](https://github.com/microsoft/TypeScript/pull/51669)
- [最新版 TypeScript\+webpack 5 の環境構築まとめ\(React, Three\.js のサンプル付き\) \- ICS MEDIA](https://ics.media/entry/16329/)

## moduleResolution の node モジュール解決方式

moduleResolution の node モジュール解決方式は、
拡張子レスの場合、以下のようにモジュールを探します。

- まず、インポート文に指定された名前に .ts, .tsx, .d.ts, .js, .jsx のいずれかの拡張子を付けてファイルが存在するかどうかを確認します。
- もしファイルが存在しない場合は、インポート文に指定された名前がディレクトリであると仮定して、その中に package.json があるかどうかを確認します。
- もし package.json がある場合は、その中の main プロパティに指定されたファイル名に .ts, .tsx, .d.ts, .js, .jsx のいずれかの拡張子を付けてファイルが存在するかどうかを確認します。
- もし package.json がない場合や main プロパティに指定されたファイルが存在しない場合は、ディレクトリ内に index.ts, index.tsx, index.d.ts, index.js, index.jsx のいずれかのファイルが存在するかどうかを確認します。

## ECMAScript Module Support と CommonJS implementation の違い

(省略 w)

## `npm install -g` でインストールされたパッケージの一覧

```bash
npm ls -g --depth 1
```

最近は`--depth 1` はデフォルトなので `npm ls -g` でも同じ。ツリーを全部展開したければ `--all` オプション

参考: [npm-ls | npm Docs](https://docs.npmjs.com/cli/v10/commands/npm-ls)

## `npm install -g` のインストール先を per user にする

なにが普通かは微妙だけど、普通は per user にするよね...

npmjs.com 上の公式のドキュメントはおそらくこれ:
[Resolving EACCES permissions errors when installing packages globally | npm Docs](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)
.npmrc と環境変数 NPM_CONFIG_PREFIX の両方の記述あり。

あとは
[npm config set prefix - Google 検索](https://www.google.co.jp/search?hl=ja&q=npm+config+set+prefix&lr=lang_ja)
で、初心者向けの記事がいっぱい

## モジュールとパッケージの違い

[About packages and modules | npm Docs](https://docs.npmjs.com/about-packages-and-modules)

> パッケージとは、package.json ファイルで記述されたファイルやディレクトリのことです。パッケージを npm レジストリに公開するには、package.json ファイルが必要です。package.json ファイルの作成についての詳細は、「package.json ファイルの作成」を参照してください。

> モジュールとは、Node.js の require()関数でロードできる、node_modules ディレクトリにあるファイルやディレクトリのことです。

- package.json があるのがパッケージ(npm init してるのは全部パッケージ)
- パッケージを npm i するとモジュールになる

ってことだよな。
