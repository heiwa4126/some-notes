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
