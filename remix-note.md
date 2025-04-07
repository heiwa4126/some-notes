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
