# PowerShell Core メモ

- [インストール](#インストール)
- [SETX の等価](#setx-の等価)

## インストール

- [Linux への PowerShell Core のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-6)
- [Linux または macOS X での AWS Tools for PowerShell Core のセットアップ - AWS Tools for PowerShell](https://docs.aws.amazon.com/ja_jp/powershell/latest/userguide/pstools-getting-set-up-linux-mac.html)

## SETX の等価

| 操作内容                                     | cmd.exe (`SETX`)     | PowerShell 等価コマンド                                             |
| -------------------------------------------- | -------------------- | ------------------------------------------------------------------- |
| **ユーザー環境変数を設定**                   | `SETX NAME VALUE`    | `[Environment]::SetEnvironmentVariable("NAME", "VALUE", "User")`    |
| **システム環境変数を設定(管理者権限必要)** | `SETX NAME VALUE /M` | `[Environment]::SetEnvironmentVariable("NAME", "VALUE", "Machine")` |
| **現在のセッションだけで一時的に設定**       | `SET NAME=VALUE`     | `$env:NAME = "VALUE"`                                               |
