# pnpm のメモ

## pnpm 自体の更新

最近は corepack 経由でやってると思うので

```sh
corepack prepare pnpm@latest --activate
```

で。

standalone script で入れたなら
`pnpm self-update`
ができるかも。

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

## trustPolicy: no-downgrade の件

前のバージョンは Sigstore で Provenance がついてた
→
新しいバージョンにはなぜか署名された Provenance がない

という時にエラーを出す。んだけど

- [X ユーザーの pnpm さん: 「We have discovered that chokidar has switched off provenance a year ago and now it fails with the trustPolicy setting set to no-downgrade. We'll need to think about a way to deal with these cases. https://t.co/fSEJQYWr1e」 / X](https://x.com/pnpmjs/status/1987836672705237243)
- [chokidar v4.0.1- npm](https://www.npmjs.com/package/chokidar/v/4.0.1) - Provenance がある、でも Source Commit なんかがリンク切れ。Rekor はある
- [chokidar v4.0.2- npm](https://www.npmjs.com/package/chokidar/v/4.0.2) - Provenance がない
- [Provenance is missing in 4.0.2 & 4.0.3 · Issue #1440 · paulmillr/chokidar](https://github.com/paulmillr/chokidar/issues/1440)

みたいなことがある。何ぞこれ。

上の Issue で chokidar v5 にしろ、と言ってるけど、依存(tsup の)だとそうもいかないしなあ。

pnpm の機能がちゃんと動いてる証拠ではあるのだけど。

とりあえず

- pnpm-workspace.yaml の `trustPolicy: no-downgrade` はそのまま
- package.json に
  ```json
  "pnpm": {
  	"overrides": {
  		"chokidar": "4.0.1"
  	}
  },
  ```
  で、しのぐ。

## minimumReleaseAge

pnpm の [minimumReleaseAge](https://pnpm.io/settings#minimumreleaseage) はサプライチェーン攻撃を避けるのに便利。

グローバルに設定するといいかも

```sh
# 例:公開から1日(=1440分)未満のリリースは入れない
pnpm config set --location=global minimumReleaseAge 1440

# 例外を作りたいとき(任意)
pnpm config set --location=global minimumReleaseAgeExclude "react @types/*"

# 設定の確認
pnpm config list --location=global
```

### ほかのパッケージマネージャでは?

ほかの言語も含めて

- Yean の npmMinimalAgeGate
- Deno の minimumDependencyAge
- Bun の minimumReleaseAge

ぐらい(なんで全部 JavaScript 系?)。
Cargo は機能リクエストが出たばかりらしい。

## そのほかの pnpm のセキュリティ機能

とりあえず
`~/.config/pnpm/rc` または `~/.npmrc`
に

```conf
minimumReleaseAge=1440        # 公開後24時間未満の新バージョンを拒否(default 0)[1](https://pnpm.io/supply-chain-security)
blockExoticSubdeps=true       # トランジティブ依存の git/tarball 等を禁止(default false)[1](https://pnpm.io/supply-chain-security)
trustPolicy=no-downgrade      # 信頼レベルが低下したバージョンを拒否(default off)[1](https://pnpm.io/supply-chain-security)
```

と書いとくといい。

参考:

- [クラウドサインは npm から pnpm へ移行しました - 弁護士ドットコム株式会社 Creators’ blog](https://creators.bengo4.com/entry/2026/01/26/080000)

## `pnpm audit -g` はない

[how to audit global packages? · pnpm · Discussion #6767](https://github.com/orgs/pnpm/discussions/6767)

とりあえず

```sh
cd "$HOME/.local/share/pnpm/global"
grype .
```

で。

「何が原因のパッケージかわからない」などの問題はあり。

同じ手法が uv とかでも使える。`grype $(uv tool dir)`

## pnpm の run-scripts に npmコマンドを使うとき

(または `pnpm version`や `pnpm pkg` のような pnpm が npm を内部で呼ぶコマンドを使うとき)

pnpm の設定で minimum-release-age のような npm にないオプションが設定されていると

> npm warn Unknown env config "minimum-release-age". This will stop working in the next major version of npm.

みたいな警告が出ます。直接 `npm pkg get version` と呼ぶと、警告が出ません。どうも pnpm は run-scripts から npm を使うとオプションを渡してるみたい。

この動作をやめさせるには?

...

結論から言うと、**pnpm は `pnpm run` 実行時に子プロセスへ `npm_config_*` 環境変数を引き継ぐ仕様**で、
これが npm v11 以降で「Unknown env config」警告の原因です。
pnpm メンテナはこの挙動を認めており(互換性の観点で)**すぐには変えない方針**を示しています。
したがって「pnpm が npm に `npm_config_*` を渡さないようにする」完全なスイッチは現状ありません。

- [Warning: \`npm warn Unknown env config "verify\-deps\-before\-run"\. This will stop working in the next major version of npm\.\` · Issue \#9234 · pnpm/pnpm](https://github.com/pnpm/pnpm/issues/9234)
- [Unknown env config "verify\-deps\-before\-run" · Issue \#9235 · pnpm/pnpm](https://github.com/pnpm/pnpm/issues/9235)

いろいろあるけど
**npm のログレベルを落として警告を非表示**
するぐらいしか方法がない。

たとえば:

- `npm --loglevel=error pkg get version`
- `NPM_CONFIG_LOGLEVEL=error npm pkg get version`
