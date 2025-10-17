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
