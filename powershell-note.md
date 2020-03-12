# powershell-note

遅い。長い。わけがわからない。
Powershellが絡むとすべてがめんどくさくなる
(諸悪の根源はMSの提供するコマンドレットの品質)。

- [powershell-note](#powershell-note)
- [いつもの呪文](#%e3%81%84%e3%81%a4%e3%82%82%e3%81%ae%e5%91%aa%e6%96%87)
  - [この呪文のいらない実行の仕方](#%e3%81%93%e3%81%ae%e5%91%aa%e6%96%87%e3%81%ae%e3%81%84%e3%82%89%e3%81%aa%e3%81%84%e5%ae%9f%e8%a1%8c%e3%81%ae%e4%bb%95%e6%96%b9)
- [moduleの場所](#module%e3%81%ae%e5%a0%b4%e6%89%80)
- [インストールされているモジュールをリスト](#%e3%82%a4%e3%83%b3%e3%82%b9%e3%83%88%e3%83%bc%e3%83%ab%e3%81%95%e3%82%8c%e3%81%a6%e3%81%84%e3%82%8b%e3%83%a2%e3%82%b8%e3%83%a5%e3%83%bc%e3%83%ab%e3%82%92%e3%83%aa%e3%82%b9%e3%83%88)
- [モジュールの削除](#%e3%83%a2%e3%82%b8%e3%83%a5%e3%83%bc%e3%83%ab%e3%81%ae%e5%89%8a%e9%99%a4)


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