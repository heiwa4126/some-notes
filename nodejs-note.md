# node.js のメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

- [node.js のメモ](#nodejs-のメモ)
  - [node.js のインストール](#nodejs-のインストール)
  - [環境設定](#環境設定)
  - [環境設定: npm のオートコンプリート(completion)](#環境設定-npm-のオートコンプリートcompletion)
  - [npm の`-g`](#npm-の-g)
  - [npm の設定一覧](#npm-の設定一覧)
  - [npm の設定を編集](#npm-の設定を編集)
  - [npm にプロキシ設定](#npm-にプロキシ設定)
  - [パッケージの更新](#パッケージの更新)
  - [npm -g でインストールされる先](#npm--g-でインストールされる先)
  - [node がモジュールを探しに行く先を表示](#node-がモジュールを探しに行く先を表示)
  - [--save と--save-dev](#--save-と--save-dev)
  - [プロジェクトにインストールしたモジュールの bin を使う](#プロジェクトにインストールしたモジュールの-bin-を使う)
  - [npm link](#npm-link)
- [cafile](#cafile)
- [いちばん簡単な node.js プロジェクトの始め方](#いちばん簡単な-nodejs-プロジェクトの始め方)
  - [続き: git](#続き-git)
  - [続き: node-dev](#続き-node-dev)
- [そのほか参考リンク](#そのほか参考リンク)
- [npm install dev 抜き](#npm-install-dev-抜き)
- [npm -g が --location=global になってめんどくさい](#npm--g-が---locationglobal-になってめんどくさい)
  - [npm の補完](#npm-の補完)
  - [import/require の "node:"](#importrequire-の-node)
  - ["node ."](#node-)
  - [pnpm や yarn には npx に相当するものがありますか?](#pnpm-や-yarn-には-npx-に相当するものがありますか)
- [Web Crypto API](#web-crypto-api)
  - [local storage で暗号化](#local-storage-で暗号化)
  - [Node.js の JSON](#nodejs-の-json)

## node.js のインストール

[Installing Node.js via package manager | Node.js](https://nodejs.org/en/download/package-manager/)

snap 版があって楽。
[distributions/README.md at master · nodesource/distributions](https://github.com/nodesource/distributions/blob/master/README.md)

```sh
sudo snap install node --channel=12/stable --classic
hash -r
node -v
```

```sh
$ LANG=C date ; node -v
Tue Apr 21 11:38:54 JST 2020
v12.16.2
```

snap 版はちょっと遅いような気がする。

Debian,Ubuntu では

- [Installing Node.js via package manager | Node.js](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
- [distributions/README.md at master · nodesource/distributions](https://github.com/nodesource/distributions/blob/master/README.md#deb)
- [Ubuntu で node.js 18.x](https://github.com/nodesource/distributions/blob/master/README.md#using-ubuntu-1)

## 環境設定

以下を.profile に追加(理由は後述)

```sh
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
PATH="$NPM_CONFIG_PREFIX/bin:./node_modules/.bin:$PATH"
export MANPATH="$NPM_CONFIG_PREFIX/man:$MANPATH"
```

最近では
[npmrc | npm Docs](https://docs.npmjs.com/cli/v10/configuring-npm/npmrc#files)
にあるように
~/.npmrc の prefix= に書くのがいいらしい。あと MANPATH は最早不要かもしれん。

## 環境設定: npm のオートコンプリート(completion)

```sh
npm completion >> ~/.profile
```

参考:

- [全部知ってる？ npm を使いこなすために絶対知っておきたい 10 のこと - WPJ](https://www.webprofessional.jp/10-npm-tips-and-tricks/)
- 原文: [10 Tips and Tricks That Will Make You an npm Ninja — SitePoint](https://www.sitepoint.com/10-npm-tips-and-tricks/)

## npm の`-g`

Python の pip だと`--user`オプションで per user だが、
npm だと`-g`で per user。
`-g`をつけないとプロジェクト(`package.json`)のパッケージになる。

## npm の設定一覧

```sh
npm config list
```

## npm の設定を編集

```sh
npm config edit
```

または NPM_CONFIG_xxxx 環境変数でも設定できる。

## npm にプロキシ設定

環境変数 http_proxy, https_proxy, ftp_proxy (いつもの)

または

```
npm config set proxy http://PROXY-SERVER:PROXY-PORT
```

## パッケージの更新

どれが古いか知る

```sh
npm outdated
```

更新

```sh
npm update <pakage name>
```

pakage.json は書き換えてくれないみたい。

ncu が便利: [npm install したパッケージの更新確認とアップデート(npm-check-updates) - dackdive's blog](http://dackdive.hateblo.jp/entry/2016/10/10/095800)

グローバルは手動になるけど。

## npm -g でインストールされる先

npm config の prefix の値に/lib/node_modules をつけたところ。

prefix の設定は

```
npm config set prefix PathYouWant
```

または

```
export NPM_CONFIG_PREFIX=PathYouWant
```

確認は

```sh
npm root -g
```

`{prifixの値}/bin`を PATH 環境変数に追加しておくと楽。
(そのパスは`npm bin -g`でも得られる)
(Windows のインストーラだとオプションで追加してくれる)

参考:

- [20 - How to prevent permissions errors | npm Documentation](https://docs.npmjs.com/getting-started/fixing-npm-permissions)

## node がモジュールを探しに行く先を表示

`require('hoge')`の hoge を探しに行く先。

```sh
node -e "console.log(global.module.paths)"
```

カレントパスから 1 個づつ上の/node_modules になる。

$HOME の下の/node_modules に per user で使うモジュールを集めておきたいなら

```sh
mkdir -p $HOME/node_modules
cd $HOME/node_modules
npm install foobar
```

で
$HOME/node_modules/.bin にパスを通せばいい。

これに加えて環境変数 NODE_PATH を対象にする。

npm -g でインストールしたモジュールを検索するなら

`export NODE_PATH=$(npm -g root)`

のようなことをする
(公開するモジュールを開発しているならやるべきではない)。

Windows のデフォルトは
`%APPDATA%\npm\node_modules`

パスは ``%APPDATA%\npm` に通しておけばいい。

[folders | npm Docs](https://docs.npmjs.com/cli/v8/configuring-npm/folders)

## --save と--save-dev

開発時にいるモジュールは`--save-dev` (package.js の"dependencies"に入る)、
ライブラリとして使われる場合にいるモジュールは`--save-dev` (package.js の"devDependencies"に入る)

参考:

- [package.json | npm Documentation](https://docs.npmjs.com/files/package.json#dependencies)
- [ちゃんと使い分けてる? dependencies いろいろ。 - Qiita](https://qiita.com/cognitom/items/acc3ffcbca4c56cf2b95)

なので、たとえば GitHub から落としたプロジェクトを使いたいだけなら

```
npm i
```

さらにこのプロジェクトを改造したりするなら

```
npm i --dev
```

↑ 古い。`npm install --only=dev`

参考(必読):

- [install | npm Documentation](https://docs.npmjs.com/cli/install)

**修正**

`--save`オプションはデフォルトだった。
`npm i PackageName`で`--save`つけたのと同等になる。
(そもそも--save は-P|--save-prod のエリアスらしい)

もし依存関係に影響をあたえず(package.json に変更を加えず)パッケージを入れたいなら`--no-save`オプションを。

## プロジェクトにインストールしたモジュールの bin を使う

$HOME/.profileや$HOME/,bash_profile で./node_modules/.bin:`を PATH に追加しておく。
こんな感じ

```
export PATH="./node_modules/.bin:$PATH"
```

## npm link

便利

[npm link の基本的な使い方まとめ - Qiita](https://qiita.com/103ma2/items/284b3f00948121f23ee4)

# cafile

ZScaler という proxy が来て、npm が使えなくなってしまった。
有名でないサイトは一旦 proxy で SSL を解除して、内容を検閲し、ZScaler で再度 SSL 化するらしい。

ZScaler の CA 証明書を PEM 形式でエクスポートして、

```
npm config set cafile "<path to your certificate file>"
```

で再び使えるようになった。.npmrc を直に編集しても OK.

参考:
[How to fix SSL certificate error when running Npm on Windows? - Stack Overflow](https://stackoverflow.com/questions/13913941/how-to-fix-ssl-certificate-error-when-running-npm-on-windows)

curl なんかも

```
curl --cafile "<path to your certificate file>" ....
```

であとりあえず使える(これも.curlrc に書ける。参考: [curl を便利に使う為の.curlrc の雛型 - Qiita](https://qiita.com/hirohiro77/items/309f5bf93083744b042e))

pip も

```
pip --cert "<path to your certificate file>" ....
```

で行ける。~/.pip/pip.conf にも書ける。参考: [python - pip: cert failed, but curl works - Stack Overflow](https://stackoverflow.com/questions/19377045/pip-cert-failed-but-curl-works)

「証明書を PEM 形式でエクスポート」は Windows のバージョンによって微妙に異なるのだが、

1. コントロールパネル
1. インターネットのプロパティ
1. コンテンツタブ
1. 証明書ボタン
1. 信頼されたルート証明機関
1. リストで"Zscaler Root CA"を選択
1. エクスポートボタン
1. ウイザードで次へボタン
1. "BASE 64 encoded X509"選択
1. 次へボタン
1. ファイル名にフルパス入力
1. 次へボタン
1. 完了ボタン

の順でマウスカチカチすればだれでも簡単にできる w。

# いちばん簡単な node.js プロジェクトの始め方

[Express](https://expressjs.com/ja/)を使った
Node.js らしい
簡単なプロジェクト(http でアクセスすると Hello world を返す)を作ってみる。

```sh
mkdir hello
cd hello
npm init -f
```

`index.js`をエディタ開いて(`vi index.js`とか`emacs index.js`)、
以下をコピペ

```javascript
#!/usr/bin/env node
const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('Hello World!'));
app.listen(3000, () => console.log('Example app listening on port 3000!'));
```

([Express の「Hello World」の例](https://expressjs.com/ja/starter/hello-world.html)から引用)

```sh
npm install express
chmod +x ./index.js
```

起動

```sh
./index.js &
```

で、テスト

```sh
$ curl http://127.0.0.1:3000/
Hello World!
```

終了は

```sh
kill %1
```

で。

(本当は`jobs`でリスト出して、`kill %{該当プロセス番号}`)が正しい。

## 続き: git

ここまでで、こんな感じになってるはず。

```
.
|-- index.js
|-- node_modules
|   `-- (省略)
|-- package-lock.json
`-- package.json
```

```sh
curl 'https://www.gitignore.io/api/vim,node,emacs,visualstudiocode' -o .gitignore
git init
git add --all
git commit -am 'Initial commit'
```

あとは頑張って開発する w。

## 続き: node-dev

このままだと、index.js を編集するたびに kill して./index.js しなければならないので、[node-dev](https://www.npmjs.com/package/node-dev)を使ってみる。

```sh
npm install --save-dev node-dev
```

または

```sh
npm install node-dev -g
```

で、`./index.js &`のかわりに

```sh
node-dev index.js &
```

で起動する。`index.js`を編集&保存するごとにオートリロードするようになる。

# そのほか参考リンク

- [npm init で author や license などの初期値を指定する - teppeis blog](https://teppeis.hatenablog.com/entry/2015/12/configure-npm-init)

# npm install dev 抜き

```sh
npm i --only=prod
# or
npm i --production
```

ちょっと気に入らない。あと npm のバージョンによっても変わるらしい。
`--only=dev`は無い。

# npm -g が --location=global になってめんどくさい

なんとかインチキできんのか。

[[Solved] npm WARN config global `--global`, `--local` are deprecated. Use `--location=global` instead. npm ERR! Unexpected token '.' | NamespaceIT](https://namespaceit.com/blog/npm-warn-config-global-global-local-are-deprecated-use-locationglobal-instead-npm-err-unexpected-token)

とりあえず
`npm -g i npm@8`
で。npm 9 だと AWS SAM で TypeScript だと死ぬとかあるので、しばらくこれで。

## npm の補完

[npm\-completion \| npm Docs](https://docs.npmjs.com/cli/v9/commands/npm-completion)
には

```bash
npm completion >> ~/.bashrc
npm completion >> ~/.zshrc
```

って書いてあるけど

自分は Ubuntu で

```bash
npm completion > /tmp/npm
sudo mv /tmp/npm /usr/share/bash-completion/completions/
```

にしました(合ってるかは知らん)

## import/require の "node:"

[Node.js 18 Introduces Prefix-Only Core Modules](https://fusebit.io/blog/node-18-prefix-only-modules/?utm_source=www.reddit.com&utm_medium=referral&utm_campaign=none)

こういうやつ

```javascript
import test from 'node:test';
import assert from 'node:assert';

test('synchronous passing test', (t) => {
  // This test passes because it does not throw an exception.
  assert.strictEqual(1, 1);
});
```

> 最大の理由は、あるモジュールが Node.js のコアから来たものであることを明示するためです。ユーザランドのモジュールは 'node:' というプレフィックスでロードできないので、ツールやコードを読む人にとって、そのモジュールが Node.js core のものであることがすぐにわかるようになっています。

> これまで、すべてのコアモジュールは 'node:' という接頭辞を使っても使わなくても同じように機能しました。言い換えれば、'fs' をインポートしても 'node:fs' をインポートしても違いはありませんでした。しかし、テストランナーモジュールの導入により、このようなことはなくなりました。

> node:test' は 'node:' というプレフィックスを使ってのみインポート可能な最初のコアモジュールです。Node の新しいテストランナーを使うには、'node:test' をインポートしなければなりません。もし 'node:' というプレフィックスが含まれていなければ、 Node.js は代わりに test という名前のモジュールをユーザランドからロードしようとします。

## "node ."

ChatGPT に聞いてみました。

"node ." は、現在のフォルダにある JavaScript ファイルを実行するためのコマンドです。 "node" は、Node.js と呼ばれる JavaScript ランタイムで、JavaScript をサーバーサイドで実行するために使用されます。 "." は、現在のフォルダを指します。

このコマンドが実行されると、現在のフォルダにある JavaScript ファイルが実行されます。 その中で、package.json の"main"に記載されたファイルが優先的に実行されます。もしない場合は、index.js が実行されます。

このように実行することで、現在のフォルダにある JavaScript アプリケーションを簡単に起動することができます。

## pnpm や yarn には npx に相当するものがありますか?

ChatGPT に聞いてみました。

pnpm には、npx に相当する機能の「pnpx」というものがあります。 pnpx は、pnpm のグローバルインストールではなく、ローカルインストールしたパッケージを実行するためのコマンドです。

Yarn には、npx に相当する機能の「yarn npx」というものがあります。これは、npm に似た形式で、ローカルにインストールしたパッケージを実行するためのコマンドです。

それで、pnpx や yarn npx は、npx に似た機能を持っており、ローカルにインストールしたパッケージを実行するために使用できます。

…なんか胡乱だけど言いたいことはわかった。

- [pnpx CLI | pnpm](https://pnpm.io/ja/6.x/pnpx-cli)
- [pnpm exec | pnpm](https://pnpm.io/ja/cli/exec)
- [pnpm dlx | pnpm](https://pnpm.io/ja/cli/dlx) - これが推奨

# Web Crypto API

Node.js には `crypto` があるけど、ブラウザにはない。
代わりにブラウザには [Web Crypto API](https://developer.mozilla.org/ja/docs/Web/API/Web_Crypto_API) がある。

で、開発とかで Node.js で Web Crypto API で使えるかどうかの調査。

以下 ChatGPT:

Web Crypto API は主にブラウザー環境で実行するために設計された API です。
Node.js では、Web Crypto API は提供されていませんが、代わりに Node.js には、暗号化操作を行うために利用できる標準の crypto モジュールがあります。

crypto モジュールには、多くの暗号アルゴリズムが含まれており、ブラウザ環境の Web Crypto API と同様の機能を提供しています。
ただし、crypto モジュールには、Web Crypto API には含まれているような、鍵の派生（key derivation）や鍵交換（key exchange）といった機能が提供されていません。

そのため、Node.js で Web Crypto API と同じ機能を使うためには、Web Crypto API の代替として提供されているサードパーティ製のライブラリを利用することがあります。
例えば、Node.js で Web Crypto API 互換の API を提供するライブラリとしては、

- [node-webcrypto-ossl](https://github.com/PeculiarVentures/node-webcrypto-ossl) - Nov 3, 2021. で archive
- [@peculiar/webcrypto](https://github.com/PeculiarVentures/webcrypto) - ↑ の後継
- [node-webcrypto-p11](https://www.npmjs.com/package/node-webcrypto-p11) - ↑ と作者同じ? ↑ より更新されてる
- node-crypto - Node.js の crypto。ChatGPT の嘘

などがあります。

ただし、これらのライブラリには注意点があり、特定のライブラリを使用する前に、よく確認することをお勧めします。

## local storage で暗号化

生データよりはちょっとはマシかな... という程度でしょうが。

- [angular - Encrypting and Decryption Local storage values - Stack Overflow](https://stackoverflow.com/questions/54039031/)
- [How to Encrypt LocalStorage data? \- Digital Fortress](https://digitalfortress.tech/js/encrypt-localstorage-data/)
- [encrypt-storage](https://www.npmjs.com/package/encrypt-storage)
- [secure-web-storage](https://www.npmjs.com/package/secure-web-storage)
- [secure-ls](https://www.npmjs.com/package/secure-ls)
- [encrypt-storage vs localstorage-slim vs secure-ls vs secure-web-storage | npm trends](https://npmtrends.com/encrypt-storage-vs-localstorage-slim-vs-secure-ls-vs-secure-web-storage)

React だったら
[react-secure-storage - npm](https://www.npmjs.com/package/react-secure-storage)
というのがある。SSR だけみたい。

secure-ls つかってみた。
開発ツールでコピペしたくなくなる程度にはなんとかなる。

## Node.js の JSON

Node.js やブラウザ内蔵の JavaScript では JSON って import/require なしに使えるよね? これはなぜ?
という話。

まず [Global objects | Node.js v20.5.1 Documentation](https://nodejs.org/api/globals.html#global-objects)
というものがある。これらはグローバルオブジェクトなので import/require なしにイキナリ使える (先頭に「これらはグローバルオブジェクトじゃありません」のリストがついてるので注意)。

ここにリストされているのは Node.js 特有のオブジェクト (ファイルシステム関連などはブラウザ版 JavaScript には存在しないから)。

で、これ以外に「JavaScript 言語自体の一部である組み込みオブジェクト」というものがあって、
[標準組み込みオブジェクト - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects)
その中の [JSON - JavaScript | MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/JSON) が
最初に出てきた JSON のドキュメント。

一方、ブラウザ内蔵 JavaScript にしかない組み込みオブジェクト、というものがあって
(例えば [Document インターフェース](https://developer.mozilla.org/ja/docs/Web/API/Document) や [Window インターフェース](https://developer.mozilla.org/ja/docs/Web/API/Window))、そのリストは [Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API#%E3%82%A4%E3%83%B3%E3%82%BF%E3%83%BC%E3%83%95%E3%82%A7%E3%82%A4%E3%82%B9) にある。

これらが「インターフェース」であって「オブジェクト」でないのは、
各ブラウザによってオブジェクトの中身には差異があるからで、
最低これだけの仕様は絶対備えてますよ、というのが「インターフェース」な理由。

また、Node.js には「標準ライブラリ」というものがあって、
[Index | Node.js v20.5.1 Documentation](https://nodejs.org/api/)
これは Node.js に最初から付属していて、`npm install` 不要で、import/require すれば使えるもの。

逆に、ブラウザ内蔵 JavaScript には「標準ライブラリ」の標準というものは無く、
「特定のブラウザでしか動かない固有のライブラリ」は存在する(例えば [Firefox の拡張機能ライブラリ](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions))。
