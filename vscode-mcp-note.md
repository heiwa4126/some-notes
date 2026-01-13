# VSCode で MCP を使うときのメモ

## VS Code 拡張の SecretStorage

VSCode で mcp.json に以下のように書いたとき、
プロンプトが表示され PAT を入力しますと、その値が VSCode を再起動した後でも保存されます。

PAT はどこに保存されるのでしょう?

```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${input:github_mcp_pat}"
      }
    }
  },
  "inputs": [
    {
      "type": "promptString",
      "id": "github_mcp_pat",
      "description": "GitHub Personal Access Token",
      "password": true
    }
  ]
}
```

- [Where are the VS Code extension secrets stored exactly? · microsoft/vscode-discussions · Discussion #748](https://github.com/microsoft/vscode-discussions/discussions/748)
- [VS Code API | Visual Studio Code Extension API](https://code.visualstudio.com/api/references/vscode-api#SecretStorage)

SecretStorage の実体はローカルの SQLite ファイルらしい.

正確には OS のネイティブな資格情報管理システム(Windows の Credential Manager や macOS の Keychain、 libsecret 経由で gnome-keyring/kwallet など)がない場合は
SQLite にフォールバックするらしい。
