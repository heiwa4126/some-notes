# node.jsでパッケージを作ったり使ったりするメモ

.mjs, .cjs, requireとimport
[node.js の require と import について調べなおす - Qiita](https://qiita.com/TakeshiNickOsanai/items/7899a60044d71aa8d899)


# そもそも

sha256sumを出してみる。

```bash
mkdir hello1 ; cd hello1
npm init -y  # -yは「全部デフォルトで」オプション
npm i crypto-js  # 標準のcryptではなくわざわざ外部のを使う
```

[crypto-js - npm](https://www.npmjs.com/package/crypto-js)

```javascript
const SHA256 = require("crypto-js/sha256");

const msg = "hello world"

console.log(msg)
console.log(SHA256(msg).toString())
```

出力があってるか一応確認
```bash
echo -n hello world | sha256sum
```

`~/.npm-global/lib/node_modules`


# 自分のローカルなパッケージテスト

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

add2のpackage.jsonをMocha用に書き換える
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

use-add2で `npm link @me/add2` の代わりに `npm i ../add2` もできる。
node_modules/の下にコピーされるし
package.jsonも書き変わる。