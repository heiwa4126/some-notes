# Vite のメモ

- [Deno で Vite](#deno-で-vite)
- [Vite で対話式でなくプロジェクトを開始する方法メモ](#vite-で対話式でなくプロジェクトを開始する方法メモ)
- [最近の Typescript で Vite+SWC の時の各々の役割](#最近の-typescript-で-viteswc-の時の各々の役割)
- [build 時に comment や debug を取り除く](#build-時に-comment-や-debug-を取り除く)
  - [minifier に esbuild を使う場合](#minifier-に-esbuild-を使う場合)
  - [minifier に terser を使う場合](#minifier-に-terser-を使う場合)
- [JSON5 や JSONC を直接インポート](#json5-や-jsonc-を直接インポート)
- [Vite dev で TSL](#vite-dev-で-tsl)

## Deno で Vite

Deno 1.28 から。

参考:

- [denoland/deno-vue-example: An example of using Vue with Deno.](https://github.com/denoland/deno-vue-example)
- [bartlomieju/vite-deno-example: Example of using Vite with Deno](https://github.com/bartlomieju/vite-deno-example)

(WSL でない)Windows だと死ぬ。Linux だと超早い感。もっと試す。

## Vite で対話式でなくプロジェクトを開始する方法メモ

`npm create vite@latest {プロジェクト名} -- --template react-swc-ts`

Bun と pnpm は
`pnpm create vite {プロジェクト名} --template react-swc-ts`

公式テンプレートのリストは
[Scaffolding Your First Vite Project](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)
にある。

コミュニティ版テンプレート(動くかどうかは微妙)は
[vitejs/awesome-vite: ⚡️ A curated list of awesome things related to Vite.js](https://github.com/vitejs/awesome-vite#templates)
にある。
基本 [degit](https://www.npmjs.com/package/degit)を使って「GitHub からソースをコピー」して使うので、
パッケージ名などを手で書き換えないといけない。

## 最近の Typescript で Vite+SWC の時の各々の役割

(2024-09) `npm create vite@latest YourProjectName -- --template react-swc-ts` の時の話

tsc, SWC, esbuild, rollup が全部入る。

- esbuild - 開発時に使われ、TypeScript やモダン JavaScript の高速なトランスパイル開発サーバーのホットリロードを担当。プロダクションビルド時に minify する場合も。
- tsc - プロダクションビルド時に型チェックや文法チェックだけ実行。出力はしない (`noEmit: true`)
- SWC - プロダクションビルド時にトランスパイルを行う
- rollup - プロダクションビルド時に最終的なバンドルプロセスを担当。モジュールバンドル、ツリーシェイキング、コードスプリッティング、および最適化の処理を行う

## build 時に comment や debug を取り除く

minifier を使う

### minifier に esbuild を使う場合

こんな感じの vite.config.ts を書く。

```typescript
// (略)
import { type ConfigEnv, type UserConfig, defineConfig } from 'vite';

// https://vitejs.dev/config/
export default defineConfig(({ command }: ConfigEnv) => {
  const cfg: UserConfig = {
    plugins: [react() //,略],
    // 略
  };

  if (command === 'build') {
    // when `vite build`
    cfg.esbuild = {
      drop: ['console', 'debugger'] // https://esbuild.github.io/api/#drop
    };
    cfg.build ||= {}; // Initialize cfg.build with an empty object
    cfg.build.minify = "esbuild";
  }

  return cfg;
});
```

こんな風に書かないと dev 時にも console.log()が無くなってしまう。

### minifier に terser を使う場合

Rollup のプラグインで terser を呼ぶようにすると書きやすい。

vite.config.ts の例

```typescript
// (略)
import { terser } from "@wwa/rollup-plugin-terser";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react() //,(略)],
  // (略)
  build: {
    rollupOptions: {
      // (略)
      plugins: [
        terser({
          format: {
            comments: false // コメントを削除
          },
          compress: {
            drop_console: true, // console.* を削除
            drop_debugger: true // debugger ステートメントを削除
          }
        })
      ]
    }
  }
});
```

`npm i @wwa/rollup-plugin-terser -D` が必要。(terser も入る)

terser は遅いので注意。
あと結構オーバーキル風味。

Rollup でやらない場合は

- [build\.minify](https://ja.vitejs.dev/config/build-options.html#build-minify)
- [build\.terserOptions](https://ja.vitejs.dev/config/build-options.html#build-terseroptions)

で出来ると思う(試してない)。

## JSON5 や JSONC を直接インポート

Vite のプラグインで出来る。

[vite-plugin-json5 - npm](https://www.npmjs.com/package/vite-plugin-json5)

## Vite dev で TSL

開発サーバーで TSL/SSL を使いたいとき。例えば

- Service Workers とか
- MediaDevices API など
- OAuth

みたいな HTTPS ないとダメなやつを開発したいときは
[mkcert](https://github.com/FiloSottile/mkcert) を使うのが一番簡単

vite.config.ts に

```
import react from "@vitejs/plugin-react";
import fs from "node:fs";
import { defineConfig } from "vite";

// https://vite.dev/config/
export default defineConfig({
	plugins: [react()],
	server: {
		https: {
			key: fs.readFileSync("./localhost-key.pem"),
			cert: fs.readFileSync("./localhost.pem"),
		},
	},
});
```

場合によっては `npm i -D @types/node`

証明書の PEM はプロジェクトに含めないほうがいいみたいので .gitignore に `*.pem` とか書く。

これで <https://localhost:5173/> や <https://localhost:4173/> で作業
