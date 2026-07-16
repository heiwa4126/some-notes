# Cloudflare Turnstile のメモ

## 超重要

Cloudflare 側の Turnstile の UI で、ホストを追加したあと、一番下の"更新"を押さないとダメ

ホストには localhost と 127.0.0.1 を入れとくと
ローカルのテストが楽
(セキュアでないので、ちょっと試したら SECRET 式にすること)
