# Azure PowerShell メモ

遅くて嫌い。PowerShell 7でも遅い。

インストール
```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
```

サインイン
```powershell
Connect-AzAccount
```
[Azure PowerShell を使用してサインインする \| Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/authenticate-azureps?view=azps-8.2.0)

サブスクリプションのリストと切替
```powershell
Get-AzSubscription
Set-AzContext -SubscriptionId "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
```
[Azure PowerShell でサブスクリプションを切り替える | Windows 実践ガイド](https://win2012r2.com/2021/03/02/azure-powershell-%E3%81%A7%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E5%88%87%E3%82%8A%E6%9B%BF%E3%81%88%E3%82%8B/)
 


# 実行例

ロケーション一覧をsortして出力:
```powershell
Get-AzLocation | select Location | Sort Location
```

`Location`が2つ要るところが不愉快。
