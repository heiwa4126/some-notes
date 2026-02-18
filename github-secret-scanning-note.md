# GitHub Secret Protection の secret scanning のメモ

## GitHub の secret scanning と Secret Protection は同じもの?

もとは repo setting では

- Settings
  - Code security and analysis
    - Secret scanning
    - Push protection
    - Code scanning
    - Dependency review

こんな感じだった。

2025-04 頃(2025-03-04発表)から、Secret scanningのUIが「Secret Protection」配下に統合された。
[Introducing GitHub Secret Protection and GitHub Code Security - GitHub Changelog](https://github.blog/changelog/2025-03-04-introducing-github-secret-protection-and-github-code-security/)
​

2025年4月1日からGitHub Advanced Security(GHAS)を

- GitHub Secret Protection
- GitHub Code Security

の2製品に分割

現在(2026-02)の構成は:

- [GitHub Secret Protection](https://github.com/security/advanced-security/secret-protection) 製品/SKU
  - [Secret scanning](https://docs.github.com/en/code-security/secret-scanning/introduction/about-secret-scanning) コミット後の検出
    - [Secret scanning alerts](https://docs.github.com/en/code-security/secret-scanning/managing-alerts-from-secret-scanning/about-alerts)
    - [AI-detected passwords(Copilot secret scanning)](https://docs.github.com/en/code-security/secret-scanning/copilot-secret-scanning/about-copilot-secret-scanning) 正規表現では検出できない非構造化シークレットをAIで検出
    - [Validity checks](https://docs.github.com/en/code-security/secret-scanning/enabling-secret-scanning-features/enabling-validity-checks-for-your-repository) 検出済みシークレットがまだ有効かどうか確認
    - [Custom patterns](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/custom-patterns/defining-custom-patterns-for-secret-scanning) 独自パターンの定義
    - [Non-provider patterns](https://docs.github.com/en/code-security/secret-scanning/enabling-secret-scanning-features/enabling-secret-scanning-for-non-provider-patterns) 接続文字列・秘密鍵など汎用パターンの検出
  - [Push protection](https://docs.github.com/en/code-security/secret-scanning/introduction/about-push-protection) コミット前のブロック
    - [Delegated bypass](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/delegated-bypass-for-push-protection/about-delegated-bypass-for-push-protection) バイパスリクエストの承認フロー
  - [Delegated alert dismissal](https://docs.github.com/en/code-security/secret-scanning/using-advanced-secret-scanning-and-push-protection-features/enabling-delegated-alert-dismissal-for-secret-scanning) アラート却下の承認フロー
  - [Security campaigns](https://docs.github.com/en/code-security/security-overview/about-security-campaigns) シークレット修正をチームで計画・推進
  - [Security overview](https://docs.github.com/en/code-security/security-overview/about-security-overview) 組織全体のリスク可視化・ガバナンス

※ Security campaignsと Security overview は
GitHub Code Securityの機能でもある

## secret scanning と push protection

設定は

repo setting \> Advanced Security の一番下の方(2026-02現在)

公開リポジトリではデフォルトで有効。設定で無効にできる。

[About secret scanning - GitHub Docs](https://docs.github.com/en/code-security/concepts/secret-security/about-secret-scanning)

> シークレットスキャンは以下のリポジトリタイプで利用可能です:
>
> - GitHub.com の公開リポジトリ
> - GitHub Secret Protectionを有効にしたGitHub Team上の組織所有リポジトリ

[About push protection - GitHub Docs](https://docs.github.com/en/code-security/concepts/secret-security/about-push-protection)

> プッシュ保護は以下のリポジトリタイプに対して利用可能です:
>
> - GitHub.com の公開リポジトリ
> - GitHub Secret Protectionを有効にしたGitHub Team上の組織所有リポジトリ

Push protection だけ独立して無効化できる設定になってるのは、
Secret Protection の機能のうち、これだけが「push時に事前ブロック」だから。
他は「push後に事後検出」。

古いプロジェクトだと Push protection が有効になってるとCIが死ぬものがあるから。
新規プロジェクトでは Push protection を無効にする理由はない。

secret scanning は全ブランチ対応

> Secret scanning scans your entire Git history on all branches present in your GitHub repository for secrets, even if the repository is archived. GitHub will also periodically run a full Git history scan for new secret types in existing content in public repositories where secret scanning is enabled when new supported secret types are added.

> (訳) シークレットスキャンは、アーカイブされていても、GitHubリポジトリ内のすべてのブランチにあるGit履歴全体をシークレットを探してスキャンします。GitHubはまた、公開リポジトリの既存コンテンツの新しい秘密タイプを定期的にGitヒストリースキャンでフルGit履歴スキャンを実施し、新たにサポートされるシークレットタイプが追加された際に有効化されます。

Dependabot や CodeQL と違って有難いですね。

Secret Protection で「スキャンするもの」はすべて
ブランチ戦略に依存せず、push されたコードと履歴全体を対象にする設計
らしい。

ちょっと例外っぽい
Push protection は名前通り
「全ブランチ対応、ただし push したもの」だけ対象
