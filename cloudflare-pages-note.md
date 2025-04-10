# Cloudflare Pages のメモ

## 無料枠

詳細: [Limits · Cloudflare Pages docs](https://developers.cloudflare.com/pages/platform/limits/)

Cloudflare Pages の無料プランの制限は以下の通り:

- **ビルド**: 月 500 回まで。ビルドのタイムアウトは 20 分。同時ビルドはアカウントごとにカウントされます。
- **カスタムドメイン**: 1 プロジェクトにつき 10 個まで。
- **ファイル数**: 1 サイトあたり最大 20,000 ファイルまで。
- **ファイルサイズ**: 1 ファイルあたり最大 25 MiB。
- **Headers**: `_headers`ファイルには、最大 100 個のヘッダールールを設定可能。各ヘッダーの最大文字数は 2,000 文字。
- **プレビューデプロイ**: 無制限。
- **リダイレクト**: `_redirects`ファイルには、最大 2,000 個の静的リダイレクトと 100 個の動的リダイレクトを設定可能。合計で 2,100 個のリダイレクトが可能です。
- **ユーザー**: サイトの管理者は無制限。
- **プロジェクト**: アカウントあたり 100 プロジェクトまで(ソフトリミット)。

## プレビューデプロイ

[Preview deployments · Cloudflare Pages docs](https://developers.cloudflare.com/pages/configuration/preview-deployments/)

無料なので活用する。

1. Cloudflare Pages と GitHub/GitLab を連携済み
2. 自動ビルド設定が有効になっている(pages.dev のサイトを使ってる)

のときに、プルリクを新しく作ると、
`https://674cfedb.project-name.pages.dev`
のような URL で自動デプロイされる。

`674cfedb` の値はほぼ乱数で、プルリクの ID と関連してたりはしない。

## Which template would you like to use?

```text
Which template would you like to use?
  ○ Worker only
  ○ Assets only
  ● Worker + Assets
  ○ Worker + Durable Objects
  ○ Worker + Durable Objects + Assets
  ○ Scheduled Worker (Cron Trigger)
  ○ Queue consumer & producer Worker
  ○ API starter (OpenAPI compliant)
```

の解説。

もし用途が決まっていなければ、たいていは
**「Worker + Assets」** を選んでおくと、静的サイトにも動的処理にも対応できるので便利です!

### Assets(アセット)

静的なファイル(HTML, CSS, JavaScript, 画像など)です。

- 例: React や Vue でビルドされた SPA の出力ファイル(`index.html`, `main.js`, `style.css` など)
- Cloudflare Pages はこれらの静的ファイルを高速な CDN 経由で配信します

### Worker(ワーカー)

Cloudflare の**エッジで動くサーバーレス関数**です。Node.js っぽい JavaScript (または TypeScript) を書いて、HTTP リクエストを処理できます。

- 例:
  - API エンドポイント
  - リダイレクト処理
  - HTML の動的生成
  - リクエストの検査・改変

### Durable Objects(デュラブルオブジェクト)

Cloudflare Workers の中で使える **永続的な状態を持つオブジェクト(≒ ミニな状態付きサーバー)** です。

- 通常の Worker はステートレス(リクエストごとに初期化)ですが、Durable Objects を使うと状態が保持できます。
- 例:
  - チャットの部屋ごとの状態管理
  - リアルタイムなカウンター
  - ショッピングカートのセッション保持

### Scheduled Worker(Cron Trigger)

定期的に実行される Worker。

- 例:
  - 毎日バックアップを取る
  - 定期的に外部 API を叩いてキャッシュ更新する

### Queue consumer & producer Worker

Cloudflare Queues と連携して、**キューの送受信を行う Worker**。

- プロデューサー: キューにメッセージを追加
- コンシューマー: キューからメッセージを受け取って処理

### API starter (OpenAPI compliant)

OpenAPI(Swagger)に準拠した API のスターターコード。

- REST API を作るときに便利
- API ドキュメントを自動生成したいときに使える

### 組み合わせテンプレートの意味

- **Worker only**:Worker だけ使いたい(API だけとか)
- **Assets only**:静的ファイルだけ使いたい(普通の静的サイト)
- **Worker + Assets**:静的サイト + API(動的な処理も入れる)
- **Worker + Durable Objects**:動的な処理 + 永続状態の管理
- **Worker + Durable Objects + Assets**:全部盛り(静的 + 動的 + 状態管理)

## Assets only のメモ

```sh
pnpm create cloudflare@latest cfp-test0
# -> Hello World example
# -> Assets only
```

某プロキシがあると`pnpm create`が死ぬ。

.gitignore が作られない。

`pnpm start` か `pnpm dev` で開発サーバーが動く。

修正した後、再デプロイするには?
`pnpm run deploy` (某プロキシがあると死ぬ)

`pnpm deploy` は npmjs.com にパッケージをデプロイするコマンドだ。

## CF の wrangler と workerd とは何?

以下 ChatGPT の回答。

Cloudflare(CF)の **`wrangler`** と **`workerd`** は、Cloudflare Workers の開発や実行に関わるツールですが、それぞれの役割が異なります。以下に簡潔にまとめます。

### wrangler (ラングラー) とは?

**Cloudflare Workers 向けの CLI**

#### 主な用途:

- Cloudflare Workers の開発・ビルド・デプロイ
- 開発中のローカルサーバー起動 (`wrangler dev`)
- 設定管理(`wrangler.toml`)
- KV や R2 など Cloudflare のリソースの操作

#### 例:

```bash
wrangler dev           # ローカルで開発サーバーを起動
wrangler publish       # 本番環境にデプロイ
wrangler login         # 認証してCloudflareアカウントと接続
```

#### 補足:

- `wrangler` は Node.js で書かれていたが、現在は Rust 製の高速なバージョンに置き換えられている。
- Vite や Webpack のようなビルド機能と Cloudflare 向けの設定をいい感じにまとめてくれる。

### workerd (ワーカーディまたはワーカード)　とは?

**Cloudflare Workers の実行エンジン本体(オープンソース)**

#### 正確に言うと:

Cloudflare Workers の **ランタイムのコア部分**で、Cloudflare が独自に開発・使用している JavaScript/TypeScript/Wasmtime 実行環境。

#### 特徴:

- V8 ベース(Node.js と同じ JS エンジン)だが、Node API は提供しない
- `fetch()` や `Request`/`Response` など、ブラウザライクな API を提供
- **Cloudflare Workers と完全に互換性のある環境をローカルで動かせる**
- **Docker イメージや systemd サービスとして実行できる**

#### 用途:

- 独自に Workers ライクなサービスをホスティングしたい場合
- Wrangler から `wrangler dev` を実行すると裏で `workerd` が動いている(Cloudflare が公式サポート)

#### 補足:

Cloudflare では **実際に本番環境でこれを使って全世界で Workers を動かしている**。

### イメージで整理すると:

```
あなたのコード (JS/TS)
    │
    ├──▶ Wrangler:CLIツール
    │      ├─ ビルド
    │      ├─ デプロイ
    │      └─ ローカル起動
    │
    └──▶ Workerd:実行エンジン(runtime)
           └─ JavaScriptコードをクラウド/ローカルで実行
```

### まとめ

| 名前       | wrangler                       | workerd                               |
| ---------- | ------------------------------ | ------------------------------------- |
| 役割       | CLI ツール、開発・デプロイ補助 | Workers 実行エンジン(runtime)         |
| 主な用途   | 開発補助、デプロイ             | 実際のコードの実行                    |
| 開発言語   | Rust                           | C++(+ V8)                             |
| 利用シーン | ローカル開発・本番デプロイ     | ローカルで Workers のような環境を再現 |

### リンク

- [Cloudflare の JavaScript ランタイム「workerd」を動かしてみる](https://zenn.dev/mryhryki/articles/2022-09-29-workerd)
- [cloudflare/workerd: The JavaScript / Wasm runtime that powers Cloudflare Workers](https://github.com/cloudflare/workerd)

## リビルドを無視する

**質問:** Cloudflare Pages で GitHub 連携しているときに、README を書き換えても再ビルドされてしまいます。特定のファイルの変更を無視することはできる?

**答え: いまのところ方法はない**

`.cfignore` は伝説らしい。

## Cloudflare DNS を使わずにカスタムドメインを設定できる?

明快な答えがみつからないけど、どうも出来ないっぽい。
でかい企業だと辛いのでは。

有料プランだとできる、という話もあるのだが、真偽不明。

### その後

フリープランでも Cloudflare DNS を使わずにカスタムドメインを設定できた。

1. **まず Cloudflare DNS に最低 1 個ドメインを登録する。** そうでないと「カスタムドメイン」タブが出てこないから
2. で、対象ドメインに CNAME で `<project name>.pages.dev.` を登録する (最後のドット重要)。
   たとえば `www2.example.net` の CNAME が `<project name>.pages.dev.` だとしよう。
3. 対象プロジェクトの「カスタムドメイン」タブから、「自分の DNS プロバイダー(CNAME セットアップを開始)」で設定した`www2.example.net`を登録する。
4. しばらくすると 緑色で `・アクティブ` になる。「ドメインが有効になると、メールで通知されます」と言われるけどメールぜんぜん届かない。

単に CNAME だけだと証明書がダメ。

### さらにその後

`npm run deploy`でなくて
GitHub と連携したサイトなら、
free プランでも「カスタムドメイン」タブが出てくる。
