# node.jsのメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

## node.jsのインストール

[Installing Node.js via package manager | Node.js](https://nodejs.org/en/download/package-manager/)

## 環境設定

以下を.profileに追加(理由は後述)
```
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
PATH="$NPM_CONFIG_PREFIX/bin:./node_modules/.bin:$PATH"
export MANPATH="$NPM_CONFIG_PREFIX/man:$MANPATH"
```

## 環境設定: npmのオートコンプリート(completion)

```
npm completion >> ~/.bash_profile
```

参考: 
- [全部知ってる？ npmを使いこなすために絶対知っておきたい10のこと - WPJ](https://www.webprofessional.jp/10-npm-tips-and-tricks/)
- 原文: [10 Tips and Tricks That Will Make You an npm Ninja — SitePoint](https://www.sitepoint.com/10-npm-tips-and-tricks/)


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
カレントパスから1個づつ上の/node_modules

これに加えて環境変数NODE_PATHを対象にする。

npm -gでインストールしたモジュールを検索するなら
```
export NODE_PATH=`npm -g root`
```
のようなことをする
(公開するモジュールを開発しているならやるべきではない)。


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

