# Amazon Q developer のメモ

## MCP のテンプレート

[MCP Server のセットアップ](https://catalog.workshops.aws/q-zero2hero/ja-JP/8-mcp/81-mcp-q-cli/811-setup-mcp-server)

の
"2. Q CLI 経由で MCP を設定するには、~/.aws/amazonq/mcp.json ファイルを編集します"
のとこのをコピペ。

AWS の MCP 一覧:
[awslabs/mcp: AWS MCP Servers — helping you get the most out of AWS, wherever you use MCP.](https://github.com/awslabs/mcp?tab=readme-ov-file#readme)

あと [mcp/DEVELOPER_GUIDE.md at main · awslabs/mcp · GitHub](https://github.com/awslabs/mcp/blob/main/DEVELOPER_GUIDE.md) も参照。

awslabs の MCP は StreamableHTTP は少なくて uvx で stdio が多い。推奨 Python は 3.10 なのでなんとかすること。

`uv python install 3.10` したあと

mcp.json の args で

```json
{
  "mcpServers": {
    "awslabs.aws-diagram-mcp-server": {
      "command": "uvx",
      "args": ["--python", "3.10", "awslabs.aws-diagram-mcp-server"],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "autoApprove": [],
      "disabled": false
    }
  }
}
```

みたいに書くとか。uvx は uv と無関係にユーザーグローバルのキャッシュディレクトリにキャッシュすることに注意

## Amazon Q の VSCode 拡張がよく死ぬ

と AWS の人も言ってた。

### 対策 1: コンテキストの削除

chat 窓で
`/clear` で消えるはず。

そこにたどり着く前に固まることも多いので、その場合は
`~/.aws/amazonq/` の下の
`cache/`
と
`history/`
を手動で消す

### 対策 2: mcp 止める

UI はあるのだが
そこにたどり着く前に固まることも多いので、その場合は
`~/.aws/amazonq/mcp.json` を編集する。

見ればわかると思うけど、 `"disable": true` で。

たぶん VSCode の MCP 管理と別口になってるのがよくないんじゃないかと思う。

あと [awslabs.core-mcp-server](https://github.com/awslabs/mcp/tree/main/src/core-mcp-server) (Core MCP Server) がよく死ぬ。
でもこれだけは入れとけ、っと感じなのでどうしたらいいのやら。

### 対策 3:あきらめて q cli を使う

`q login && q chat`
こっちはわりと死なない感じ。
