# powershell-note

遅い。長い。わけがわからない。
Powershellが絡むとすべてがめんどくさくなる
(諸悪の根源はMSの提供するコマンドレットの品質)。

- [powershell-note](#powershell-note)
- [いつもの呪文](#いつもの呪文)
  - [この呪文のいらない実行の仕方](#この呪文のいらない実行の仕方)
- [moduleの場所](#moduleの場所)
- [インストールされているモジュールをリスト](#インストールされているモジュールをリスト)
- [モジュールの削除](#モジュールの削除)
- [相対パスでImport-Module](#相対パスでimport-module)


# いつもの呪文

管理者権限で

``` powershell
Set-ExecutionPolicy RemoteSigned
```
参考にならない: [about_Execution_Policies - PowerShell | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_execution_policies) - これ見たら普通の人は即死。

## この呪文のいらない実行の仕方

ユーザが.batで実行する時など
``` bat
cd /d %~dp0
powershell -ExecutionPolicy RemoteSigned .\hugahoge.ps1
```


# moduleの場所

``` powershell
$env:PSModulePath
```

# インストールされているモジュールをリスト

``` powershell
Get-InstalledModule # 全モジュール
Get-InstalledModule -name Az # Azだけ
Get-InstalledModule -Name Az -AllVersions # Azの全バージョン
```

[Get-InstalledModule](https://docs.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershell-6)


# モジュールの削除

参考になる: [Azure PowerShell のアンインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/uninstall-az-ps?view=azps-2.8.0)

# 相対パスでImport-Module

[powershell - relative path in Import-Module - Stack Overflow](https://stackoverflow.com/questions/14382579/relative-path-in-import-module)

```powershell
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\..\MasterScript\Script.ps1
```

あとネームスペースもどきはImport-Moduleの-prefixオプションでできる。

参考: [PowerShell でも名前空間を作りたい - Qiita](https://qiita.com/nimzo6689/items/2c5c504f0340b4e5d236)
