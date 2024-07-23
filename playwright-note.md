# Playwright のメモ

スペル間違いやすい。

## チュートリアル

[Playwright で初めてのエンドツーエンド テストをビルドする - Training | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/modules/build-with-playwright/)

## 既存のプロジェクトに playwright をインストーする

```sh
npm i @playwright/test @types/node npm-run-all -D
```

run-scripts にこんな感じで書く

```json
"scripts": {
    "test:e2e:test": "playwright test",
    "test:e2e:show-report": "playwright show-report",
    "test:e2e": "run-s test:e2e:test test:e2e:show-report"
}
```

練習で
`npm init playwright@latest`
で作ったプロジェクトから
`playwright.config.ts` と `tests`(`tests-e2e`とかにリネームするといい)をコピーしてくる & 整える。

`npx playwright install` で (pnpm だったら `pnpm exec playwright install`)
ブラウザ類をインストール

`npm run test:e2e` を実行。
& VSCode の拡張からテスト

.gitignore も整える

```text
# Playwright specific
/test-results/
/playwright-report/
/playwright/.cache/
```

### vite の場合

`npm run dev` で起動してると、`/playwright-report/` が書き換わるごとにリロードされてしまう。

vite.config.ts を、こんなふうに設定

```typescript
export default defineConfig({
  plugins: [react()],
  server: {
    watch: {
      ignored: ['**/playwright-report/**']
    }
  }
});
```

つづく
