# Reactメモ

## 基礎

* [現代の JavaScript チュートリアル](https://ja.javascript.info/)
* [TypeScript Deep Dive 日本語版](https://typescript-jp.gitbook.io/deep-dive/)

## Reactチュートリアル

* [チュートリアル：React の導入 – React](https://ja.reactjs.org/tutorial/tutorial.html) - めちゃめちゃ古い。関数コンポーネントとTypeScriptとHooks使うやつを見つけないと...
* [Reactをはじめる - ウェブ開発を学ぶ | MDN](https://developer.mozilla.org/ja/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/React_getting_started) - やや新しい
* [Amazon.co.jp: はじめてつくるReactアプリ with TypeScript eBook : mod728: 本](https://www.amazon.co.jp/dp/B094Z1R281)
  - [ワールドウェザー with TypeScript](https://react-typescript-book-weather-app.netlify.app/links)
  - [GitHub - mod728/react-typescript-book-weather-app: Kindle本「はじめてつくるReactアプリ with TypeScript」](https://github.com/mod728/react-typescript-book-weather-app)
  - [Free Weather API - WeatherAPI.com](https://www.weatherapi.com/)

## ツール

* React Developer Tools
  * [React Developer Tools \- Chrome Web Store](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)
  * [React Developer Tools – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)

## 公開

* [Netlify: Develop & deploy the best web experiences in record time](https://www.netlify.com/)
* [AWS で React アプリケーションを構築する - AWS Amplify を使用してシンプルなウェブアプリケーションを作成する](https://aws.amazon.com/jp/getting-started/hands-on/build-react-app-amplify-graphql/)
* [[React] GitHub Pagesにデプロイ - create-react-appで作ったReactプロジェクトをGitHub Pagesにデプロイしてみましょう。](https://dev-yakuza.posstree.com/react/github-pages/)

## 参考

* [create-react-appでは脆弱性の警告が出るが無視して良い](https://zenn.dev/appare45/articles/7f667031aab94b)
* [知っていると捗るcreate-react-appの設定 - Qiita](https://qiita.com/geekduck/items/6f99a3da15dd39658fff)
* [Node.js - npm start vs npm run xx vs node xx.jsの違い｜teratail](https://teratail.com/questions/93327) - なんかあやしい
* [お前らのReactは遅い - Qiita](https://qiita.com/teradonburi/items/5b8f79d26e1b319ac44f)

## メモ

create-react-appは
```sh
npx create-react-app your-app \
 --use-npm \
 --template typescript
```
としてyarnではなくnpmでやりました。

## 関数コンポーネント と クラスコンポーネント

- [React:関数コンポーネントとクラスコンポーネントの違い](https://www.twilio.com/blog/react-choose-functional-components-jp)
- [最近Reactを始めた人向けのReact Hooks入門](https://sbfl.net/blog/2019/11/12/react-hooks-introduction/)

「クラスコンポーネントは最近ではほぼ見ないもの」ぐらいに考えておけばいいかな。

クラスコンポーネント(Class Components):
- React.Componentを継承するクラスでrender()メソッドを持つ
- stateの処理がややこしい

関数コンポーネント(Function Components):
- JSXを返す関数
- stateはHooksで処理する

あと「ライフサイクルメソッド」 [Reactのライフサイクル - React入門 - to-R Media](https://www.to-r.net/media/react-tutorial09/)



## propsの型定義

[【初心者】React × TypeScript 基本の型定義](https://zenn.dev/ogakuzuko/articles/react-typescript-for-beginner#3.-props%E3%81%AE%E5%9E%8B%E5%AE%9A%E7%BE%A9)


## React 18でuseEffectが2回呼ばれる件

[[React 18] useEffect が2回実行されてしまう問題の対処法](https://b.0218.jp/202207202243.html)

 `<StrictMode>` をやめるのが一番手っ取り早いんだけど、もうちょっとなんとかならんのか。

 
