# GitHub Dependabot メモ

Code security and analysis のところに設定項目がいろいろあるけど、
よくわからん。

## チュートリアル

[GitHub リポジトリで Dependabot セキュリティ アップデートを構成する - Training | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/modules/configure-dependabot-security-updates-on-github-repo/)

## .github/dependabot.yml のテンプレート

```yaml
version: 2
updates:
  - package-ecosystem: "npm" # See documentation for possible values
    directory: "/" # Location of package manifests
    schedule:
      interval: "monthly"
    open-pull-requests-limit: 1
```

`open-pull-requests-limit` を 1 にしておくと、複数の bump を 1 個にしてくれるので手抜きができるらしい。
その反面([ここ参照](https://docs.github.com/ja/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#open-pull-requests-limit)).

参考: [dependabot.yml ファイルの構成オプション - GitHub Docs](https://docs.github.com/ja/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)

## Dependency graph

これを enable にすると、
リポジトリが依存している全てのパッケージを一覧表示し、
それらのバージョン情報も確認できます。

確認は Insites の Dependency graph で。

## Dependabot 以下の設定

GitHub の「Code security and analysis」にある以下の項目について、それぞれの機能と有効にした場合に起きることを説明します。

"Dependabot on Actions runners" と "Dependabot on self-hosted runners" 以外の機能は、一般的に無条件に有効にすることをお勧めします。
これらの機能を有効にすることで、セキュリティの向上と依存関係の管理が自動化され、プロジェクトの保守性が大きく向上します。

### Dependabot Alerts

**概要**:
Dependabot は、リポジトリの依存関係に脆弱性が見つかったときにアラートを発行します。

**有効化の効果**:

- 依存関係にセキュリティ脆弱性が検出された場合、自動的に通知を受け取ります。
- 脆弱性の詳細、影響を受けるバージョン、修正方法が提供されます。
- リポジトリの「Security」タブで、発行されたアラートを確認できます。

### Dependabot Security Updates

**概要**:
Dependabot は、依存関係に脆弱性が見つかった場合に自動的に修正プルリクエストを作成します。

**有効化の効果**:

- 脆弱性を含む依存関係を最新の安全なバージョンに自動更新するためのプルリクエストが作成されます。
- プルリクエストには、アップデートの詳細や変更の影響が記載されます。
- プルリクエストをレビューしてマージすることで、脆弱性を迅速に修正できます。

### Grouped Security Updates

**概要**:
複数のセキュリティアップデートを 1 つのプルリクエストにまとめる機能です。

**有効化の効果**:

- Dependabot が作成する複数のセキュリティアップデートを 1 つのプルリクエストにまとめて管理できます。
- プルリクエストの数が減り、管理が簡単になります。
- 依存関係の更新作業が一度に行われるため、作業効率が向上します。

### Dependabot Version Updates

**概要**:
Dependabot は、依存関係の新しいバージョンがリリースされたときに自動的にプルリクエストを作成します。

**有効化の効果**:

- 新しいバージョンがリリースされた依存関係を最新に保つためのプルリクエストが自動的に作成されます。
- プルリクエストには、変更点や新機能の詳細が含まれます。
- 最新の機能やバグ修正を素早く取り入れることができます。

### Dependabot on Actions Runners

**概要**:
GitHub Actions のランナー上で Dependabot を実行します。

**有効化の効果**:

- Dependabot が GitHub Actions ランナー上で依存関係の更新やセキュリティチェックを行います。
- CI/CD パイプラインの一部として Dependabot を統合し、継続的な依存関係の管理が可能になります。

### Dependabot on Self-Hosted Runners

**概要**:
セルフホストのランナー上で Dependabot を実行します。

**有効化の効果**:

- 自分たちのインフラ上で運用するセルフホストのランナーで Dependabot を実行します。
- インターネット接続が制限された環境や特定のセキュリティ要件を満たす必要がある場合に有用です。
- ローカルの環境に適応した依存関係管理が可能になります。

### まとめ

これらの機能を有効にすることで、依存関係のセキュリティと最新状態の維持が自動化され、プロジェクトの保守性と安全性が向上します。Dependabot のアラートやアップデート機能を活用することで、脆弱性への迅速な対応や依存関係の最新バージョンへの更新が容易になります。

## GitHub の Dependabot アラートはどこに送られる?

GitHub の Dependabot アラートは、リポジトリのセキュリティ設定に従って、リポジトリの管理者やメンテナに通知されます。
具体的には、以下の場所や方法で通知が行われます:

1. **GitHub インターフェース内での通知**: リポジトリの「Security」タブにある「Dependabot alerts」セクションで確認できます。

2. **メール通知**: リポジトリのセキュリティアラートを受け取る設定をしているユーザーに、アラートがメールで送信されます。

3. **GitHub Notifications**: GitHub の通知システムを通じて、ウェブインターフェース上の通知センターや、設定されている場合は、ブラウザやモバイルアプリのプッシュ通知で通知されます。

4. **Webhook**: リポジトリに設定されている場合、Dependabot アラートは指定された Webhook エンドポイントに送信することもできます。

これらの設定は、リポジトリのセキュリティや通知設定によってカスタマイズ可能です。設定を確認したり変更したりするには、リポジトリの「Settings」タブにアクセスし、「Security & analysis」セクションを確認してください。

無設定の場合でも、GitHub はデフォルトでリポジトリの管理者やメンテナに対して Dependabot アラートを通知するようになっています。

## 自分のすべてのレポジトリに Depandabot を設定する

1. 右上にあるプロファイルの写真を選択します。
2. `settings` を選択し、左側のメニューの `Code security and analysis`を選択。(ここまでは <https://github.com/settings/security_analysis> で直リン)
3. 有効にする機能の右にある `Enable all` (すべて有効にする) を選択します。
   これらの設定をすべての新しいリポジトリに適用する場合は、`Automatically enable for new repositories`(新しいリポジトリに対して自動的に有効にする) チェック ボックスをオンにします。
   最低でも `Dependabot alerts` だけは `Enable all` にするべき。

組織の所有者やエンタープライズでも組織内のすべてのリポジトリに対して依存関係グラフと Dependabot アラートを一度に有効にすることができるので、
設定しといてほしいです。
