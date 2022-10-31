# powershell-note

PowerShellはクソ。遅い。長い。わけがわからない。v7でも変わらない
Powershellが絡むとすべてがめんどくさくなる
(諸悪の根源はMSの提供するコマンドレットの品質)。

建て増しを重ねた温泉旅館。火事になると大勢が焼け死ぬ。

- [powershell-note](#powershell-note)
- [Powershellの常識、世間の非常識](#powershellの常識世間の非常識)
- [Powershellのいいところ](#powershellのいいところ)
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
- [functionの型ノート](#functionの型ノート)
- [Powershellの長いプロンプトを短くする](#powershellの長いプロンプトを短くする)
  - [vscodeの場合](#vscodeの場合)
- [vscodeのterminalで使うpowershellをv6,v7にする](#vscodeのterminalで使うpowershellをv6v7にする)
- [TIPS](#tips)
- [isFile, isDirのたぐい](#isfile-isdirのたぐい)
- [Powershellで bash の '&' みたいの](#powershellで-bash-の--みたいの)
- [Powershellで、プロパティ全部出す](#powershellでプロパティ全部出す)
- [Powershellの補完](#powershellの補完)
- [ea 0](#ea-0)


# Powershellの常識、世間の非常識

識別子の大文字小文字を区別しない。
(`-eq`ですら。ケースセンシティブな文字列比較は`-ceq`,`-cne`を使う)


# Powershellのいいところ

コマンドレットの機能がすごい。

(副作用もすごい。あまり使われてないコマンドレットだとバグもすごい)

(…なんだか「いいところ」じゃないような気がしてきた)



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


# functionの型ノート

強制力はないんだけど記述する方針で。
ただ構文がキチガイじみてる。
classメソッドと記述方法が違うのも異常。

[about_Functions_OutputTypeAttribute - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_outputtypeattribute?view=powershell-7)

以下(気が付き)にくいテンプレート
```powershell
function Invoke-Notepad
{
  [OutputType([System.Void])]
  Param ()
  & notepad.exe | Out-Null
}
```

# Powershellの長いプロンプトを短くする

ものすごく役に立つtips.

[PowerShellのプロンプトを短くする方法 | mrkmyki＠フリーランスブログ](https://mrkmyki.com/powershell%E3%81%AE%E3%83%97%E3%83%AD%E3%83%B3%E3%83%97%E3%83%88%E3%82%92%E7%9F%AD%E3%81%8F%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)

`%userprofile%\Documents\Powershell`に
`Microsoft.PowerShell_profile.ps1`という名前で
以下のようなプログラムを置く (フォルダがなかったら作る。ファイルがなかったら作る。すでにあればマージ)。

```powershell
function prompt() {
  (Split-Path (Get-Location) -Leaf) + "> "
}
Set-PSReadLineKeyHandler -Key Tab -Function Complete
```

```powershell
echo 'function prompt() {
  (Split-Path (Get-Location) -Leaf) + "> "
}
Set-PSReadLineKeyHandler -Key Tab -Function Complete
' >> $PROFILE
```
途中のディレクトリがない場合は、mkdirしてください。

[PowerShell 5 と 6 で Profile の場所が違う](http://www.vwnet.jp/Windows/PowerShell/2018032601/PS6Profile.htm)

```
PS5 : %userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
PS6 : %userprofile%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

**ここ参照。だいたいなんでも書いてある。**
[プロファイルについて \- PowerShell \| Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2)

プロファイルパスはケースバイケースなのでpowershellで
```powershell
$PROFILE
```
で。

## vscodeの場合

[visual studio code - Hiding the full file path in a PowerShell command prompt in VSCode - Stack Overflow](https://stackoverflow.com/questions/52107170/hiding-the-full-file-path-in-a-powershell-command-prompt-in-vscode)


# vscodeのterminalで使うpowershellをv6,v7にする

だって倍早いし。

[How to Configure Visual Studio Code to run PowerShell for Windows and PowerShell Core Simultaneously](https://techcommunity.microsoft.com/t5/itops-talk-blog/configure-visual-studio-code-to-run-powershell-for-windows-and/ba-p/283258)

UIからできます。

# TIPS

便利なリンクなど

- [PoweShellでのファイル出力方法あれこれ - Qiita](https://qiita.com/gtom7156/items/066fe8a8d48394bdbaa4)
- [【PowerShell】ローカルのホスト名(コンピューター名)を取得する方法 - buralog](https://buralog.jp/powershell-get-hostname-or-computername/)


# isFile, isDirのたぐい

よくネットで見るのはPSIsContainerで識別する方法だけど、
レジストリが来たら大惨事に (例: `HKCU:\`)。

知りたいのは
**「ファイルシステム上のファイル(かディレクトリ)」**
なのだ。

正しい流れはこんな感じ。Get-Itemのところは適切に
```
$i = Get-Item -LiteralPath $file -ErrorAction silent
$i -eq $null # -> 存在しない
$i -is [System.IO.DirectoryInfo] # -> ディレクトリ
$i -is [System.IO.FileInfo] # -> ファイル
# -> それ以外のなにか
```
`LiteralPath`にしてるのはglob避け。


# Powershellで bash の '&' みたいの

```sh
a ; b & c & d & e
```
みたいのをPowershellでやる方法。
(cmd.exeでできればもっといいのだがそれはさすがに無理でしょう)

- [Powershell equivalent of bash ampersand (&) for forking/running background processes - Stack Overflow](https://stackoverflow.com/questions/185575/powershell-equivalent-of-bash-ampersand-for-forking-running-background-proce)
- [Start\-Job \(Microsoft\.PowerShell\.Core\) \- PowerShell \| Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Start-Job?view=powershell-7.1)


書いた。
[heiwa4126/powershell-bg: bashで `a; b & c & d ; e` みたいのをPowershellでやるサンプル。](https://github.com/heiwa4126/powershell-bg)


# Powershellで、プロパティ全部出す

なんかプロパティを全部出さない機能があって不便。
回避する例(`Get-NetAdapter`で)

```powershell
Get-NetAdapter
# 不便

Get-NetAdapter | fl
# コンソール向け

Get-NetAdapter | select * | out-grid
# GUI向け
```

# Powershellの補完

tabよりもctrl+spaceが便利。

他、tab補完をbash風にする
```powershell
Set-PSReadLineKeyHandler -Key Tab -Function Complete
```
[PowerShellのTab補完をbashのようにする - minus9d's diary](https://minus9d.hatenablog.com/entry/2021/01/13/214844)

# ea 0

`-ErrorAction SilentlyContinue` のかわりに `-ea 0` と書ける。便利
