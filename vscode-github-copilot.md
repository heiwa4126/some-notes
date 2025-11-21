# VSCode + GitHub Copilot のメモ

## .vscode/mcp.json の「モデルアクセスの構成」とは何

英 UI だと "Configure Model Access"

"servers"の各々のサーバで「その他...」をクリックすると出てくるやつ。

またはコマンドパレットから MCP: List Servers → 対象サーバー選択 → Configure でも行ける

### サンプリングとは

- [Sampling - MCP developer guide | Visual Studio Code Extension API](https://code.visualstudio.com/api/extension-guides/ai/mcp#sampling)
- [MCP の Sampling 機能を試す](https://zenn.dev/mitsuaki/articles/mcp-sampling)
- [Sampling – Model Context Protocol (MCP)](https://modelcontextprotocol.info/docs/concepts/sampling/)

MCP サーバーが「自分では LLM を持っていないので、VS Code に頼んでモデルに問い合わせたい」という仕組みです。

VSCode+GitHub Copilot で使う場合
**Sampling の仕組みを使うと、MCP サーバー側では API キーや認証情報を一切保持しなくて済みます。**

いま VSCode で awslabs.aws-documentation-mcp-server が設定されているとしましょう。

この流れで「Sampling」は サーバーが VS Code に LLM 呼び出しを委託するプロセスです。

ステップごとの動き

1. **MCP サーバー(AWS Documentation MCP Server)が VS Code に対して要求する**  
   → 主語:AWS Documentation MCP Server  
   → 述語:VS Code に「この質問を LLM に投げて答えを返してほしい」と依頼する  
   → これは MCP の sampling/createMessage リクエストです。
2. **VS Code がユーザーに確認する**  
   → 主語:VS Code  
   → 述語:「このサーバーが LLM を使いたがっています。許可しますか?」とユーザーに尋ねる  
   → ここで「モデルアクセスの構成」で許可したモデルだけが候補になります。
3. **VS Code が選んだ LLM にプロンプトを送る**  
   → 主語:VS Code  
   → 述語:ユーザーが許可したモデル(例:GPT-4、Claude、Azure OpenAI など)に対して、サーバーから受け取った質問を送信する  
   → ここで使うモデルは VS Code 側の契約や API キーで動きます。
4. **LLM が応答を返す**  
   → 主語:LLM(選択されたモデル)  
   → 述語:VS Code に回答を返す。
5. **VS Code がその回答を MCP サーバーに返す**  
   → 主語:VS Code  
   → 述語:LLM の回答を AWS Documentation MCP Server に渡す。

まあそういうことなんだけど
`sampling/createMessage`
は「あんまり発生しない」みたい。

## チャット参加者 (Chat Participants)

- **@workspace** → ワークスペース全体のコンテキストで質問に答える
- **@vscode** → VS Code の機能や設定に関する質問
- **@terminal** → ターミナルコマンドに関する質問

## GitHub Copilot のエージェント

[Built\-in agents](https://code.visualstudio.com/docs/copilot/chat/copilot-chat#_builtin-agents)

- **Agent** → 実装を自動化
- **Plan** → 計画策定
- **Ask** → 質問・調査
- **Edit** → 既知の変更を適用
- **カスタムエージェント** [Custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

### Agent エージェント

- **目的**: 複雑なコーディングタスクを自律的に実行
- **特徴**:
  - 高レベルの要件に基づき、必要なファイル編集やツール実行を自動で判断
  - ターミナルコマンドやビルドも実行可能(ただし**ユーザーの承認が必要**)
  - エディタに直接コード変更を適用し、diff ビューやインラインプレビューでレビュー可能
- **例**:  
  「OAuth2 と JWT で認証システムを実装して」→ 必要なコードと設定を自動生成。

### Plan エージェント

- **目的**: 実装前に詳細な計画を作成
- **特徴**:
  - 複雑な機能をステップに分解
  - 明確化のため質問を投げかける
  - 作成した計画は、後で Agent モード に引き継ぎ可能
- **例**:  
  「多言語対応を追加するための計画を立てて」→ 手順リストを提示

### Ask エージェント

- **目的**: コードや技術に関する質問に回答
- **特徴**:
  - コードの仕組み説明、アイデア探索、小規模なコード提案
  - 提案コードは個別に適用可能
- **例**:  
  「React で検索機能を実装する 3 つの方法を教えて」  
  「このプロジェクトで DB 接続はどこ?」

### Edit エージェント

- **目的**: 複数ファイルにわたるコード編集
- **特徴**:
  - ユーザーが変更内容を把握している場合に最適
  - エディタで直接変更を適用し、diff ビューで確認
- **例**:  
  「この関数を async/await に書き換えて」→ 対象ファイルを自動編集

### カスタムエージェントの作成

`.github` フォルダに Markdown ファイルを配置することで、プロジェクト固有のカスタムエージェントを作成できます。

- [Custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [コードレビュー用のカスタムエージェントを作成する](https://code.visualstudio.com/docs/copilot/getting-started#_create-a-custom-agent-for-code-reviews)

## Plan モードについて

- [Planning in VS Code chat](https://code.visualstudio.com/docs/copilot/chat/chat-planning)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
