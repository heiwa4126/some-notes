# gh (GitHub CLI) のメモ

## GitHub Actions をデバッグするときに便利な GitHub CLI コマンド

Web からやるより便利! 事前に `gh auth login` は要ります

```sh
# ワークフロー実行の一覧を表示
gh run list

# 失敗したワークフロー実行の一覧を表示
gh run list --status failure

# 特定のワークフロー実行の詳細を表示
gh run view [run-id]

# 最新のワークフロー実行を表示
gh run view --latest

# 特定のワークフローに絞って表示
gh run list --workflow=publish.yml

# ワークフロー実行をリアルタイムで監視
gh run watch

# 失敗したワークフローのログを表示(stdout)
gh run view [run-id] --log-failed

# 最後に失敗したワークフローのrun-idを取得
RUN_ID=$(gh run list --status failure --limit 1 --json databaseId --jq '.[0].databaseId')

# 上↑の発展: publish.ymlで失敗した最後のrun-idを取得
RUN_ID=$(gh run list --workflow=publish.yml --status failure --limit 1 --json databaseId --jq '.[0].databaseId')
echo "Failed publish.yml run ID: $RUN_ID"

# [run-id]のログを取得
# リダイレクトしてAIエージェントに食わせると便利
gh run view [run-id] --log
```

### VSCode でエラーログだけ取りたいなら...

[GitHub Actions - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions)の方がお手軽かも。

1. アクティビティバーで GitHub Actions アイコンを押す。
2. WORKFLOWS ペインから対象のワークフローを選ぶ
3. エラーになってるジョブの右端の "View Job Logs"アイコンを押す

GitHub Copilot Chat のコンテキストにも選べるよ。

## gh の bash completion

```sh
gh completion -s bash
```

この出力を.bashrc に追記するとか、遅延ロードするとか

## `gh auth login` は expire しないらしい

そのうえ keyring のない Linux では平文で token が保存されるらしい。

## なるべくオプションで

```console
$ gh auth login
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser
```

ここまでを対話的でなくオプションで指定する方法はあるか?

```console
$ gh --version
gh version 2.83.2 (2025-12-10)
https://github.com/cli/cli/releases/tag/v2.83.2
```

では、ここまで行けた。

```console
$ gh auth login --hostname github.com --git-protocol https --web
? Authenticate Git with your GitHub credentials? (Y/n)
```

## 複数アカウント

`gh auth status` で複数アカウント出てくる場合。

`gh auth switch --user UserName` のように切り替え可能

```console
$ gh auth switch --help
Switch the active account for a GitHub host.

This command changes the authentication configuration that will
be used when running commands targeting the specified GitHub host.

If the specified host has two accounts, the active account will be switched
automatically. If there are more than two accounts, disambiguation will be
required either through the `--user` flag or an interactive prompt.

For a list of authenticated accounts you can run `gh auth status`.


USAGE
  gh auth switch [flags]

FLAGS
  -h, --hostname string   The hostname of the GitHub instance to switch account for
  -u, --user string       The account to switch to

INHERITED FLAGS
  --help   Show help for command

EXAMPLES
  # Select what host and account to switch to via a prompt
  $ gh auth switch

  # Switch the active account on a specific host to a specific user
  $ gh auth switch --hostname enterprise.internal --user monalisa

LEARN MORE
  Use `gh <command> <subcommand> --help` for more information about a command.
  Read the manual at https://cli.github.com/manual
  Learn about exit codes using `gh help exit-codes`
  Learn about accessibility experiences using `gh help accessibility`
```

## gh CLI から Variables や Secrets は登録できる?

登録できる。レポジトリの指定方法は 3 通りある。

### 1) カレントディレクトリの Git リモートから自動推測(デフォルト)

作業中のリポジトリ配下で実行すると、そのディレクトリの Git リモート(例: `origin`)から `OWNER/REPO` が推測されます。追加指定は不要です。 [\[docs.github.com\]](https://docs.github.com/ja/github-cli/github-cli/quickstart)

```sh
# 例:現在のリポジトリに Secret を設定
gh secret set MY_SECRET --body "value"

# 現在のリポジトリに Variable を設定
gh variable set FEATURE_FLAG --body "on"
```

### 2) `--repo` / `-R` フラグで明示指定

どこから実行しても、対象リポジトリを `[HOST/]OWNER/REPO` 形式で指定できます。GitHub Enterprise のホスト名を含めた指定も可。 [\[cli.github.com\]](https://cli.github.com/manual/gh_secret_set), [\[mankier.com\]](https://www.mankier.com/1/gh-secret-set), [\[cli.github.com\]](https://cli.github.com/manual/gh_variable_set)

```sh
# GitHub.com の特定リポジトリに Secret
gh secret set DOCKER_TOKEN --body "$TOKEN" --repo your-org/your-repo

# Enterprise の特定リポジトリに Variable(ホスト名付き)
gh variable set API_URL --body "https://api.example.local" \
  --repo ghe.example.com/your-org/your-repo
```

### 3) **環境変数 `GH_REPO` で固定する**

頻繁に同じリポジトリを操作する場合は、環境変数 `GH_REPO` に `[HOST/]OWNER/REPO` を設定しておくと、各コマンドで対象が既定になります。 [\[cli.github.com\]](https://cli.github.com/manual/gh_help_environment)

```sh
export GH_REPO=your-org/your-repo
# 以降 --repo を付けずに対象が your-org/your-repo になる
gh secret set SENTRY_DSN --body "$DSN"
gh variable set LOG_LEVEL --body "debug"
```

### 補足

- **Organization レベル**を指定する場合は `--org your-org` を使います(Secrets/Variables ともに可)。 [\[cli.github.com\]](https://cli.github.com/manual/gh_secret_set), [\[cli.github.com\]](https://cli.github.com/manual/gh_variable_set)
- **Environment 向け**なら `--env production` のように環境名を加えます(事前に Environment が存在している必要あり。未作成なら `gh api -X PUT /repos/OWNER/REPO/environments/ENV` で作成可能)。 [\[cli.github.com\]](https://cli.github.com/manual/gh_secret_set), [\[cli.github.com\]](https://cli.github.com/manual/gh_variable_set), [\[stackoverflow.com\]](https://stackoverflow.com/questions/70943164/create-environment-for-repository-using-gh)
