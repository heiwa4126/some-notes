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

## oxcは対象ファイルを表示する方法がない

(2026-03現在)

[oxc: list all affected files · Issue #19833 · oxc-project/oxc](https://github.com/oxc-project/oxc/issues/19833)
では「デバッグフラグ使え」

```sh
OXC_LOG=debug oxfmt
```

で、stderrにログが出る。

例:

```sh
OXC_LOG=debug oxfmt 2>&1 | ansi2txt | grep -oP '(?<=\{path=)[^}]+' | sort -u
```

oxlint の方は debugログにファイル情報が出ないので手に負えない。
たぶん oxfmtと同じファイルが対象になるのでは。

`--list-files` オプションのPRがマージされてるので

- [feat(formatter): Add --list-files command to formatter by dosmond · Pull Request #19933 · oxc-project/oxc](https://github.com/oxc-project/oxc/pull/19933)
- [feat(linter): Add --list-files to linter by wagenet · Pull Request #17233 · oxc-project/oxc](https://github.com/oxc-project/oxc/pull/17233)

そのうち使えるようになるのではないか?

とりあえずデバッグ出力みると .gitignore を読むらしい。
