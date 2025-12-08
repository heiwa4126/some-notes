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

## gh の bash completion

```sh
gh completion -s bash
```

この出力を.bashrc に追記するとか、遅延ロードするとか

## `gh auth login` は expire しないらしい

そのうえ keyring のない Linux では平文で token が保存されるらしい。
