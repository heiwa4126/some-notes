# Azure PowerShell メモ

遅くて嫌い。PowerShell 7 でも遅い。

Windows でも Azure CLI は使えるので、無理に使う必要なし。

```powershell
winget install -e --id Microsoft.AzureCLI
```

[Windows 用 Azure CLI をインストールする | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli-windows?tabs=winget)

# Azure PowerShell を使ってみる

インストール

```powershell
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
# bicepもいるなら
winget install -e --id Microsoft.Bicep
# Azure CLIもいるなら
winget install -e --id Microsoft.AzureCLI
```

- [Azure Az PowerShell モジュールをインストールする | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps)
- [MSI を使用して Azure PowerShell をインストールする | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps-msi)

サインイン

```powershell
Connect-AzAccount
```

[Azure PowerShell を使用してサインインする \| Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/authenticate-azureps)

サブスクリプションのリストと切替

```powershell
Get-AzSubscription
Set-AzContext -SubscriptionId "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
Get-AzContext
```

- [Azure PowerShell でサブスクリプションを切り替える | Windows 実践ガイド](https://win2012r2.com/2021/03/02/azure-powershell-%E3%81%A7%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E5%88%87%E3%82%8A%E6%9B%BF%E3%81%88%E3%82%8B/)
- [\[Azure\]現在のサブスクリプションを確認する – エンジニ屋](https://sevenb.jp/wordpress/ura/2021/04/03/azure-powershell%E7%8F%BE%E5%9C%A8%E6%93%8D%E4%BD%9C%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E7%A2%BA%E8%AA%8D/)

# 実行例

ロケーション一覧を sort して出力:

```powershell
Get-AzLocation | select Location | Sort Location
```

`Location`が 2 つ要るところが不愉快。
