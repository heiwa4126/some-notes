# おためし Vite + React

評判の 次世代フロントエンドツール [Vite](https://ja.vitejs.dev/) をちょっとだけ使ってみました。

テストした環境:

- node v18.12.1
- Windows 11 (x86_64)
- Windows Terminal から Powershll 7.3 で
- あと vscode

## テンプレート作成

参考: [最初の Vite プロジェクトを生成する](https://ja.vitejs.dev/guide/#%E6%9C%80%E5%88%9D%E3%81%AE-vite-%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E3%82%92%E7%94%9F%E6%88%90%E3%81%99%E3%82%8B)

```powershell
npm create vite@latest my-react-app -- --template react-ts
cd my-react-app
npm install
npm run dev
```

で、http://127.0.0.1:5173/ をブラウザで開く。

ブラウザを開いたまま vscode でコードを修正すると、自動でリロードされる(HMR)。

## デプロイ

参考: [静的サイトのデプロイ | Vite](https://ja.vitejs.dev/guide/static-deploy.html)

```powershell
npm run build
```

で、./dist/の下に出力される。

これを

```powershell
npm run preview
```

http://127.0.0.1:4173/ をブラウザで開く。

または [http-server](https://www.npmjs.com/package/http-server)を使って、

```powershell
npx http-server dist
```

http://127.0.0.1:8080/ をブラウザで開く、とかでも OK。

## 感想

- **異常に早い**。create-react-app より 1000 倍ぐらい早いような気がする。
- Webpack や Babel や tsc を入れる手間がぜんぜん要らない。そういえば React も明示的に入れてない。

## その他参考リンク

- [Vite+React+Amplify の初期設定方法!](https://zenn.dev/akira_abe/articles/20221012-vite-react-amplify)
- [Vite のプロジェクトに Amplify の設定を適用する方法 - Qiita](https://qiita.com/maejima_f/items/0188adbcc8f2af564153)

## Deno で Vite

Deno 1.28 から。

参考:

- [denoland/deno-vue-example: An example of using Vue with Deno.](https://github.com/denoland/deno-vue-example)
- [bartlomieju/vite-deno-example: Example of using Vite with Deno](https://github.com/bartlomieju/vite-deno-example)

(WSL でない)Windows だと死ぬ。Linux だと超早い感。もっと試す。

## Vite で対話式でなくプロジェクトを開始する方法メモ

`npm create vite@latest {プロジェクト名} -- --template react-swc-ts`

Bun と pnpm は
`pnpm create vite {プロジェクト名} --template react-swc-ts`

公式テンプレートのリストは
[Scaffolding Your First Vite Project](https://vitejs.dev/guide/#scaffolding-your-first-vite-project)
にある。

コミュニティ版テンプレート(動くかどうかは微妙)は
[vitejs/awesome-vite: ⚡️ A curated list of awesome things related to Vite.js](https://github.com/vitejs/awesome-vite#templates)
にある。
