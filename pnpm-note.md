# pnpm のメモ

## pnpm 自体の更新

最近は corepack 経由でやってると思うので

```sh
corepack prepare pnpm@latest --activate
```

で。

## pnpm でパッケージをまとめて latest に

```sh
pnpm up --latest
```

## pnpm で `npm ls`

````sh
pnpm ls --depth Infinity
``

デフォルトではトップレベルしか表示しない

## pnpm でキャッシュを消す

pnpm 用語では、キャッシュでなくストアというらしい。

```sh
# ストアから参照されていないパッケージを削除する
pnpm store prune
````

<https://pnpm.io/cli/store#prune>

## bash で補完

[Command line tab-completion | pnpm](https://pnpm.io/completion)

```sh
pnpm completion bash > completion-for-pnpm.bash
sudo mv completion-for-pnpm.bash /etc/bash_completion.d/
```

## ライフサイクルスクリプトとは何?

pnpm v10 からデフォルトでは禁止された「ライフサイクルスクリプト」とは何か?

「ライフサイクルスクリプト (lifecycle scripts)」とは、
プロジェクトに含まれるパッケージが、インストール時・公開前後・ビルド前後など「ライフサイクル (周期・段階)」の特定タイミングで自動実行されるスクリプトのこと

たとえば、
`package.json` の run-scripts の
`preinstall`, `postinstall`, `prepare`, `prepublish`, `prepack`, `postpack`
がこれにあたる。

ただコードをダウンロード/インストールするだけでなく
「インストール直後に依存関係をビルドする」「パッケージ公開前にトランスパイルを走らせる」など、自動で必要なタスクを行うための仕組み。

参考:
[pnpm のセキュリティ機能で npm を安全に使う #GameWith #TechWith - GameWith Developer Blog](https://tech.gamewith.co.jp/entry/2025/12/09/101041)

### ライフサイクルスクリプトの実例: `esbuild`

- [esbuild - npm](https://www.npmjs.com/package/esbuild?activeTab=code)
- [esbuild - Getting Started](https://esbuild.github.io/getting-started/#additional-npm-flags)

```json
  "scripts": {
    "postinstall": "node install.js"
  },
```

`npm install esbuild` すると、
`install.js` というスクリプトが実行される。

これは、ユーザーのプラットフォーム (OS/CPU アーキテクチャ) に対応したバイナリを選んでセットアップしたり、
node_modules/.bin/esbuild に対して最適化 (shim → 実行可能ファイルへの差し替え) を行うためのもの。

※ shim = 薄い代理スクリプト(ラッパー)

shim 残したままでも動くが、ちょっと遅くなる。
