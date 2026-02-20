# VSCode拡張を書いてみるメモ

`yo code` で TypeScript でやってみるよ

## 公式チュートリアルやってみる

[Your First Extension | Visual Studio Code Extension API](https://code.visualstudio.com/api/get-started/your-first-extension)

メモ:

- F5
- Ctrl+Shift+P hello
- `Developer: Reload Window`
- ```typescript
  const now = new Date();
  const msg = `Hello VS Code. Current time is ${now.toLocaleTimeString()}`;
  // vscode.window.showInformationMessage(msg);
  vscode.window.showWarningMessage(msg);
  ```

つづき
[Extension Anatomy | Visual Studio Code Extension API](https://code.visualstudio.com/api/get-started/extension-anatomy)

"Extension Manifest" として package.json に
Contribution Points など
VSCode拡張の設定を紛れ込ませるしくみ。

- [Extension Manifest | Visual Studio Code Extension API](https://code.visualstudio.com/api/references/extension-manifest)
- [Contribution Points | Visual Studio Code Extension API](https://code.visualstudio.com/api/references/contribution-points)

- VS Code 1.74.0 以降は "onCommand:..." の記述が不要
- contributes.commands でコマンド登録すれば activationEvents を空配列にしても問題なしば

## VSCode拡張の e2eテストを書きたいです。Playwrightのようなものはありますか?

1. @vscode/test-cli + @vscode/test-electron (公式・推奨)
2. vscode-extension-tester (RedHat製、Playwrightに近い)

## 配布

メジャーなのは3パターン

1. VSIX 配布
2. Open VSX Registry に公開
3. VS Code Marketplace に公開

## 命名

VSCode で 現在エディタで開いているファイルが markdown の場合

- ファイルを保存
- foo <そのmdファイル> を実行。fooはmdファイルを成型する
  - foo はパスにあるものを使用する。なければ警告だして終了
- ファイルをリロード

という VSCode拡張を作りたい。

パッケージ名、リポジトリ名、VSCode拡張のIDはどう名付けるのが一般的? 提案して。  
パッケージ名は `@username/...` にしたいとする。

### 命名提案

VSCode拡張の命名規則に沿って提案します。

ツールの役割は「fooでMarkdownをフォーマットする」なので、それを軸に考えます。

| 項目                        | 提案                            | 備考                                |
| --------------------------- | ------------------------------- | ----------------------------------- |
| **パッケージ名**            | `@username/vscode-foo-markdown` | npm scoped package の慣例           |
| **リポジトリ名**            | `vscode-foo-markdown`           | パッケージ名から scope を除いたもの |
| **拡張ID (publisher.name)** | `username.foo-markdown`         | VSCode Marketplace の形式           |

#### 命名の考え方

**パッケージ名 (`@username/vscode-foo-markdown`)**

- VSCode拡張のnpmパッケージは `vscode-` プレフィックスが慣例(例: `vscode-eslint`, `vscode-prettier`)
- `foo` をツール名として前に出す

**リポジトリ名 (`vscode-foo-markdown`)**

- GitHubではscopeなしでパッケージ名と揃えるのが一般的

**拡張ID (`username.foo-markdown`)**

- `{publisher}.{name}` の形式はVSCode Marketplaceの必須形式
- `package.json` の `publisher` と `name` フィールドに対応
  ```json
  {
    "name": "foo-markdown",
    "publisher": "username",
    "displayName": "foo Markdown Formatter"
  }
  ```
- `vscode-` プレフィックスは拡張IDの `name` 部分には **つけないことが多い**(`publisher` で文脈が明確なため)

さらに `package.json` の `contributes.commands` の提案です。

```json
"contributes": {
  "commands": [
    {
      "command": "foo-markdown.format",
      "title": "Format with foo",
      "category": "foo Markdown"
    }
  ]
}
```

**`command`**

- `{拡張name}.{動詞}` の形式が慣例
- `format` はシンプルで意図が明確

**`title`**

- コマンドパレット(`Ctrl+Shift+P`)に表示される文字列
- `"Format with foo"` のように動詞から始めるのが慣例

**`category`**

- コマンドパレットでは `foo Markdown: Format with foo` と表示される
- カテゴリを設定しておくと複数コマンドに増えたとき見やすくなる

将来コマンドが増えた場合のイメージ:

```json
"commands": [
  { "command": "foo-markdown.format",        "title": "Format with foo",              "category": "foo Markdown" },
  { "command": "foo-markdown.formatOnSave",  "title": "Toggle Format on Save",        "category": "foo Markdown" }
]
```

## README.md は 拡張機能のREADME

なので開発関係は別ファイルにするべき。

例) `DEVELOPMENT.md`

あと README中にはテンプレートが入れられるみたい。
