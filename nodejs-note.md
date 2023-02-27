# node.jsのメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

- [node.jsのメモ](#nodejsのメモ)
  - [node.jsのインストール](#nodejsのインストール)
  - [環境設定](#環境設定)
  - [環境設定: npmのオートコンプリート(completion)](#環境設定-npmのオートコンプリートcompletion)
  - [npmの`-g`](#npmの-g)
  - [npmの設定一覧](#npmの設定一覧)
  - [npmの設定を編集](#npmの設定を編集)
  - [npmにプロキシ設定](#npmにプロキシ設定)
  - [パッケージの更新](#パッケージの更新)
  - [npm -g でインストールされる先](#npm--g-でインストールされる先)
  - [nodeがモジュールを探しに行く先を表示](#nodeがモジュールを探しに行く先を表示)
  - [--saveと--save-dev](#--saveと--save-dev)
  - [プロジェクトにインストールしたモジュールのbinを使う](#プロジェクトにインストールしたモジュールのbinを使う)
  - [npm link](#npm-link)
- [cafile](#cafile)
- [いちばん簡単なnode.jsプロジェクトの始め方](#いちばん簡単なnodejsプロジェクトの始め方)
  - [続き: git](#続き-git)
  - [続き: node-dev](#続き-node-dev)
- [そのほか参考リンク](#そのほか参考リンク)
- [npm install dev抜き](#npm-install-dev抜き)
- [npm -g が --location=global になってめんどくさい](#npm--g-が---locationglobal-になってめんどくさい)
- [npmの補完](#npmの補完)
- [import/requireの "node:"](#importrequireの-node)
- ["node ."](#node-)
- [pnpmやyarnにはnpxに相当するものがありますか?](#pnpmやyarnにはnpxに相当するものがありますか)
- [Web Crypto API](#web-crypto-api)
- [local storageで暗号化](#local-storageで暗号化)

## node.jsのインストール

[Installing Node.js via package manager | Node.js](https://nodejs.org/en/download/package-manager/)

snap版があって楽。
[distributions/README.md at master · nodesource/distributions](https://github.com/nodesource/distributions/blob/master/README.md)

``` sh
sudo snap install node --channel=12/stable --classic
hash -r
node -v
```

```
$ LANG=C date ; node -v
Tue Apr 21 11:38:54 JST 2020
v12.16.2
```

snap版はちょっと遅いような気がする。

Debian,Ubuntuでは
- [Installing Node.js via package manager | Node.js](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
- [distributions/README.md at master · nodesource/distributions](https://github.com/nodesource/distributions/blob/master/README.md#deb)
- [Ubuntuでnode.js 18.x](https://github.com/nodesource/distributions/blob/master/README.md#using-ubuntu-1)


## 環境設定

以下を.profileに追加(理由は後述)
```
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
PATH="$NPM_CONFIG_PREFIX/bin:./node_modules/.bin:$PATH"
export MANPATH="$NPM_CONFIG_PREFIX/man:$MANPATH"
```

## 環境設定: npmのオートコンプリート(completion)

```
npm completion >> ~/.profile
```

参考: 
- [全部知ってる？ npmを使いこなすために絶対知っておきたい10のこと - WPJ](https://www.webprofessional.jp/10-npm-tips-and-tricks/)
- 原文: [10 Tips and Tricks That Will Make You an npm Ninja — SitePoint](https://www.sitepoint.com/10-npm-tips-and-tricks/)

## npmの`-g`

Pythonのpipだと`--user`オプションでper userだが、
npmだと`-g`でper user。
`-g`をつけないとプロジェクト(`package.json`)のパッケージになる。


## npmの設定一覧
```
npm config list
```

## npmの設定を編集
```
npm config edit
```
またはNPM_CONFIG_xxxx環境変数でも設定できる。

## npmにプロキシ設定

環境変数http_proxy, https_proxy, ftp_proxy (いつもの)

または
```
npm config set proxy http://PROXY-SERVER:PROXY-PORT
```

## パッケージの更新

どれが古いか知る
```
npm outdated
```

更新
```
npm update <pakage name>
```
pakage.jsonは書き換えてくれないみたい。

ncuが便利: [npm installしたパッケージの更新確認とアップデート(npm-check-updates) - dackdive's blog](http://dackdive.hateblo.jp/entry/2016/10/10/095800)

グローバルは手動になるけど。

## npm -g でインストールされる先

npm config の prefixの値に/lib/node_modulesをつけたところ。

prefixの設定は
```
npm config set prefix PathYouWant
```
または
```
export NPM_CONFIG_PREFIX=PathYouWant
```

確認は
```
npm root -g
```

`{prifixの値}/bin`をPATH環境変数に追加しておくと楽。
(そのパスは`npm bin -g`でも得られる)
(Windowsのインストーラだとオプションで追加してくれる)

参考:
- [20 - How to prevent permissions errors | npm Documentation](https://docs.npmjs.com/getting-started/fixing-npm-permissions)

## nodeがモジュールを探しに行く先を表示


`require('hoge')`のhogeを探しに行く先。

```
node -e "console.log(global.module.paths)" 
```
カレントパスから1個づつ上の/node_modulesになる。

$HOMEの下の/node_modulesにper userで使うモジュールを集めておきたいなら
```sh
mkdir -p $HOME/node_modules
cd $HOME/node_modules
npm install foobar
```
で
$HOME/node_modules/.binにパスを通せばいい。


これに加えて環境変数NODE_PATHを対象にする。

npm -gでインストールしたモジュールを検索するなら

`export NODE_PATH=$(npm -g root)`

のようなことをする
(公開するモジュールを開発しているならやるべきではない)。


Windowsのデフォルトは
`%APPDATA%\npm\node_modules`

パスは ``%APPDATA%\npm` に通しておけばいい。


[folders | npm Docs](https://docs.npmjs.com/cli/v8/configuring-npm/folders)



## --saveと--save-dev

開発時にいるモジュールは`--save-dev` (package.jsの"dependencies"に入る)、
ライブラリとして使われる場合にいるモジュールは`--save-dev` (package.jsの"devDependencies"に入る)

参考:
- [package.json | npm Documentation](https://docs.npmjs.com/files/package.json#dependencies)
- [ちゃんと使い分けてる? dependenciesいろいろ。 - Qiita](https://qiita.com/cognitom/items/acc3ffcbca4c56cf2b95)

なので、たとえばGitHubから落としたプロジェクトを使いたいだけなら
```
npm i
```
さらにこのプロジェクトを改造したりするなら
```
npm i --dev
```
↑古い。`npm install --only=dev`

参考(必読):
- [install | npm Documentation](https://docs.npmjs.com/cli/install)

**修正**

`--save`オプションはデフォルトだった。
`npm i PackageName`で`--save`つけたのと同等になる。
(そもそも--saveは-P|--save-prodのエリアスらしい)

もし依存関係に影響をあたえず(package.jsonに変更を加えず)パッケージを入れたいなら`--no-save`オプションを。



## プロジェクトにインストールしたモジュールのbinを使う

$HOME/.profileや$HOME/,bash_profileで./node_modules/.bin:`をPATHに追加しておく。
こんな感じ
```
export PATH="./node_modules/.bin:$PATH"
```

## npm link

便利

[npm linkの基本的な使い方まとめ - Qiita](https://qiita.com/103ma2/items/284b3f00948121f23ee4)


# cafile

ZScalerというproxyが来て、npmが使えなくなってしまった。
有名でないサイトは一旦proxyでSSLを解除して、内容を検閲し、ZScalerで再度SSL化するらしい。

ZScalerのCA証明書をPEM形式でエクスポートして、
```
npm config set cafile "<path to your certificate file>"
```
で再び使えるようになった。.npmrcを直に編集してもOK.

参考:
[How to fix SSL certificate error when running Npm on Windows? - Stack Overflow](https://stackoverflow.com/questions/13913941/how-to-fix-ssl-certificate-error-when-running-npm-on-windows)


curlなんかも
```
curl --cafile "<path to your certificate file>" ....
```
であとりあえず使える(これも.curlrcに書ける。参考: [curlを便利に使う為の.curlrcの雛型 - Qiita](https://qiita.com/hirohiro77/items/309f5bf93083744b042e))

pipも
```
pip --cert "<path to your certificate file>" ....
```
で行ける。~/.pip/pip.confにも書ける。参考: [python - pip: cert failed, but curl works - Stack Overflow](https://stackoverflow.com/questions/19377045/pip-cert-failed-but-curl-works)

「証明書をPEM形式でエクスポート」はWindowsのバージョンによって微妙に異なるのだが、
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

の順でマウスカチカチすればだれでも簡単にできるw。

# いちばん簡単なnode.jsプロジェクトの始め方

[Express](https://expressjs.com/ja/)を使った
Node.jsらしい
簡単なプロジェクト(httpでアクセスするとHello worldを返す)を作ってみる。


```sh
mkdir hello
cd hello
npm init -f
```
`index.js`をエディタ開いて(`vi index.js`とか`emacs index.js`)、
以下をコピペ

```javascript
#!/usr/bin/env node
const express = require('express')
const app = express()
app.get('/', (req, res) => res.send('Hello World!'))
app.listen(3000, () => console.log('Example app listening on port 3000!'))
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

あとは頑張って開発するw。

## 続き: node-dev

このままだと、index.jsを編集するたびにkillして./index.jsしなければならないので、[node-dev](https://www.npmjs.com/package/node-dev)を使ってみる。

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

- [npm initでauthorやlicenseなどの初期値を指定する - teppeis blog](https://teppeis.hatenablog.com/entry/2015/12/configure-npm-init)



# npm install dev抜き

```sh
npm i --only=prod
# or
npm i --production
```

ちょっと気に入らない。あとnpmのバージョンによっても変わるらしい。
`--only=dev`は無い。


# npm -g が --location=global になってめんどくさい

なんとかインチキできんのか。

[[Solved] npm WARN config global `--global`, `--local` are deprecated. Use `--location=global` instead. npm ERR! Unexpected token '.' | NamespaceIT](https://namespaceit.com/blog/npm-warn-config-global-global-local-are-deprecated-use-locationglobal-instead-npm-err-unexpected-token)

とりあえず
`npm -g i npm@8`
で。npm 9だとAWS SAMでTypeScriptだと死ぬとかあるので、しばらくこれで。


# npmの補完

[npm\-completion \| npm Docs](https://docs.npmjs.com/cli/v9/commands/npm-completion)
には

```bash
npm completion >> ~/.bashrc
npm completion >> ~/.zshrc
```
って書いてあるけど

自分はUbuntuで
```bash
npm completion > /tmp/npm
sudo mv /tmp/npm /usr/share/bash-completion/completions/
```
にしました(合ってるかは知らん)


# import/requireの "node:"

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


# "node ."

ChatGPTに聞いてみました。

"node ." は、現在のフォルダにあるJavaScriptファイルを実行するためのコマンドです。 "node" は、Node.jsと呼ばれるJavaScriptランタイムで、JavaScriptをサーバーサイドで実行するために使用されます。 "." は、現在のフォルダを指します。

このコマンドが実行されると、現在のフォルダにあるJavaScriptファイルが実行されます。 その中で、package.jsonの"main"に記載されたファイルが優先的に実行されます。もしない場合は、index.jsが実行されます。

このように実行することで、現在のフォルダにあるJavaScriptアプリケーションを簡単に起動することができます。

# pnpmやyarnにはnpxに相当するものがありますか?

ChatGPTに聞いてみました。

pnpmには、npxに相当する機能の「pnpx」というものがあります。 pnpxは、pnpmのグローバルインストールではなく、ローカルインストールしたパッケージを実行するためのコマンドです。

Yarnには、npxに相当する機能の「yarn npx」というものがあります。これは、npmに似た形式で、ローカルにインストールしたパッケージを実行するためのコマンドです。

それで、pnpxやyarn npxは、npxに似た機能を持っており、ローカルにインストールしたパッケージを実行するために使用できます。

…なんか胡乱だけど言いたいことはわかった。

- [pnpx CLI | pnpm](https://pnpm.io/ja/6.x/pnpx-cli)
- [pnpm exec | pnpm](https://pnpm.io/ja/cli/exec)
- [pnpm dlx | pnpm](https://pnpm.io/ja/cli/dlx) - これが推奨


# Web Crypto API

Node.js には `crypto` があるけど、ブラウザにはない。
代わりにブラウザには [Web Crypto API](https://developer.mozilla.org/ja/docs/Web/API/Web_Crypto_API) がある。

で、開発とかで Node.js で Web Crypto APIで使えるかどうかの調査。

以下ChatGPT:

Web Crypto APIは主にブラウザー環境で実行するために設計されたAPIです。
Node.jsでは、Web Crypto APIは提供されていませんが、代わりにNode.jsには、暗号化操作を行うために利用できる標準のcryptoモジュールがあります。

cryptoモジュールには、多くの暗号アルゴリズムが含まれており、ブラウザ環境のWeb Crypto APIと同様の機能を提供しています。
ただし、cryptoモジュールには、Web Crypto APIには含まれているような、鍵の派生（key derivation）や鍵交換（key exchange）といった機能が提供されていません。

そのため、Node.jsでWeb Crypto APIと同じ機能を使うためには、Web Crypto APIの代替として提供されているサードパーティ製のライブラリを利用することがあります。
例えば、Node.jsでWeb Crypto API互換のAPIを提供するライブラリとしては、
- [node-webcrypto-ossl](https://github.com/PeculiarVentures/node-webcrypto-ossl) - Nov 3, 2021. で archive
- [@peculiar/webcrypto](https://github.com/PeculiarVentures/webcrypto) - ↑の後継
- [node-webcrypto-p11](https://www.npmjs.com/package/node-webcrypto-p11) - ↑と作者同じ? ↑より更新されてる
- node-crypto - Node.jsのcrypto。ChatGPTの嘘

などがあります。

ただし、これらのライブラリには注意点があり、特定のライブラリを使用する前に、よく確認することをお勧めします。


# local storageで暗号化

生データよりはちょっとはマシかな... という程度でしょうが。

- [angular - Encrypting and Decryption Local storage values - Stack Overflow](https://stackoverflow.com/questions/54039031/)
- [How to Encrypt LocalStorage data? \- Digital Fortress](https://digitalfortress.tech/js/encrypt-localstorage-data/)
- [encrypt-storage](https://www.npmjs.com/package/encrypt-storage)
- [secure-web-storage](https://www.npmjs.com/package/secure-web-storage)
- [secure-ls](https://www.npmjs.com/package/secure-ls)
- [encrypt-storage vs localstorage-slim vs secure-ls vs secure-web-storage | npm trends](https://npmtrends.com/encrypt-storage-vs-localstorage-slim-vs-secure-ls-vs-secure-web-storage)

Reactだったら
[react-secure-storage - npm](https://www.npmjs.com/package/react-secure-storage)
というのがある。SSRだけみたい。


secure-lsつかってみた。
開発ツールでコピペしたくなくなる程度にはなんとかなる。
