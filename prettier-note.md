# Prettier のメモ

## Markdown をフォーマットするときに、英単語の前後にスペースが入らなくなった

- [Do not insert whitespaces between latin and cj letters · Issue #6385 · prettier/prettier](https://github.com/prettier/prettier/issues/6385)
- [Prettier で Markdown をフォーマットしたときの英語と日本語の間に入るスペースをどうにかする #VSCode - Qiita](https://qiita.com/kumapo0313/items/92d1597da5f3752f6584)
- [Markdown: unnecessary space is inserted between Korean & English words · Issue #5028 · prettier/prettier](https://github.com/prettier/prettier/issues/5028)
- [Prettier で markdown をフォーマットしたら、半角スペースがうざかった話 | K.W.info](https://k-w.info/blog/2021-10-25-markdown-format-prettier)

自分は入ってたほうが好きなので。

1 つの答えは別のツールをつかうことで、

```sh
npm i -g textlint textlint-rule-preset-ja-spacing
```

で、`~/.textlintrc` に

```json
{
  "rules": {
    "preset-ja-spacing": {
      "ja-space-between-half-and-full-width": {
        "space": "always"
      }
    }
  },
  "ignoreDirectories": ["node_modules", "dist", "build"]
}
```

のように書いて、
`textlint --fix "**/*.md"`
すればいいです。

## VSCode 拡張の Prettier は Prettier がバンドルされている?

[Prettier - Code formatter - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

バンドルされているか? は Yes

優先度は:

1. プロジェクトの local dependency ← 推奨
2. global にインストールされた prettier
3. Prettier 拡張にバンドルされた prettier (フォールバック)

## Prettierでグローバルにインストールしたプラグインは使える?

基本使えない。ただしプラグインの絶対パスを指定すれば使えないこともない。

VSCode では

```json
{
  "prettier.resolveGlobalModules": true
}
```

で npm か yarn のグローバルインストールを見に行くらしい。
