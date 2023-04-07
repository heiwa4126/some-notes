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
