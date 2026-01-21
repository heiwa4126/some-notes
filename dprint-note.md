# dprint メモ

Prettier が遅いので乗換計画中。
Biome と併用する(特に markdown)

- [dprint - Code Formatter](https://dprint.dev/)
- [Dprint Code Formatter - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=dprint.dprint)

## インストール

dprint 自体はバイナリーなんだけど npmjs や PyPI で管理できる。

`uv tool install dprint` や
`npm install -g dprint` が
楽だと思う。

[Install - dprint - Code Formatter](https://dprint.dev/install/)

そのあと `cd ~ ; dprint init` でプラグイン選んで、以下の config のプラグイン以外のところをコピペする感じ。

早いけど config がちょっとめんどう。

いまのところの `~/dprint.conf`:

```json
{
  "markdown": {
    "lineWidth": 120
  },
  "toml": {
    "printWidth": 120,
    "useTabs": true
  },
  "dockerfile": {},
  "malva": {
    "printWidth": 120,
    "useTabs": true,
    "quotes": "preferDouble"
  },
  "markup": {
    "printWidth": 120,
    "useTabs": true
  },
  "excludes": ["**/node_modules", "**/dist", "**/*-lock.json", "**/*-lock.yaml", "*.js", "*.mjs", "*.cjs", "*.ts", "*.tsx", "*.jsx", "*.json", "*.jsonc", "*.graphql", "*.vue", "*.svelte", "*.astro"],
  "plugins": [
    "https://plugins.dprint.dev/markdown-0.17.8.wasm",
    "https://plugins.dprint.dev/toml-0.6.2.wasm",
    "https://plugins.dprint.dev/dockerfile-0.3.2.wasm",
    "https://plugins.dprint.dev/g-plane/malva-v0.10.1.wasm",
    "https://plugins.dprint.dev/g-plane/markup_fmt-v0.13.1.wasm",
    "https://plugins.dprint.dev/g-plane/pretty_yaml-v0.5.0.wasm"
  ]
}
```

- tab インデントが好きなので Prettier とはかなり違う設定に
- Biome と併用なので、Biome がサポートしている

## プラグインの更新

`dprint config update`

[Plugins - dprint](https://plugins.dprint.dev/)
