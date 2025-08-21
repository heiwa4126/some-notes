# Marp メモ

Markdown でスライドを作るやつ。
[Marp: Markdown Presentation Ecosystem](https://marp.app/#get-started)

VSCode の拡張版と npm ベースの CLI 版がある。

[@marp-team/marp-cli - npm](https://www.npmjs.com/package/@marp-team/marp-cli)

CLI 版の方は、編集可能な pptx にエクスポートするオプション(--pptx-editable)が付いた。
[Release v4.1.0 · marp-team/marp-cli](https://github.com/marp-team/marp-cli/releases/tag/v4.1.0)

VSCode の拡張版で、CLI のパスが指定できるらしい。

いま見たら `markdown.marp.pptx.editable` って設定があるな Marp for VScode。
どっちがいいか比較する。(2025-03)

## Marp の sytax

(2025-08 調べ)

marp-vscode は marpit フレームワークの上で書かれているので
[Marpit Markdown](https://marpit.marp.app/markdown)

あと

- [marp-team/marp-vscode: Marp for VS Code: Create slide deck written in Marp Markdown on VS Code](https://github.com/marp-team/marp-vscode?tab=readme-ov-file#readme)
- [marp-team/marp-core: The core of Marp converter](https://github.com/marp-team/marp-core?tab=readme-ov-file#readme)

も参照しないと全貌がわからない。

## marp-vscode v4 で Mermaid の図を PDF で export する

いまのところ直接 Mermaid を埋め込む方法はなくて

- Marp 中に Mermaid を書き、HTML 有効&スクリプト有効で CDN から mermaid を読んで PDF 中で実行
- fig1.mmd みたいので別に図を描き、これを svg に変換して、普通に markdown 風に埋め込む

最初のやつはセキュリティ的にヤバいしオフラインでどうなるかわからん。後者を試す。

拡張機能は

- `mermaid-preview` [Mermaid Preview - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=vstirbu.vscode-mermaid-preview)
- あと `marp-vscode` [Marp for VS Code - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)

手順は

- まず .mmd でファイル作る
- `Mermaid Preview: Preview Diagram` でプレビュー開く & 編集
- プレビュー画面の左上に export アイコンがあるので、そこから
- で marp のほうにインライン

画像のサイジングは Marp の特殊記法を使う
[Image syntax](https://marpit.marp.app/image-syntax)
参照。

これでプレビューみながらサイズを調整すると、その比率でエクスポートされる
(何言ってるかわからんと思うが試してみて)

あとこの記法を使うと図が左揃になる。これは CSS で治す。

```text
---
marp: true
style: |
  section img {
    display: block;
    margin: auto;
  }
---
```

こんな感じ。セクション単位で指定できるはず。
