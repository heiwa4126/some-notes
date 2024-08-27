# React メモ

## 基礎

- [現代の JavaScript チュートリアル](https://ja.javascript.info/)
- [TypeScript Deep Dive 日本語版](https://typescript-jp.gitbook.io/deep-dive/)

## React チュートリアル

- [チュートリアル：React の導入 – React](https://ja.reactjs.org/tutorial/tutorial.html) - めちゃめちゃ古い。関数コンポーネントと TypeScript と Hooks 使うやつを見つけないと...
- [React をはじめる - ウェブ開発を学ぶ | MDN](https://developer.mozilla.org/ja/docs/Learn/Tools_and_testing/Client-side_JavaScript_frameworks/React_getting_started) - やや新しい
- [Amazon.co.jp: はじめてつくる React アプリ with TypeScript eBook : mod728: 本](https://www.amazon.co.jp/dp/B094Z1R281)
  - [ワールドウェザー with TypeScript](https://react-typescript-book-weather-app.netlify.app/links)
  - [GitHub - mod728/react-typescript-book-weather-app: Kindle 本「はじめてつくる React アプリ with TypeScript」](https://github.com/mod728/react-typescript-book-weather-app)
  - [Free Weather API - WeatherAPI.com](https://www.weatherapi.com/)

## ツール

- React Developer Tools
  - [React Developer Tools \- Chrome Web Store](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)
  - [React Developer Tools – Get this Extension for 🦊 Firefox (en-US)](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)

## 公開

- [Netlify: Develop & deploy the best web experiences in record time](https://www.netlify.com/)
- [AWS で React アプリケーションを構築する - AWS Amplify を使用してシンプルなウェブアプリケーションを作成する](https://aws.amazon.com/jp/getting-started/hands-on/build-react-app-amplify-graphql/)
- [[React] GitHub Pages にデプロイ - create-react-app で作った React プロジェクトを GitHub Pages にデプロイしてみましょう。](https://dev-yakuza.posstree.com/react/github-pages/)

## 参考

- [create-react-app では脆弱性の警告が出るが無視して良い](https://zenn.dev/appare45/articles/7f667031aab94b)
- [知っていると捗る create-react-app の設定 - Qiita](https://qiita.com/geekduck/items/6f99a3da15dd39658fff)
- [Node.js - npm start vs npm run xx vs node xx.js の違い｜ teratail](https://teratail.com/questions/93327) - なんかあやしい
- [お前らの React は遅い - Qiita](https://qiita.com/teradonburi/items/5b8f79d26e1b319ac44f)

## メモ

create-react-app は

```sh
npx create-react-app your-app \
 --use-npm \
 --template typescript
```

として yarn ではなく npm でやりました。

## 関数コンポーネント と クラスコンポーネント

- [React:関数コンポーネントとクラスコンポーネントの違い](https://www.twilio.com/blog/react-choose-functional-components-jp)
- [最近 React を始めた人向けの React Hooks 入門](https://sbfl.net/blog/2019/11/12/react-hooks-introduction/)

「クラスコンポーネントは最近ではほぼ見ないもの」ぐらいに考えておけばいいかな。

クラスコンポーネント(Class Components):

- React.Component を継承するクラスで render()メソッドを持つ
- state の処理がややこしい

関数コンポーネント(Function Components):

- JSX を返す関数
- state は Hooks で処理する

あと「ライフサイクルメソッド」 [React のライフサイクル - React 入門 - to-R Media](https://www.to-r.net/media/react-tutorial09/)

## props の型定義

[【初心者】React × TypeScript 基本の型定義](https://zenn.dev/ogakuzuko/articles/react-typescript-for-beginner#3.-props%E3%81%AE%E5%9E%8B%E5%AE%9A%E7%BE%A9)

## React 18 で useEffect が 2 回呼ばれる件

[[React 18] useEffect が 2 回実行されてしまう問題の対処法](https://b.0218.jp/202207202243.html)

`<StrictMode>` をやめるのが一番手っ取り早いんだけど、もうちょっとなんとかならんのか。

[AbortController](https://developer.mozilla.org/ja/docs/Web/API/AbortController) を使う例。
[React 18 useEffect Double Call for APIs: Emergency Fix | by Jack Herrington | JavaScript in Plain English](https://javascript.plainenglish.io/react-18-useeffect-double-call-for-apis-emergency-fix-724b7ee6a646)

react-query を使う。

React.StrictMode がなぜ 2 度呼ぶかだんだんわかってきた...なるほど。

## React の SPA に認証/認可を実装するにあたり、フレームワークはありますか?

ChatGPT に聞いてみた(ので正しいかは疑問)。

React には認証/認可を実装するためのフレームワークは標準では提供されていませんが、現在多くのパッケージが提供されています。

以下は、React で認証/認可を実装するためによく使用されるフレームワークの一部です。

- react-router: React アプリケーションのルーティングを管理するために使用されるフレームワークで、認証/認可機能を拡張するためのパッケージもあります。
- react-auth0: Auth0 という認証プラットフォームと統合するためのパッケージで、React アプリケーションでの認証/認可を簡単に実装することができます。
- react-firebase-auth: Firebase 認証と統合するためのパッケージで、React アプリケーションでの認証/認可を簡単に実装することができます。
- react-jwt-auth-hoc: JSON Web Token(JWT)を使用した認証/認可を簡単に実装するためのパッケージで、React アプリケーションでの認証/認可を簡単に実装することができます。
- redux-auth-wrapper: Redux を使用した React アプリケーションでの認証/認可を簡単に実装するためのパッケージで、認証状態の管理を行うことができます。

これらのフレームワークは、認証/認可の方法や要件に応じて、使用するものを選ぶことができます。

## Hydrate/Rehydrate

"Hydrate"と"Rehydrate"は、React アプリケーションにおいてサーバーサイドレンダリング（SSR）とクライアントサイドレンダリング（CSR）を統合するための専門用語です。

サーバーサイドレンダリングでは、アプリケーションの HTML マークアップがサーバー上で生成され、ブラウザに送信されます。
このマークアップは、JavaScript の実行前にブラウザ上に存在します。

一方、クライアントサイドレンダリングでは、JavaScript が実行されてアプリケーションが描画されます。
このとき、React は既存のマークアップを使用してアプリケーションを再描画します。これを"Hydrate"と呼びます。

"Rehydrate"は、再描画されたアプリケーションに状態を戻すことを意味します。
例えば、サーバーサイドレンダリングで生成された HTML マークアップから localStorage や Cookie などの状態情報を読み取り、クライアントサイドレンダリングでアプリケーションに再適用することを指します。

これらの用語は、SSR と CSR を統合することで、ユーザーの読み込み時間を短縮し、ページのパフォーマンスを向上させることができます。

## React の useEfect でオブジェクトの比較に使われるのは shallow compare ですか? useState ではどうですか?

React の useState および useEffect フックでは、デフォルトで浅い比較が使用されます。
つまり、オブジェクトが同じ参照を持っている場合には同じであると見なされます。
このため、オブジェクトに対して直接プロパティを変更すると、オブジェクトの参照が同じままであり、useState および useEffect フックはそれを検出できず、再レンダリングが行われません。

いろいろやってみたけど、この動作がいちばん簡単で自由度が高い感じ。

## JSX.Element vs ReactElement vs ReactNode

- [JSX\.Element vs ReactElement vs ReactNode \- DEV Community](https://dev.to/fromaline/jsxelement-vs-reactelement-vs-reactnode-2mh2)
- [ReactElement・ReactNode・JSX.Element の違い](https://zenn.dev/i_sa/scraps/2db2fc0deb223e)

SX.Element, ReactElement, ReactNode は、React の中で使用される型であり、以下のような違いがあります。

- **JSX.Element**：JSX 構文を使って書かれた React 要素（コンポーネント、HTML 要素、テキストなど）の型を表します。React のコンポーネントは JSX.Element を返す必要があります。ReactElement と同じで、props と type が any 型になっています
- **ReactElement**：JSX.Element と同じ意味で、React ライブラリで定義されている型のエイリアスです。ReactElement は ReactNode の一部であり、ReactNode が持つ props、key、ref を持っています。type と props はジェネリックで指定できます
- **ReactNode**：React の要素の型を表します。ReactNode は React の仮想 DOM に描画されるすべての要素を表し、文字列、数値、ReactElement など、すべての可能な型を含みます。ReactNode は props、key、ref を持ちますが、型情報は失われています。React のクラスコンポーネントの render() メソッドの戻り値は ReactNode 型になります。

つまり、JSX.Element と ReactElement は同じものを表しており、ReactNode は JSX.Element を含むすべての要素を表しています。
React コンポーネントの返り値としては JSX.Element を使うことが一般的です。

## useEffect()の lambda の戻り値って何を返せばいいんでしたっけ?

クリーンアップ関数を返す必要があります。

クリーンアップ関数は、
コンポーネントがアンマウントされる前や、
依存関係が変更される前に実行されるもので、
リソースの解放やイベントリスナーの解除など、
サイドエフェクトをクリーンにするために使用されます。

よくある例:

```javascript
useEffect(() => {
  const timer = setTimeout(() => {
    console.log('Timer executed');
  }, 1000);

  // クリーンアップ関数
  return () => {
    clearTimeout(timer); // タイマーをクリア
  };
}, []);
```
