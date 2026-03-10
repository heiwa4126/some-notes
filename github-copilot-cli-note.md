# GitHub Copilot CLI のメモ

[GitHub Copilot CLI - GitHub Docs](https://docs.github.com/copilot/how-tos/copilot-cli)

## 認証認可

[Authenticating GitHub Copilot CLI - GitHub Docs](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli)

1. 環境変数（最優先）
   - COPILOT_GITHUB_TOKEN (最優先)
   - GH_TOKEN
   - GITHUB_TOKEN
2. `copilot -i /login`
3. `gh auth login` のデフォルトアカウント

Fine-grained PAT (Classicは不可) で
スコープは
GitHub Copilot → Copilot requests: Read and write
があればいい。
