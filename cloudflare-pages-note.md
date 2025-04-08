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
2. 自動ビルド設定が有効になっている（pages.dev のサイトを使ってる）

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
