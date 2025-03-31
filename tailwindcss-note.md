# Tailwind CSS メモ

## VScode で `@tailwind` や `@apply` に警告を出さなくする

`PostCSS Language Support` 拡張機能をインストールする。

- ["Unknown at rule @tailwind"の警告を消す](https://zenn.dev/somahc/articles/20a041eabb9d17)
- [VSCode Tailwind CSS の Unknown at rule エラーに対応する | Memorandom](https://memorandom.whitepenguins.com/posts/tailwind-atmark-error/)
- [unknown at rule @tailwind css(unknownAtRules) tailwind error - Stack Overflow](https://stackoverflow.com/questions/76776910/unknown-at-rule-tailwind-cssunknownatrules-tailwind-error)

## Tailwind CSS v4

ものすごく書き換えないとダメ。

- PostCSS が不要になった。モジュールも不要(postcss と autoprefixer)
- postcss.config.js と tailwind.config.js は削除。content 配列も要らなくなって楽。
- 全部の \*.css の先頭に `@import "tailwindcss";` が要る
- ```css
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
  ```
  は不要になったので削除
- `@plugin "@tailwindcss/typography";` のように main.css に書く
- arbitrary values が使えるプロパティが増えた。`bg-[#242424]`とか。楽
- dark mode なんかはこうやって書く [Dark mode - Core concepts - Tailwind CSS](https://tailwindcss.com/docs/dark-mode#toggling-dark-mode-manually)
- Vite は`@tailwindcss/vite`を使う。<https://tailwindcss.com/docs/installation/using-vite>に説明あり。
  - Vite でのミグレーションの詳細は <https://tailwindcss.com/docs/installation/using-vite>
  - その他さまざまなフレームワークでの詳細は <https://tailwindcss.com/docs/installation/framework-guides>

## v4 で PostCSS が不要になった、というのは微妙に正確ではなくて

フレームワークによっては必要な時もある。

- オリジナルの - [postcss - npm](https://www.npmjs.com/package/postcss)
- TailWindCSS v4 専用?の - [@tailwindcss/postcss - npm](https://www.npmjs.com/package/@tailwindcss/postcss)

参照: [Using PostCSS](https://tailwindcss.com/docs/upgrade-guide#using-postcss)

## v4 ではカスタム CSS ルールセットの直接的な再利用ができなくなった

```css
.btn {
  /* ボタンの形状を定義 */
  @apply rounded-md py-2 px-4 font-semibold text-white;
}
.btn1 {
  /* 色だけ変える(青) */
  @apply btn bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700;
}
.btn2 {
  /* 色だけ変える(赤) */
  @apply btn bg-red-700 hover:bg-red-600 active:bg-red-800;
}
```

こういうのが出来ない。`Cannot apply unknown utility class: btn` というエラーになる。

`class="btn btn1"` 的な方法か `@layer` を使うか、ユーティリティとして定義する。

```css
@utility btn {
  @apply rounded-md py-2 px-4 font-semibold text-white;
}

.btn1 {
  @apply btn bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700;
}

.btn2 {
  @apply btn bg-red-700 hover:bg-red-600 active:bg-red-800;
}
```

- [Functions and directives - Core concepts - Tailwind CSS](https://tailwindcss.com/docs/functions-and-directives#utility-directive)
- [Adding custom styles - Core concepts - Tailwind CSS](https://tailwindcss.com/docs/adding-custom-styles#adding-custom-utilities)

## v4 参考リンク

- [Tailwind CSS の一歩進んだ書き方](https://zenn.dev/ixkaito/articles/advanced-tailwindcss)
- [Tailwind CSS V4 まとめ！](https://zenn.dev/miz_dev/articles/tailwind-css-v4)

## v4 で Google Fonts

`@import`がそのまま使えるようになった。
**ただし `@import "tailwindcss";` より前で宣言すること。**

### 参考

- [font-family - Typography - Tailwind CSS](https://tailwindcss.com/docs/font-family)
- [Customizing your theme](https://tailwindcss.com/docs/font-family#customizing-your-theme) のちょっと下。Google Fonts の例が出てる。
