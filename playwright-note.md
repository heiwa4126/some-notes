# Playwright のメモ

スペル間違いやすい。

## チュートリアル

[Playwright で初めてのエンドツーエンド テストをビルドする - Training | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/modules/build-with-playwright/)

## 既存のプロジェクトに playwright をインストーする

```sh
mkdir test1 && cd test1
pnpm init
#
pnpm add -D @playwright/test
playwright init

## とりあえずChrome(Chromium)だけあればいい場合は
playwright install chromium  # chromium, chromium_headless, ffmpeg の最新版が入る
## Chromium で URLを開いてみる
playwright cr "https://www.google.com/"
```

Webkit (Safari) が要る場合は事前に

```sh
sudo apt-get install libgtk-4-1 libavif13
```

## ブラウザはどこにインストールされる?

`~/.cache/ms-playwright`

ほかの OSは [Browsers | Playwright](https://playwright.dev/docs/browsers) 参照。

あとこのディレクトリは単なるキャッシュなので、
古いブラウザを手で消しても問題ないそうです。

## インストールされているブラウザは?

```sh
npx playwright install --list
```

## 某 ZScaler が MITM で邪魔する場合

```sh
# これは動く
playwright cr "https://www.google.com/"
# これは動かない
playwright cr "https://www.example.com/"
```

実行例:

```console
$ playwright cr "https://www.example.com/"
Error: net::ERR_CERT_AUTHORITY_INVALID at https://www.example.com/
Call log:
  - navigating to "https://www.example.com/", waiting until "load"
```

Linux 版 Chromium / Firefox は共通してNSS (Network Security Services)を使うので
`$HOME/.pki/nssdb` を作ってやればいい。

```sh
# nssdbの作成
mkdir -p $HOME/.pki/nssdb
certutil -d sql:$HOME/.pki/nssdb -N --empty-password
## ※ `certutil` は `libnss3-tools` パッケージに含まれています
```

実行例

```console
$ certutil -d sql:$HOME/.pki/nssdb -N --empty-password

Enter Password or Pin for "NSS Certificate DB": (enter押す)
Enter a password which will be used to encrypt your keys.
The password should be at least 8 characters long,
and should contain at least one non-alphabetic character.

Enter new password: (enter押す)
Re-enter password: (enter押す)
Password changed successfully.
```

`--empty-password` を指定してもパスワードを聞いてくるのはなんでだか不明

で、

```sh
for cert in /etc/ssl/certs/*.pem; do
    certname=$(basename "$cert" .pem)
    certutil -d sql:$HOME/.pki/nssdb -A -n "$certname" -t "CT,," -i "$cert" 2>/dev/null
done
```

これはよくばりセットなので、`/etc/ssl/certs/*.pem` のところを
zscaler.pem の本当のパスに変えてください。

```sh
# 確認
certutil -d sql:$HOME/.pki/nssdb -L

# これは動く
playwright cr "https://www.google.com/"
# これも動くはず
playwright cr "https://www.example.com/"
```

Firefoxもあるなら `cr` を `ff` にしてみよう。

## 既存のプロジェクトに playwright をインストーする(old)

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
