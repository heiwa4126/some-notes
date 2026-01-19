# powershell-note

PowerShell はクソ。遅い。長い。わけがわからない。v7 でも変わらない
Powershell が絡むとすべてがめんどくさくなる
(諸悪の根源は MS の提供するコマンドレットの品質)。

建て増しを重ねた温泉旅館。火事になると大勢が焼け死ぬ。

- [Powershell の常識、世間の非常識](#powershell-の常識世間の非常識)
- [Powershell のいいところ](#powershell-のいいところ)
- [いつもの呪文](#いつもの呪文)
  - [この呪文のいらない実行の仕方](#この呪文のいらない実行の仕方)
- [module の場所](#module-の場所)
- [インストールされているモジュールをリスト](#インストールされているモジュールをリスト)
- [type()とメンバー](#typeとメンバー)
- [モジュールの削除](#モジュールの削除)
- [strict モード](#strict-モード)
- [エラーがあったらそこで止まる](#エラーがあったらそこで止まる)
- [相対パスで Import-Module](#相対パスで-import-module)
- [using module](#using-module)
- [unit test](#unit-test)
- [namespace](#namespace)
- [function の型ノート](#function-の型ノート)
- [Powershell の長いプロンプトを短くする](#powershell-の長いプロンプトを短くする)
  - [vscode の場合](#vscode-の場合)
- [vscode の terminal で使う powershell を v6,v7 にする](#vscode-の-terminal-で使う-powershell-を-v6v7-にする)
- [TIPS](#tips)
- [isFile, isDir のたぐい](#isfile-isdir-のたぐい)
- [Powershell で bash の '\&' みたいの](#powershell-で-bash-の--みたいの)
- [Powershell で、プロパティ全部出す](#powershell-でプロパティ全部出す)
- [Powershell の補完](#powershell-の補完)
- [ea 0](#ea-0)
- [PowerShell で jobs](#powershell-で-jobs)
- [grep の代わり](#grep-の代わり)

## Powershell の常識、世間の非常識

識別子の大文字小文字を区別しない。
(`-eq`ですら。ケースセンシティブな文字列比較は`-ceq`,`-cne`を使う)

## Powershell のいいところ

コマンドレットの機能がすごい。

(副作用もすごい。あまり使われてないコマンドレットだとバグもすごい)

(...なんだか「いいところ」じゃないような気がしてきた)

## いつもの呪文

「このシステムではスクリプトの実行が無効になっているため」が出たら

```powershell
# 管理者権限で
Set-ExecutionPolicy RemoteSigned
# カレントユーザだけだったら
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

参考にならない: [about_Execution_Policies - PowerShell | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_execution_policies) - これ見たら普通の人は即死。

### この呪文のいらない実行の仕方

ユーザが.bat で実行する時など

```bat
cd /d %~dp0
powershell -ExecutionPolicy RemoteSigned .\hugahoge.ps1
```

## module の場所

```powershell
$env:PSModulePath
```

## インストールされているモジュールをリスト

```powershell
Get-InstalledModule # 全モジュール
Get-InstalledModule -name Az # Azだけ
Get-InstalledModule -Name Az -AllVersions # Azの全バージョン
```

[Get-InstalledModule](https://docs.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershell-6)

## type()とメンバー

```powershell
$o.GetType()
$o|Get-Member
```

## モジュールの削除

参考になる: [Azure PowerShell のアンインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/azure/uninstall-az-ps?view=azps-2.8.0)

## strict モード

使わないと死ぬ。

```powershell
Set-StrictMode -Version Latest
```

## エラーがあったらそこで止まる

普通が普通じゃない PowerShell の世界。

```powershell
$ErrorActionPreference = "Stop"
```

参考:
[PowerShell のエラーハンドリングを(今度こそ)理解する - Qiita](https://qiita.com/mkht/items/24da4850f9d000b35fc4#%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%AE%E7%A8%AE%E9%A1%9E)

## 相対パスで Import-Module

[powershell - relative path in Import-Module - Stack Overflow](https://stackoverflow.com/questions/14382579/relative-path-in-import-module)

```powershell
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module $ScriptDir\..\MasterScript\Script.ps1
```

あとネームスペースもどきは Import-Module の-prefix オプションでできる。

参考: [PowerShell でも名前空間を作りたい - Qiita](https://qiita.com/nimzo6689/items/2c5c504f0340b4e5d236)

モジュールはバージョンがかわらないとリロードされないので、
デバッグ中は
Import-Module で-force オプションをつける。

- [PowerShell モジュールマニフェストを記述する方法 - PowerShell | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7)
- [How to force a module function definition to reload without starting a new Powershell session? - Stack Overflow](https://stackoverflow.com/questions/55736597/how-to-force-a-module-function-definition-to-reload-without-starting-a-new-power)

## using module

(コメントを除く)コードの先頭に書かなきゃならないのが辛い。

[about_Using - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-7)

パスは呼び出すスクリプトからの相対パスが使える。cwd とは無関係。
Import-Module は相対パスが難しい。

Import-Module の-force オプションに相当するものがない。
remove-module もダメ。

- [Using Statement: Import PowerShell Classes from Modules - SAPIEN Information Center | SAPIEN Information Center](https://info.sapien.com/index.php/scripting/scripting-classes/import-powershell-classes-from-modules)
- ["Using module" statement does not reload module after changes are made · Issue #7654 · PowerShell/PowerShell](https://github.com/PowerShell/PowerShell/issues/7654)

にあるように vscode なら毎回セッションを再起動する設定があるので(遅い)、
それを使う。

> File ->Preferences -> Settings -> PowerShell > Debugging: Create Temporary

`powershell Create Temporary`で検索できる。

PowerShell はクソ。

その後:

new の wapper 書いて
そいつを`Export-ModuleMember -Function`して
`Import-Module -Force`してやれば
いちおういける。

開発中は ↑ で
本番では`using module`にすればいい。
ただし Export-ModuleMember の関数は全滅するので
new ラッパも[class]::new に置き換える...

やっぱり PowerShell はクソ。

↑Import-Module の-prefix でインチキ namespace つかった場合。
もうラッパーだとあきらめるほうがいいかも。

## unit test

`Pester`というのがあるらしい。

- [pester/Pester: Pester is the ubiquitous test and mock framework for PowerShell.](https://github.com/pester/Pester)
- [PowerShell でユニットテスト(Pester) - Qiita](https://qiita.com/Kosen-amai/items/1f36ce59a768e7f9e869)

.test.ps1 を実行するしかけ。

## namespace

[PowerShell 5.0 で搭載された using namespace シンタックスの概要 - tech.guitarrapc.cóm](https://tech.guitarrapc.com/entry/2015/08/30/082605)

> クラス構文の返戻値の型宣言には使えないので気を付けてください

やっぱり PowerShell はクソ。

## function の型ノート

強制力はないんだけど記述する方針で。
ただ構文がキチガイじみてる。
class メソッドと記述方法が違うのも異常。

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

## Powershell の長いプロンプトを短くする

ものすごく役に立つ tips.

[PowerShell のプロンプトを短くする方法 | mrkmyki@フリーランスブログ](https://mrkmyki.com/powershell%E3%81%AE%E3%83%97%E3%83%AD%E3%83%B3%E3%83%97%E3%83%88%E3%82%92%E7%9F%AD%E3%81%8F%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)

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

途中のディレクトリがない場合は、mkdir してください。

[PowerShell 5 と 6 で Profile の場所が違う](http://www.vwnet.jp/Windows/PowerShell/2018032601/PS6Profile.htm)

```
PS5 : %userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
PS6 : %userprofile%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

**ここ参照。だいたいなんでも書いてある。**
[プロファイルについて \- PowerShell \| Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.2)

プロファイルパスはケースバイケースなので powershell で

```powershell
$PROFILE
```

で。

### vscode の場合

[visual studio code - Hiding the full file path in a PowerShell command prompt in VSCode - Stack Overflow](https://stackoverflow.com/questions/52107170/hiding-the-full-file-path-in-a-powershell-command-prompt-in-vscode)

## vscode の terminal で使う powershell を v6,v7 にする

だって倍早いし。

[How to Configure Visual Studio Code to run PowerShell for Windows and PowerShell Core Simultaneously](https://techcommunity.microsoft.com/t5/itops-talk-blog/configure-visual-studio-code-to-run-powershell-for-windows-and/ba-p/283258)

UI からできます。

## TIPS

便利なリンクなど

- [PoweShell でのファイル出力方法あれこれ - Qiita](https://qiita.com/gtom7156/items/066fe8a8d48394bdbaa4)
- [【PowerShell】ローカルのホスト名(コンピューター名)を取得する方法 - buralog](https://buralog.jp/powershell-get-hostname-or-computername/)

## isFile, isDir のたぐい

よくネットで見るのは PSIsContainer で識別する方法だけど、
レジストリが来たら大惨事に (例: `HKCU:\`)。

知りたいのは
**「ファイルシステム上のファイル(かディレクトリ)」**
なのだ。

正しい流れはこんな感じ。Get-Item のところは適切に

```
$i = Get-Item -LiteralPath $file -ErrorAction silent
$i -eq $null # -> 存在しない
$i -is [System.IO.DirectoryInfo] # -> ディレクトリ
$i -is [System.IO.FileInfo] # -> ファイル
## -> それ以外のなにか
```

`LiteralPath`にしてるのは glob 避け。

## Powershell で bash の '&' みたいの

```sh
a ; b & c & d & e
```

みたいのを Powershell でやる方法。
(cmd.exe でできればもっといいのだがそれはさすがに無理でしょう)

- [Powershell equivalent of bash ampersand (&) for forking/running background processes - Stack Overflow](https://stackoverflow.com/questions/185575/powershell-equivalent-of-bash-ampersand-for-forking-running-background-proce)
- [Start\-Job \(Microsoft\.PowerShell\.Core\) \- PowerShell \| Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Core/Start-Job?view=powershell-7.1)

書いた。
[heiwa4126/powershell-bg: bash で `a; b & c & d ; e` みたいのを Powershell でやるサンプル。](https://github.com/heiwa4126/powershell-bg)

## Powershell で、プロパティ全部出す

なんかプロパティを全部出さない機能があって不便。
回避する例(`Get-NetAdapter`で)

```powershell
Get-NetAdapter
## 不便

Get-NetAdapter | fl
## コンソール向け

Get-NetAdapter | select * | out-grid
## GUI向け
```

## Powershell の補完

tab よりも ctrl+space が便利。

他、tab 補完を bash 風にする

```powershell
Set-PSReadLineKeyHandler -Key Tab -Function Complete
```

[PowerShell の Tab 補完を bash のようにする - minus9d's diary](https://minus9d.hatenablog.com/entry/2021/01/13/214844)

## ea 0

`-ErrorAction SilentlyContinue` のかわりに `-ea 0` と書ける。便利

## PowerShell で jobs

`foo &` でバックグランド起動できる。

| linux(bash) | PowerShell                                                                                                                 |
| ----------- | -------------------------------------------------------------------------------------------------------------------------- |
| jobs        | [Get-Job](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/get-job?view=powershell-7.4)       |
| kill %1     | [Remove-Job](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/remove-job?view=powershell-7.4) |

その他

- [Stop-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/stop-job?view=powershell-7.4)
- [Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.4)
- [Receive-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://learn.microsoft.com/ja-jp/powershell/module/microsoft.powershell.core/receive-job?view=powershell-7.4)

[PowerShell で処理をバックグラウンドで実行する | 晴耕雨読](https://tex2e.github.io/blog/powershell/background-job)

## grep の代わり

```powershell
# ファイル名に fooが含まれるものをリスト
ls | where Name -match "foo"
ls | where Name -like "*foo*"

# ファイル中に fooが含まれるものをリスト
ls | Select-String -Pattern "foo"
ls | sls "foo" # エリアスとデフォルトオプションで
sls foo *
```
