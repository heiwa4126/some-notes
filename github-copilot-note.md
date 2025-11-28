# GitHub Copilot のメモ

## チュートリアル

VSCode のと GitHub のがある。

- これが一番簡単だった - [Get started with GitHub Copilot in VS Code](https://code.visualstudio.com/docs/copilot/getting-started)
- [GitHub Copilot のクイック スタート - GitHub ドキュメント](https://docs.github.com/ja/copilot/get-started/quickstart?tool=visualstudio)
- [GitHub Copilot のチュートリアル - GitHub ドキュメント](https://docs.github.com/ja/copilot/tutorials)

## Copilot Chat のプロンプト要素 (prompt elements)

チャット参加者・チャット変数・スラッシュコマンドの総称

- Copilot Chat のプロンプト要素
- Copilot Chat のキーワード(chat keywords)

ともいう。

- [GitHub Copilot Chat cheat sheet - GitHub Docs](https://docs.github.com/en/copilot/reference/cheat-sheet?tool=vscode)
- [Getting started with prompts for GitHub Copilot Chat - GitHub Docs](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/get-started-with-chat?tool=vscode)

## 参考訳: GitHub Copilot Chat のプロンプトの概要 (Visual Studio Code)

[Getting started with prompts for GitHub Copilot Chat - GitHub Docs](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/get-started-with-chat?tool=vscode) の参考訳

Copilot Chat を使って、プロジェクトに関する具体的な質問や、ソフトウェア全般に関する質問をすることができます。
また、Copilot Chat にコードの記述、エラーの修正、テストの記述、コードのドキュメント化を依頼することもできます。

以下のプロンプト例には、**チャット参加者(`@`で始まる)**、**スラッシュコマンド(`/`で始まる)**、**チャット変数(`#`で始まる)** が含まれています。

キーワードの詳細については「[IDE で GitHub Copilot に質問する](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide#using-keywords-in-your-prompt)」を参照してください。

### ソフトウェアに関する一般的な質問をする

Copilot Chat に一般的なソフトウェアに関する質問をすることができます。

**例:**

- nodejs の Web サーバーフレームワークについて教えて
- Express アプリをどうやって作成すればいい?
- @terminal npm パッケージを更新する方法を教えて

### プロジェクトに関する質問をする

プロジェクトについて Copilot Chat に質問できます。

**例:**

- この関数はどのソートアルゴリズムを使っていますか?
- @workspace 通知はどのようにスケジュールされていますか?
- #file:gameReducer.js #file:gameInit.js これらのファイルはどう関連していますか?

Copilot に正しいコンテキストを提供するための方法:

- 関連するコード行をハイライトする
- `#selection`、`#file`、`#editor`、`#codebase`、`#git` などのチャット変数を使う
- `@workspace` チャット参加者を使う

### コードの記述を依頼する

Copilot にコードの記述を依頼できます。

**例:**

- リスト内のすべての数字を合計する関数を書いて
- この関数にエラーハンドリングを追加して
- @workspace ニュースレターページと同様のフォームバリデーションを追加して

Copilot がコードブロックを返すと、応答には以下のオプションが含まれます:

- コードをコピーする
- カーソル位置に挿入する
- 新しいファイルに挿入する
- ターミナルに挿入する

### GitHub Advanced Security 機能のアラートについて質問する

GitHub Advanced Security 機能(code scanning、secret scanning、Dependabot alerts)によるリポジトリのセキュリティアラートについて質問できます。

**例:**

- このアラートを修正するにはどうすればいい?
- このプルリクエストにはいくつアラートがありますか?
- このコードスキャンアラートはどのコード行を参照していますか?
- この Dependabot アラートで影響を受けているライブラリはどれですか?

### 新しいプロジェクトを設定する

`/new` スラッシュコマンドを使用して、新しいプロジェクトを設定します。

**例:**

- /new TypeScript を使った React アプリ
- /new Python Django Web アプリケーション
- /new Node.js Express サーバー

Copilot はディレクトリ構造を提案し、提案されたファイルと内容を作成するためのボタンを提供します。  
提案されたファイルをプレビューするには、提案されたディレクトリ構造でファイル名を選択します。

### 新しい Jupyter ノートブックを設定する

`/newNotebook` スラッシュコマンドを使用します。

**例:**

- /newNotebook タイタニックのデータセットを取得し、Seaborn を使ってデータをプロットする

### コードの修正、改善、リファクタリング

アクティブなファイルにエラーが含まれている場合は、`/fix` スラッシュコマンドを使用して修正を依頼します。  
また、コードを改善またはリファクタリングするための一般的な要求も可能です。

**例:**

- このコードを改善するにはどうすればいい?
- このコードを C# に変換して
- この関数にエラーハンドリングを追加して

### テストを記述する

`/tests` スラッシュコマンドを使用して、アクティブなファイルまたは選択したコードのテストを記述します。

**例:**

- /tests
- /tests Jest フレームワークを使って
- /tests 関数が空のリストを拒否することを確認する

テスト駆動開発を行う場合は、`/tests` コマンドを省略して、テストの記述を依頼できます。

**例:**

- 整数のリストを合計する JavaScript 関数のテストを追加して

### Visual Studio Code について質問する

`@vscode` チャット参加者を使用して、Visual Studio Code に関する具体的な質問をします。

**例:**

- @vscode node.js アプリをどうやってデバッグすればいいか教えて
- @vscode Visual Studio Code の配色を変更する方法を教えて
- @vscode キーバインドを変更するにはどうすればいい?

### コマンドラインについて質問する

`@terminal` チャット参加者を使用して、コマンドラインに関する質問をします。

**例:**

- @terminal src ディレクトリで最大のファイルを見つけて
- @terminal #terminalLastCommand 最後のコマンドとエラーを説明して

## チャット参加者 (chat participant) とは

Copilot Chat における特定のコンテキストや役割を指定するためのキーワード。
簡単に言うと、Copilot に「どの視点で答えてほしいか」を指示する仕組みです。

### 具体的な役割

- **`@workspace`**  
  → プロジェクト全体(ワークスペース)に関する質問をするときに使います。  
  例: `@workspace How are notifications scheduled?`  
  → 「ワークスペース全体で通知はどうスケジュールされている?」

- **`@vscode`**  
  → Visual Studio Code に関する質問をするときに使います。  
  例: `@vscode tell me how to debug a node.js app`  
  → 「Visual Studio Code で Node.js アプリをどうデバッグするか教えて」

- **`@terminal`**  
  → ターミナルやコマンドラインに関する質問をするときに使います。  
  例: `@terminal find the largest file in the src directory`  
  → 「src ディレクトリで最大のファイルを見つけて」

### なぜ必要か?

Copilot は複数の情報源(コード、エディタ、ターミナルなど)を参照できます。  
**チャット参加者を指定することで、回答のコンテキストを絞り込み、より正確な答えを得ることができます。**

## チャット変数 (chat variables) とは

**Copilot Chat に質問する際に、どのコードやコンテキストを参照してほしいかを指定するための仕組み**。  
簡単に言うと、**「どの部分のコードを見て答えてほしいか」を明示するタグ**です。

### 主なチャット変数の種類と役割

- **`#file`**  
  → 特定のファイルを参照するよう指示します。  
  例: `#file:gameReducer.js #file:gameInit.js how are these files related?`  
  → 「gameReducer.js と gameInit.js はどう関連していますか？」

- **`#selection`**  
  → エディタで選択したコード部分を参照します。  
  例: `#selection explain this code`  
  → 「選択したコードを説明して」

- **`#editor`**  
  → 現在開いているファイル全体を参照します。  
  例: `#editor suggest improvements`  
  → 「このファイル全体の改善点を提案して」

- **`#codebase`**  
  → プロジェクト全体のコードベースを参照します。  
  例: `#codebase where is the user authentication implemented?`  
  → 「ユーザー認証はどこで実装されていますか？」

- **`#git`**  
  → Git の履歴や差分を参照します。  
  例: `#git summarize the last commit`  
  → 「最後のコミットを要約して」

- **`#terminalLastCommand`**  
  → ターミナルで最後に実行したコマンドを参照します。  
  例: `@terminal #terminalLastCommand explain the last command and error`  
  → 「最後のコマンドとエラーを説明して」

## スラッシュコマンド (slash commands) とは

**Copilot Chat に特定のアクションを直接指示するためのコマンド**。

- **即時アクション指示型**  
  → Copilot に「何をするか」を直接命令するため、通常の質問よりも明確。
- **IDE と連携**  
  → Visual Studio Code などの IDE 上で、ファイル作成やコード挿入などの操作を簡単に実行できる。

### 主なスラッシュコマンドと役割

- **`/new`**  
  → 新しいプロジェクトを作成する。  
  例: `/new react app with typescript`  
  → 「TypeScript を使った React アプリを作成して」

- **`/newNotebook`**  
  → 新しい Jupyter ノートブックを作成する。  
  例: `/newNotebook retrieve the titanic dataset and use Seaborn to plot the data`  
  → 「タイタニックのデータセットを取得し、Seaborn でプロットするノートブックを作成して」

- **`/fix`**  
  → アクティブなファイルや選択したコードのエラーを修正する。  
  例: `/fix`  
  → 「このファイルのエラーを修正して」

- **`/tests`**  
  → アクティブなファイルや選択したコードのテストを生成する。  
  例: `/tests using the Jest framework`  
  → 「Jest フレームワークを使ってテストを書いて」

## チャット参加者・チャット変数・スラッシュコマンドの違い

- **チャット参加者 (`@workspace`, `@vscode`)**  
  → 「どの視点で答えるか」を指定。
- **チャット変数 (`#file`, `#selection`)**  
  → 「どのコードや情報を参照するか」を指定。
- **スラッシュコマンド (`/new`, `/fix`)**  
  → 「何をするか」を直接指示。

## `/help` で表示されるメッセージ

(ここちょっと古い)

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

## カスタムエージェント

- [Create a custom agent for code reviews](https://code.visualstudio.com/docs/copilot/getting-started#_create-a-custom-agent-for-code-reviews)
- [Custom agent example](https://code.visualstudio.com/docs/copilot/customization/custom-agents#_custom-agent-example)
- [カスタム エージェントについて - GitHub ドキュメント](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-custom-agents)
- [カスタム エージェントの作成 - GitHub ドキュメント](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-custom-agents)
- [最初のカスタム エージェント - GitHub ドキュメント](https://docs.github.com/en/copilot/tutorials/customization-library/custom-agents/your-first-custom-agent)

VSCode の場合
通常プロジェクト単位で `.github/agents/` 配下に置く。

グローバルで使うには
`現在のユーザープロファイルフォルダーにカスタムエージェントプロファイルを作成し、それをすべてのワークスペースで使用します`
と書かれていて、どこに置けばいいのかよくわからない。

## 自分がどのライセンスの GitHub Copilot をつかっているのかわからなくなったら

GitHub の Web コンソールに移動してから
<https://github.com/settings/copilot/features>
へ移動

> GitHub Copilot Business is active for your account
