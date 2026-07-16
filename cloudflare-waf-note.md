# Cloudflare の WAF

## Rate Limiting と Throttling は違う

API エンドポイントなら Rate Limiting、
ログインページなど人間がアクセスする場所なら Throttling、
というのが一般的な使い分け。

free tier では Rate Limiting が使えない(未確認)。

### レート制限 (Rate Limiting)

- 制限を超えたリクエストを**即座に 429 を返して拒否**
- 指定した時間が経過するまで**全てのリクエストを拒否し続ける**

```text
リクエスト 1〜10: 通過
リクエスト 11以降: 即 429(10分間)
10分後: またカウントリセット
```

### スロットリング(Throttling)

- 制限を超えたリクエストに**Challenge(CAPTCHA等)を出す**
- Challenge を**クリアしたらカウンターがリセット**されて通過できる
- 正規ユーザーが誤って引っかかった場合に救済できる

```text
リクエスト 1〜10: 通過
リクエスト 11以降: CAPTCHA を出す
  → クリアしたら → カウンターリセットして通過
  → 失敗したら → ブロック
```

## free tier で Rate Limiting

ドメインが登録されてればできるらしい

Security rules ページに移動し、Create rule > Rate limiting rule を選択します。

Free プランでの設定手順

- Rule name にルール名を入力（例: "Rate limit login"）
- When incoming requests match で条件を設定  
  例: `(http.request.uri.path eq "/login" and http.request.method eq "POST")`  
  式ビルダーだとメソッド指定ができない。"式を編集" をクリック。
- With the same characteristics — Free プランでは IP が自動で選択されます
- When rate exceeds で閾値を設定  
  Requests: 5（例）
- Period: Free プランでは 10 seconds のみ選択可能
- Then take action — Free プランでは Block のみ選択可能
- For duration — Free プランでは 10 seconds のみ選択可能
- Deploy をクリック
