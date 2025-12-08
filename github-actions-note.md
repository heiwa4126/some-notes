# GitHub Actions メモ

デバッグが難しい。YAML とか JSON で書くやつは全部そんな感じ

- [On: が難しい](#on-が難しい)
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

## On: が難しい

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

- 有効化すると、アクションを使うときに必ず コミット SHA で参照しなければならなくなります。
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
