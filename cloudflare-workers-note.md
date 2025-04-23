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
