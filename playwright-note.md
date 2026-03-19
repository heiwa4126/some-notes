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
pnpm exec create playwright
## playwright.config.ts など

## とりあえずChrome(Chromium)だけあればいい場合は
playwright install chromium  # chromium, chromium_headless, ffmpeg の最新版が入る
## Chromium で URLを開いてみる
playwright cr "https://www.google.com/"
```

Webkit (Safari) が要る場合は事前に

```sh
sudo apt-get install libgtk-4-1 libavif13
```

### `pnpm exec create playwright` のところがめんどくさいけどオプションが無い

```console
$ pnpm create playwright --browser chromium

Getting started with writing end-to-end tests with Playwright:
Initializing project in '.'
✔ Where to put your end-to-end tests? · tests_e2e
✔ Add a GitHub Actions workflow? (Y/n) · false
✔ Install Playwright operating system dependencies (requires sudo / root - can be done manually via 'sudo pnpm exec playwright install-deps')? (y/N) · false

Installing Playwright Test (pnpm add --save-dev -w @playwright/test)…
Already up to date
Progress: resolved 49, reused 22, downloaded 0, added 0, done
Done in 366ms using pnpm v10.30.3
✔ /home/heiwa/works/hono/hono-learn-ejs2/playwright.config.ts already exists. Override it? (y/N) · true
Writing playwright.config.ts.
✔ /home/heiwa/works/hono/hono-learn-ejs2/tests_e2e/example.spec.ts already exists. Override it? (y/N) · true
Writing tests_e2e/example.spec.ts.
Writing package.json.
Downloading browsers (pnpm exec playwright install chromium)…
✔ Success! Created a Playwright Test project at /home/heiwa/works/hono/hono-learn-ejs2

Inside that directory, you can run several commands:

  pnpm exec playwright test
    Runs the end-to-end tests.

  pnpm exec playwright test --ui
    Starts the interactive UI mode.

  pnpm exec playwright test --project=chromium
    Runs the tests only on Desktop Chrome.

  pnpm exec playwright test example
    Runs the tests in a specific file.

  pnpm exec playwright test --debug
    Runs the tests in debug mode.

  pnpm exec playwright codegen
    Auto generate tests with Codegen.

We suggest that you begin by typing:

    pnpm exec playwright test

And check out the following files:
  - ./tests_e2e/example.spec.ts - Example end-to-end test
  - ./playwright.config.ts - Playwright Test configuration

Visit https://playwright.dev/docs/intro for more information. ✨

Happy hacking! 🎭
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

## Playwright MCP と Playwright CLI の比較

