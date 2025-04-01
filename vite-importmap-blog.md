# importmap

(2025-04)

React v19 から UMD ビルドが廃止になって、
ESM ベースの CDN が推奨になりました。
(参照: [UMD ビルドの削除](https://ja.react.dev/blog/2024/04/25/react-19-upgrade-guide#umd-builds-removed))

で

```sh
pnpm create vite vite-react-esm1 --template react-ts
cd vite-react-esm1
pnpm i
pnpm build && pnpm preview
```

で <http://localhost:4173/> を開いて、動作確認したら

```sh
git init
git add --all
git commit -am 'initial commit'
```

次は ESM 対応にしてみます。

まず、`./index.html` を編集して、\</head\> の直前に
インポートマップを追加しましょう。

```html
<head>
  /*...*/
  <script type="importmap">
    {
      "imports": {
        "react": "https://esm.sh/react@19/",
        "react-dom/client": "https://esm.sh/react-dom@19/client"
      }
    }
  </script>
</head>
```

つぎに `./vite.config.ts` を編集して
defineConfig に rollup のオプションを追加しましょう。

```typescript
export default defineConfig({
  //...
  build: {
    rollupOptions: {
      external: ['react', 'react-dom/client']
    }
  }
});
```

除外するのは `src/main.tsx`などで import しているモジュールをそのまま書きます。
'react-dom/client' のかわりに 'react-dom'　や 'react-dom/\*' とは書けないようです。

あとは `pnpm build && pnpm preview` で、
バンドルサイズが減ったことを確認し、
<http://localhost:4173/> を開いて、動作確認してください。

いまのところの欠点

- `pnpm dev` で開発時にも importmap を呼んでしまう。
- モジュールのリストのメンテが手動。プラグインで自動でできればいいんですが。
