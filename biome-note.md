# @biomejs/biome のメモ

## ありがちな biome.json

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

コメント入り JSON と 末尾のコンマを許可している。

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
