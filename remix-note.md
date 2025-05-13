# React Router v7 の framework モードと元 Remix のメモ

React Router v7 の data モードについては別ページに。[react-router-note.md](react-router-note.md)

- v7 framework モード - [Installation | React Router](https://reactrouter.com/start/framework/installation)
  - React Router v7 - [React Router Home | React Router](https://reactrouter.com/home)
- v7 framework モード - [インストール - React Router v7 ドキュメント 日本語版](https://react-router-docs-ja.techtalk.jp/start/framework/installation)
- v2 相当 - [Remix Docs Home | Remix](https://remix.run/docs/en/main)
- v2 相当? - [Remix ドキュメント 日本語版](https://remix-docs-ja.techtalk.jp/)

## clientLoader()

> 💿 Hey developer 👋. You can provide a way better UX than this when your app is loading JS modules and/or running `clientLoader` functions. Check out https://remix.run/route/hydrate-fallback for more information.

Remix v2 からあるらしい。

ssr: false の時、とりあえず上のメッセージを消したいときは
root.tsx に

```typescript
export function HydrateFallback() {
  return <p>Loading, please wait...</p>;
  // 文字列はご自由に
}
export async function clientLoader() {}
```

と書いとけばいい。

## マルチページの SSR として使いたいときは

[Static re-rendering](https://reactrouter.com/start/framework/rendering#static-pre-rendering)
[静的プリレンダリング](https://react-router-docs-ja.techtalk.jp/start/framework/rendering#%E9%9D%99%E7%9A%84%E3%83%97%E3%83%AA%E3%83%AC%E3%83%B3%E3%83%80%E3%83%AA%E3%83%B3%E3%82%B0)
にしないと、そのページに直接 URL で行けなくなる。

## `import type { Route } from "./+types/home"`

これは何?

- [Type Safety | React Router](https://reactrouter.com/explanation/type-safety)
- [Route Module Type Safety | React Router](https://reactrouter.com/how-to/route-module-type-safety)
- [型安全性 - React Router v7 ドキュメント 日本語版](https://react-router-docs-ja.techtalk.jp/explanation/type-safety)
- [ルートモジュールの型安全性 - React Router v7 ドキュメント 日本語版](https://react-router-docs-ja.techtalk.jp/how-to/route-module-type-safety)

たとえば`routes.ts`で

`route("page1", "routes/page1.tsx"),` だったら、
page1.tsx では
`import type { Route } from "./+types/home"`

`route("products/:id", "routes/products.tsx"),` だったら、
products.tsx では
`import type { Route } from "./+types/products"`

`route("products/:id", "routes/products/products.tsx"),` だったら、
products.tsx では
`import type { Route } from "./+types/products"`

`route("products", "routes/products/index.tsx"),` だったら、
index.tsx では
`import type { Route } from "./+types/home"`

1 個上を書けばいいらしい。どのディレクトリであっても "./+types/" らしい。
.react-router/ 以下に自動で合成される。

こんな感じで使う。

```typescript
import type { Route } from './+types/products';

export default function Products({ params }: Route.MetaArgs) {
  return (
    <>
      <h1>製品 {params.id}</h1>
      <p>製品情報</p>
    </>
  );
}
```

## basePath

GitHub Pages なんかで `/` に置けないときに。

`react-router.config.ts`で
`basename` に設定する。

[Config | React Router API Reference](https://api.reactrouter.com/v7/types/_react_router_dev.config.Config.html#__type.basename)

`/foo/` でも `/foo` でもいいみたいだけど、最後の'/'は付けといたほうがいいような気がする。

## ハイドレーション(Hydration;水分補給)

動的でない部分をなるべく HTML として返す仕掛け。
SEO 対策とか、クライアント側で最初の表示が早くなるとかの効果がある(はず)。

ハイドレーションされてるかされてないかを確認するには

- w3m や lynx などのテキストブラウザで見てみる
- Chrome などの開発者モードで、Network→ 最初にロードされる HTML の preview を見る

でわかる。要は JavaScript 抜きで何が見られるか、ということ。

まず、SSR が有効(`ssr:true`)なケースでは、

- サーバサイドで React が動いて、どうしても動的じゃないとダメじゃない部分を除いたものを送信してくる
- その後ページ全体を描画する JavaScript を要求。これを使ってクライアント側の React がハイドレーションする

という仕掛けなのでハイドレーション云々を気にする必要はない。

SSR 有効で特定のページのみプリレンダリングを選択、というケース。
ビルドすると index.html が生成され、イニシャルではそれが配信される。
なので build して index.html を編集すると(`<title>`がおすすめ)、
2 段階で変わるページが見えて面白い。

SSR 無効かつプリレンダリングも指定しない場合(つまり SPA)の時は

```typescript
export function HydrateFallback() {
  return <p>Loading, please wait...</p>;
}
```

を root.tsx などに書いておかないと

> 💿 Hey developer 👋. You can provide a way better UX than this when your app is loading JS modules and/or running `clientLoader` functions. Check out https://remix.run/route/hydrate-fallback for more information.

という警告がコンソールに出る。

SSR 無効でプリレンダリングを指定する場合

- あらかじめプリレンダリングされた HTML(SSG; Static Site Generation)を送信してくる
- その後ページ全体を描画する JavaScript を要求。これを使ってクライアント側の React がハイドレーションする

というしかけになる。

SSR 無効でプリレンダリングされていない URL は
事実上の SPA で、
ルートから呼ばれるしかけになるので
「ソフト 404」や「フォールバック」でない
HTTP サーバだと URL 直接、とかリロードに失敗するので面白い。

### ハイドレーションで最初の表示は早くなるはず

ただし

1. どうしても JavaScript がないとダメな部分を除いた HTML
2. そのページ全体をレンダリングする JavaScript を読む

の 2 段がまえなので、データの流量は倍などになるし、「最後」までにかかる時間はそれなりになるわけで。

### hydration という用語について

正確には、

1. 最初に「どうしても JavaScript がないとダメな部分を除いた HTML」が来る。これは SSR だとサーバー側で React によって生成されたもの。pre-build だったら SSG。
2. その HTML は まだ hydration(再活性化)されていない状態。
3. ブラウザがその HTML を受け取った後、クライアント側の React がその HTML に対して hydration を行う。

というのが正しい hydration の説明。

で、1.の状態の HTML には特に定まった用語がない。
ので、状況に応じてさまざまな呼び方をされ、それが混乱のもとになる。

呼び方の例:

- Static HTML
- Initial HTML
- Static HTML Shell
- Initial HTML Payload

とりあえず自分は「初期 HTML (Initial HTML)」と呼ぶことにする。

## 重要: Loader() じゃなくて loader()

[データローディング - React Router v7 ドキュメント 日本語版](https://react-router-docs-ja.techtalk.jp/start/framework/data-loading#%E3%82%B5%E3%83%BC%E3%83%90%E3%83%BC%E3%83%87%E3%83%BC%E3%82%BF%E3%83%AD%E3%83%BC%E3%83%87%E3%82%A3%E3%83%B3%E3%82%B0)

## 1 ページに複数フォーム

ちょっとめんどくさい。
