# powershell-note

遅い。長い。わけがわからない
Powershellが絡むとすべてがめんどくさくなる。

# moduleの場所

``` powershell
$env:PSModulePath
```

# インストールされているモジュール

``` powershell
Get-InstalledModule # 全モジュール
Get-InstalledModule -name Az # Azだけ
Get-InstalledModule -Name Az -AllVersions # Azの全バージョン

```

[Get-InstalledModule](https://docs.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershell-6)


# モジュールの削除

参考になる: [Azure PowerShell のアンインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/uninstall-az-ps?view=azps-2.8.0)