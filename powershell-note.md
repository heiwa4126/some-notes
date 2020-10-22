# powershell-note

PowerShellはクソ。遅い。長い。わけがわからない。v7でも変わらない
Powershellが絡むとすべてがめんどくさくなる
(諸悪の根源はMSの提供するコマンドレットの品質)。

- [powershell-note](#powershell-note)
- [Powershellの常識、世間の非常識](#powershellの常識世間の非常識)
- [いつもの呪文](#いつもの呪文)
  - [この呪文のいらない実行の仕方](#この呪文のいらない実行の仕方)
- [moduleの場所](#moduleの場所)
- [インストールされているモジュールをリスト](#インストールされているモジュールをリスト)
- [type()とメンバー](#typeとメンバー)
- [モジュールの削除](#モジュールの削除)
- [strictモード](#strictモード)
- [エラーがあったらそこで止まる](#エラーがあったらそこで止まる)
- [相対パスでImport-Module](#相対パスでimport-module)
- [using module](#using-module)
- [unit test](#unit-test)
- [namespace](#namespace)


# Powershellの常識、世間の非常識

識別子の大文字小文字を区別しない。


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


# type()とメンバー

```powershell
$o.GetType()
$o|Get-Member
```


# モジュールの削除

参考になる: [Azure PowerShell のアンインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/uninstall-az-ps?view=azps-2.8.0)


# strictモード

使わないと死ぬ。

```powershell
Set-StrictMode -Version Latest
```

# エラーがあったらそこで止まる

普通が普通じゃないPowerShellの世界。

```powershell
$ErrorActionPreference = "Stop"
```

参考:
[PowerShell のエラーハンドリングを（今度こそ）理解する - Qiita](https://qiita.com/mkht/items/24da4850f9d000b35fc4#%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%AE%E7%A8%AE%E9%A1%9E)

# 相対パスでImport-Module

[powershell - relative path in Import-Module - Stack Overflow](https://stackoverflow.com/questions/14382579/relative-path-in-import-module)

```powershell
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\..\MasterScript\Script.ps1
```

あとネームスペースもどきはImport-Moduleの-prefixオプションでできる。

参考: [PowerShell でも名前空間を作りたい - Qiita](https://qiita.com/nimzo6689/items/2c5c504f0340b4e5d236)

モジュールはバージョンがかわらないとリロードされないので、
デバッグ中は
Import-Moduleで-force オプションをつける。


- [PowerShell モジュールマニフェストを記述する方法 - PowerShell | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7)
- [How to force a module function definition to reload without starting a new Powershell session? - Stack Overflow](https://stackoverflow.com/questions/55736597/how-to-force-a-module-function-definition-to-reload-without-starting-a-new-power)


# using module

(コメントを除く)コードの先頭に書かなきゃならないのが辛い。

[about_Using - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-7)

パスは呼び出すスクリプトからの相対パスが使える。cwdとは無関係。
Import-Moduleは相対パスが難しい。

Import-Moduleの-forceオプションに相当するものがない。
remove-moduleもダメ。

- [Using Statement: Import PowerShell Classes from Modules - SAPIEN Information Center | SAPIEN Information Center](https://info.sapien.com/index.php/scripting/scripting-classes/import-powershell-classes-from-modules)
- ["Using module" statement does not reload module after changes are made · Issue #7654 · PowerShell/PowerShell](https://github.com/PowerShell/PowerShell/issues/7654)

にあるようにvscodeなら毎回セッションを再起動する設定があるので(遅い)、
それを使う。

> File ->Preferences -> Settings -> PowerShell > Debugging: Create Temporary

`powershell Create Temporary`で検索できる。

PowerShellはクソ。


その後:

newのwapper書いて
そいつを`Export-ModuleMember -Function`して
`Import-Module -Force`してやれば
いちおういける。

開発中は↑で
本番では`using module`にすればいい。
ただしExport-ModuleMemberの関数は全滅するので
newラッパも [class]::new に置き換える...

やっぱりPowerShellはクソ。

↑Import-Moduleの-prefixでインチキnamespaceつかった場合。
もうラッパーだとあきらめるほうがいいかも。


# unit test

`Pester`というのがあるらしい。

- [pester/Pester: Pester is the ubiquitous test and mock framework for PowerShell.](https://github.com/pester/Pester)
- [PowerShellでユニットテスト(Pester) - Qiita](https://qiita.com/Kosen-amai/items/1f36ce59a768e7f9e869)

.test.ps1を実行するしかけ。


# namespace

[PowerShell 5.0 で搭載された using namespace シンタックスの概要 - tech.guitarrapc.cóm](https://tech.guitarrapc.com/entry/2015/08/30/082605)

> クラス構文の返戻値の型宣言には使えないので気を付けてください

やっぱりPowerShellはクソ。
