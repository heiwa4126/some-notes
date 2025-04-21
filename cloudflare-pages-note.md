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

動的な部分 (Cloudflare Pages Functions & Workers)

- 1 日あたり 10 万リクエスト
- 1 リクエストあたり 10 ミリ秒の CPU 時間
- Workers KV のストレージも無料で 1GB まで
- 超過時は自動課金されず、単にエラーになります

参照: [開発プラットフォーム | Cloudflare](https://www.cloudflare.com/ja-jp/plans/developer-platform-pricing/)

面白いのは
**静的コンテンツ(静的アセット)の転送量(egress)には、Free プランを含め、明示的な制限は設けられていない**こと。

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

### workerd (ワーカーディまたはワーカード) とは?

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

**結論: Pages なら出来る(Apex 以外)、Workers ならできない。**

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

## wrangler pages

[Direct Upload · Cloudflare Pages docs](https://developers.cloudflare.com/pages/get-started/direct-upload/)

```console
$ wrangler pages --help
wrangler pages

⚡️ Configure Cloudflare Pages

COMMANDS
  wrangler pages dev [directory] [-- command..]  Develop your full-stack Pages application locally
  wrangler pages functions                       Helpers related to Pages Functions
  wrangler pages project                         Interact with your Pages projects
  wrangler pages deployment                      Interact with the deployments of a project
  wrangler pages deploy [directory]              Deploy a directory of static assets as a Pages deployment  [aliases: publish]
  wrangler pages secret                          Generate a secret that can be referenced in a Pages project
  wrangler pages download                        Download settings from your project

GLOBAL FLAGS
      --cwd      Run as if Wrangler was started in the specified directory instead of the current working directory  [string]
  -h, --help     Show help  [boolean]
  -v, --version  Show version number  [boolean]
```

## Pages はデフォルトが「フォールバック」または「ソフト 404」らしい

**まとめ: \_redirects は思ったようには動かない。静的コンテンツの転送はタダなので割り切る。**

つまり
`https://example.pages.dev/notexists1` でも
`https://example.pages.dev/notexists2` でも
`https://example.pages.dev/` を返してくる。

SPA 的には便利なんだけど(たとえば React Router)
本当に存在しない場合は 404 ページを返してほしい。
...んだけど結構難しい。

[Redirects · Cloudflare Pages docs](https://developers.cloudflare.com/pages/configuration/redirects/)

- `https://example.pages.dev/`
- `https://example.pages.dev/about` (静的または SPA 的に存在)

は存在するが、`https://example.pages.dev/notexists1`などは存在しないので、404.txt を返して欲しい、という場合は

```text
/about/* / 200
/* /404.txt 404
```

\_redirects は Pages のルートに置く必要があるので
例えば Vite+React のプロジェクトの場合、pubic/ に書く。

404.txt も同様。pubic/

```text
404 Not Found
```

## Functions で使うモジュール

は root の project.json に書けばいい。

フロントエンドと Functions で使うモジュールを混ぜたくない、
という意見もあるでしょーが、それは無視する。

## ビルド設定

いま自分の Cloudflare Pages の設定で

```text
ビルド構成

ビルドコマンド: pnpm install --frozen-lockfile && pnpm run build
ビルド出力: build/client
ルートディレクトリ:
ビルドコメント: 有効
```

みたいになってるとき(RRv7 のプロジェクトを pnpm でやってるので)、
ビルドコメントとルートディレクトリとはなんでしょう?

### ビルドコメント (Build Comments)

この設定を「有効」にすると、Cloudflare Pages はデプロイ履歴に各ビルドの Git コミットメッセージを表示するようになります。

### ルートディレクトリ (Root Directory)

あなたのプロジェクトのソースコードがリポジトリ内のどこにあるかを Cloudflare Pages に伝えるための設定です。
ビルドコマンド(pnpm install...)はこのディレクトリを起点として実行されます。

デフォルト: この項目が空欄(未設定)の場合、Cloudflare Pages はリポジトリの最上位(ルート)ディレクトリをプロジェクトのルートディレクトリとして扱います。

利用シーン: 例えば、1 つのリポジトリ内にフロントエンド(例: /frontend)とバックエンド(例: /backend)のコードが別々のディレクトリに存在する場合(モノレポ構成など)、
Pages でフロントエンドだけをビルド・デプロイしたいなら、ルートディレクトリに /frontend と指定します。

## `./+types/`

`tsconfig.json` に

```json
		"rootDirs": [".", "./.react-router/types"],
```

と書いてあるので
app/routes/home.tsx で

```typescript
import type { Route } from './+types/home';
```

と書くと
`.react-router/types/app/routes/+types/home.ts`
から定義を読む。

一方
app/routes/products/home.tsx
で

```typescript
import type { Route } from './+types/home';
```

と書くと、同じ記述なのに
`.react-router/types/app/routes/products/+types/home.ts`
から定義を読む。

確認は

```sh
pnpm typecheck
```

で。(実体は `react-router typegen && tsc`)

`react-router typegen` は dev や build で自動生成されてるらしい。

## CloudFront Pages で出来ることを AWS にやらせてみる

結論: 転送量にもよるけど月額 数十円〜数百円程度ではないか。

**質問**

Cloudflare Pages で

- 静的コンテンツ (一部 Functions)
- SSL 化
- カスタムドメイン

を**無料**で実現しています。これを Amazon の S3 や Cloudfront で実現するとしたら、
費用のかかるリソースはどれで、可能なら費用の見積もりもおねがいします。

**Google Gemini に聞いてみた結果**

Cloudflare Pages で無料で実現できている機能(静的コンテンツ、一部 Functions、SSL 化、カスタムドメイン)を Amazon S3 と CloudFront で実現する場合、費用が発生する主なリソースは以下の通りです。

**費用のかかるリソース:**

- **Amazon S3 (静的コンテンツのホスティング):**

  - **ストレージ容量:** 保存する静的コンテンツのデータ量に応じて課金されます。
  - **データ転送量 (アウトバウンド):** S3 からインターネットへデータが転送される量に応じて課金されます。ウェブサイトへのアクセスが増えるほど、この費用も増加します。
  - **リクエスト数 (PUT/GET など):** S3 バケットへのオブジェクトのアップロードやダウンロードなどのリクエスト数に応じて課金されます。

- **AWS Lambda@Edge (一部 Functions の代替):**

  - **リクエスト数:** Lambda 関数が実行された回数に応じて課金されます。
  - **コンピューティング時間:** Lambda 関数の実行時間に応じて課金されます。

- **Amazon CloudFront (コンテンツ配信ネットワーク):**

  - **データ転送量 (アウトバウンド):** CloudFront からインターネットへデータが転送される量に応じて課金されます。ウェブサイトへのアクセスが増えるほど、この費用も増加します。CloudFront は世界中にエッジロケーションを持つため、ユーザーに近い場所からコンテンツを配信でき、高速化とレイテンシの削減に貢献しますが、その分データ転送量に応じた費用が発生します。
  - **HTTP/HTTPS リクエスト数:** CloudFront が受信した HTTP および HTTPS リクエストの数に応じて課金されます。

- **Amazon Route 53 (カスタムドメインの DNS 管理):**
  - **ホストゾーンの料金:** カスタムドメインの DNS レコードを管理するためのホストゾーンを作成すると、月額料金が発生します。
  - **DNS クエリ数:** ドメインへのアクセスが発生するたびに DNS クエリが実行され、そのクエリ数に応じて課金されます。

**無料で利用できるリソース:**

- **AWS Certificate Manager (ACM):** SSL/TLS 証明書を無料でプロビジョニング、管理、デプロイできます。CloudFront と連携させることで、カスタムドメインでの HTTPS 通信を無料で実現できます。

**AWS での見積もり (概算):**

正確な見積もりは、ウェブサイトのトラフィック量、コンテンツのサイズ、関数の実行回数や実行時間など、具体的な利用状況によって大きく変動します。以下は、一般的な小規模なウェブサイトを想定した非常にざっくりとした概算です。

**仮定:**

- 静的コンテンツのサイズ: 1 GB
- 月間のデータ転送量 (アウトバウンド): 10 GB
- 月間の HTTP/HTTPS リクエスト数: 100 万件
- Lambda@Edge の月間実行回数: 10 万回
- Route 53 の DNS クエリ数: 月間 100 万件

**概算費用:**

- **Amazon S3:** 月額 数十円〜数百円程度 (データ転送量とリクエスト数に大きく依存)
- **AWS Lambda@Edge:** 月額 数十円程度 (実行回数と実行時間に大きく依存)
- **Amazon CloudFront:** 月額 数百円〜数千円程度 (データ転送量に大きく依存)
- **Amazon Route 53:** 月額 約 50 円程度 (ホストゾーン料金とクエリ数)

**合計:** 月額 数百円〜数千円程度

**注意点:**

- 上記はあくまで非常にざっくりとした概算であり、実際の費用は利用状況によって大きく異なります。
- AWS の料金体系は複雑で、リージョンによっても料金が異なります。
- より正確な見積もりには、AWS Pricing Calculator を利用することをお勧めします。
- Cloudflare Pages の無料枠は非常に魅力的であり、特に小規模なウェブサイトや個人利用の場合は、AWS よりも大幅にコストを抑えることができます。

Cloudflare Pages のように、静的コンテンツのホスティング、一部の動的な機能、SSL 化、カスタムドメインを無料で利用できるサービスは、コスト面で大きなメリットがあります。AWS で同様の構成を組む場合は、上記のような費用が発生することを理解しておく必要があります。

## "SPA support" or "SPA mode"

実際に静的ファイル(アセット)が存在しない URL を呼ぶと、
ルートの HTML を返す機能を何と呼ぶか?
という話。

一般的には "Fallback Routing" と呼ぶらしい。

Cloudflare では "SPA support" や "SPA mode" と呼ぶらしい。

- Netlify では「History pushstate」や「Redirect and rewrite rules」
- Vercel では「Rewrites」
- AWS CloudFront では「Default root object」や「Custom error responses」

という名称。

React Router では History モードと呼ぶらしい(History API 由来)。
