# Google Apps Script (GAS)

Gmailの古いメールをアーカイブしたくて始めてみたんだけど

## WebUI

ここから <https://script.google.com/>

Google Driveに \<プロジェクト名\> として保存される。
フォルダではないみたい。スクリプトとメタデータのzip? のような感じ

## チュートリアル

- [Google Apps Script の実践: 4 行のコードで Google スプレッドシート、マップ、Gmail にアクセスする](https://codelabs.developers.google.com/codelabs/apps-script-intro?hl=ja#0)
- [Apps Script の基礎に関する Codelab の概要 | Google for Developers](https://developers.google.com/apps-script/samples/fundamentals-codelabs?hl=ja)

## VSCode

質問: GAS は VScode で書いてトークン与えて実行、みたいなことはできますか?

これでできるらしい。CLASP (Command Line Apps Script Projects)

- [@google/clasp - npm](https://www.npmjs.com/package/@google/clasp?activeTab=dependencies)
- [google/clasp: 🔗 Command Line Apps Script Projects](https://github.com/google/clasp)

ざっくり手順

```sh
# claspをインストール
npm install -g @google/clasp

# Googleアカウントでログイン
clasp login

# プロジェクトの作成または取得
## 新規作成
clasp create "hello"
## または既存の取得
clasp clone <Script ID>  # clasp clone

# コードを書いてアップロード
clasp push
## このあとブラウザのスクリプトエディタから実行
## または
clasp run \<関数名\>
## clasp run でも clasp push は必要
```

詳しくは

- [google/clasp の README](https://github.com/google/clasp?tab=readme-ov-file#install)
- [clasp導入で既存のGAS開発を効率化！インストールからデプロイの手順とメリットを徹底解説 | Sqripts](https://sqripts.com/2025/03/13/104667/)

「アップロード」先は、Google ドライブ上にある「Google Apps Script プロジェクト(スクリプトエディタ、GASエディタ)」。

デバックは「GASエディタ」でデバッグするしかない。

## GASで外部モジュール

ふつーに `npm add` して使えない。

1. バンドルする。
2. または 他の人が公開している「スクリプト ID」を自分のプロジェクトに登録

cjsにトランスパイル&バンドル&IIFE(エントリ関数をグローバルに)して clasp pushする感じがいいらしい。
