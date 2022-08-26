# Azure PowerShell メモ

遅くて嫌い。PowerShell 7でも遅い。

インストール
```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

# 実行例

ロケーション一覧をsortして出力:
```powershell
Get-AzLocation | select Location | Sort Location
```

`Location`が2つ要るところが不愉快。
