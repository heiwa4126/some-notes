# GitHub Dependabot メモ

Code security and analysis のところに設定項目がいろいろあるけど、よくわからん。

## GitHub Dependabot は3種類ある

このへん [GitHub CI/CD実践ガイド | 技術評論社](https://gihyo.jp/book/2024/978-4-297-14173-8) からの引用多し

- Dependabot version updates: 最新バージョンへの自動アップデート
- Dependabot security updates: 脆弱性を含むバージョンの自動アップデート
- Dependabot alerts: 脆弱性が含まれるバージョンのアラート通知

`.github/dependabot.yml` に書くのは

- Dependabot version updates
- Dependabot security updates

の共用設定

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

確認は Insight の Dependency graph で。

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

で、これに加えて「コンフリクトがない PR(mergeable)」という条件が欲しいところ。しかし
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

`first: nn` のとこはデバッグ用。最大 100

ややこしいので
[heiwa4126/depbot-pr-tools: (作業用) 自分の GitHub repositories を全部スキャンして、Dependabot の PR を JSON 形式でリストするスクリプト](https://github.com/heiwa4126/depbot-pr-tools)
にした。これ参照

## dependabot.yml の updates[].directory はリストが書けません

複数ディレクトリだったら `directories:` を使いましょう。ワイルドカードも使える

- [How to add multiple directories in dependabot.yml config file? · Issue #2824 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/2824)
- [Defining multiple locations for manifest files](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/manage-your-dependency-security/controlling-dependencies-updated#defining-multiple-locations-for-manifest-files)

## Dependency Graph を有効にする話

Dependency Graph が enable になっていないと
Dependabot alerts と Dependabot security updates が動かない。

「GitHub で private レポジトリの Dependency Graph はデフォルトでは有効ではない」というのは昔の話みたいです(実際に試した)。

- 2021 年頃までは「public はデフォルト on / private は手動で有効化」という明確な線引きが公式に書かれていた。 [github](https://github.blog/enterprise-software/secure-software-development/secure-at-every-step-how-githubs-dependency-graph-is-generated/)
- その後のドキュメントでは、可視性に依存した説明ではなく「どの可視性でもオーナーが一括で on/off 管理する」形に変わっており、private だけ特別にデフォルト off というニュアンスは薄れています。 [docs.github](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/configuring-the-dependency-graph)
- 2025 年には、**逆に** public に対しても「無効化できる」「新規 public はデフォルト off にする」方向の変更が入り、現在は activity ベースや設定ベースで on/off が決まる設計になっています。 [github](https://github.blog/changelog/2025-05-15-users-can-now-disable-dependency-graph-for-public-repositories/)

まあそういうやっかいな状況。

とりあえず
自分の全リポジトリをスキャンして、

- アーカイブになっていないリポジトリのなかで
- Dependency Graph が disable になっているもの

を列挙する CLI を書きました。
[heiwa4126/depbot-pr-tools: test7.sh](https://github.com/heiwa4126/depbot-pr-tools/blob/main/test7.sh)

### そもそも 個人アカウントだったら一括設定がある

https://github.com/settings/security_analysis に

- Dependency graph
- Dependabot alerts
- Dependabot security updates

の 3 つとも

- 新しく作るレポジトリでは自動で有効
- 全レポジトリで有効
- 全レポジトリで無効

がある

## GitHub の 「サプライチェーンセキュリティ機能」

[About supply chain security - GitHub Docs](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-supply-chain-security)

- Dependency graph
- Dependency review
- Dependabot alerts
- Dependabot updates
  - Dependabot security updates
  - Dependabot version updates
- Immutable releases
- Artifact attestations

### Dependency graph

リポジトリ内の依存関係(直接・間接)を解析・可視化する基盤機能。  
他の多くのサプライチェーン機能の前提となる。

### Dependency review

Pull Request で変更される依存関係をレビューし、  
**新たに追加される脆弱性やライセンス問題**を検出する。

### Dependabot alerts

Dependency graph をもとに、  
**既知の脆弱性(GitHub Advisory Database)を含む依存関係**を検出し通知する。

### Dependabot updates

依存関係を自動更新する Pull Request を作成する機能。

- **Dependabot security updates**  
  脆弱性を修正するための更新 PR を自動作成する。
- **Dependabot version updates**  
  最新バージョンへの追従を目的とした更新 PR を作成する。

### Immutable releases

リリース成果物を **後から変更できない(immutable)状態**にし、  
公開後の差し替えや改ざんを防ぐ。

### Artifact attestations

ビルド成果物に対して  
「誰が」「どのような環境・手順で」作成したかを証明するメタデータ(attestation)を付与し、  
サプライチェーンの完全性を検証可能にする。

### 機能間の依存関係まとめ表

| 機能                        | 主な役割                     | 依存している機能                      |
| --------------------------- | ---------------------------- | ------------------------------------- |
| Dependency graph            | 依存関係の解析・可視化       | なし(基盤)                            |
| Dependency review           | PR時の依存関係変更チェック   | Dependency graph                      |
| Dependabot alerts           | 脆弱性の検出と通知           | Dependency graph                      |
| Dependabot security updates | 脆弱性修正用PRの自動作成     | Dependency graph<br>Dependabot alerts |
| Dependabot version updates  | 新バージョン追従のPR自動作成 | Dependency graph                      |
| Immutable releases          | リリース改ざん防止           | なし(独立)                            |
| Artifact attestations       | 成果物の真正性・来歴の証明   | CI/CD(ワークフロー)※                  |

※ Artifact attestations は Dependency graph には直接依存せず、  
GitHub Actions などの CI/CD 実行結果を前提とします。

### ひとことで全体像

- **Dependency graph** が土台
- **Dependency review / Dependabot 系** はその上に乗る検知・自動化レイヤ
- **Immutable releases / Artifact attestations** は  
  「公開後・配布後の安全性」を担保するレイヤ

という三層構造で考えると分かりやすい

## Dependency graph の仕組み(概要)

[Dependency graph の全体像・基本概念](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-the-dependency-graph)

### どのように依存関係を発見するか(静的解析 / submission)

[Dependency graph supported package ecosystems - GitHub Docs](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

- 対応言語・対応エコシステム一覧
- どのマニフェスト/ロックファイルを解析するか
- 静的解析と dependency submission の説明

#### ロックファイルと精度に関する説明

特にこの部分が重要。同ページ内セクション:

- 「Building the dependency graph」
- 「Recommended formats」

### dependency submission(静的解析で足りない場合)

[Using the dependency submission API](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/using-the-dependency-submission-api) - GitHub Actions から依存関係を送信する仕組み

[Configuring automatic dependency submission for your repository](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-automatic-dependency-submission-for-your-repository)

### purl(Package URL) 対応(最近の仕様変更)

[Dependency graph supports all purl-identified package ecosystems - GitHub Changelog](https://github.blog/changelog/2025-04-03-dependency-graph-supports-all-purl-identified-package-ecosystems/)

## Dependency graph が生成される実例

前提:

- リポジトリ内に **package.json** がある
- リポジトリ内に **pnpm-lock.yaml** がある
- **dependabot.yml は無い**(つまり Dependabot updates の自動 PR 設定はしていない)
- リポジトリ設定で **Dependency graph が有効**

このとき、Dependency graph 生成は **Dependabot updates の設定とは無関係**に走ります。  
Dependency graph 自体は「**リポジトリ内のマニフェスト/ロックファイルの静的解析**」で構築されるからです。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

### 1) GitHub が実際にやること(静的解析の流れ)

#### ステップA:リポジトリをスキャンする

Dependency graph が有効だと、GitHub はリポジトリをスキャンして  
対応エコシステムの **manifest files(マニフェスト)** を探します。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

pnpm の場合、対応ファイルは公式に明示されています。

- **package.json**
- **pnpm-lock.yaml(推奨=Recommended formats)** [2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

> つまり「pnpm-lock.yaml がある」時点で、GitHub は dependency graph を “より正確に” 作れる条件を満たします。  
> (ロックファイルが推奨フォーマットに分類されているため)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

#### ステップB:見つけたファイルをパースして依存関係表現を作る

GitHub は見つけたマニフェスト/ロックファイルを **parse(解析)** して、  
各パッケージの **名前とバージョン**などを表現に落とし込みます。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)  
このやり方は GitHub Docs 上で **static analysis(静的解析)** と呼ばれています。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

#### ステップC:dependency graph として表示できる形にまとめる

Dependency graph は、リポジトリ内の manifest/lock files(静的解析結果)と、  
(あれば)dependency submission API で投稿された依存関係を統合したものです。[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

あなたのケースは **submission は使っていない**想定なので、
**package.json + pnpm-lock.yaml の静的解析結果だけ**で graph が生成されます。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

### 2) pnpm の場合、package.json と pnpm-lock.yaml はどう効く?

#### package.json から分かること(主に “直接依存”)

package.json は、あなたが明示的に書いた依存(dependencies / devDependencies 等)を示します。  
GitHub は「マニフェスト」を解析して依存を表現にします。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

例(イメージ):

```json
{
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

ここから分かるのは「express を使っている」という事実(ただし `^4.18.0` のような範囲指定)。  
**範囲指定だけだと “実際にインストールされた正確なバージョン” は確定しません。**

### pnpm-lock.yaml から分かること(“実バージョン+間接依存”)

pnpm-lock.yaml は、**実際に解決された依存関係(バージョン)** を固定します。

GitHub Docs は「推奨フォーマットは、直接・間接の両方のバージョンを明示し、より正確な dependency graph になる」旨を述べています。 [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems), [docs.github.com](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

したがって pnpm-lock.yaml があると、graph はだいたいこうなります:

- **直接依存**:package.json に書いた express など
- **間接依存(transitive)**:express が内部で引く dependencies(例:accepts, mime-types...など)
- **それぞれの正確なバージョン**:lock に固定されている版

> これが「package.json だけ」よりも graph が正確になる理由です。 [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

### 3) dependabot.yml が無い場合に「起きないこと/起きること」

#### 起きないこと(=Dependabot updates は動かない)

dependabot.yml が無いと、通常 **Dependabot version updates / security updates の “更新PR作成”** は構成されていません。  
(つまり PR が勝手に作られることは基本ありません)

※ただし、ここは「graph の生成」の話とは別で、あなたの質問の主眼ではないので深入りしません。

#### 起きること(=Dependency graph は作られる)

dependabot.yml が無くても、Dependency graph は  
**manifest/lock files をスキャンして作る**ものなので、作られます。 [docs.github.com](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems), [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

### 4) “最終的に GitHub 画面ではどう見えるか” のイメージ

Dependency graph の説明として、GitHub Docs は「依存関係の一覧、どのマニフェストが含めたか、既知の脆弱性有無」などが見えると言っています。 [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

pnpm の場合は典型的に:

- **Dependencies タブ**に
  - `express@4.18.2` のように **確定バージョン**が表示(lock があるため)
  - さらにその下に **transitive 依存**もぶら下がる(lock による精度向上) [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems), [docs.github.com](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)
- 各依存には
  - どのファイル(package.json / pnpm-lock.yaml)が根拠か、などが出る [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

### 5) よく混乱するポイント(ここが「分かりにくい」原因になりがち)

#### 「Dependency graph」≠「Dependabot updates」

- Dependency graph:**依存関係を“把握”する機能**(静的解析で構築) [docs.github.com](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems), [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)
- Dependabot updates:**更新PRを“作る”機能**(dependabot.yml でスケジュール等を指定)

dependabot.yml が無くても graph ができるのは、この役割分離のせいです。 [docs.github.com](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems), [docs.github.com](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

## submission (dependency submission) とは(超要約)

Dependency graph は通常、リポジトリ内の **マニフェスト/ロックファイルを静的解析**して作られます。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

しかし一部エコシステムでは、**ビルド時に依存関係が確定**するため、静的解析だけだと **完全な依存ツリーを作れない**ことがあります。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

その不足分を補うために、GitHub Actions などで依存ツリーを生成し、**dependency submission API に送って** Dependency graph に反映させるのが submission です。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[2](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/dependency-graph-supported-package-ecosystems)

**submission を使うと**

- 静的解析では取り切れない **ビルド時の(より完全な)依存関係**を Dependency graph に載せられます。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)
- submission で追加した依存関係も、結果として **Dependabot alerts / Dependabot updates に流れ込む**(=検知・更新の対象にできる)と GitHub Docs に明記されています。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)
- 「Supported package ecosystems」の表にないエコシステムでも、dependency submission API を使って **任意の依存関係を追加できる**(=拡張手段になる)と説明されています。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

### 「自動」と「手動」の2パターン

- GitHub Docs は、ビルド時依存に対して GitHub Actions を使うアプローチとして **automatic と manual** の 2 つがある、と述べています。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)
  - **Automatic dependency submission**:リポジトリ設定から「自動投稿」を有効化できるエコシステムがある。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)
  - **Manual dependency submission**:ワークフローで依存ツリー生成→API 投稿、を自分で組む(外部 Action を使うことが多い)。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)

### purl と submission(最近の拡張ポイント)

- 2025-04-03 の GitHub Changelog により、dependency submission で **purl(Package URL)識別子**を含むグラフを投稿すると、より広いエコシステムを扱える(= purl で識別可能なエコシステムをサポート)方向に拡張されています。[3](https://github.blog/changelog/2025-04-03-dependency-graph-supports-all-purl-identified-package-ecosystems/)
- つまり **「静的解析で対応していない」=即ムリ**ではなく、submission(特に purl)で取り込める余地があります。[1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependency-graph-supported-package-ecosystems)[3](https://github.blog/changelog/2025-04-03-dependency-graph-supports-all-purl-identified-package-ecosystems/)

## Dependency graph が更新されるタイミング

整理すると、**Dependency graph は「3 つの経路」×「特定のイベント」**で更新されます。公式ドキュメントに書かれている内容を、実務的な視点で噛み砕いて説明します。

### 1 リポジトリへの push(最も基本)

- **対応エコシステムの manifest / lock file** が
  - 追加された
  - 変更された
- その変更を含む **commit が push された**

このとき GitHub は **自動的に再スキャン**し、Dependency graph を更新します。

公式より:

> When you push a commit to GitHub that changes or adds a supported manifest or lock file to the default branch, the dependency graph is automatically updated. [1](https://docs.github.com/github/visualizing-repository-data-with-graphs/about-the-dependency-graph)

#### pnpm 例に当てはめると

- `package.json` (manifest) を変更して push
- `pnpm-lock.yaml` (lock file) を更新して push

→ **それぞれの push がトリガー**になり、graph が更新されます。

### 2 Dependency graph を「有効化した直後」

- Dependency graph を **初めて有効化**したとき
- 既にリポジトリ内に存在している
  - `package.json`
  - `pnpm-lock.yaml`
    などを **即座に解析**

公式より:

> When the dependency graph is first enabled, any manifest and lock files for supported ecosystems are parsed immediately. The graph is usually populated within minutes. [2](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/configuring-the-dependency-graph)

**実務的な注意**

- 「有効にしたのに出てこない」場合は、**数分待つ**のが正解
- 大規模 repo では多少遅れることあり [2](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/configuring-the-dependency-graph)

### 3 依存関係が “上流” リポジトリで更新されたとき

あなたが依存している **外部パッケージ側**で

- 新しいリリース
- 脆弱性情報の追加

が行われた場合

Dependency graph 自体は変わらなくても、
**脆弱性情報やメタデータが更新される**ことがあります。

公式より:

> In addition, the graph is updated when anyone pushes a change to the repository of one of your dependencies. [1](https://docs.github.com/github/visualizing-repository-data-with-graphs/about-the-dependency-graph)

📌  
これは「自分が push していないのに、Security タブの表示が変わった」  
という現象の正体です。

### 4 dependency submission(手動 or 自動)

これは **静的解析とは別系統の更新トリガー**です。

#### 4-1 手動 / カスタム submission

- GitHub Actions などが
- **dependency submission API** に snapshot を送信したとき

公式より:

> The dependency graph shows any dependencies you submit using the API in addition to any dependencies that are identified from manifest or lock files. [3](https://docs.github.com/en/rest/dependency-graph/dependency-submission)

→ **API 投稿のたびに graph が更新**されます。

#### 4-2 automatic dependency submission を有効にしている場合

- リポジトリ設定で **automatic dependency submission** を有効化
- GitHub が Actions を使って
  - ビルド時依存を検出
  - 自動で submission API に投稿

公式より:

> When you enable automatic dependency submission for a repository, GitHub automatically identifies the transitive dependencies in the repository and will submit these dependencies to GitHub using the dependency submission API. [4](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-automatic-dependency-submission-for-your-repository)

📌  
この場合:

- **Actions の実行タイミング(push / PR / schedule)**に依存して更新される

### 勘違いポイント: Pull Request 自体では「確定更新」されない

- Dependency graph(確定状態)は **更新されない**
- PR では
  - Dependency review
  - 差分チェック
    に使われるだけ

公式:

> When you create a pull request containing changes to dependencies that targets the default branch, GitHub uses the dependency graph to add dependency reviews to the pull request. [1](https://docs.github.com/github/visualizing-repository-data-with-graphs/about-the-dependency-graph)

✅ **main に merge されて push が発生して初めて更新**

### タイミングまとめ(早見表)

| イベント                              | Dependency graph 更新 |
| ------------------------------------- | --------------------- |
| Dependency graph を初めて有効化       | ✅ すぐ               |
| package.json / pnpm-lock.yaml を push | ✅                    |
| PR 作成(未 merge)                     | ❌(reviewのみ)        |
| PR merge → push                       | ✅                    |
| 依存先パッケージに変更・脆弱性追加    | ✅(メタデータ更新)    |
| dependency submission API に投稿      | ✅                    |
| automatic submission の Actions 実行  | ✅                    |

### pnpm 前提の超短い結論

> **pnpm + pnpm-lock.yaml がある repo では:**

- push が唯一の更新トリガー(submission なしなら)
- Dependabot.yml の有無は **graph 更新とは無関係**
- 「更新されない」と感じたら:
  - default branch への push か?
  - lockfile が対応フォーマットか?
  - graph が有効か?

を疑うのが正解です。

## Dependency graph が更新されたら...

### Dependabot alerts (Dependency alerts)

*Dependency graph の変化*を契機にスキャンしてアラートを出す(= ほぼ直結)[1](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-alerts)

### Dependabot security updates

*Dependabot alert が raise された後*に、修正 PR を作ろうとする(= alerts に依存)[2](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-dependabot-security-updates)

### Dependabot version updates

これは**graph 更新に直結しない**

`.github/dependabot.yml` の **schedule** に従って定期実行される。
そもそも dependabot.yml がないと動きません。[3](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/manage-your-dependency-security/controlling-dependencies-updated)

## ハマりポイント: security updates も 一部の dependabot.yml 設定を読む

GitHub 公式の **Dependabot options reference** には、はっきりこう書かれています。

> **All options marked with a ⚠️ icon also change how Dependabot creates pull requests for security updates, except where target-branch is used.**  
> (⚠️マークが付いたオプションは、target-branch を除き、security updates にも影響する) [1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

つまり:

- **dependabot.yml は version updates 専用ではない**
- **security updates でも、明示的に記載された対象オプションは評価される**

### ✅ security updates で「確実に効く」設定例

#### ignore / allow

- **無視した依存関係は、security updates の PR も作られない**
- allow と ignore が両方マッチした場合は ignore が優先される

公式仕様:

> Dependabot default behavior:
>
> - All dependencies defined in lock files with vulnerable dependencies are updated by security updates.
> - If a dependency is matched by an allow and an ignore statement, then it is ignored. [1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

✅ つまり「除外設定(ignore)が security updates に効く」という話は **正しい**。

#### directory / directories / exclude-paths

- どのマニフェストをスキャン対象にするか/しないか
- **security updates でも “対象外ディレクトリはそもそも見ない”**

`exclude-paths`(2025 年 GA)の説明でも、

> Applies before manifest parsing: Dependabot will not list, parse, or open pull requests for excluded paths. [2](https://github.blog/changelog/2025-08-26-dependabot-can-now-exclude-automatic-pull-requests-for-manifests-in-selected-subdirectories/)

→ **PR 種別(version / security)に関係なく影響**

#### private registries / registries

2024 年の Changelog で明示されています。

> Dependabot security updates now uses private registry configurations specified in the dependabot.yml file as expected. [3](https://github.blog/changelog/2024-03-18-dependabot-security-updates-work-with-private-registries-even-if-target-branch-is-specified/)

→ レジストリ設定も **security updates が読む**

### ❌ 誤解されがちな点:すべての設定が効くわけではない

#### ❌ schedule

- **security updates は schedule を使わない**
- 依存するのは「alert が発生したかどうか」

公式より:

> When Dependabot security updates are enabled, Dependabot will automatically try to open pull requests to resolve every open Dependabot alert that has an available patch. [4](https://graphite.com/guides/introduction-to-github-dependency-graph)

→ 時間や曜日は **一切見ない**

#### ❌ target-branch

- **security updates では非対応**
- docs にも明記された例外

> except where target-branch is used [1](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference)

### まとめ

| dependabot.yml の要素    | security updates に影響 |
| ------------------------ | ----------------------- |
| ignore / allow           | ✅ 効く                 |
| directory / directories  | ✅ 効く                 |
| exclude-paths            | ✅ 効く                 |
| registries (private)     | ✅ 効く                 |
| schedule                 | ❌ 無関係               |
| open-pull-requests-limit | ✅ 効く                 |
| commit-message / labels  | ✅ 効く                 |
| target-branch            | ❌ 効かない             |

## Insights → Dependency graph → Dependabot の "Check for updates" ボタンで実行されるのは何?

Dependabot version updates だけ。

"Check for updates" ボタンの出現条件は:

1. (そもそも) **`dependabot.yml` が設定されている**
   - リポジトリに `.github/dependabot.yml` ファイルが存在し、`version-updates` が有効になっている必要があります

2. **次回の定期実行までに時間がある**
   - Dependabot は設定されたスケジュール(daily、weekly、monthly)で自動実行されます
   - 最後の実行から次回の実行予定まで時間がある場合にボタンが表示されます

3. **Dependabot が実行中でない**
   - 既に更新チェックが実行中の場合は表示されません
   - 実行中は "Last checked: Checking now..." のような表示になります

4. **Dependabot version updates が有効**
   - リポジトリ設定で Dependabot が無効になっていると表示されません

逆にボタンが消える状況は:

- Dependabot が実行中
- 最近(数分~数時間以内)チェックが完了したばかり
- `dependabot.yml` が存在しない、または無効
- 次回の自動実行が間もなく予定されている場合

つまり、「手動で今すぐチェックする必要性がある状況」でのみ表示される設計。

参考:

- [Manually trigger an update for a specific dependency · Issue #2980 · dependabot/dependabot-core](https://github.com/dependabot/dependabot-core/issues/2980)
- UI のスクリーンショットあり - [How to Trigger Dependabot Manually | Medium](https://manumagalhaes.medium.com/tip-how-to-trigger-dependabot-manually-15e50151886b)

## Dependabot からセキュリティアップデートだけほしい場合

Dependabot version updates を disable にする。

あたりまえなんだけど、しばらく気が付かなかった...

## package-ecosystem: github-actions で

レポジトリのルートに `action.yml` があり、 `.github/workflows/*.yml` もあるような場合

```yaml
version: 2
updates:
  - package-ecosystem: github-actions
    directories:
      - / # for /.github/workflows/*.yml
      - ./ # for /action.yml
      - ./another # for /another/action.yml
      - ...
```

みたいに書かないとルートの`/action.yml` を見てくれない。
**設定したら Insights → Dependency graph で確認すること。**

あと dependabot.yml は主に
Dependabot version updates の設定で、
Dependency graph は自動更新(dependabot.yml も少し参考にする)らしいので、
すぐ更新されないかもしれない
というのを忘れないこと。

## Automatic dependency submission

> リポジトリ内のファイルだけでは分からない「ビルド時に解決される依存関係(特に transitive dependencies)」を、
> GitHub Actions を使って自動的に検出し、Dependency graph に送信(登録)する仕組み

通常、Dependency graph は
マニュフェスト(package.json など)と
ロックファイル(package-lock.json など)
を読んで、静的に依存を決定する。

しかし一部のエコシステムでは、

- 依存関係の完全な解決がビルド時にしか分からない
- lockfile が存在しない/不完全
- プラグインや条件分岐で依存が変わる

といった理由で、
リポジトリを見ただけでは「実際に使われる依存関係」を GitHub が把握できない。

Automatic dependency submission を「有効」にすると、GitHub が次のことを行う。

1. GitHub Actions を自動実行
2. ビルドツール(例: Maven/Gradle/NuGet など)を使って実際に依存解決を行う
3. 解決された完全な依存関係ツリー(transitive dependency 含む) を Dependency Submission API 経由で GitHub に送信
4. Dependency graph に反映

### 注意: Automatic dependency submission を「有効」にすると

1. GitHub Actions の実行が発生する - Actions minutes を消費する
2. Dependency graph が前提 - 先に Dependency graph 自体を有効化する必要あり
3. 「自動」だが内部的には API 提出 - 内部的には Dependency Submission API を使っている

### Automatic dependency submission を「有効」にしたほうがいいケース

まず、Java 系(Gradle/Maven), .NET(NuGet)

その他は

- Python(pip) - ロックファイルがないので効き目あり。2025 年 7 月から対応
  [Dependency auto-submission now supports Python - GitHub Changelog](https://github.blog/changelog/2025-07-08-dependency-auto-submission-now-supports-python/)

#### gradle.lockfile

Gradle はオプションでロックファイルを作れるようになった(Gradle 4.8 以降)

ただ

- Dependency graph は gradle.lockfile を参照するが完全性は保証されない。Automatic submission の有効化推奨
- Dependabot は gradle.lockfile 対応. 更新・PR 作成にも対応

### Automatic dependency submission のランナー

右のボタンのプルダウンから

1. Enabled
2. Enabled for labeled runners
3. Disabled

が選べる。2.にすると

self-hosted runner のうち、
dependency-submission という label が付いた runner のみ
Automatic dependency submission を実行する。

- GitHub-hosted runner は使われない
- 社内ネットワーク / private registry / 特殊ビルド環境が使える
- Actions minutes を消費しない (self-hosted のため)

向いているケースは

- 社内 Maven / NuGet / PyPI mirror を使っている
- ビルドに特殊なツール・SDK が必要
- セキュリティ上、GitHub-hosted runner を使えない

など

### Automatic dependency submission における “ビルド” とは何か

[Configuring automatic dependency submission for your repository - GitHub Docs](https://docs.github.com/en/code-security/how-tos/secure-your-supply-chain/secure-your-dependencies/configuring-automatic-dependency-submission-for-your-repository)

> Automatic dependency submission が Actions で実行する「ビルド」とは、
> “成果物を作るための build” **ではなく**、「依存関係を 解決(resolve) するための最小限の実行」です。

- テストは走らない
- publish もしない
- 実アプリのビルドが成功する必要もない
- 依存関係が (例えば.NET の場合)NuGet として解決できれば十分

具体的に何をするか?どんなコマンドが実行されるか? は **明示されていない。**

.NET の場合
.NET では「依存解決」＝ NuGet restore なので
概ね次のいずれかだと推測される。

| コマンド         | 依存解決           | 使われる可能性   |
| ---------------- | ------------------ | ---------------- |
| `dotnet restore` | ✅                 | **高い（本質）** |
| `dotnet build`   | ✅（restore 内包） | 可能性あり       |
| `dotnet test`    | ✅                 | **使われない**   |
| `dotnet publish` | ✅                 | **使われない**   |

他エコシステムでは以下のコマンドが実行されていると推測される

| エコシステム | 実行される「ビルド」の本質    |
| ------------ | ----------------------------- |
| Maven        | `mvn dependency:resolve` 相当 |
| Gradle       | 依存解決タスクのみ            |
| .NET / NuGet | **`dotnet restore`**          |
| Python       | `pip install` / resolve 相当  |
