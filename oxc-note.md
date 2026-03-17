# oxc (Oxidation Compiler) メモ

## oxlint のサポートする言語

[What Oxlint supports](https://oxc.rs/docs/guide/usage/linter.html#what-oxlint-supports)

## oxfmt のサポートする言語

[Supported languages](https://oxc.rs/docs/guide/usage/formatter.html#supported-languages)

## VSCode拡張

[VS Code](https://oxc.rs/docs/guide/usage/formatter/editors.html#vs-code)

## 設定ファイル

(2026-03)

```console
$ pnpm exec oxlint --version

Version: 1.55.0

$ pnpm exec oxlint --help

(略)
Basic Configuration
    -c, --config=<./.oxlintrc.json>  Oxlint configuration file
                              * `.json` and `.jsonc` config files are supported in all runtimes
                              * JavaScript/TypeScript config files are experimental and require
                              running via Node.js
                              * you can use comments in configuration files.
                              * tries to be compatible with ESLint v8's format
```

なので `.oxlintrc.jsonc` がいいのではないか。

```console
$ pnpm exec oxfmt --version

Version: 0.40.0

$ pnpm exec oxfmt --help

(略)
Config Options
    -c, --config=PATH        Path to the configuration file (.json, .jsonc, .ts, .mts, .cts, .js,
                             .mjs, .cjs)
(略)
```

なので、こっちも `.oxfmt.jsonc` がいいのではないか。

どちらも「親ディレクトリへ向かって上に辿る」方式らしい

> Oxfmt automatically looks for the following files starting from the current directory and walking up the tree

> If not provided, Oxlint will look for a .oxlintrc.json, .oxlintrc.jsonc, or oxlint.config.ts file in the current working directory.
