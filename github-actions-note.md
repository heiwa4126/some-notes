# GitHub Actions メモ

デバッグが難しい。YAML とか JSON で書くやつは全部そんな感じ

[actions/checkout]: https://github.com/actions/checkout 'actions/checkout: Action for checking out a repo'
[osv-scanner-reusable.yml]: https://github.com/google/osv-scanner-action/blob/main/.github/workflows/osv-scanner-reusable.yml 'osv-scanner-action/.github/workflows/osv-scanner-reusable.yml at main · google/osv-scanner-action'

- [そもそも](#そもそも)
- [on: が難しい](#on-が難しい)
- [on.push.tags で 新しい tag が 2 つ以上 push されたら、全部について action が発生しますか? またその場合 uses actions/checkout で checkout されるのは何?](#onpushtags-で-新しい-tag-が-2-つ以上-push-されたら全部について-action-が発生しますか-またその場合-uses-actionscheckout-で-checkout-されるのは何)
- [GITHUB_REPO_NAME 環境変数が空](#github_repo_name-環境変数が空)
- [レポジトリ名の取得](#レポジトリ名の取得)
- [GitHub Actions の workflow runs に過去の実行結果が残っていますが、これは消すべきですか? 一定期間で消えますか?](#github-actions-の-workflow-runs-に過去の実行結果が残っていますがこれは消すべきですか-一定期間で消えますか)
- [特定のワークフローファイルだけ実行できるようにする方法はある?](#特定のワークフローファイルだけ実行できるようにする方法はある)
- [GitHub Actions のキャッシュサイズを知る方法](#github-actions-のキャッシュサイズを知る方法)
- [SHA pinning enforcement](#sha-pinning-enforcement)
- [VSCode の GitHub Actions 拡張](#vscode-の-github-actions-拡張)
- [env: と environment:](#env-と-environment)
- [workflows を特定のユーザや特定のブランチに制限する](#workflows-を特定のユーザや特定のブランチに制限する)
- [actions/checkout が .gitattributes の設定を無視する](#actionscheckout-が-gitattributes-の設定を無視する)
- [タグをつけなおす](#タグをつけなおす)
- [VSCode 拡張](#vscode-拡張)
- [permission:](#permission)
- [action/setup-node](#actionsetup-node)
- [GITHUB_TOKEN と permissions:](#github_token-と-permissions)
- [secrets.GITHUB_TOKEN と github.token](#secretsgithub_token-と-githubtoken)
- [actionlint](#actionlint)
- [actionlint はローカル actions をみてくれない](#actionlint-はローカル-actions-をみてくれない)
  - [ちなみに pinact は](#ちなみに-pinact-は)
- [action-validator](#action-validator)
- [shell: bash](#shell-bash)
  - [`--noprofile`](#--noprofile)
  - [`--norc`](#--norc)
  - [`-e` \& `-o pipefail`](#-e---o-pipefail)
- [Composite Action (複合アクション)](#composite-action-複合アクション)
- [メタデータ構文 (Action) でハマりやすい「落とし穴」まとめ](#メタデータ構文-action-でハマりやすい落とし穴まとめ)
- [ややこしくなってきたのでちょっとまとめる](#ややこしくなってきたのでちょっとまとめる)
  - [GitHub Actions の分類:](#github-actions-の分類)
  - [シンタックスで分類:](#シンタックスで分類)
  - [場所で分類:](#場所で分類)
  - [分類例](#分類例)
  - [このほかに](#このほかに)
  - [歴史](#歴史)
  - [ActionからActionは呼べる?](#actionからactionは呼べる)
  - [Action から Reusable workflow は呼べる?](#action-から-reusable-workflow-は呼べる)
  - [Workflow 兼 Reusable Workflow](#workflow-兼-reusable-workflow)
  - [use: で呼べる呼べないのリスト](#use-で呼べる呼べないのリスト)
- [ロググループ](#ロググループ)
  - [1) なぜ「再利用可能な workflow」が必要だったのか(導入前の痛み)](#1-なぜ再利用可能な-workflowが必要だったのか導入前の痛み)
    - [1-1. “同じ YAML をコピペ”がスケールしない](#1-1-同じ-yaml-をコピペがスケールしない)
    - [1-2. 「Composite Action」だけでは足りなかった](#1-2-composite-actionだけでは足りなかった)
  - [2) 実装の経緯(β→GA→改善)と主要URL](#2-実装の経緯βga改善と主要url)
    - [2-1. 2021年10月:Beta 開始](#2-1-2021年10月beta-開始)
    - [2-2. 2021年11月24日:Generally Available(GA)リリース](#2-2-2021年11月24日generally-availablegaリリース)
    - [2-3. 2022年1月25日:ローカル参照の簡略化(同一repo内 `./.github/workflows/...`)](#2-3-2022年1月25日ローカル参照の簡略化同一repo内-githubworkflows)
  - [2-4. 2022年8月22日:マトリクス呼び出し/ネスト呼び出し(最大4階層)](#2-4-2022年8月22日マトリクス呼び出しネスト呼び出し最大4階層)
  - [2-5. 2025年11月:ネスト上限や呼び出し数上限の拡大(10階層/50 workflows)](#2-5-2025年11月ネスト上限や呼び出し数上限の拡大10階層50-workflows)
  - [3) GitHub が公式に述べている “実装理由” を要約すると](#3-github-が公式に述べている-実装理由-を要約すると)
    - [3-1. DRY(重複排除)と保守性](#3-1-dry重複排除と保守性)
    - [3-2. 標準化・ベストプラクティスの押しつけ(良い意味で)](#3-2-標準化ベストプラクティスの押しつけ良い意味で)
    - [3-3. 組織スケール(数十〜数百 repo)への対応](#3-3-組織スケール数十数百-repoへの対応)
  - [4) あなたの推測は当たり:でも “ただのテンプレ” ではない](#4-あなたの推測は当たりでも-ただのテンプレ-ではない)
  - [5) 参考URLまとめ(経緯を追える順)](#5-参考urlまとめ経緯を追える順)
  - [次に聞きたい(任意)](#次に聞きたい任意)
- [`jobs.<job_id>.uses`](#jobsjob_iduses)

## そもそも

みんなが最初に書く GitHub Action は Actions でなくて Workflows だ、というのが罠。

## on: が難しい

[Workflow syntax for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on)

よく使う割によくわからん。
どうもマッチが正規表現じゃないらしい。Glob らしい(Glob のさらに拡張。`+`があるし)

- [on\.push\.<branches\|tags\|branches\-ignore\|tags\-ignore>](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushbranchestagsbranches-ignoretags-ignore)
- [フィルター パターンのチート シート](https://docs.github.com/ja/actions/reference/workflows-and-actions/workflow-syntax#filter-pattern-cheat-sheet)
- おそらくこれは使われていない。`hashFiles()`等用 [@actions/glob - npm](https://www.npmjs.com/package/@actions/glob)

> branches、branches-ignore、tags、tags-ignore キーワードは、_、_、+、 ?、! などの文字を使用して複数のブランチ名やタグ名にマッチするグロブ・パターンを受け付けます。名前にこれらの文字が含まれており、リテラル・マッチを行いたい場合は、各特殊文字を \ でエスケープする必要があります。グロブパターンの詳細については、"GitHub アクションのワークフロー構文" を参照してください。

とりあえず、「頭に v、続けて[SemVer](https://semver.org/lang/ja/)」にマッチする(pre-release や build も考慮) on.push.tags は以下の感じ

```yaml
on:
  push:
    tags:
      # 通常リリース: 例) v1.2.3
      - 'v[0-9]+.[0-9]+.[0-9]+'
      # プリリリースのみ: 例) v1.2.3-rc.1, v1.2.3-beta など(必ず '-' が付く)
      - 'v[0-9]+.[0-9]+.[0-9]+-*'
```

ちょっと雑かも(pre-release や build のところ)。**実用上問題ない**と思う。

で、プロジェクトの Environment で Deployment branches and tags のところはまた別物で

- [デプロイと環境 - GitHub Docs](https://docs.github.com/ja/actions/reference/workflows-and-actions/deployments-and-environments#deployment-branches-and-tags)
- [Class: File (Ruby 2.5.1)](https://ruby-doc.org/core-2.5.1/File.html#method-c-fnmatch)

```ruby
# 通常リリース(例: v1.2.3)
v[0-9]*.[0-9]*.[0-9]*
# プリリリースのみ: v1.2.3-rc.1, v1.2.3-beta など(必ず '-' が付く)
v[0-9]*.[0-9]*.[0-9]*-?*
```

...なんか変だけど我慢すること。

あと Deployment branches and tags のルールも、OR 条件。

## on.push.tags で 新しい tag が 2 つ以上 push されたら、全部について action が発生しますか? またその場合 uses actions/checkout で checkout されるのは何?

まず「全部について action が発生する」みたい。

で、どれが checkout されるかというと「デフォルトブランチの最新の checkout」みたい。

制御するなら
concurrency: の cancel-in-progress: を使う。

- [jobs\.<job_id>\.steps\[\*\]\.uses](https://docs.github.com/ja/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsuses)
- [actions/checkout: Action for checking out a repo](https://github.com/actions/checkout)

> The branch, tag or SHA to checkout. When checking out the repository that triggered a workflow, this defaults to the reference or SHA for that event.
> Otherwise, uses the default branch.

いまいち明解じゃないので、
安全のために以下のように書いておくといいと思う。

```yaml
steps:
  - uses: actions/checkout@v4
    with:
      ref: ${{ github.event.push.ref }}
```

`${{ github.event.push.ref }}`:この行は、ref パラメータに値を設定しています。この値は、**プッシュイベントがトリガーされたときの Git リファレンス(つまり、ブランチ名やタグ名)** を表します。これにより、ワークフローはプッシュが行われた特定のブランチのコードをチェックアウトします。

## GITHUB_REPO_NAME 環境変数が空

(この情報は古い。次のセクション参照)

gh-pages ブランチで GutHub Pages を作ろうと思ったら(base:で指定したかった)
GITHUB_REPO_NAME 環境変数が空で、理由がわからない。

<https://docs.github.com/en/actions/learn-github-actions/variables>

ドキュメントにもこの変数載ってないので、

GITHUB_REPOSITORY 環境変数が
`user1/hello-world`
みたいな `<GitHubアカウント名>/<レポジトリ名>` になってるので
これからレポジトリ名を取ることにする。

Next.js の next.config.js だと

```javascript
let basePath = process.env.GITHUB_REPOSITORY?.split("/")[1];
basePath = basePath ? `/${basePath}` : "";
{
    basePath,
    assetPrefix: basePath,
}
```

Vite の vite.config.ts だと

```javascript
{
    base: process.env.GITHUB_REPOSITORY?.split("/")[1] ?? "./",
}
```

みたいな感じ。

参照:

- [リポジトリ名の取得 [GitHub Actions]](https://zenn.dev/snowcait/articles/757d0c6815227f)

bash だったら

```bash
${GITHUB_REPOSITORY#${GITHUB_REPOSITORY_OWNER}/}
```

## レポジトリ名の取得

`github.event.repository.name` がよさそう。

[continuous integration - Repository Name as a GitHub Action environment variable? - Stack Overflow](https://stackoverflow.com/questions/62803531/repository-name-as-a-github-action-environment-variable)

## GitHub Actions の workflow runs に過去の実行結果が残っていますが、これは消すべきですか? 一定期間で消えますか?

[Usage limits \(使用状況の制限\)](https://docs.github.com/ja/actions/learn-github-actions/usage-limits-billing-and-administration#usage-limits)
によると「開始から 35 日で消える」ように読める。

## 特定のワークフローファイルだけ実行できるようにする方法はある?

1. Required reviewers(必須レビュアーの設定)
2. Deployment branches and tags(デプロイ対象のブランチとタグの制限)
3. Wait Timer(遅延タイマー)
4. Approval workflows(承認フロー)

はあるんだけど、最終的には「全部実行するか or 全部実行しないか」しかない。

ワークフローファイル内部で if:書いて制御するしか手がない。

## GitHub Actions のキャッシュサイズを知る方法

GitHub Actions のキャッシュのサイズを知る方法はいくつかあります。

GitHub のウェブインターフェースを使用する方法: [キャッシュの管理](https://docs.github.com/ja/actions/writing-workflows/choosing-what-your-workflow-does/caching-dependencies-to-speed-up-workflows#managing-caches)

API を使用する方法

(GPT-4 に書いてもらったメモ。後で確認)

`https://api.github.com/repos/{owner}/{repo}/actions/runs/{run_id}/artifacts` エンドポイントに GET リクエストを送信します。

応答には、実行のアーティファクトに関する情報が含まれます。キャッシュのサイズは、各アーティファクトの size_in_bytes フィールドで確認できます。

これらの方法を使用して、GitHub Actions のキャッシュのサイズを確認できます。キャッシュのサイズを把握することで、プロジェクトのパフォーマンスやリソースの使用状況を把握するのに役立ちます。

## SHA pinning enforcement

ハッシュでピンニングされてない action を実行させない機能らしい。

[GitHub Actions policy now supports blocking and SHA pinning actions - GitHub Changelog](https://github.blog/changelog/2025-08-15-github-actions-policy-now-supports-blocking-and-sha-pinning-actions/)

で、free アカウントでも使えるらしい(public レポのみ?)んだけど、UI のどこにあるかがわからん。

ありました

1. リポジトリに入る
2. Settings タブを開く
3. 左サイドバーの Code and automation セクションの中に Actions → General があります
4. そのページの冒頭に Actions permissions というセクションが
5. これの "Require actions to be pinned to a full-length commit SHA" がそれ。

ついでに Actions permissions セクションの項目の説明。

1. Allow all actions and reusable workflows (デフォルト)
   - すべての Actions / 再利用可能ワークフローを利用可能。
   - 誰が作ったか(公式・外部・自分)を問わず GitHub Marketplace のアクションを自由に使えます。
   - セキュリティ的には最も緩い設定です。
2. Disable actions
   - このリポジトリでは GitHub Actions を完全に無効化します。
   - Actions タブ自体が非表示になり、ワークフローは走りません。
   - CI/CD を一切使いたくない場合に選びます。
3. Allow <username> actions and reusable workflows
   - 自分のアカウント配下にあるリポジトリで定義したアクションと再利用可能ワークフローのみ使えるように制限。
   - 他人が公開している Marketplace のアクションは使えません。
   - 内製アクションだけで完結させたい場合に使います。
4. Allow <username>, and select non-<username> actions and reusable workflows
   - 自分のリポジトリ内のアクションはすべて許可。
   - それに加えて、「指定した外部のアクション」だけ許可できます。
   - 設定は allow リストを別途 YAML などで指定する形です。
   - 外部アクションの利用を最小限に制御しながら使いたいときに便利。

で "Require actions to be pinned to a full-length commit SHA" は:

- 有効化すると、アクションを使うときに必ずコミット SHA で参照しなければならなくなります。
  - uses: actions/checkout@v4 # ❌ ← バージョンタグは不可
  - uses: actions/checkout@a81bbbf... # ✅ ← コミット SHA で指定
- タグやブランチ参照だと、後から中身が変わってしまうリスクがあるため、セキュリティを高めたいときに使う設定です。
- チェックを入れると、SHA でピンしていないワークフローは実行時に失敗します。

"コミット SHA" は人間の管理できるものではないので
[pinact](https://github.com/suzuki-shunsuke/pinact)
を使いましょう。

あと gh でも参照設定できるけど "Actions permissions" セクション丸ごと参照&丸ごと設定なんで、あまり便利じゃない。

## VSCode の GitHub Actions 拡張

- [github/vscode-github-actions: GitHub Actions extension for VS Code](https://github.com/github/vscode-github-actions)
- [GitHub Actions - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions)

```yaml
jobs:
  uv-example:
    name: python
    runs-on: ubuntu-latest
    environment: testpypi
```

のようなワークフローを書くと、 environment:の行で `Value 'testpypi' is not valid` という警告が消えません。

回避する方法は無い(行ごと無効プラグマとか無し)ので、無視してください。
[Suppress \`vars\` context validation in an environment set via an expression. · Issue #96 · github/vscode-github-actions](https://github.com/github/vscode-github-actions/issues/96)

actionlint を併用する。

あとインデントはスペースのみ。

## env: と environment:

全然違うものらしい...

env: は環境変数の定義。使える場所は workflow 全体, job, step。そのスコープでのみ有効

- [env - GitHub Actions のワークフロー構文 - GitHub Docs](https://docs.github.com/ja/actions/reference/workflows-and-actions/workflow-syntax#env)
- [変数に情報を格納する - GitHub Docs](https://docs.github.com/ja/actions/how-tos/write-workflows/choose-what-workflows-do/use-variables)

## workflows を特定のユーザや特定のブランチに制限する

workflow 中に

```yaml
jobs:
  security-check:
    name: Security check
    runs-on: ubuntu-latest
    steps:
      - name: Check repository owner
        if: github.repository_owner != github.actor
        run: |
          echo "Error: Only repository owner can trigger this workflow"
          exit 1
```

だけだと、うっかりプルリクでマージされる可能性があるので
これと併用して environment を使うといい。

(だから Direct publishing でも environment 指定できるようになっているんだな)。

Environment Protection の設定手順:

1. Settings → Environments → 環境作るまたは既存環境選ぶ
2. "Required reviewers" にオーナーを追加
3. "Deployment branches" を main のみに制限

4. は状況に応じて設定

## actions/checkout が .gitattributes の設定を無視する

- [Checkout@v2 detached HEAD · Issue #124 · actions/checkout](https://github.com/actions/checkout/issues/124)
- [Issue search results](https://github.com/search?q=repo%3Aactions%2Fcheckout++.gitattributes&type=issues)

もう治す気が全くないらしいので、改行コードが絡む場合(テストケースとか)は注意。

## タグをつけなおす

(すいません。これあんまり役に立たない)

こういうワークフローで、

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
```

ワークフローにバグがあったりして、修正して再度実行したいときは

```sh
TAG=0.0.5 # ここは仮
git tag -d "v${TAG}" && git push origin ":refs/tags/v${TAG}"
git add --all && git commit -am '[WIP] fix workflow'
git tag  "v${TAG}" -m ''  && git push --all --follow-tags
```

こんなかんじ。
オプション類は各自調整。

`TAG=0.0.5`のところは `git describe --tags --abbrev=0`にするとか(`v9.9.9`式になるので注意!)
アレンジして。

## VSCode 拡張

[GitHub Actions - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions)

シンタックスハイライトや lint は普通だけど、
なんといっても Actions のログが見れるのが便利。

ただ背後で GitHub CLI (gh)が動いてるらしく、
GitHub アカウントを複数持ってるときは `gh auth status` & `gh auth switch` でアクティブアカウントを切り替えること。

## permission:

`permission:` で
`secrets.GITHUB_TOKEN` のスコープを制御できる。

参考:

- [GitHub Actions permissions](https://www.graphite.com/guides/github-actions-permissions)
- [GitHub - Understanding Workflow Permissions - DEV Community](https://dev.to/pwd9000/fgjgghjgh-19ka)

## action/setup-node

action/setup-node は action/cache を内部で呼んでる。

`cache:` は省略すると、何もしてくれない。npm でも `cache: npm` と書くこと。

あと `cache-dependency-path:` (このファイルのハッシュがキーになるらしい) は cache が npm, pnpm, yarn なら自動で設定される。
(2026-01 現在。GitHub のソース参照。<https://github.com/actions/setup-node/blob/main/src/cache-utils.ts>)

つまり bun だと bun.lock か bun.lockb を記述するべき。

pnpm スペシャルとして pnpm のグローバルストアと node_modules/以下のリンクをキャッシュしてくれる。
つまり `pnpm install --frozen-lockfile` (`npm ci`相当) 以外はなにもしなくていい。

あと `registry-url:` と `scope:` で ${NPM_CONFIG_USERCONFIG} に .npmrc が自動生成される。
モジュールをプライベートレポジトリから install するのに便利で

```yaml
- uses: actions/setup-node@v6
  with:
    registry-url: https://npm.pkg.github.com/
    scope: '@yourOrg'
```

で、こんな .npmrc が自動生成されるので

```text
//npm.pkg.github.com/:_authToken=${NODE_AUTH_TOKEN}
@yourOrg:registry=https://npm.pkg.github.com/
```

依存インストール時には

```yaml
- name: Install dependencies
  run: pnpm install --frozen-lockfile
  env:
    NODE_AUTH_TOKEN: ここはsecretから取るなど各々工夫
```

のようにして使う

## GITHUB_TOKEN と permissions:

permissions:は workflow と job に書ける。

**一度でも permissions を記述したら、書かなかったスコープは none(無効)**

なので
**Workflow 全体の permissions は、特別な理由がない限り書かない方が安全。**
job に記述すること

デフォルト値は
`https://github.com/<userOrOrg>/<reponame>/settings/actions`
の Workflow permissions

レポジトリの "Setting"->"Actions"->"General"-> "Workflow permissions" のところ。
デフォルトは "Read repository contents and packages permissions" で

- Contents:read
- Packages:read

らしい。

(実際にやってみると Metadata:read もついてたけど
Metadata スコープとは?)

## secrets.GITHUB_TOKEN と github.token

同じ値。

推奨は github.token。
secrets.GITHUB_TOKEN は互換性のために残されているらしい。

## actionlint

[rhysd/actionlint: :octocat: Static checker for GitHub Actions workflow files](https://github.com/rhysd/actionlint)

Docker 版は shellcheck と pyflakes 入り

- [actionlint/Dockerfile at main · rhysd/actionlint](https://github.com/rhysd/actionlint/blob/main/Dockerfile)
- [rhysd/actionlint - Docker Image](https://hub.docker.com/r/rhysd/actionlint)

## actionlint はローカル actions をみてくれない

無理に

```sh
actionlint .github/actions/*/action.yml
```

とかやっても間違った結果しか出てこない。

機能要求は出てる。

- [Feature request: check that local actions exist · Issue #265 · rhysd/actionlint](https://github.com/rhysd/actionlint/issues/265)

v1.7 で実装された? [Release v1.7.0 · rhysd/actionlint](https://github.com/rhysd/actionlint/releases/tag/v1.7.0)

action-validator というのがあるらしい。
[mpalmer/action-validator: Tool to validate GitHub Action and Workflow YAML files](https://github.com/mpalmer/action-validator)

### ちなみに pinact は

[suzuki-shunsuke/pinact-action: GitHub Actions to pin GitHub Actions by pinact](https://github.com/suzuki-shunsuke/pinact-action)

> pinact-action is a GitHub Actions to pin GitHub Actions and reusable workflows by pinact. This action fixes files \.github/workflows/[^/]+\.ya?ml$ and ^(.\*/)?action\.ya?ml? and pushes a commit to a remote branch.

とあるので、ローカルアクションも pin してくれるらしい(未確認)

## action-validator

[mpalmer/action-validator: Tool to validate GitHub Action and Workflow YAML files](https://github.com/mpalmer/action-validator)

メタデータ構文とワークフロー構文サポート。

使い方:

```sh
action-validator -v .github/workflows/*.yml  .github/actions/*/action.yml
```

特徴: エラーメッセージが意味不明

たとえば「action.yml の step では shell:必須」。たしかに検出してくれるんだけど、
出力を見て何が問題なのか、どこに問題があるのかは全然わからない。

## shell: bash

デフォルトは bash なんだけど

- デフォルトだと `bash -e {0}`
- 指定すると `bash --noprofile --norc -eo pipefail {0}`

なんだそうな。

### `--noprofile`

ログイン時や非対話起動時に読み込まれる \*\*プロファイル系の起動ファイルを読まなくする。

### `--norc`

**rc ファイルを読みません**。

ユーザー環境の `.bashrc` にエイリアス・関数・`shopt` 等があると CI とローカルで挙動が変わることがあります。これを避けます。

### `-e` & `-o pipefail`

`set -e` と同じで、**コマンドが非ゼロで終了したら直ちにシェルを終了**します。  
ただし有名な落とし穴があり、以下では終了しません(= 無効化される文脈がある):

- `if` の条件式内、`while`/`until` の条件式内
- `&&` / `||` の右辺
- `!`(否定)で実行したコマンド
- サブシェル(`( ... )`)内、`command`/`builtin` などで抑制された場合

で、
`set -o pipefail` と同じで、**パイプラインのどこか1つでも失敗したら失敗(非ゼロ)として扱う**ようにします。  
通常 Bash では `a | b | c` の終了ステータスは最後の `c` のものになりますが、`pipefail` を有効にすると **`a` や `b` が失敗しても検出**できます。

## Composite Action (複合アクション)

- [Creating a composite action - GitHub Docs](https://docs.github.com/en/actions/tutorials/create-actions/create-a-composite-action)

```yaml
runs:
  using: composite
  steps:
```

となってるのが Composite Action。

- Composite Action = workflow の中で呼べる「関数」
- Reusable Workflow = workflow を呼ぶ「サブルーチン」。別プロセスで動く。「親環境を引き継がない fork()」みたいな。

なかまに JavaScript action と Docker container action がある。

- [Creating a JavaScript action - GitHub Docs](https://docs.github.com/en/actions/tutorials/create-actions/create-a-javascript-action)
- [Creating a Docker container action - GitHub Docs](https://docs.github.com/en/actions/tutorials/use-containerized-services/create-a-docker-container-action)

Composite Action は workflow に似ているけど、**文法が違う**。

メタデータ構文とワークフロー構文。

- [メタデータ構文リファレンス - GitHub ドキュメント](https://docs.github.com/ja/actions/reference/workflows-and-actions/metadata-syntax)
- [GitHub Actionsのワークフロー構文 - GitHub ドキュメント](https://docs.github.com/ja/actions/reference/workflows-and-actions/workflow-syntax)

## メタデータ構文 (Action) でハマりやすい「落とし穴」まとめ

1. **`required: true` でも未指定エラーにならない**  
   `inputs.<id>.required: true` を付けても、入力未指定時に自動で失敗せず、そのまま実行されることがある。呼び出し元ワークフロー側で検証 or Action 側でガードを入れる。[1](https://docs.github.com/en/actions/reference/workflows-and-actions/metadata-syntax)[2](https://docs.github.com/ja/actions/reference/workflows-and-actions/metadata-syntax)

2. **シークレット(含む `GITHUB_TOKEN`)は自動では使えない**  
   Composite Action 内で `secrets.*` に直接アクセスできない前提で設計する。**入力(`with:`→`inputs`)や `env:` で明示的に渡す**。また、呼び出し元で `permissions` を適切に付与(例:`contents: write`)しないと Git 操作が 403 になる。[6](https://stackoverflow.com/questions/70098241/using-secrets-in-composite-actions-github)[3](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)

3. **シークレットのログ漏えい懸念**  
   シークレットを入力として渡す設計は一般的。GitHub はログ上でマスキングするが、**Action 内での取り扱い(エコーや外部コマンド引数など)次第で漏えいしうる**ため、実装レビュー&コミット SHA ピン留めを推奨。[7](https://github.com/orgs/community/discussions/34212)

4. **作業ディレクトリの“勘違い”**  
   Composite の `run:` で相対パスを使うと**呼び出し元ワークフローの作業ディレクトリ**を見に行く。Action 側のファイルを実行したいなら `${{ github.action_path }}` を使って絶対パス化する。[8](https://zenn.dev/noraworld/articles/github-actions-metadata-side-commands)

5. **`defaults.run` は Action 側には効かない**  
   呼び出し元ワークフローで `defaults.run.working-directory` を設定しても、**Action(Composite)内部の step には適用されない**。各 step に明示的に `working-directory`/`shell` を指定する。[9](https://qiita.com/shun198/items/e7b7a3d9d3b86aec4813)

6. **入出力の“環境変数化”の仕様差**  
   メタデータで宣言した `inputs` は、Docker/JS Action では `INPUT_<NAME>` として環境変数化される一方、**Composite では自動環境変数化されない**ため `inputs` コンテキスト経由で参照する(必要なら `env` で渡す)。[1](https://docs.github.com/en/actions/reference/workflows-and-actions/metadata-syntax)

7. **ログの粒度が粗くなる**  
   Composite Action は実行ログが 1 ステップにまとまり、**失敗点の切り分けがしにくい**。段階的に小さめの Composite に分ける・`set -x`/明示ログを入れるなどで補う。[10](https://zenn.dev/tmrekk/articles/5fef57be891040)

## ややこしくなってきたのでちょっとまとめる

### GitHub Actions の分類:

- Workflows
  - 再利用前提でない。わざわざ「明示的に opt‐in された Reusable Workflow」というコンセプトがある
  - レポジトリの `.github/workflows/*.yml` (または .yaml)に書く。これは固定
- Actions
  - 再利用前提。opt-in も opt-out もない。Actions は常に reusable
  - パブリックレポジトリに置いたら全 GitHub ユーザが使える
  - レポジトリの `.github/actions/*/action.yml` に書くのが**習慣**。
    実はどこに置いてもいい
  - `action.yml` または `action.yaml` というファイル名は固定
  - use: ではディレクトリを指定して、`action.yml` のほうが優先

### シンタックスで分類:

- Workflow 構文で書くやつ
  - Workflows
  - Reusable Workflow (on: に workflow_call があるやつ)
- メタデータ構文で書くやつ
  - Composite Actions (複数ステップをまとめる)
  - JavaScript Actions
  - Docker Actions

### 場所で分類:

- ローカル - 同一レポジトリ
- リモート - 同一レポジトリでないもの(同一ユーザ、同一組織、他ユーザ&組織)

### 分類例

- [actions/checkout] は「メタデータ構文で書かれた JavaScript Action」かつ「リモート(別リポジトリ)アクション」
- [osv-scanner-reusable.yml] は
 「Workflow 構文で書かれた Reusable Workflow」かつ
 「リモート(別リポジトリ)の再利用ワークフロー」

### このほかに

「プライベートレポジトリ」とか「属する組織のレポジトリ」の件があるけど
それはアクセス権限の話で GitHub Actions の本筋ではない。別ティア。

### 歴史

デフォルトで Workflows も Actions も reusable で、
オプションで unusable にできる。のような設計にすればよかったはず
(あるいはその逆)。

理由は歴史的なもの。
もともと同一レポだろうが、他所のレポジトリであろうが
workflow から workflow は呼べなかった。
workflow から action は呼べる(もともとそういう設計)。

Reusable workflow 以前(2019-2021 年)は
workflow から workflow を use:する方法はなかった
(ハックはあった。GitHub API を Curl 経由で使う)。

で、2021 年に Reusable Workflows が実装されて、
「便利だがややこしい」状態になった、という経緯

### ActionからActionは呼べる?

- Composite Action から他の Action は呼べる
- JavaScript/Docker Action からは直接は呼べない

JavaScript/Docker Action から GitHub API 経由で Actions は呼べるけど
それは workflow を呼び出すように別プロセスになる。

### Action から Reusable workflow は呼べる?

呼べない。
(これもハックすれば呼べるんだけど)

でも例えば `action/checkout` は workflow じゃなくて action なので
action から呼べます。

### Workflow 兼 Reusable Workflow

`on:` に workflow_call 以外のトリガーがあれば

workflow 兼 reusable workflow になる。

### use: で呼べる呼べないのリスト

- ✅ workflow から action
- ✅ workflow から reusable workflow
- ❌ workflow から workflow
- ✅ composite action から action
- ❌ action から workflow
- ❌ action から reusable workflow

※「GitHub API 経由で呼ぶ」とかのハックは除く  
※ ローカル/リモート関係なし

## ロググループ

[デバッグメッセージの設定](https://docs.github.com/ja/actions/reference/workflows-and-actions/workflow-commands#setting-a-debug-message)

```sh
echo "::group::..."
printenv # or do anything
echo "::endgroup::"
```

ネスト可能かはドキュメントに書いてない。誰か試して。

# Reusable workflows が実装された経緯(背景と経緯つき)

> GitHub Actions の Reusable workflows が実装された理由を、経緯(URL)もふくめて解説して。
> おそらく再利用可能なworkflowsが欲しかったんだろうと推測されますが。

と GPT5 に聞いて出てきたのが以下:

結論から言うと、**「CI/CD の“手順(ワークフロー)そのもの”を再利用して DRY にし、組織規模で標準化・統制できるようにする」** のが Reusable workflows(`workflow_call`)導入の主目的です。GitHub 自身が「重複を減らす」「組織で一元管理できる」「ベストプラクティスを促進できる」と明言しています。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)

### 1) なぜ「再利用可能な workflow」が必要だったのか(導入前の痛み)

#### 1-1. “同じ YAML をコピペ”がスケールしない

Reusable workflows が登場するまで、複数リポジトリで同じ CI を回すには、**各リポジトリに workflow YAML をコピペして運用** するのが一般的でした。GitHub Blog でも「最近まで、複数箇所で使うには YAML をコピー&ペーストするしかなかった」と説明されています。[3](https://github.blog/developer-skills/github/using-reusable-workflows-github-actions/)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

この方式の問題はシンプルで、

- 手順の更新(Node バージョン更新・セキュリティ手順追加等)があるたびに **全レポジトリに横展開PR**が必要
- レポジトリ間で **微妙に手順がズレて** 事故る(テストが抜ける・デプロイ条件が違う等)
- 「この組織では本番デプロイ前に必ずこの検証を通す」みたいな **統制**が難しい

という “運用コストとリスク” が、リポジトリ数に比例して増えます。GitHub 公式は、Reusable workflows を「重複を避けてメンテしやすくし、中央で管理できるライブラリを作れる」ものとして位置づけています。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[5](https://resources.github.com/learn/pathways/automation/intermediate/create-reusable-workflows-in-github-actions/)

#### 1-2. 「Composite Action」だけでは足りなかった

「再利用」なら Composite Actions(複数 step の束ね)でも良さそうに見えますが、Reusable workflows が狙っているのは **“ジョブ/複数ジョブを含むパイプラインの塊”** の再利用です。  
GitHub Docs は、Reusable workflows を「ワークフロー全体を別ワークフローから呼べる」仕組みとして説明し、Composite actions との比較もしています(どちらも重複回避だが、粒度が違う)。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[3](https://github.blog/developer-skills/github/using-reusable-workflows-github-actions/)

つまり「step を部品化」だけではなく、**CI/CDの設計(複数ジョブ・依存関係・環境・デプロイ手順)ごと使い回したい**ニーズが強かった、ということです。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

### 2) 実装の経緯(β→GA→改善)と主要URL

#### 2-1. 2021年10月:Beta 開始

GitHub Changelog によると、Reusable workflows は **2021年10月にベータが開始**され、その後改善が続いたとされています。[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

> ここが「経緯」の起点です(=いきなりGAではなく、βで実運用に揉まれた)。

#### 2-2. 2021年11月24日:Generally Available(GA)リリース

Reusable workflows が **GAになったのは 2021-11-24**。GitHub Changelog が明確に「generally available」として告知しています。[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)  
同時期の GitHub Blog(ニュース記事)でも GA を前提に、ユースケースと改善点(β以降の改良)を説明しています。[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)

- GitHub Changelog(GA 告知):  
  [GitHub Actions: Reusable workflows are generally available](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)
- GitHub Blog(GA とユースケース):  
  [GitHub Actions: reusable workflows is generally available](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

GA 告知では、Reusable workflows の価値を「**ワークフロー全体を action のように再利用して重複を減らす**」と要約しています。[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)

#### 2-3. 2022年1月25日:ローカル参照の簡略化(同一repo内 `./.github/workflows/...`)

GA 直後の改善として、**同一リポジトリ内の呼び出しがパス指定で簡単に**できるようになっています。[6](https://github.blog/changelog/2022-01-25-github-actions-reusable-workflows-can-be-referenced-locally/)  
これは「まずは同一 repo 内で共通化したい」という現実的ニーズにも応えた変更です。[6](https://github.blog/changelog/2022-01-25-github-actions-reusable-workflows-can-be-referenced-locally/)[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)

- [Reusable workflows can be referenced locally](https://github.blog/changelog/2022-01-25-github-actions-reusable-workflows-can-be-referenced-locally/)

### 2-4. 2022年8月22日:マトリクス呼び出し/ネスト呼び出し(最大4階層)

次の大きな改善は、**matrix から呼べる**・**reusable workflow から別の reusable workflow を呼べる**(ネスト)ようになった点です。[7](https://github.blog/changelog/2022-08-22-github-actions-improvements-to-reusable-workflows-2/)  
“部品化”を本格的にやると「共通 workflow の中でも共通化したい」ので、ここはスケール要件として重要です。[7](https://github.blog/changelog/2022-08-22-github-actions-improvements-to-reusable-workflows-2/)[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)

- [Improvements to reusable workflows (matrix / nesting)](https://github.blog/changelog/2022-08-22-github-actions-improvements-to-reusable-workflows-2/)

### 2-5. 2025年11月:ネスト上限や呼び出し数上限の拡大(10階層/50 workflows)

さらに最近(2025-11)には、**ネスト上限や呼び出し可能数が拡大**され、より大規模な再利用に寄せています。[8](https://github.blog/changelog/2025-11-06-new-releases-for-github-actions-november-2025/)[9](https://docs.github.com/ja/actions/reference/workflows-and-actions/reusing-workflow-configurations)  
(Docs 側でも上限が更新されていることが読み取れます)[9](https://docs.github.com/ja/actions/reference/workflows-and-actions/reusing-workflow-configurations)[10](https://docs.github.com/en/actions/reference/workflows-and-actions/reusing-workflow-configurations)

- [New releases for GitHub Actions – November 2025(上限拡大)](https://github.blog/changelog/2025-11-06-new-releases-for-github-actions-november-2025/)

### 3) GitHub が公式に述べている “実装理由” を要約すると

GitHub Docs / Blog の表現をまとめると、Reusable workflows は次の狙いを満たすために導入されました。

#### 3-1. DRY(重複排除)と保守性

「コピペをやめて、**1箇所の共通 workflow を参照**する」ことができる。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[3](https://github.blog/developer-skills/github/using-reusable-workflows-github-actions/)  
これにより、更新時に全リポジトリへ PR 横展開する必要が減り、保守が楽になります。[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)[5](https://resources.github.com/learn/pathways/automation/intermediate/create-reusable-workflows-in-github-actions/)

#### 3-2. 標準化・ベストプラクティスの押しつけ(良い意味で)

Docs は「よく設計され、テストされ、実績のある workflow を使わせることで **ベストプラクティスを促進**できる」と言っています。[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[5](https://resources.github.com/learn/pathways/automation/intermediate/create-reusable-workflows-in-github-actions/)  
大企業の “Paved Road(舗装路)” 的な運用に寄せたい意図が読み取れます。[5](https://resources.github.com/learn/pathways/automation/intermediate/create-reusable-workflows-in-github-actions/)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

#### 3-3. 組織スケール(数十〜数百 repo)への対応

GA 告知やブログは「大規模組織での利用」「多数の repo を同じ方法でビルド/デプロイする」ユースケースを前面に出しています。[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)  
つまり、**Actions を“チーム規模”から“組織規模”へスケールさせる機能**として投入された、という位置づけです。[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)

### 4) あなたの推測は当たり:でも “ただのテンプレ” ではない

ご推測の「再利用可能な workflows が欲しかった」はその通りです。ただし GitHub の狙いは単なるテンプレ共有に留まらず、

- **入力/出力**(`inputs` / `outputs` / `secrets`)で “パラメータ化されたパイプライン部品” にする[11](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)
- “呼び出し側のコンテキストで動く” という設計で、レポジトリ横断でも扱いやすくする(checkout 対象など)[1](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)[11](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- 監査ログ(audit log)に reusable workflow 使用情報を出し、統制を効かせる[2](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

といった **「組織運用・統制」まで含めた CI/CD のモジュール化**に踏み込んでいます。[5](https://resources.github.com/learn/pathways/automation/intermediate/create-reusable-workflows-in-github-actions/)[4](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)

### 5) 参考URLまとめ(経緯を追える順)

- 2021-11-24 GA(changelog):  
  [GitHub Actions: Reusable workflows are generally available](https://github.blog/changelog/2021-11-24-github-actions-reusable-workflows-are-generally-available/)
- 2021-11-29 GA(blog / ユースケース):  
  [GitHub Actions: reusable workflows is generally available](https://github.blog/news-insights/product-news/github-actions-reusable-workflows-is-generally-available/)
- 2022-01-25 ローカル参照改善:  
  [Reusable workflows can be referenced locally](https://github.blog/changelog/2022-01-25-github-actions-reusable-workflows-can-be-referenced-locally/)
- 2022-08-22 matrix/ネスト改善:  
  [Improvements to reusable workflows](https://github.blog/changelog/2022-08-22-github-actions-improvements-to-reusable-workflows-2/)
- 公式 Docs(概念/理由の説明がまとまってる):  
  [Reusing workflow configurations](https://docs.github.com/en/actions/concepts/workflows-and-actions/reusing-workflow-configurations)
- 公式 Docs(使い方の手順):  
  [Reuse workflows](https://docs.github.com/en/actions/how-tos/reuse-automations/reuse-workflows)
- 2025-11 上限拡大(より大規模へ):  
  [New releases for GitHub Actions – November 2025](https://github.blog/changelog/2025-11-06-new-releases-for-github-actions-november-2025/)

### 次に聞きたい(任意)

Reusable workflows が「なぜ _jobs.<job_id>.uses_ なのか」「なぜ step から呼べないのか」「composite action との責務分離は設計として正しいのか」みたいな“設計思想の違和感”も、あなたが以前話していた論点に直結します。

続けて、

- **「Reusable workflow と Composite action を、責務・セキュリティ境界・再利用単位でどう使い分けるべきか」**
- **「なぜ workflow_call が env を引き継がない設計なのか(落とし穴)」**
  あたりも掘ります?

## `jobs.<job_id>.uses`

これは説明用表記であって、JSONPath とかではない。

Workflows の場合:

```yaml
jobs:
  do_something:
    uses: owner/repo/.github/workflows/reusable-workflow.yml@main
    # ↑ この「uses:」の部分が `jobs.<job_id>.uses`
```

GitHub Actions は

- YAML
- glob
- 独自 expression
- ドキュメント擬似記法

がごちゃっと混ざってる...
コンテキストを考慮しないとダメ。

実際に `jobs.<job_id>.uses` のような表記が出てくる GitHub の文書:

- [Workflow syntax for GitHub Actions - GitHub Enterprise Server 3.1 Docs](https://docs.github.com/en/enterprise-server@3.1/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsenv)
