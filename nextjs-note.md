# Next.js メモ

2023-04 から Next.js 始めて見た(Next.js v13)のでメモ

## チュートリアル

[Create a Next.js App | Learn Next.js](https://nextjs.org/learn/basics/create-nextjs-app)

```bash
pnpm create next-app@latest nextjs-blog --use-pnpm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"
cd nexnjs-blog
pnpm dev
```

## 普通のプロジェクトの始め方 (2023-07)

```bash
pnpx create-next-app@latest  my-app1 --no-src-dir --import-alias '@/*' --ts --tailwind --eslint --app --use-pnpm
```

## Nexs.js 感想

なんでもできるが
なんにもない。

- **なんでもできる** - 拡張性すごい。
- **なんにもない** - 初期状態ではほぼ何もない。CMS としてみればあって当然、みたいのが無い。

## pages to app 資料

- [Upgrading: App Router Migration | Next.js](https://nextjs.org/docs/app/building-your-application/upgrading/app-router-migration#migrating-from-pages-to-app)
- [Next.js App Router (app ディレクトリ) の逆引き辞典](https://zenn.dev/yumemi_inc/articles/next-13-app-overview)

## Next.js 課題

チュートリアルベース(まだ非 appdir)の
`/posts` (`/pages/posts`ではなく)に markdown ならべる例からの拡張で

- code ブロックのフォーマット - prism であっさりできた。まとめる
- TypeScript - これも <https://nextjs.org/learn/excel/typescript/nextjs-types> にしたがってやれば OK
- appDir 化 - やる
- markdown の画像を`next/image`にする - 不当に難しい
- markdown の内部リンクを`next/link` にする - これも不当に難しい
- MDX つかってみる - React コンポーネントとか埋め込んでみたい
- `/posts`の階層化 - 意外と簡単にできそう
- かっこいい CSS

## app dir の title

metadata を使うらしい。
head.js や head.tsx は削除したほうがいいらしい。

- [head\.js \(deprecated\)](https://beta.nextjs.org/docs/api-reference/file-conventions/head)
- [Metadata](https://beta.nextjs.org/docs/api-reference/metadata)
- 静的: `export const metadata` - <https://beta.nextjs.org/docs/guides/seo#static-metadata>
- 動的: `export generateMetadata()` - <https://beta.nextjs.org/docs/guides/seo#dynamic-metadata>

参考: [Next.js 13.2 で追加された Metadata API を使って head.js を置き換える - アルパカログ](https://alpacat.com/blog/nextjs132-metadata-api/)

- [Blog - Next.js 13.3 | Next.js](https://nextjs.org/blog/next-13-3#file-based-metadata-api)

## Module parse failed: Bad character escape sequence

Next.js 結構複雑な処理やってるらしくて、
`Module parse failed: Bad character escape sequence`
が、Next.js のバージョンに限らず再々出るみたい。

自分は React のコンポーネントで function 使ってたら
Next.js のマイナーアップデートの時点でこれが急に
出るようになったので、
アロー関数に変換したら動くようになりました。

**嘘みたいだが本当の話。**

以下 Next.js で app dir で、13.3.0 に上げたときの例:

元(./components/counter.tsx):

```typescript
"use client";
import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);
  return (
    <div>
      <button onClick={() => setCount((count) => count + 1)}>
        count is {count}
      </button>
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
      <button onClick={() => setCount((count) => count + 1)}>
        count is {count}
      </button>
    </div>
  );
};

export default Counter;
```

## Static Export for App Router

Next.js 13.3 にしたら、いままでどーしてもうまく動かなかった Static Export ができるようになった。

[Static Export for App Router](https://nextjs.org/blog/next-13-3#static-export-for-app-router)

1. app dir で作る。
2. nextConfig に `output: 'export'`
3. `npm build` でプロジェクトルート直下の `out/` 以下にビルドされる。
4. `http-server ./out` でテストしてみる。

SSG があるとどうなるかはテストしてない。

## getServerSideProps()と getStaticProps()は同じモジュールには入れられない

別のモジュールならいいわけだよね...

## app dit への移行

[Migrating from pages to app](https://beta.nextjs.org/docs/upgrade-guide#migrating-from-pages-to-app)

getServerSideProps, getStaticProps, getStaticPaths などは
[Data Fetching Fundamentals](https://beta.nextjs.org/docs/data-fetching/fundamentals)
参照。

## その戻り値の型 `Promise<Element>` は、有効な JSX 要素ではありません。

```bash
'UsersList' を JSX コンポーネントとして使用することはできません。
  その戻り値の型 'Promise<Element>' は、有効な JSX 要素ではありません。
    型 'Promise<Element>' には 型 'ReactElement<any, any>' からの次のプロパティがありません: type, props, keyts(2786)
```

みたいなやつをカッコよく回避する方法はないです。

> 残念ながら、今のところこれを回避する唯一の方法は、非同期サーバーコンポーネントに :any 型定義を使用することです。
> Next.js 13 の Typescript のドキュメントに、この方法が紹介されています。

- [reactjs \- Next 13 — client and async server component combined: 'Promise&lt;Element&gt;' is not a valid JSX element \- Stack Overflow](https://stackoverflow.com/questions/75497449/next-13-client-and-async-server-component-combined-promiseelement-is-not)
- [Configuring: TypeScript \| Next\.js](https://beta.nextjs.org/docs/configuring/typescript)
- [Async Server Component TypeScript Error](https://beta.nextjs.org/docs/configuring/typescript#async-server-component-typescript-error)

> 一時的な回避策として、コンポーネントの上に `{/_ @ts-expect-error Async Server Component _/}` を追加することで、そのコンポーネントの型チェックを無効化することができます。

あと

> Layout および Page コンポーネントには適用されません。

これはなんとなくわかる。

## Server Component と Client Component

[Rendering: Server and Client Components | Next.js](https://beta.nextjs.org/docs/rendering/server-and-client-components)

サーバー＆クライアントコンポーネントにより、開発者はサーバーとクライアントにまたがるアプリケーションを構築することができ、クライアントサイドアプリケーションの豊かなインタラクティブ性と従来のサーバーレンダリングの改善された性能を組み合わせることができます。

このページでは、Server Component と Client Component の違いと、Next.js アプリケーションでの使い方を説明します。

app ディレクトリ内のコンポーネントは、特殊なファイルやコロケーションされたコンポーネントも含め、
**デフォルトですべて React Server Components（RSC）**
になっています。

クライアントコンポーネントを使用すると、アプリケーションにクライアントサイドのインタラクティブ性を追加することができます。
Next.js では、サーバーでプリレンダリングされ、クライアントでハイドレーションされます。

'use client';ディレクトリを先頭に書けば、それはクライアントコンポーネント。

"use client "は、すべてのファイルで定義する必要はありません。
Client モジュールの境界は、「エントリーポイント」で一度だけ定義すればよく、そこにインポートされたすべてのモジュールが Client コンポーネントとみなされます。

[When to use Server vs\. Client Components?](https://beta.nextjs.org/docs/rendering/server-and-client-components#when-to-use-server-vs-client-components)

## generateStaticParams

App router の Dynamic route で設定されたページを Static な静的なファイルとして作成したい場合
generateStaticParams を使うと SSG になる。

- [Functions: generateStaticParams | Next.js](https://nextjs.org/docs/app/api-reference/functions/generate-static-params)

## import alias

```bash
pnpm create next-app@latest appdir --ts --use-pnpm
```

とかやったときの

> What import alias would you like configured? ... @/\*

とは何か?

[Next.js+TypeScript でパスの alias を設定する - Qiita](https://qiita.com/tatane616/items/e3ee99a181662ad6824b)

> Next.js + TypeScript のプロジェクトで相対パス辛いなとなったので、そのエイリアスの設定方法
> import { SomeComponent } from '@/components/SomeComponent みたいなやつです

[Advanced Features: Absolute Imports and Module Path Aliases | Next.js](https://nextjs.org/docs/advanced-features/module-path-aliases)

## app dir で カスタム 404 ページ

これ
[Advanced Features: Custom Error Page | Next.js](https://nextjs.org/docs/advanced-features/custom-error-page#404-page)
を Next.js 13.3 でやる方法がいまのところ無い。

いろいろ「出来る」って書いてあるページはいくつもあるんだけど

- notFound()で not-found.js を呼ぶ

のがほとんどで、それだとステータス 200 になる。
嘘でした 404 になりました。

また上記方法だと
dynamic segments にだけしか使えない。
「ルーティングからもれた URL」に対応できない。

app/404/page.tsx もダメだった。build で死ぬ。

13.4 以降に期待か?
これ? [not-found.js](https://nextjs.org/docs/app/api-reference/file-conventions/not-found)

## App Router (beta) 抜き書き

[File Conventions](https://beta.nextjs.org/docs/routing/fundamentals#file-conventions)

layout と template、2 つあるのはなんで?

template の方は「ただし、新しいコンポーネントインスタンスがナビゲーションにマウントされる」

ここで列挙されてるのが「特殊なファイル」で、あとは好き勝手に何を置いてもいい([Colocation](https://beta.nextjs.org/docs/routing/fundamentals#colocation))。

`route.js`がよくわからん。

[Component Hierarchy](https://beta.nextjs.org/docs/routing/fundamentals#component-hierarchy)

## revalidate

- [Data Fetching: Revalidating | Next.js](https://beta.nextjs.org/docs/data-fetching/revalidating)
- <https://beta.nextjs.org/docs/api-reference/segment-config#revalidate>

```typescript
const getUser = async (id: string) => {
  const response = await fetch(
    `https://jsonplaceholder.typicode.com/users/${id}`,
    {
      next: {
        revalidate: 60,
      },
    },
  );
  const user: User = await response.json();

  return user;
};
```

SWR だと [Automatic Revalidation – SWR](https://swr.vercel.app/docs/revalidation) ? (試すこと)
[Mutation & Revalidation – SWR](https://swr.vercel.app/docs/mutation)

そもそもサーバで SWR 使えるかよくわからん(loading.js とかの関係で)。
クライアントサイドでは SWR とか使え、って書いてあるけど。
<https://beta.nextjs.org/docs/data-fetching/fundamentals#fetching-data-on-the-server>

## fetch()

自分自身を参照するような fetch()を使うと build できない(当然だけど)。
React とは違う。クライアントコンポーネントにしてもダメ。build 時に 1 回呼ぶから。

<https://beta.nextjs.org/docs/data-fetching/caching#per-request-caching>

によると、
fetch()にはすでに cache()がパッチされているので
fetch()を使う場合には `import {cache} from "react";` は不要。
DB のクエリには cache()を使え、と書いてある。

## Turbopack

[Configuring: Turbopack | Next.js](https://beta.nextjs.org/docs/configuring/turbopack)

1 から始める場合

```bash
pnpm create next-app@latest your-app-name --ts --use-pnpm -e with-turbopack
```

既存のプロジェクトに Turbopack サポートを追加するには?

## Next.js の.env

- [Configuring: Environment Variables | Next.js](https://nextjs.org/docs/pages/building-your-application/configuring/environment-variables)
- [Next.js で環境変数（env）を使いこなすための記事](https://zenn.dev/aktriver/articles/2022-04-nextjs-env)

上記ドキュメントから引用:

**知っておくとよいこと:**
`.env`、`.env.development`、`.env.production` ファイルはデフォルトを定義しているので、リポジトリに含めるべきです。
`.env*.local` は `.gitignore` に追加する必要があります。`.env.local` は秘密を保存する場所です。

## UI ライブラリ

Tailwind 系と MUI 系と独立系。 MUI が楽でメジャーだけど重い感じがする。

Tailwind 系:

- [daisyUI — Tailwind CSS コンポーネント](https://daisyui.com/)
- [Tailwind UI - Official Tailwind CSS Components & Templates](https://tailwindui.com/) - コンポーネント集、みたい。

[@material-tailwind/react vs daisyui vs flowbite vs konsta | npm trends](https://npmtrends.com/@material-tailwind/react-vs-daisyui-vs-flowbite-vs-konsta)

あと tailwindCSS、リセット CSS で始めるのは辛いので
[@tailwindcss/typography - Tailwind CSS](https://tailwindcss.com/docs/typography-plugin)
は要ると思う。

## app dir の api

[Routing: Route Handlers | Next.js](https://nextjs.org/docs/app/building-your-application/routing/router-handlers)

## app router でないときメモ

- [getInitialProps()](https://nextjs.org/docs/pages/api-reference/functions/get-initial-props) - 古い。以下の 2 つになった
- [getStaticProps()](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-static-props)
- [getServerSideProps()](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props) - SSR のときだけ呼ばれる。

app router では
[generateStaticParams()](https://nextjs.org/docs/app/api-reference/functions/generate-static-params)

## デプロイ

Vercel にデプロイするなら

- [Building Your Application: Deploying | Next.js](https://nextjs.org/docs/pages/building-your-application/deploying#managed-nextjs-with-vercel)
- [Deploying Your Next.js App | Learn Next.js](https://nextjs.org/learn/basics/deploying-nextjs-app)

Vercel 以外のサービスなら

- [Other Services](https://nextjs.org/docs/pages/building-your-application/deploying#other-services)

セルフホスティングするなら

- [Self-Hosting](https://nextjs.org/docs/pages/building-your-application/deploying#self-hosting)
