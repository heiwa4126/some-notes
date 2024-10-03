# GitHub Actions メモ

デバッグが難しい。YAML とか JSON で書くやつは全部そんな感じ

- [On: が難しい](#on-が難しい)
- [on.push.tags で 新しい tag が 2 つ以上 push されたら、全部について action が発生しますか? またその場合 uses actions/checkout で checkout されるのは何?](#onpushtags-で-新しい-tag-が-2-つ以上-push-されたら全部について-action-が発生しますか-またその場合-uses-actionscheckout-で-checkout-されるのは何)
- [GITHUB_REPO_NAME 環境変数が空](#github_repo_name-環境変数が空)
- [GitHub Actions の workflow runs に過去の実行結果が残っていますが、これは消すべきですか? 一定期間で消えますか?](#github-actions-の-workflow-runs-に過去の実行結果が残っていますがこれは消すべきですか-一定期間で消えますか)
- [特定のワークフローファイルだけ実行できるようにする方法はある?](#特定のワークフローファイルだけ実行できるようにする方法はある)
- [GitHub Actions のキャッシュサイズを知る方法](#github-actions-のキャッシュサイズを知る方法)

## On: が難しい

[Workflow syntax for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on)

よく使う割によくわからんのがこれ:\
[on\.push\.<branches\|tags\|branches\-ignore\|tags\-ignore>](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushbranchestagsbranches-ignoretags-ignore)

どうもマッチが正規表現じゃないらしい。

> branches、branches-ignore、tags、tags-ignore キーワードは、_、_、+、 ?、! などの文字を使用して複数のブランチ名やタグ名にマッチするグロブ・パターンを受け付けます。名前にこれらの文字が含まれており、リテラル・マッチを行いたい場合は、各特殊文字を \ でエスケープする必要があります。グロブパターンの詳細については、"GitHub アクションのワークフロー構文" を参照してください。

とえあえず、「頭に v、続けて[SemVer](https://semver.org/lang/ja/)」にマッチする(pre-release や build も考慮) on.push.tags は以下の感じ

```yaml
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+**'
```

ちょっと雑かも(pre-release や build のところ)。実用上問題ないと思う。

で、プロジェクトの Environment で Deployment branches and tags のところには `v*.*.*` と書く。
(こっちでは正規表現が使えないから)

なんか変だけど我慢すること。

あと Deployment branches and tags のルールは、OR 条件。

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

gh-pages ブランチで GutHub Pages を作ろうと思ったら(base:で指定したかった)
GITHUB_REPO_NAME 環境変数が空で、理由がわからない。

[https://docs.github.com/en/actions/learn-github-actions/variables](https://docs.github.com/en/actions/learn-github-actions/variables)

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
