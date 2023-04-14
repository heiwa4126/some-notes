2023-04からNext.js 始めて見た(Next.js v13)のでメモ

## チュートリアル

[Create a Next.js App | Learn Next.js](https://nextjs.org/learn/basics/create-nextjs-app)

```bash
pnpm create next-app@latest nextjs-blog --use-pnpm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"
cd nexnjs-blog
pnpm dev
```

## Nexs.js 感想

なんでもできるが
なんにもない。

- **なんでもできる** - 拡張性すごい。
- **なんにもない** - 初期状態ではほぼ何もない。CMSとしてみればあって当然、みたいのが無い。


## Next.js 課題

チュートリアルベース(まだ非appdir)の
`/posts` (`/pages/posts`ではなく)にmarkdownならべる例からの拡張で

- codeブロックのフォーマット - prismであっさりできた。まとめる
- TypeScript - これも https://nextjs.org/learn/excel/typescript/nextjs-types にしたがってやればOK
- appDir化 - やる
- markdownの画像を`next/image`にする - 不当に難しい
- markdownの内部リンクを`next/link` にする - これも不当に難しい
- MDXつかってみる - Reactコンポーネントとか埋め込んでみたい
- `/posts`の階層化 - 意外と簡単にできそう
- かっこいいCSS

## app dir の title

metadataを使うらしい。
head.jsやhead.tsxは削除したほうがいいらしい。

- [head\.js \(deprecated\)](https://beta.nextjs.org/docs/api-reference/file-conventions/head)
- [Metadata](https://beta.nextjs.org/docs/api-reference/metadata)
- 静的: `export const metadata` - https://beta.nextjs.org/docs/guides/seo#static-metadata
- 動的: `export generateMetadata()` - https://beta.nextjs.org/docs/guides/seo#dynamic-metadata

参考: [Next.js 13.2で追加されたMetadata APIを使ってhead.jsを置き換える - アルパカログ](https://alpacat.com/blog/nextjs132-metadata-api/)

- [Blog - Next.js 13.3 | Next.js](https://nextjs.org/blog/next-13-3#file-based-metadata-api)


## Module parse failed: Bad character escape sequence

Next.js 結構複雑な処理やってるらしくて、
`Module parse failed: Bad character escape sequence`
が、Next.jsのバージョンに限らず再々出るみたい。

自分はReactのコンポーネントでfunction使ってたら
Next.jsのマイナーアップデートの時点でこれが急に
出るようになったので、
アロー関数に変換したら動くようになりました。

**嘘みたいだが本当の話。**

以下Next.jsでapp dirで、13.3.0に上げたときの例:

元(./components/counter.tsx):
```typescript
"use client";
import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <button onClick={() => setCount((count) => count + 1)}>count is {count}</button>
    </div>
  );
}
```

修正後:
```typescript
"use client";
import { useState } from "react";

const Counter = () => {
  const [count, setCount] = useState(0);
  return (
    <div>
      <button onClick={() => setCount((count) => count + 1)}>count is {count}</button>
    </div>
  );
};

export default Counter;
```


## Static Export for App Router

Next.js 13.3にしたら、いままでどーしてもうまく動かなかったStatic Exportができるようになった。

[Static Export for App Router](https://nextjs.org/blog/next-13-3#static-export-for-app-router)

1. app dirで作る。
2. nextConfig に `output: 'export'`
3. `npm build` で プロジェクトルート直下の `out/` 以下にビルドされる。
4. `http-server ./out` で テストしてみる。

SSGがあるとどうなるかはテストしてない。


## getServerSideProps()とgetStaticProps()は同じモジュールには入れられない

別のモジュールならいいわけだよね...


## app dit への移行

[Migrating from pages to app](https://beta.nextjs.org/docs/upgrade-guide#migrating-from-pages-to-app)

getServerSideProps, getStaticProps, getStaticPaths などは
[Data Fetching Fundamentals](https://beta.nextjs.org/docs/data-fetching/fundamentals)
参照。


## その戻り値の型 `Promise<Element>` は、有効な JSX 要素ではありません。

```
'UsersList' を JSX コンポーネントとして使用することはできません。
  その戻り値の型 'Promise<Element>' は、有効な JSX 要素ではありません。
    型 'Promise<Element>' には 型 'ReactElement<any, any>' からの次のプロパティがありません: type, props, keyts(2786)
```

みたいなやつをカッコよく回避する方法はないです。

> 残念ながら、今のところこれを回避する唯一の方法は、非同期サーバーコンポーネントに :any 型定義を使用することです。
> Next.js 13のTypescriptのドキュメントに、この方法が紹介されています。

- [reactjs \- Next 13 — client and async server component combined: 'Promise<Element>' is not a valid JSX element \- Stack Overflow](https://stackoverflow.com/questions/75497449/next-13-client-and-async-server-component-combined-promiseelement-is-not)
- [Configuring: TypeScript \| Next\.js](https://beta.nextjs.org/docs/configuring/typescript)
- [Async Server Component TypeScript Error](https://beta.nextjs.org/docs/configuring/typescript#async-server-component-typescript-error)


> 一時的な回避策として、コンポーネントの上に{/* @ts-expect-error Async Server Component */}を追加することで、そのコンポーネントの型チェックを無効化することができます。

あと

> LayoutおよびPageコンポーネントには適用されません。

これはなんとなくわかる。


## Server ComponentとClient Component

[Rendering: Server and Client Components | Next.js](https://beta.nextjs.org/docs/rendering/server-and-client-components)

サーバー＆クライアントコンポーネントにより、開発者はサーバーとクライアントにまたがるアプリケーションを構築することができ、クライアントサイドアプリケーションの豊かなインタラクティブ性と従来のサーバーレンダリングの改善された性能を組み合わせることができます。

このページでは、Server ComponentとClient Componentの違いと、Next.jsアプリケーションでの使い方を説明します。

appディレクトリ内のコンポーネントは、特殊なファイルやコロケーションされたコンポーネントも含め、
**デフォルトですべてReact Server Components（RSC）**
になっています。

クライアントコンポーネントを使用すると、アプリケーションにクライアントサイドのインタラクティブ性を追加することができます。
Next.jsでは、サーバーでプリレンダリングされ、クライアントでハイドレーションされます。

'use client';ディレクトリを先頭に書けば、それはクライアントコンポーネント。

"use client "は、すべてのファイルで定義する必要はありません。
Clientモジュールの境界は、「エントリーポイント」で一度だけ定義すればよく、そこにインポートされたすべてのモジュールがClientコンポーネントとみなされます。


[When to use Server vs\. Client Components?](https://beta.nextjs.org/docs/rendering/server-and-client-components#when-to-use-server-vs-client-components)

## generateStaticParams

Dynamic routeで設定されたページをStaticな静的なファイルとして作成したい場合
generateStaticParamsを使うとSSGになる。

[Server Component Functions: generateStaticParams | Next.js](https://beta.nextjs.org/docs/api-reference/generate-static-params)



## App Router (beta) 抜き書き

[File Conventions](https://beta.nextjs.org/docs/routing/fundamentals#file-conventions)

layoutとtemplate、2つあるのはなんで?

templateの方は「ただし、新しいコンポーネントインスタンスがナビゲーションにマウントされる」

ここで列挙されてるのが「特殊なファイル」で、あとは好き勝手に何を置いてもいい([Colocation](https://beta.nextjs.org/docs/routing/fundamentals#colocation))。

`route.js`がよくわからん。

[Component Hierarchy](https://beta.nextjs.org/docs/routing/fundamentals#component-hierarchy)


## revalidate

- [Data Fetching: Revalidating | Next.js](https://beta.nextjs.org/docs/data-fetching/revalidating)
- https://beta.nextjs.org/docs/api-reference/segment-config#revalidate

```typescript
const getUser = async (id: string) => {
  const response = await fetch(`https://jsonplaceholder.typicode.com/users/${id}`, {
    next: {
      revalidate: 60,
    },
  });
  const user: User = await response.json();

  return user;
};
```

SWRだと [Automatic Revalidation – SWR](https://swr.vercel.app/docs/revalidation) ? (試すこと)
[Mutation & Revalidation – SWR](https://swr.vercel.app/docs/mutation)

そもそもサーバでSWR使えるかよくわからん(loading.jsとかの関係で)。
クライアントサイドではSWRとか使え、って書いてあるけど。
https://beta.nextjs.org/docs/data-fetching/fundamentals#fetching-data-on-the-server


## fetch()

自分自身を参照するようなfetch()を使うとbuildできない(当然だけど)。
Reactとは違う。クライアントコンポーネントにしてもダメ。build時に1回呼ぶから。

https://beta.nextjs.org/docs/data-fetching/caching#per-request-caching

によると、
fetch()にはすでにcache()がパッチされているので
fetch()を使う場合には `import {cache} from "react";` は不要。
DBのクエリにはcache()を使え、と書いてある。
