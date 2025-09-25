# GitHub Copilot のメモ

## `/help` で表示されるメッセージ

(ちょっと古い)

`@mermAId` は vscode-mermAId 拡張によるもの。

```text
プログラミングに関する一般的な質問をしたり、特殊な専門知識を持ち、アクションを実行できる次の参加者とチャットしたりできます。

@workspace - ワークスペースについて質問する
/explain - アクティブなエディターのコードの仕組みを説明します
/tests - 選択したコードの単体テストを生成する
/fix - 選択したコードの問題の修正を提案する
/new - ワークスペース内の新しいファイルまたはプロジェクトのスキャフォールディング コード
/newNotebook - 新しい Jupyter Notebook を作成する
/fixTestFailure - 失敗したテストの修正を提案します
/setupTests - プロジェクトでテストを設定する (試験段階)

@vscode - VS Code に関する質問をする
/search - ワークスペース検索のクエリ パラメーターを生成する
/startDebugging - VS Code で起動構成を生成してデバッグを開始する (試験段階)

@terminal - ターミナルで何かを行う方法を確認する
/explain - ターミナルで何か説明する

@remote-ssh - Remote - SSH について学び、接続の問題を診断します

@mermAId - Work with diagrams in the chat
/uml - Generate a UML diagram
/sequence - Generate a sequence diagram
/iterate - Iterate on a diagram generated in a previous chat turn
/help - How to use the mermAId agent

@github - Web 検索、コード検索、エンタープライズのナレッジ ベースに基づいている回答を得る
また、次の変数を使用して追加のコンテンツを提供することで、質問の理解に役立てることもできます。

#editor - The visible source code in the active editor
#selection - The current selection in the active editor
#terminalLastCommand - The active terminal's last run command
#terminalSelection - The active terminal's selection
#file - ワークスペースでファイルを選択する
```

## チャットの過去を消すコマンド

`/clear`
