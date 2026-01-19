# @biomejs/biome のメモ

## biome.json の場所

.jsonc でもいいらしい。

カレント以外は見ない。
親ディレクトリ、先祖ディレクトリも見る、というのは噓っぽい。

`--config-path="$HOME/biome.json"` とか書くのが一番良さそう。


## ありがちな biome.json (v1)

```json
{
  "$schema": "https://biomejs.dev/schemas/1.8.2/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "vcs": {
    "enabled": true,
    "clientKind": "git",
    "useIgnoreFile": true,
    "root": "."
  },
  "json": {
    "parser": {
      "allowComments": true,
      "allowTrailingCommas": true
    }
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    },
    "ignore": ["dist/**/*", "node_modules/**/*"]
  },
  "formatter": {
    "enabled": true,
    "ignore": ["dist/**/*", "node_modules/**/*"]
  }
}
```

コメント入り JSON と末尾のコンマを許可している。

vcs.root は、~/biome.json でまとめて設定を書く用。
[Configuration | Biome](https://biomejs.dev/reference/configuration/#vcs)参照

## ありがちな run-scripts

```json
{
  "scripts": {
    "format": "biome format --write .",
    "lint": "biome lint .",
    "check": "biome check --write ."
  }
}
```

## v2 が出たので設定ファイルをミグレートする (2025-06)

```sh
biome migrate --write
# か、プロジェクトごとdevにbiomeに入れてるとかなら
# `npx @biomejs/biome migrate --write` 的にやる
```

で cwd 以下の biome.json が全部更新される。
自分の環境では `files.ignore` が無くなったのを `includes` の `!` パターンに置き換えられた。

## VSCode 設定

```json
{
  "[javascript]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  },
  "[typescript]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  },
  "[json]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  },
  "[jsonc]": {
    "editor.defaultFormatter": "biomejs.biome",
    "editor.tabSize": 2,
    "editor.insertSpaces": false
  }
}
```
