# Azure Functions 忘備録

Ubuntu 18.04LTS上でPythonでAzure Functionsを書くメモ。
AWS Lambdaと全然違う。

- [Azure Functions 忘備録](#azure-functions-忘備録)
- [Azure Functionsで使える言語](#azure-functionsで使える言語)
- [以下の記事はやや古いけど参考にはなります](#以下の記事はやや古いけど参考にはなります)
- [Azure Functions リファレンス](#azure-functions-リファレンス)
- [functionsの開発にいるもの](#functionsの開発にいるもの)
- [リンク](#リンク)
  - [Azure CLI](#azure-cli)
  - [Azure Functions Core Tools](#azure-functions-core-tools)
  - [日本語ドキュメント](#日本語ドキュメント)
- [Pythonの制限(2019-7)](#pythonの制限2019-7)
  - [前提](#前提)
  - [準備](#準備)
- [InsightsのLog Analytics(Azure Monitor)で使えるクエリサンプル](#insightsのlog-analyticsazure-monitorで使えるクエリサンプル)
- [Azure Functions Core Toolsのインストール](#azure-functions-core-toolsのインストール)
  - [Windowsの場合](#windowsの場合)
- [Azure Functionsのデプロイがめんどくさすぎる問題](#azure-functionsのデプロイがめんどくさすぎる問題)
  - [発端](#発端)
  - [調査](#調査)
  - [結論](#結論)
  - [結論0](#結論0)
  - [結論1](#結論1)
  - [結論2](#結論2)
- [Linux](#linux)
- [nodejs v12 LTS](#nodejs-v12-lts)
- [未整理メモ](#未整理メモ)
- [ホスティング プラン](#ホスティング-プラン)
- [よく使うfuncコマンド](#よく使うfuncコマンド)
  - [デプロイ](#デプロイ)
  - [設定のダウンロード](#設定のダウンロード)
- [HTTPトリガのauthLevel](#httpトリガのauthlevel)
- [invoke](#invoke)
- [テレメトリー](#テレメトリー)
- [Docker](#docker)
- [時は流れて2022-09](#時は流れて2022-09)

# Azure Functionsで使える言語

[Azure Functions ランタイム バージョンの概要 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-versions#languages)

ただし課金プランで、いちばん安い「従量課金プラン」が使える言語は限られる。
(従量課金プランは消費量プラン、`Consumption plan`とも言う)

[Azure Functions での従量課金プランのコストの見積もり | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-consumption-costs)




# 以下の記事はやや古いけど参考にはなります

^^^^^^^^^^^^^^^

# Azure Functions リファレンス

- [Azure Functions のドキュメント | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/)


# functionsの開発にいるもの

最低限必要なもの:

- Azureのサブスクリプション
- [Azure CLI](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli)
- Node.js 10.x (12は今はダメ)
- [Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2) 2.x
- Python, JDK, .NET Core etc

あると便利なもの:

- [Visual Studio Code](https://code.visualstudio.com/)

チュートリアル [Visual Studio Code を使用して Azure で初めての関数を作成する](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-vs-code)にはVScode+ExtensionやVisual Studioが必須のように書かれていますが、funcコマンドでなんとでもなる。


# リンク

## Azure CLI

- [Azure/azure-cli: Command-line tools for Azure.](https://github.com/Azure/azure-cli)
- [Azure/azure-powershell: Microsoft Azure PowerShell](https://github.com/Azure/azure-powershell)

## Azure Functions Core Tools

[Azure/azure-functions-core-tools: Command line tools for Azure Functions](https://github.com/Azure/azure-functions-core-tools)

Azure Functions Runtime 2.0.12850が2019-10-29に出てた。


## 日本語ドキュメント

[azure-docs.ja-jp/articles/azure-functions at master · MicrosoftDocs/azure-docs.ja-jp](https://github.com/MicrosoftDocs/azure-docs.ja-jp/tree/master/articles/azure-functions)


# Pythonの制限(2019-7)

v2.7.1724

- [Azure Functions on Linux Preview · Azure/Azure-Functions Wiki · GitHub](https://github.com/Azure/Azure-Functions/wiki/Azure-Functions-on-Linux-Preview)

Japan EastでもPython使えるみたい(2019-10)

使えるリージョンがいまのところ
- West US
- East US
- West Europe
- East Asia

GUIも使えたり使えなかったり。
コードの編集も
テストランもできません。

あと
Premiumプラン、
App Serviceプランだけなので、
「少なくとも 1 つのインスタンスが常にウォーム状態である必要があります。 つまり、実行数に関係なく、アクティブなプランごとに固定の月額コストがかかります」
のは同じ。

[Azure Functions のスケールとホスティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-scale#premium-plan)


## 前提

ここから開始→ [Azure で HTTP によってトリガーされる関数を作成する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-python)

> Python 3.6 のインストール

は省略。本当に必要なのかはわからないがvenvを使うので
```
sudo apt-get install python3-venv
```
しておく。

> Azure CLI バージョン 2.x 以降をインストールします。

[Azure CLI のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli?view=azure-cli-latest)
参照。


> Azure Functions Core Tools バージョン 2.6.666 以降をインストールします。

[Azure Functions Core Tools の操作 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2)参照

Azure CLI入れてあるなら下の手順はスキップ
``` bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
```

次に
``` bash
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
```

さらに
```
sudo apt-get install azure-functions-core-tools
```

## 準備

作業ディレクトリ作る & 移動
```
mkdir works/azure
cd !$
```

ローカル関数プロジェクトを作成
```
func init MyFunctionProj
cd MyFunctionProj
```

venv環境作成
```
python3 -m venv .env
```

venv環境へ移動(毎回最初に実行)
```
ource .env/bin/activate
```

```
pip install -r requirements.txt
```

ローカル設定ファイル`local.settings.json`で
AzureWebJobsStorageの接続文字列を編集する。
設定しないとfunctionはなにも動かないので仕方がない。
[Azure ストレージ エミュレーター](https://docs.microsoft.com/ja-jp/azure/storage/common/storage-use-emulator)も使えるらしいのだが、Linux版が無い。

[ストレージ接続文字列の取得](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#get-your-storage-connection-strings)を参考にして接続文字列を得る。

この設定はあとで`func azure functionapp fetch-app-settings <APP_NAME>`で上書きされる。
先にポータルでfunction作ってからのほうが楽かもしれない。



関数つくる。中身は空で。
``` bash
func new --template "Http Trigger" --name HttpTrigger1
func new --template "Timer Trigger" --name TimerTrigger1
```

ホスト起動
``` bash
func host start
```

関数を呼ぶ。とりあえず引数無しで。

HttpTrigger1の方
``` bash
$ curl --get http://localhost:7071/api/HttpTrigger1?name=Azure%20Rocks
Hello Azure Rocks!
```

TimerTrigger1の方
``` bash
curl -i http://localhost:7071/admin/functions/TimerTrigger1
```
これでJSONがずらずら帰ってくれば、とりあえずOK。

一方Storageの方に `azure-webjobs-hosts`というのができてるはず。


venvの環境は`~/.env/lib/python3.6/site-packages`からモジュールを読むので
```
pip install -r requirements.txt -U -t ~/.env/lib/python3.6/site-packages
```
みたいなことが必要(当たってる?)。


# InsightsのLog Analytics(Azure Monitor)で使えるクエリサンプル

参考:
- [Overview - Azure Data Explorer | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/kusto/query/)


普通のlogっぽい出力を得る
```
traces | top 100 by timestamp desc | project timestamp, message
```

過去60分以内のerrorレベルのログを出す。
```
union traces
| union exceptions
| where timestamp > ago(60m)
| where customDimensions.LogLevel == "Error"
| order by timestamp desc
```
これは実際に使った。
count>0のとき、メール送るアクショングループを起動する、という感じで(期間60分頻度5分)


# Azure Functions Core Toolsのインストール

[Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2)

## Windowsの場合

まとめると、今現在(2019-10)では

1. node 10.xを先に入れる(12もLTSだが、Azure Functions Core Toolsが対応していない) - これ12.xも使えるようになった(2020-04)
2. Chocolatey入れる
3. ChocolateyでAzure Functions Core Toolsいれる

の順で。


WindowsだとChocolatey でインストールしないと`func`が動かない。
(npmでもproxyが邪魔で入らない場合があるけど、それとは別)

```
C:\>func -v
internal/child_process.js:366
    throw errnoException(err, 'spawn');
(略)
```
何かがたりないんだと思うけど、何だかはわからない。

管理者権限で
```
choco install azure-functions-core-tools
```

結果
```
C:\>func -v
2.7.1724
```

そもそもChocolateyが入ってない場合は
[Chocolatey Software | Installing Chocolatey](https://chocolatey.org/install)
参照。


# Azure Functionsのデプロイがめんどくさすぎる問題

開発をしない、デプロイだけする人のことを考えたときに(SIer的な)
AWS Lambdaみたいな「ポータルからZIPでデプロイ」が無いのは辛い、という話。

開発者にとっては、かなり便利()
[Azure Functions のデプロイ テクノロジ | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-deployment-technologies)



## 発端

たとえばnodejsの場合、
チュートリアル [Visual Studio Code を使用して Azure で初めての関数を作成する](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-vs-code)
によれば、

- [Azure CLI](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Node.js](https://nodejs.org/) 推奨は8.xか10.x
- [Visual Studio Code](https://code.visualstudio.com/)
- [Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2) 2.x
- VSCodeに [Azure Functions 拡張機能](vscode:extension/ms-azuretools.vscode-azurefunctions)

を揃えて、なおかつPortalでいろいろやんなくちゃならないのは辛い。
apt/yum、msi/msixまではともかく、
AWS Lambdaみたいにzipでなんとかならないのか(なるよね?)
を確かめる。

参考: [Azure Functions の zip プッシュ デプロイ | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/deployment-zip-push)

## 調査

まず上のような開発環境で作る & 動作確認

できあがったものがこちら →
[heiwa4126/hello-function: Azure Functions & nodejs。vscodeを使った開発環境と、デプロイ用のzipを作るテスト](https://github.com/heiwa4126/hello-function)

## 結論

Azure CLIでzipを発行するのが


ポータルで、該当functionから、プラットフォーム->デプロイセンター
様々なデプロイが選べる。

- 継続的配置 (CI/CD)
- 手動配置 (プッシュ/同期)

の2種類がある。とりあえず手動配置(構成後「同期」ボタンをおして配信)の方から選ぶ。

## 結論0

[Azure Functions の zip プッシュ デプロイ](https://docs.microsoft.com/ja-jp/azure/azure-functions/deployment-zip-push)
にある通りの[Azure PowerShell](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps?view=azps-2.8.0)(Azure CLIとは違う)を使ったデプロイ。

※ Azure CLI (python版)にも同じコマンドがあるので、
無理にpowershell版をいれなくてもOK。
下のコマンドも行継続キャラを'^'にするだけでbatになる。Linuxとかでも同様にできる。

ポータルでfunctionを作り、azure powershellでazureにlogin後、
``` powershell
az functionapp deployment source config-zip `
 -g <functionのリソースグループ> `
 -n <function名> `
 --src <zipfile名>
```

実際に実行すると出力はこんな感じ(Powershell版)
```
az : WARNING: Getting scm site credentials for zip deployment
At C:\Users\heiwa4126\Documents\Projects\func-check-url-nodejs-zip\deploy1.ps1:1 char:1
+ az functionapp deployment source config-zip `
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (WARNING: Gettin... zip deployment:String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError

WARNING: Starting zip deployment. This operation can take a while to complete ...
{
  "active": true,
  "author": "N/A",
  "author_email": "N/A",
  "complete": true,
  "deployer": "Push-Deployer",
  (略)
}
```
ログ出力代わりにwarning出すな、といいたい(Python版のAzure CLIでは警告でません)。

Azure powershellのインストールがめんどくさいので、
最初の1回とか、二度と変更しないような場合に使う。

Azure Functions Core Toolsが入っていれば
``` bash
func azure functionapp publish <app name> --build remote
```
の方が楽。



## 結論1

自分でデプロイするなら、External。

> パブリックの Git または Mercurial リポジトリからデプロイします。

「パブリックの」はインタネット上の、ぐらいの意味で、pullさえできれば
GitHubのprivateレポジトリでもOK

プラットフォーム->デプロイセンター->External->続行->App Service のビルド サービス->続行

- リポジトリ
- ブランチ
- リポジトリの種類 - Mercurial｜Git
- プライベート リポジトリ - いいえ｜はい
- ユーザー名 (プライベート リポジトリを「はい」にしたとき)
- パスワード (プライベート リポジトリを「はい」にしたとき)

最初の1回目は自動的にpull & npm install & functionの再起動が行われる。
2回め以降は「同期」ボタン。

これはなかなか便利なので、TODO:
- AWS lambdaでも同様のことができないか試す。
- 継続的配置のGitHubのほうも試す。


## 結論2

gitってなんだ? っていう人が扱う場合には、FTPS

zipのダウンロードは

ポータルで、該当functionから、
アプリのコンテンツのダウンロード
サイトのコンテンツ、「ダウンロードにアプリ設定を含める」はチェックしない
ダウンロードボタン (たぶんcliでできる)

FTPSクライアントはWinSCPが使える。

ポータルで、該当functionから、

プラットフォーム->デプロイセンター->FTP->ダッシュボード

FTPSエンドポイント
アプリの資格情報タブで
ユーザ名
パスワード

これをWinSCPにコピペして、オープンしたら、
zipの中身を上書きコピーする。

functionsの再起動はしないようなので、
関数の停止/開始を行う(再起動ではダメだった)。

gitでデプロイ、と違って、npm installはやってくれないみたいで、
node_modules以下も必要で、転送サイズが大きくなりがち。

# Linux

Azure FunctionsでLinuxを使うとデプロイセンターが使えない。



# nodejs v12 LTS

(この項は古い。2020-04現在12.x使える)

nodejs v12.13 LTSが出たので、アップグレードしたら
[Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2)
が、

```
[2019/10/23 2:32:53] [error] Incompatible Node.js version. The version you are using is
v12.13.0, but the runtime requires an LTS-covered major version (ex: 8.11.1 or 10.14.1). LTS-covered versions have an even major version number (8.x, 10.x, etc.) as per https://github.com/nodejs/Release#release-plan. For deployed code, change WEBSITE_NODE_DEFAULT_VERSION in App Settings. Locally, install or switch to a supported node version (make sure to quit and restart your code editor to pick up the changes).
```

とか言って死ぬ。

```
npm update -g azure-functions-core-tools
```
してもダメだった。

Functionsの開発環境はしばらく10.xで。



# 未整理メモ

「とりあえず」仕様

出力はInsightsのLog Analyticsに特殊な先頭文字付きで出し、
Kustoクエリで
```
traces
| where (cloud_RoleName == "hello9vaglet") and (isempty(severityLevel) != true ) and ( message matches regex "^\\*\\*\\*\\*\\ " )
| project timestamp, message
```
みたいな感じで。

queueに出力も簡単にできるのだが、意外とリードアウトがめんどくさい。


欠点: Log Analyticsへの出力が死ぬほど遅い。


# ホスティング プラン

[Azure Functions のスケールとホスティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-scale)


# よく使うfuncコマンド

## デプロイ

``` bash
func azure functionapp publish <APP_NAME> --build remote
```
`--build remote`オプションをつけるとリモートビルドする(
`pip install -r requirements.txt`や
`npm install`をリモートでやってくれるらしい)

## 設定のダウンロード

``` bash
func azure functionapp fetch-app-settings <APP_NAME>
```
local.settings.jsonに設定をダウンロードしてくれる。


# HTTPトリガのauthLevel

functio.jsonのauthLevelで

- anonymous - わかる
- function - わかる。「関数固有の API キーが必要です。 何も指定されなかった場合は、これが既定値になります」
- admin - わからん。「マスター キーが必要です」

- [承認キー](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-bindings-http-webhook#authorization-keys)
- [Azure API Management の認証ポリシー | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/api-management/api-management-authentication-policies)

# invoke

AWS CLIの `aws lambda invoke` に相当するものがないらしい。

たぶん以下のどちらかで実現できる

- [Azure Functions における Azure Queue Storage のバインド | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-bindings-storage-queue)
- [Azure Functions における Azure Service Bus のバインド | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-bindings-service-bus)


これも使えるかも。
- [Durable Functions の概要 - Azure | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/durable/durable-functions-overview)
- [GitHub - Azure/azure-functions-durable-js: JavaScript library for using the Durable Functions bindings](https://github.com/Azure/azure-functions-durable-js)

# テレメトリー

```
Telemetry
---------
The Azure Functions Core tools collect usage data in order to help us improve your experience.
The data is anonymous and doesn't include any user specific or personal information. The data is collected by Microsoft.

You can opt-out of telemetry by setting the FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT environment variable to '1' or 'true' using your favorite shell.
```
ということなので~/.profileなどに`FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1`とか書いておく。

see: [Azure/azure-functions-core-tools: Command line tools for Azure Functions](https://github.com/Azure/azure-functions-core-tools)

# Docker

Azure Functionsでdockerを使うと、Functionを停止しても料金が発生するので、辛い。

Linuxベースのfunctions(Pythonとか)はそうではなかったような気がする。


# 時は流れて2022-09

[コマンド ラインから Python 関数を作成する - Azure Functions | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/create-first-function-cli-python?tabs=azure-cli%2Cbash%2Ccurl)

それでもCLIコマンドたくさん必要で、
ちょっとしたスクリプト用意しないといけない。
プロジェクトをgit cloneして `sam build && sam deploy --guided` みたいには行かない。

デプロイ全般にわたって遅い。
リソースグループのデプロイが空だ(ARM templateが一切使われていない)。

リソースグループ消すと全部消えるのは好き。

これ便利。`az config param-persist on`
[永続化されたパラメーター オプション – Azure CLI | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/param-persist-howto)

Terraformのほうがよさそう。
[Deploy Azure Functions with Terraform](https://www.maxivanov.io/deploy-azure-functions-with-terraform/)
