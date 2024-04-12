# npm メモ

- [npm メモ](#npm-メモ)
  - [多分最初にこれよんだほうがよさそう](#多分最初にこれよんだほうがよさそう)
  - [scripts のコロン](#scripts-のコロン)
  - [package.json の dependencies のバージョン](#packagejson-の-dependencies-のバージョン)
  - [package.json の linter はありますか?](#packagejson-の-linter-はありますか)
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
  - [GitHub を`npm i` する](#github-をnpm-i-する)
  - [.npmrc は HOME 以外の場所にできませんか?](#npmrc-は-home-以外の場所にできませんか)
  - [`npm version`サブコマンド](#npm-versionサブコマンド)
  - [npm パッケージを GitHub の releases として公開](#npm-パッケージを-github-の-releases-として公開)
  - [`npm run` でなくて実行できるもの](#npm-run-でなくて実行できるもの)
  - [新しめの linter や formatter など (2024-04)](#新しめの-linter-や-formatter-など-2024-04)
  - [package.json に作者名とメールアドレスを書く](#packagejson-に作者名とメールアドレスを書く)
  - [npm unlink は存在しない](#npm-unlink-は存在しない)
  - [npm でグローバルでインストールしたパッケージを require() で呼ぶ](#npm-でグローバルでインストールしたパッケージを-require-で呼ぶ)
    - [まとめ](#まとめ)
  - [npx foo で実行されるのは何?](#npx-foo-で実行されるのは何)

## 多分最初にこれよんだほうがよさそう

[developers | npm Docs](https://docs.npmjs.com/cli/v10/using-npm/developers)

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

**嘘でした**。コロンあってもそれはただのラベル

## package.json の dependencies のバージョン

(pip と混じってすぐわからなくなるのでちゃんと調べる)

公式の記述:

- [dependencies - package.json | npm Docs](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#dependencies)
- [node-semver](https://github.com/npm/node-semver#readme)
- [セマンティック バージョニング 2.0.0 | Semantic Versioning](https://semver.org/lang/ja/) 日本語版
- [X ユーザーの中東いくべぇさん: 「Semantic Versioning とか言ってる人は初学者で、rpm, deb, apk, pip, gem, maven, NuGet などなどは全て semver に従ってません(独自の規則を持っている)。npm も caret とか tilde とか独自の constraint 持ってるし gem と npm に至っては caret の指すものが違います。」 / X](https://twitter.com/knqyf263/status/1323237581946048513)

semver の規格 には `~`(Tilde Ranges) も `^`(Caret Ranges) も無い。node-semver にはある。

```json
"dependencies": {
  "foo": "1.0.0",
  "bar": "^1.0.0",
  "baz": "^1.0.0-x",
  "boo": "2.x",
  "qux": "1.0.0 || 2.3.4",
  "asd": "latest",
  "git-dependency": "https://github.com/you/awesome-thing",
  "file-dependency": "file:./awesome-thing"
}
```

それぞれの意味は以下の通りです。

- `"foo": "1.0.0"`: foo パッケージの `1.0.0` 版を依存関係として指定しています。
- `"bar": "^1.0.0"`: bar パッケージの `1.0.0` 以上 `2.0.0` 未満の最新版を依存関係として指定しています。
- `"baz": "^1.0.0-x"`: bazz パッケージの `1.0.0` リリース後の最新プレリリース版を依存関係として指定しています。
- `"boo": "2.x"`: boo パッケージの `2.0.0` 以上 `3.0.0` 未満の最新版を依存関係として指定しています。
- `"qux": "1.0.0 || 2.3.4"`: qux パッケージの `1.0.0` 版または `2.3.4` 版のいずれかを依存関係として指定しています。
- `"asd": "latest"`: asd パッケージの最新版を依存関係として指定しています。
- `"git-dependency": "https://github.com/you/awesome-thing"`: GitHub リポジトリからパッケージをインストールすることを指定しています。
- `"file-dependency": "file:./awesome-thing"`: ローカルファイルからパッケージをインストールすることを指定しています。

このように、`dependencies` フィールドでは、パッケージごとに適切なバージョン指定を行うことができます。より詳細なバージョン指定の方法は ドキュメントを参照してください。

## package.json の linter はありますか?

あるんだねこれが。
これやると nodejs にパブリッシュした時の手戻りを減らせる。

- [tclindner/npm-package-json-lint: Configurable linter for package.json files](https://github.com/tclindner/npm-package-json-lint)
- [npm-package-json-lint | npm-package-json-lint](https://npmpackagejsonlint.org/)

グローバルにインストールする例:

```sh
# グローバルにインストール
npm i npm-package-json-lint -g

# つぎに https://npmpackagejsonlint.org/docs/rcfile-example/ の ~/.npmpackagejsonlintrc.json をコピペする
# とりあえず "valid-values-author" のフィールドは自分の名前に書き換えよう。
# 参照: https://npmpackagejsonlint.org/docs/rules/valid-values/valid-values-author

# 開発中のプロジェクトに移動して...
npmPkgJsonLint .  # カレント以下の全部のpackage.jsonを対象にしてlintする
npmPkgJsonLint ./package.json  # カレントのpackage.jsonを対象にしてlintする

# 他の使い方は https://npmpackagejsonlint.org/docs/cli 見てね
```

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

## GitHub を`npm i` する

こんな感じで

```sh
npm i github:heiwa4126/npm-hello1
# 上に同じ
npm i https://github.com/heiwa4126/npm-hello1.git
```

どっちでやっても package.json は

```json
  "dependencies": {
    "@heiwa4126/hello1": "github:heiwa4126/npm-hello1"
  }
```

になる。ちょっと不思議。

## .npmrc は HOME 以外の場所にできませんか?

.npmrc の設置場所を HOME ディレクトリ以外に指定することができます。

npmrc の場所は以下の順で検索されます。

1. プロジェクトの `.npmrc` ファイル
2. `$PREFIX/etc/npmrc`
3. `$PREFIX/npmrc`
4. グローバル `~/.npmrc`

参照: [npmrc | npm Docs](https://docs.npmjs.com/cli/v10/configuring-npm/npmrc)

ここで、`$PREFIX` は npm のプレフィックスパスを指しています。デフォルトでは `/usr/local` がこのパスになりますが、独自にプレフィックスパスを設定することができます。

プレフィックスパスを変更する例:

```sh
# Windowsの場合
npm config set prefix D:\npm

# Unix/Macの場合
npm config set prefix /opt/npm
```

この設定を行うと、npmrc ファイルは以下の場所で読み込まれます。

- Windows: `D:\npm\etc\npmrc`
- Unix/Mac: `/opt/npm/etc/npmrc`

つまり、`$PREFIX/etc/npmrc` にカスタムの npmrc ファイルを配置できます。この npmrc は、プロジェクトレベルの npmrc よりも優先されます。

このようにプレフィックスパスを変更することで、npmrc の場所をホームディレクトリ以外に設定可能です。企業内の npm 設定を一元管理したい場合などに役立ちます。

ただし、この設定はグローバル設定になるため、ユーザー単位で異なる設定を行いたい場合は `.npmrc` をホームディレクトリに置く必要があります。

プロジェクト単位で npmrc を設定したい場合は、プロジェクトルートに `.npmrc` ファイルを作成すれば良いでしょう。

## `npm version`サブコマンド

[npm-version | npm Docs](https://docs.npmjs.com/cli/v10/commands/npm-version)

`npm version` コマンドは、package.json の `version` フィールドを更新し、そのバージョンにタグを付けるためのコマンドです。使い方は以下の通りです。

```man
npm version [<newversion> | major | minor | patch | premajor | preminor | prepatch | prerelease [--preid=<prerelease-id>] | from-git]
```

- `<newversion>`: 新しいバージョン番号を直接指定できます。
- `major`: メジャーバージョンを増やします (例: 1.0.0 -> 2.0.0)。
- `minor`: マイナーバージョンを増やします (例: 1.0.0 -> 1.1.0)。
- `patch`: パッチバージョンを増やします (例: 1.0.0 -> 1.0.1)。
- `premajor`: プレメジャーリリースを作成します (例: 1.0.0 -> 2.0.0-0)。
- `preminor`: プレマイナーリリースを作成します (例: 1.0.0 -> 1.1.0-0)。
- `prepatch`: プレパッチリリースを作成します (例: 1.0.0 -> 1.0.1-0)。
- `prerelease`: プレリリースを作成します (例: 1.0.0 -> 1.0.1-0)。`--preid` オプションで識別子を指定できます。
- `from-git`: リポジトリの最新コミットハッシュからバージョンを決定します。

また、以下のオプションも利用できます。

- `-m, --message="<message>"`: タグに設定するメッセージを指定します。
- `-w, --workspace=<workspace-name>`: ワークスペースのプロジェクトに対してコマンドを実行します。
- `-ws, --workspaces`: すべてのワークスペースのプロジェクトに対してコマンドを実行します。

使用例:

- `npm version patch`: パッチバージョンを上げる (1.0.0 -> 1.0.1)
- `npm version minor`: マイナーバージョンを上げる (1.0.0 -> 1.1.0)
- `npm version premajor --preid=beta`: ベータ版のメジャーバージョンを作成 (1.0.0 -> 2.0.0-beta.0)
- `npm version from-git`: Git のコミットハッシュからバージョンを決定

`version` コマンドを実行すると、package.json の version が更新され、そのバージョンで Git タグが作成されます。リリース管理にとても便利なコマンドです。

一般的なフローとしては、機能追加時には `npm version minor` 、
バグ修正時には `npm version patch` を実行し、新しいリリースを作成します。

Semver 的にメジャーアップデートが必要な場合は `npm version major` を使います。

## npm パッケージを GitHub の releases として公開

`npm pack`で tarball を releases にすればいいのだから GitHub Actions として書けるはず。

このへん?

- [GitHub Packages を使用して private な npm パッケージとして公開する](https://zenn.dev/052hide/articles/github-packages-npm-052hide)
- [GitHub Packages で npm パッケージを公開してみた - あしたのチーム Tech Blog](https://engineer.ashita-team.com/entry/test-github-packages)
- [Node.js パッケージの公開 - GitHub Docs](https://docs.github.com/ja/actions/publishing-packages/publishing-nodejs-packages)

GitHub Packages とは? ([github-packages-note.md](github-packages-note.md)につづく)

## `npm run` でなくて実行できるもの

- `npm test` は `npm run test` の省略形
- `npm start` は `npm run start` の省略形
- `npm stop` は `npm run stop` の省略形
- `npm restart` は `npm run stop && npm run restart && npm run start` の省略形
- そもそも `npm run` は `npm run-script` の省略形

[npm-run-script | npm Docs](https://docs.npmjs.com/cli/v10/commands/npm-run-script)

「省略形」というのも微妙に違う感じで、例えば `npm start` だと
[npm-start | npm Docs](https://docs.npmjs.com/cli/v10/commands/npm-start)

> これは、パッケージの "scripts "オブジェクトの "start "プロパティで指定された定義済みのコマンドを実行する。
> scripts "オブジェクトに "start "プロパティが定義されていない場合、npm は node server.js を実行します。

なので概ね間違いではないけど、ちょっとドキュメント読んでから使った方がいいと思う。

## 新しめの linter や formatter など (2024-04)

- [Rust 製の Linter「Oxlint」が速すぎる](https://zenn.dev/ako/articles/d4d92a43c9e34d)
- [【2024/01 最新】husky + lint-staged でコミット前に lint を強制する方法](https://zenn.dev/risu729/articles/latest-husky-lint-staged)
- [新しい TypeScript のリンター Biome を触ってみる](https://zenn.dev/collabostyle/articles/86477d39be3a2e)
- [Biome、Web のためのツールチェーン](https://biomejs.dev/ja/)

## package.json に作者名とメールアドレスを書く

```json
  "author":  "Foo Bar",
```

から

```json
  "author": {
    "name": "Foo Bar",
    "email": "bfoo@example.com"
  },
  // もし共著者がいれば以下のように書く
  "contributors": [
    {
      "name": "Second Author",
      "email": "second-author@example.com"
    },
    {
      "name": "Third Author",
      "email": "third-author@example.com"
    }
  ],
```

## npm unlink は存在しない

`npm link` は `npm uninstall パッケージ名 -g` でアンインストール

## npm でグローバルでインストールしたパッケージを require() で呼ぶ

のはけっこう難しい。結局フルパスで呼ぶしかない。

```sh
export NODE_PATH=$(npm root -g)
```

でもいけるけど、この環境変数が設定されてることをアテにはできない。
(`NODE_PATH=$(npm root -g) node ...` でいいのか)

たぶん `import` も同じ。

require.resolve() の疑似コードは
[https://nodejs.org/api/modules.html#all-together](https://nodejs.org/api/modules.html#all-together)
にある。

[Node.js の require の検索パス #Node.js - Qiita](https://qiita.com/aosho235/items/684cccc64e72b9d714e1)

[Loading from the global folders](https://nodejs.org/api/modules.html#loading-from-the-global-folders) には

---

さらに、Node.js は以下の GLOBAL_FOLDERS のリストを検索する：

1. `$HOME/.node_modules`
2. `$HOME/.node_libraries`
3. `$PREFIX/lib/node`

ここで、`$HOME`はユーザーのホーム・ディレクトリ、
`$PREFIX` は Node.js で設定された node_prefix です。

これらは主に歴史的な理由によるものです。

---

って書いてあるなあ... あれ、これ node_prefix で npm_prefix じゃないや...

```sh
ln -s "$(npm root -g)"  "$HOME/.node_modules"
```

とかでいけそう。

### まとめ

Node.js の公式ドキュメントに基づいて`require.resolve()`の動作を解説します。

`require.resolve()`は、指定されたモジュールの完全な絶対パスを解決する関数です。解決の過程は以下の通りです:

1. **Node.js コアモジュールのチェック**

   - 指定されたモジュール名が Node.js の組み込みモジュール(fs、http 等)の場合、そのモジュールのパスを返します。

2. **絶対パス/相対パスのチェック**

   - 与えられたモジュール識別子が絶対パスまたは相対パスの場合、そのパスを解決し、そのパスが存在すれば返します。

3. **ファイルモジュールのチェック**

   - モジュール識別子が`.`、`..`、`/`で始まる場合、ファイルモジュールとみなされます。
   - カレントディレクトリと`node_modules`フォルダを探索し、一致するファイルを見つけたらそのパスを返します。

4. **ノードモジュールのロード**

   - `node_modules`フォルダ内のモジュールを解決しようと試みます。
   - まずカレントディレクトリの`node_modules`を探し、見つからなければ親ディレクトリを順に探索します。
   - `NODE_PATH`環境変数で指定されたディレクトリも探索対象になります。

5. **npm のグローバルモジュールは探索対象外**
   - npm でグローバルにインストールされたモジュールは探索対象外です。

つまり、`require.resolve()`はローカルと NODE_PATH のみを解決対象とし、npm のグローバルモジュールは解決できない点に注意が必要です。

グローバルモジュールを参照するには、npm 提供のユーティリティコマンド`npm root -g`で絶対パスを取得し、その絶対パスを指定する必要があります。

## npx foo で実行されるのは何?

package.json の bin の最初のエントリーらしい。
