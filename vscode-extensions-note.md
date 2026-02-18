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
