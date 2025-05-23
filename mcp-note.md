# MCP(Model Context Protocol)のメモ

MCP のことなら claude に聞くといいです。

## ざっくり理解

MCP サーバーは
さまざまな RPC(リモート関数) をつめこんだサーバ。

プロトコルは JSON-RPC。

で、計算機 MCP サーバーには
「わたしはこんな関数(関数名と説明)があって、こんな呼び出し方をすると、こんな感じの答えを返しますよ?」の一覧を返す関数がある。

- [Listing Resources (resources/list)](https://modelcontextprotocol.io/specification/draft/server/resources#listing-resources)
- [Listing Tools (tools/list)](https://modelcontextprotocol.io/specification/2025-03-26/server/tools#listing-tools)

認可には Bearer Token 式が多いみたい。
