# GitHub Dependabot メモ

Code security and analysis のところに設定項目がいろいろあるけど、
よくわからん。

## チュートリアル

[GitHub リポジトリで Dependabot セキュリティ アップデートを構成する - Training | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/modules/configure-dependabot-security-updates-on-github-repo/)

## .github/dependabot.yml のテンプレート

```yaml
version: 2
updates:
  - package-ecosystem: 'npm' # See documentation for possible values
    directory: '/' # Location of package manifests
    schedule:
      interval: 'monthly'
    groups:
      all-dependencies:
        patterns:
          - '*'
```

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

## dependabot で uv の困ったエラー

こんなやつ

```console
2025-11-11T08:15:46.5500758Z Dependabot encountered '1' error(s) during execution, please check the logs for more details.
2025-11-11T08:15:46.5501654Z +-------------------------------------------------------------------------------------------+
2025-11-11T08:15:46.5502494Z |                               Dependencies failed to update                               |
2025-11-11T08:15:46.5503235Z +------------+-------------------------------------+----------------------------------------+
2025-11-11T08:15:46.5504232Z | Dependency | Error Type                          | Error Details                          |
2025-11-11T08:15:46.5505445Z +------------+-------------------------------------+----------------------------------------+
2025-11-11T08:15:46.5506375Z | uv-build   | dependency_file_content_not_changed | {                                      |
2025-11-11T08:15:46.5507183Z |            |                                     |   "message": "Content did not change!" |
2025-11-11T08:15:46.5507826Z |            |                                     | }                                      |
2025-11-11T08:15:46.5508373Z +------------+-------------------------------------+----------------------------------------+
2025-11-11T08:15:46.6840426Z Failure running container 7438124e092f7c076da986d5f317be30467e4e472b2952c1dd961a4ee3cf22ce: Error: Command failed with exit code 1: /bin/sh -c $DEPENDABOT_HOME/dependabot-updater/bin/run update_files
2025-11-11T08:15:47.1175662Z Cleaned up container 7438124e092f7c076da986d5f317be30467e4e472b2952c1dd961a4ee3cf22ce
2025-11-11T08:15:47.1289277Z   proxy | 2025/11/11 08:15:47 24/47 calls cached (51%)
2025-11-11T08:15:47.1301891Z   proxy | 2025/11/11 08:15:47 Posting metrics to remote API endpoint
2025-11-11T08:15:47.9026799Z ##[error]Dependabot encountered an error performing the update
```

Dependabot は「更新が必要だと判断したが、ファイルが変わらない」場合に失敗扱いにしてしまう。

issues はこのへん。問題は認識されているけど修正されていないらしい。

- [Error updating build-system dependencies with uv · Issue #12124 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/12124)
- [uv errors the Dependabot job when attempted version updates are incompatible · Issue #12087 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/12087)
- [Dependabot not updating python packages via \`uv\` · Issue #13014 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/13014)

## Dependabot が生成したモジュール更新の PR を cli で close する

```sh
gh pr list
# または
gh pr list --author "dependabot[bot]" --state open
# あとは1個づつ
gh pr close <PR番号> --comment "手元で pnpm up により更新済みのため、この Dependabot PR は不要になりました。"
```

## GitHub の UI で Dependabot の open な PR があるレポジトリを検索する方法

GitHub の検索バーで
`owner:@me is:pr is:open author:app/dependabot`

- "セキュリティアップデートだけ" なら `label:security` を
- "アーカイブされたレポジトリを除く"なら `archived:false` を
- "マージコンフリクトしている(ので適応できない)" なら `conflicts:true` を

追加すること。`@me`については次の章も参照

ブラウザでブックマークできる。

## 検索で `@me` が使える

- [Search by @me - GitHub Changelog](https://github.blog/changelog/2020-01-20-search-by-me/)
- [ユーザ名によるクエリ](https://docs.github.com/ja/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax#queries-with-usernames)

> 検索クエリに user、actor、assignee のようなユーザー名を必要とする修飾子が含まれている場合、有効なユーザー名を使って特定の個人を指定し、@me を使って現在のユーザーを指定し、@copilot を使って Copilot を指定できます。

## 手動でパッケージをアップデートしたので このレポジトリの Dependabot の PR をまとめて close したい

UI はない。gh を使う。

```sh
gh pr list \
  --author app/dependabot \
  --state open \
  --json number \
  --jq '.[].number' \
| xargs -n1 gh pr close
```

※
実行する前に
`gh pr list`
ぐらいはしましょう。

## 自分の repositories を全部スキャンして、オープンな Dependabot の PR をリストするスクリプト

まず

```sh
# 自分の repositories を全部スキャンして、
# オープンな Dependabot の PR をリストするスクリプト
gh search prs \
  --owner @me \
  --state open \
  --author app/dependabot \
  --json repository,number,title,url,updatedAt,labels
```

で、これに加えて「コンフリクトがないPR(mergeable)」という条件が欲しいところ。しかし
`--json`
オプションには `mergeable` がないので

- 検索後に `gh pr view` で mergeable を確認
- または GraphQL API で

のどちらか。まず

```sh
gh api graphql -f query='
  query {
    search(query: "is:pr is:open author:app/dependabot user:@me", type: ISSUE, first: 20) {
      nodes {
        ... on PullRequest {
          repository { nameWithOwner }
          number
          title
          url
          updatedAt
          labels(first: 10) { nodes { name } }
          mergeable
        }
      }
    }
  }
'
```

`first: nn` のとこはデバッグ用。最大100

ややこしいので
[heiwa4126/depbot-pr-tools: (作業用) 自分の GitHub repositories を全部スキャンして、Dependabot の PR を JSON 形式でリストするスクリプト](https://github.com/heiwa4126/depbot-pr-tools)
にした。これ参照

## dependabot.yml の updates[].directory はリストが書けません

複数ディレクトリだったら `directories:` を使いましょう。ワイルドカードも使える

- [How to add multiple directories in dependabot.yml config file? · Issue #2824 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/2824)
- [Defining multiple locations for manifest files](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/manage-your-dependency-security/controlling-dependencies-updated#defining-multiple-locations-for-manifest-files)
