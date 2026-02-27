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
