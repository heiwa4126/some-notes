# node.js でパッケージを作ったり使ったりするメモ

.mjs, .cjs, require と import
[node.js の require と import について調べなおす - Qiita](https://qiita.com/TakeshiNickOsanai/items/7899a60044d71aa8d899)

## そもそも

sha256sum を出してみる。

```bash
mkdir hello1 ; cd hello1
npm init -y  # -yは「全部デフォルトで」オプション
npm i crypto-js  # 標準のcryptではなくわざわざ外部のを使う
```

[crypto-js - npm](https://www.npmjs.com/package/crypto-js)

```javascript
const SHA256 = require('crypto-js/sha256');

const msg = 'hello world';

console.log(msg);
console.log(SHA256(msg).toString());
```

出力があってるか一応確認

```bash
echo -n hello world | sha256sum
```

`~/.npm-global/lib/node_modules`

## 自分のローカルなパッケージテスト

```bash
mkdir package1 ; cd package1
mkdir add2 use-add2
cd add2
npm init --scope=me -y    # "me"は仮
cd ../use-add
npm init -y
cd ../add2
npm install --save-dev mocha
```

add2 の package.json を Mocha 用に書き換える

```json
  "scripts": {
    "test": "node_modules/mocha/bin/mocha.js"
  },
```

`add2/index.js` と `add2/test/index-test.js` を書く。

`npm test` でテスト実行。

`npm link` でリンク作る。確認は

```bash
ls -lad ~/.npm-global/lib/node_modules/@me/add2
ls -la ~/.npm-global/lib/node_modules/@me/add2/
```

つまり `npm i -g`と同じような効果があるわけだ。

このモジュールを使う側へ移動

```bash
cd ../use-add2
npm link @me/add2
```

で node_modules/の下にリンクができる。

`use-add2/index.js` を書く。`node index.js` で実行。

あとはコードを一生懸命書く。

use-add2 で `npm link @me/add2` の代わりに `npm i ../add2` もできる。
node_modules/の下にコピーされるし
package.json も書き変わる。

## yarn や pnpm

2022 年ごろのインストール方法. corepack を使う。

```bash
sudo corepack enable
corepack prepare pnpm@latest --activate
corepack prepare yarn@stable --activate
```

- [Corepack \| Node\.js v19\.4\.0 Documentation](https://nodejs.org/api/corepack.html)
- [corepack を使って npm/Yarn をお仕事的に安心して使う方法を考える \| t28\.dev](https://t28.dev/blog/manage-npm-and-yarn-using-corepack-safely/)

## モジュールとパッケージ

- [Modules: CommonJS modules](https://nodejs.org/api/modules.html)
- [Modules: ECMAScript modules](https://nodejs.org/api/esm.html)
- [Modules: Packages](https://nodejs.org/api/packages.html)
- [About packages and modules | npm Docs](https://docs.npmjs.com/about-packages-and-modules)

パッケージとは、

- package.json ファイルによって記述されるファイルまたはディレクトリ
- npm レジストリに公開するためには、パッケージに package.json ファイルが必要
- パッケージには、スコープなしと、スコープつき(`@foo/xpackage`みたいなやつ)があり、
  スコープ付きパッケージはプライベートとパブリックがある

モジュールとは、

- node_modules ディレクトリにある、Node.js の require()関数で読み込むことができるファイルやディレクトリを指す
- Node.js の require()関数で読み込まれるためには、モジュールは以下の**いずれか**に該当する必要がある
  - "main" フィールドを含む package.json ファイルを持つフォルダー
  - JavaScript ファイル

.js ファイルを含まないモジュールやパッケージが存在する。
例えば、CSS や画像などの静的ファイルのみを含むモジュールがある。
ただし、package.json ファイルは必要。

- [GitHub - css-modules/css-modules: Documentation about css-modules](https://github.com/css-modules/css-modules) の examples 参照
- [css-only · GitHub Topics · GitHub](https://github.com/topics/css-only)

つまりこれらの用語はかなり適当ということ。

- `package.json` がなければ確実に「モジュール」
- スコープがついてたら確実に「パッケージ」
- require()で読めたら「モジュール」
- それ以外はあいまい
