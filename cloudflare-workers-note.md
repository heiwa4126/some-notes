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
