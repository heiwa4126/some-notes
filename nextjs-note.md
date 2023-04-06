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
