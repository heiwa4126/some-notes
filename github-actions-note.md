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
  - 再利用前提でない。わざわざ「明示的に opt‑in された Reusable Workflow」というコンセプトがある
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

Reusable workflow 以前（2019-2021 年）は
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
