## GITHUB_REPO_NAME環境変数が空

gh-pagesブランチでGutHub Pagesを作ろうと思ったら(base:で指定したかった)
GITHUB_REPO_NAME環境変数が空で、理由がわからない。

https://docs.github.com/en/actions/learn-github-actions/variables

ドキュメントにもこの変数載ってないので、

GITHUB_REPOSITORY環境変数が
`user1/hello-world`
みたいな `<GitHubアカウント名>/<レポジトリ名>` になってるので
これからレポジトリ名を取ることにする。

Next.jsのnext.config.jsだと
```javascript
let basePath = process.env.GITHUB_REPOSITORY?.split("/")[1];
basePath = basePath ? `/${basePath}` : "";
{
    basePath,
    assetPrefix: basePath,
}
```

Viteのvite.config.tsだと
```javascript
{
    base: process.env.GITHUB_REPOSITORY?.split("/")[1] ?? "./",
}
```

みたいな感じ。

参照:
- [リポジトリ名の取得 [GitHub Actions]](https://zenn.dev/snowcait/articles/757d0c6815227f)

bashだったら
```bash
${GITHUB_REPOSITORY#${GITHUB_REPOSITORY_OWNER}/}
```
