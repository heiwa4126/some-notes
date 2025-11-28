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
```

## gh の bash completion

```sh
gh completion -s bash
```

この出力を.bashrc に追記するとか、遅延ロードするとか

## `gh auth login` は expire しないらしい

そのうえ keyring のない Linux では平文で token が保存されるらしい。

## Windows 上の Git Credential Manager (GCM)を WSL で使う

まず Windows 側で GCM 入ってるか確認。

```console
PowerShell 7.5.4

ps> git --version
git version 2.52.0.windows.1

ps> git config --system credential.helper
manager

ps> git credential-manager --version
2.6.1+786ab03440ddc82e807a97c0e540f5247e44cec6
```

**重要**: **GCM が使われるのはトランスポートが https の場合のみ**

WSL の場合、Windows の EXE を起動できるので、
Windows の Git Credentials Manager (GCM)を読んで
Windows Credential Manager(Windows 資格情報マネージャー) にストアする方法がある。

あまり参考にならない: [WSL の GCM を確認して設定するコマンド](https://learn.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-git#commands-to-check-and-set-up-gcm-for-wsl)

で、

`git-credential-manager.exe`
はだいたい
`C:\Program Files\Git\mingw64\bin\git-credential-manager.exe`
にあるので(**要確認**)

WSL 側で

```sh
# 確認
ls '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'

# 既存の設定を確認
git config --global --get credential.helper

# 設定
git config --global credential.helper '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'
## 設定されたことを確認
git config --global --get credential.helper
```