[Playwright MCP vs Playwright CLI](https://github.com/microsoft/playwright-mcp?tab=readme-ov-file#playwright-mcp-vs-playwright-cli)
の日本語訳。

このパッケージはPlaywrightへのMCPインターフェースを提供します。コーディングエージェントをご利用の場合は、代わりに[CLI+SKILLS](https://github.com/microsoft/playwright-cli)を使用すると便利です。

- **CLI**：現代のコーディングエージェントは、 MCPよりもSKILLとして公開されるCLIベースのワークフローを好む傾向にあります。これは、CLI呼び出しの方がトークン効率が高いためです。CLI呼び出しでは、大規模なツールスキーマや冗長なアクセシビリティツリーをモデルコンテキストに読み込む必要がなくなり、エージェントは簡潔で専用のコマンドを使用して動作できます。そのため、CLI + SKILLは、ブラウザ自動化と大規模なコードベース、テスト、そして限られたコンテキストウィンドウ内での推論のバランスを取る必要がある高スループットコーディングエージェントに適しています。Playwright [CLI with SKILLS](https://github.com/microsoft/playwright-cli)
  の詳細については、こちらをご覧ください。
- **MCP** : MCP は、探索的自動化、自己修復テスト、継続的なブラウザ コンテキストの維持がトークン コストの懸念を上回る長期実行自律ワークフローなど、永続的な状態、豊富なイントロスペクション、ページ構造の反復的な推論の恩恵を受ける特殊なエージェント ループに引き続き関連しています。

## playwright-core が2つあって、違うバージョンのブラウザを使おうとするとき

@playwright/test と
@playwright/mcp が
異なるバージョンの playwright-core を使っていて
いまこんな感じなんですがどうすればいい?
という話

```console
$ pnpm ls | grep -Fi playwright
├── @playwright/mcp@0.0.68
├── @playwright/test@1.58.2

$ pnpm why playwright-core
playwright-core@1.58.2
└─┬ playwright@1.58.2
  └─┬ @playwright/test@1.58.2
    └── my-project (devDependencies)

playwright-core@1.59.0-alpha-1771104257000
├─┬ @playwright/mcp@0.0.68
│ └── my-project (devDependencies)
└─┬ playwright@1.59.0-alpha-1771104257000
  └── @playwright/mcp@0.0.68 [deduped]

$ pnpm exec playwright --version
Version 1.58.2
```

playwright-coreのバージョンに応じたブラウザバージョンを要求するので
**オンデマンドでインストールしたくなければ**

```sh
pnpm exec playwright install chromium
pnpx playwright@1.59.0-alpha-1771104257000 install chromium
```

のように `~/.cache/ms-playwright` 以下に2バージョンインストールする必要がある。

### ついでに `@playright/cli` もaddしてみた

```console
$ pnpm ls | grep -Fi playwright
├── @playwright/cli@0.1.1
├── @playwright/mcp@0.0.68
├── @playwright/test@1.58.2

$ pnpm why playwright-core
playwright-core@1.58.2
└─┬ playwright@1.58.2
  └─┬ @playwright/test@1.58.2
    └── my-project (devDependencies)

playwright-core@1.59.0-alpha-1771104257000
├─┬ @playwright/mcp@0.0.68
│ └── my-project (devDependencies)
└─┬ playwright@1.59.0-alpha-1771104257000
  ├─┬ @playwright/cli@0.1.1
  │ └── my-project (devDependencies)
  └── @playwright/mcp@0.0.68 [deduped]
```

(たまたまかもしれないけど) @playwright/test だけ違うのだな。

### issues など

この問題、けっこう「既知の罠」らしい

- [Stabilize usage of \\`playwright\\` & \\`playwright-core\\` versions · Issue #917 · microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp/issues/917)
- [Missing prerequisite steps in Getting Started documentation · Issue #1113 · microsoft/playwright-mcp](https://github.com/microsoft/playwright-mcp/issues/1113)

### とりあえず対策

こんなスクリプトでなんとか。
(いま chromium を指定しています)

```mjs
#!/usr/bin/env node
# scripts/download_chromes.mjs

import { execSync } from "node:child_process";

// `pnpm why playwright-core --json` で確実にバージョンを拾う
const raw = execSync("pnpm why playwright-core --json", { encoding: "utf-8" });

const versions = new Set(JSON.parse(raw).map((entry) => entry.version));

console.log("Detected playwright-core versions:", [...versions]);

for (const version of versions) {
	console.log(`\nInstalling Chromium for playwright@${version}...`);
	execSync(`pnpm dlx playwright@${version} install chromium`, {
		stdio: "inherit",
	});
}
```

## Playwright MCP でブラウザ固定

(`node_modules` にインストールした playwright を使う場合。
肝心なのはoption)

"--browser=chromium" のようなオプションを使う。
これつけないと Chrome をインストールしようとする。

`.vscode/mcp.json`

```json
{
  "servers": {
    "playwright": {
      "command": "pnpm",
      "args": ["exec", "playwright-mcp", "--browser=chromium"]
    }
  },
  "inputs": []
}
```

## Playwright MCP でスクリーンショット

(`node_modules` にインストールした playwright を使う場合。
肝心なのはoption)

Vision リクエストが禁止されてる環境でエラーになるみたい。

```json
{
  "servers": {
    "playwright": {
      "command": "pnpm",
      "args": ["exec", "playwright-mcp", "--image-responses", "omit"]
    }
  },
  "inputs": []
}
```

みたいな感じで回避できる。

## Playwright CLI の show サブコマンドが面白い

[Monitoring](https://github.com/microsoft/playwright-cli?tab=readme-ov-file#monitoring)

もう少し使いこなしてから書く。
