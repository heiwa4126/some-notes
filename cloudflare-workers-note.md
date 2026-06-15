# Cloudflare Workers メモ

## 無料枠

Pages と比べて結構ややこしい。

引用元: [Limits · Cloudflare Workers docs](https://developers.cloudflare.com/workers/platform/limits/)

「Free プランの 1 日あたりのリクエスト数は、UTC の深夜にリセットされます」

"Worker size" というのがピンとこない。
[Worker size](https://developers.cloudflare.com/workers/platform/limits/#worker-size)

Git integration もあるけど Pages とはかなり違うみたい
[Git integration](https://developers.cloudflare.com/workers/ci-cd/builds/git-integration/)

Pages のような「月間ビルド回数」の制限はないけど
Workers で「Workers Builds」機能(CI/CD スタイルの自動デプロイ)を利用した場合、
無料プランでは「ビルド分数(3,000 分/月)」と「同時ビルド数(1 件)」という制限があるらしい。

あとプレビューはあるらしい

- [Preview URLs](https://developers.cloudflare.com/workers/configuration/previews/)
- [Versions & Deployments](https://developers.cloudflare.com/workers/configuration/versions-and-deployments/)

## Basic Features ボタンの場所

[Cloudflare無料プランの「Basic Features」ボタン一発で有効になる11機能を全解説](https://zenn.dev/yostos/articles/cloudflare-security2)

**重要: ドメインが登録してないと設定できません。あと無料プランのみ**

1. **Cloudflareダッシュボード**にログインします。
2. 設定したい**ドメイン(Webサイト)をクリック**して選択します。
3. 左側メニューで一番上の**「Overview(概要)」**が選択されていることを確認します。
4. 画面の中央、あるいは右側のサイドバー付近に、**「Basic Features」**というタイトルのカード(枠)が表示されます。

## wrangler deploy の認可

### 1. OAuthログイン式

`wrangler login`

- ブラウザが開く → Cloudflareにログイン
- CLIにトークン保存 (~/.config/.wrangler)

欠点は

1アカウントにしか対応していない
`wrangler logout` して `wrangler login`

### 2. API Token 式

`export CLOUDFLARE_API_TOKEN=xxxxxxxx`

## ログイン状態を知る

`wrangler whoami`

pnpm だったら
`pnpm exec wrangler whoami`
的に。

他(2025年12月から)

```sh
# トークンをそのまま表示
wrangler auth token

# 認証タイプ付きのJSON出力
wrangler auth token --json
```

このトークンを `CLOUDFLARE_API_TOKEN=` で使えるか

## ブラウザで認証が終わっても `wrangler login` が終わらない

特にssh接続先リモートとかで起きる。
[リモート環境からWranglerを使う](https://zenn.dev/kaz_sakakibara/articles/806caa0768d68e)

めんどくさすぎるのであきらめてAPI Tokenを使う

[API トークン \| Cloudflare](https://dash.cloudflare.com/profile/api-tokens)
トークンを作成する
Cloudflare Workers を編集する
いくつか設定項目あり

で
`export CLOUDFLARE_API_TOKEN=cf************`

## 開発とデプロイ

```sh
# ローカル開発サーバで
# ローカルの Miniflare 環境で動作。Cloudflare には繋がらない。
wrangler dev

# Cloudflare のエッジ環境上で (デプロイではなく一時的な開発環境)
# Cloudflareのインフラ上で実行されるが、デプロイはされない(一時的)。ただし実際のリソース(KV、DO等)にアクセスするため注意が必要。
wrangler dev --remote

# デプロイ
# 本番への即時デプロイ。内部的には versions upload + versions deploy を一度にやっているイメージ。
wrangler deploy

# プリビューとしてデプロイ。プレビューURLが発行される
wrangler versions upload

# プリビューとしてアップロードしたものを本番とする
wrangler versions deploy
```

それを踏まえて run-scripts はこんな感じがいいと思う

```json
"scripts": {
  "dev": "wrangler dev",
  "dev:remote": "wrangler dev --remote",
  "upload": "wrangler versions upload",
  "preview": "wrangler versions upload",   // uploadの別案
  "release": "wrangler versions deploy",
  "deploy": "wrangler deploy"              // 即時デプロイ用に残す場合
}
```

あと wrangler は .env があれば自動で読む。`--env-file .env.prod` みたいに指定もできる。

## DO を別ファイルにする

同じ Worker 内で Durable Objects などを別ファイルに分割する場合(例えば`mydo.ts`)
index.ts で re-export するのが楽。

```ts
export { MyDurableObject } from './mydo.js';
```

別 Worker(別スクリプト)として分離するのはもう一工夫必要

## worker-configuration.d.ts

`wrangler types` で生成される。

以下 Cloudflare の "Ask AI" に
`worker-configuration.d.ts って何の役に立つの?`と
聞いた答え

...

`worker-configuration.d.ts` は、Wrangler の設定(`wrangler.json` / `wrangler.toml`)をもとに自動生成される型定義ファイルです。主に以下の役割があります:

### 1. `Env` 型の自動生成

KV、R2、D1、Durable Objects、Queue など、バインディングの型が `Env` インターフェースとして定義されます。

```typescript
// worker-configuration.d.ts 内(自動生成)
interface Env {
  MY_KV: KVNamespace;
  MY_BUCKET: R2Bucket;
  MY_DO: DurableObjectNamespace;
  MY_DB: D1Database;
}
```

これにより、`env.MY_KV` にマウスオーバーすると `KVNamespace` と補完され、存在しないキーへのアクセスは型エラーになります。

### 2. Workers ランタイムの型補完

`compatibility_date` や `compatibility_flags` に基づいて、Workers ランタイムで利用可能な API の型が提供されます。

### 3. 型安全性の確保

`src/index.ts` などで `env: Env` と書くだけで、すべてのバインディングに正しい型がつきます:

```typescript
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext) {
    // env.MY_KV に型補完・型チェックが効く
    const value = await env.MY_KV.get('key');
  }
};
```

### 使い方

`tsconfig.json` に含まれていると、エディタ(VS Code など)が自動で認識して補完してくれます。Wrangler の設定を変更したら、`npx wrangler types` を再実行して最新の型に更新してください。

## Pages みたいな preview は?

> Durable Objectsを使用しているWorkerではプレビューURLが生成されません

<https://developers.cloudflare.com/changelog/post/2025-07-23-workers-preview-urls/#limitations-while-in-beta>

えええええ

## Pages みたいな デプロイ回数制限は?

少なくとも現在の Cloudflare Workers Free プランには Pages Free のような「月○回までデプロイ」という制限はありません。
公式の Free プランにはデプロイ回数の上限は記載されておらず、Wrangler から何度でもデプロイできます。

ただし、もし Workers Builds(Cloudflare 上でビルドを実行する CI/CD 機能)を使う場合は別で、こちらには

- 3,000 build minutes/月
- 同時実行 1 build

という制限があります。なので、

- wrangler deploy でローカルからデプロイする → 実質的にデプロイ回数制限なし
- GitHub連携+Workers Builds にビルドさせる → build minutes 制限あり

と考えると分かりやすいです。

## worker-configuration.d.ts

「このファイルはこの Worker プロジェクトのためだけに存在する」と理解しておけば問題なし。
IDEの補完、型チェックに便利。`wrangler type` で生成できるので、レポジトリに含めても含めなくてもいい。

wrangler.toml の内容が変わったタイミングで再作成する必要がある。

wranglerのバージョンが変わった時にも再生成するといいですが、
worker-configuration.d.ts 内には wrangler のバージョンが入っていて、処理を変えるらしいので
再生成は必須ではない。

## workers のデプロイ単位でドメイン名はつけられる?

できない。別の prod/dev的にしたいなら、
some-api-v1.example.com, some-api-v2.example.com
みたいにするしかない

## 制限

[Limits · Cloudflare Workers docs](https://developers.cloudflare.com/workers/platform/limits)

