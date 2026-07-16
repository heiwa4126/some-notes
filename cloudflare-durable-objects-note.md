# Cloudflare Durable Objects

略称: DO

[Overview · Cloudflare Durable Objects docs](https://developers.cloudflare.com/durable-objects/)

## DOとは何か?

[What are Durable Objects? · Cloudflare Durable Objects docs](https://developers.cloudflare.com/durable-objects/concepts/what-are-durable-objects/)

- DO は ID によって一意に識別されるシングルトン
- 同じ ID に対しては、世界中で 1 つのインスタンスのみが存在する(ある時点において)
- その 1 つのインスタンスに全リクエストがルーティングされる → 強一貫性が得られる

## DOは1個または0個

- DO は遅延生成(初めてアクセスされたときに作られる)
- 一定時間アクセスがないとメモリから消える(eviction)
- ただし Storage に保存したデータは残る → 次のアクセス時に復元される

なので「インスタンスとしては 0 か 1」だけど
「データとしては永続する」という二層構造

## SQLインタフェースを使わない場合(KVストレージ)では自分でget/put を書く必要がある

ただし get はインメモリにキャッシュする手法がよくとられる。

```ts
constructor(state: DurableObjectState) {
  this.state = state;
  // コンストラクタで blockConcurrencyWhile を使い初期化
  this.state.blockConcurrencyWhile(async () => {
    this.value = await this.state.storage.get("myKey") ?? null;
  });
}
```

だったら put もハイバネートフックで...と思うけど、それはできない。

ハイバネートのタイミングは制御できないので、「消える直前に put」というコードは書けません。
変更したときに即 put する。

## DOでSQLインタフェースをつかうときは、コンストラクタでテーブルを作る

`CREATE TABLE IF NOT EXISTS`

## DO namespace を削除するとストレージも消える
