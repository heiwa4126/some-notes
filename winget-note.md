# winget のメモ

## コマンド

```pwsh
# wingetでローカルにインストールされている全リスト
winget list
# アップグレード可能なもの
winget upgrade
winget list --upgrade-available
winget list --upgrade-available --include-unknown
# アップグレード
winget upgrade <package_name>
winget upgrade --all
# 確認なしで全アップグレード
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
```

## wingetのレポジトリ

[WinGet ソース コマンド | Microsoft Learn](https://learn.microsoft.com/ja-jp/windows/package-manager/winget/source)
