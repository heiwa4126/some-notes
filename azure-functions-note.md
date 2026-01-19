# Azure Functions 忘備録

Ubuntu 18.04LTS 上で Python で Azure Functions を書くメモ。
AWS Lambda と全然違う。

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

- Azure のサブスクリプション
- [Azure CLI](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli)
- Node.js 10.x (12 は今はダメ)
- [Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2) 2.x
- Python, JDK, .NET Core etc

あると便利なもの:

- [Visual Studio Code](https://code.visualstudio.com/)

チュートリアル [Visual Studio Code を使用して Azure で初めての関数を作成する](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-vs-code)には VScode+Extension や Visual Studio が必須のように書かれていますが、func コマンドでなんとでもなる。

# リンク

## Azure CLI

- [Azure/azure-cli: Command-line tools for Azure.](https://github.com/Azure/azure-cli)
- [Azure/azure-powershell: Microsoft Azure PowerShell](https://github.com/Azure/azure-powershell)

## Azure Functions Core Tools

[Azure/azure-functions-core-tools: Command line tools for Azure Functions](https://github.com/Azure/azure-functions-core-tools)

Azure Functions Runtime 2.0.12850 が 2019-10-29 に出てた。

## 日本語ドキュメント

[azure-docs.ja-jp/articles/azure-functions at master · MicrosoftDocs/azure-docs.ja-jp](https://github.com/MicrosoftDocs/azure-docs.ja-jp/tree/master/articles/azure-functions)

# Pythonの制限(2019-7)

v2.7.1724

- [Azure Functions on Linux Preview · Azure/Azure-Functions Wiki · GitHub](https://github.com/Azure/Azure-Functions/wiki/Azure-Functions-on-Linux-Preview)

Japan East でも Python 使えるみたい(2019-10)

使えるリージョンがいまのところ

- West US
- East US
- West Europe
- East Asia

GUI も使えたり使えなかったり。
コードの編集も
テストランもできません。

あと
Premium プラン、
App Service プランだけなので、
「少なくとも 1 つのインスタンスが常にウォーム状態である必要があります。 つまり、実行数に関係なく、アクティブなプランごとに固定の月額コストがかかります」
のは同じ。

[Azure Functions のスケールとホスティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-scale#premium-plan)

## 前提

ここから開始→ [Azure で HTTP によってトリガーされる関数を作成する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-python)

> Python 3.6 のインストール

は省略。本当に必要なのかはわからないが venv を使うので

```
sudo apt-get install python3-venv
```

しておく。

> Azure CLI バージョン 2.x 以降をインストールします。

[Azure CLI のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli?view=azure-cli-latest)
参照。

> Azure Functions Core Tools バージョン 2.6.666 以降をインストールします。

[Azure Functions Core Tools の操作 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2)参照

Azure CLI 入れてあるなら下の手順はスキップ

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
```

次に

```bash
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

venv 環境作成

```
python3 -m venv .env
```

venv 環境へ移動(毎回最初に実行)

```
ource .env/bin/activate
```

```
pip install -r requirements.txt
```

ローカル設定ファイル`local.settings.json`で
AzureWebJobsStorage の接続文字列を編集する。
設定しないと function はなにも動かないので仕方がない。
[Azure ストレージ エミュレーター](https://docs.microsoft.com/ja-jp/azure/storage/common/storage-use-emulator)も使えるらしいのだが、Linux 版が無い。

[ストレージ接続文字列の取得](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#get-your-storage-connection-strings)を参考にして接続文字列を得る。

この設定はあとで`func azure functionapp fetch-app-settings <APP_NAME>`で上書きされる。
先にポータルで function 作ってからのほうが楽かもしれない。

関数つくる。中身は空で。

```bash
func new --template "Http Trigger" --name HttpTrigger1
func new --template "Timer Trigger" --name TimerTrigger1
```

ホスト起動

```bash
func host start
```

関数を呼ぶ。とりあえず引数無しで。

HttpTrigger1 の方

```bash
$ curl --get http://localhost:7071/api/HttpTrigger1?name=Azure%20Rocks
Hello Azure Rocks!
```

TimerTrigger1 の方

```bash
curl -i http://localhost:7071/admin/functions/TimerTrigger1
```

これで JSON がずらずら帰ってくれば、とりあえず OK。

一方 Storage の方に `azure-webjobs-hosts`というのができてるはず。

venv の環境は`~/.env/lib/python3.6/site-packages`からモジュールを読むので

```
pip install -r requirements.txt -U -t ~/.env/lib/python3.6/site-packages
```

みたいなことが必要(当たってる?)。

# InsightsのLog Analytics(Azure Monitor)で使えるクエリサンプル

参考:

- [Overview - Azure Data Explorer | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/kusto/query/)

普通の log っぽい出力を得る

```
traces | top 100 by timestamp desc | project timestamp, message
```

過去 60 分以内の error レベルのログを出す。

```
union traces
| union exceptions
| where timestamp > ago(60m)
| where customDimensions.LogLevel == "Error"
| order by timestamp desc
```

これは実際に使った。
count>0 のとき、メール送るアクショングループを起動する、という感じで(期間 60 分頻度 5 分)

# Azure Functions Core Toolsのインストール

[Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2)

## Windowsの場合

まとめると、今現在(2019-10)では

1. node 10.x を先に入れる(12 も LTS だが、Azure Functions Core Tools が対応していない) - これ 12.x も使えるようになった(2020-04)
2. Chocolatey 入れる
3. Chocolatey で Azure Functions Core Tools いれる

の順で。

Windows だと Chocolatey でインストールしないと`func`が動かない。
(npm でも proxy が邪魔で入らない場合があるけど、それとは別)

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

そもそも Chocolatey が入ってない場合は
[Chocolatey Software | Installing Chocolatey](https://chocolatey.org/install)
参照。

# Azure Functionsのデプロイがめんどくさすぎる問題

開発をしない、デプロイだけする人のことを考えたときに(SIer 的な)
AWS Lambda みたいな「ポータルから ZIP でデプロイ」が無いのは辛い、という話。

開発者にとっては、かなり便利()
[Azure Functions のデプロイ テクノロジ | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-deployment-technologies)

## 発端

たとえば nodejs の場合、
チュートリアル [Visual Studio Code を使用して Azure で初めての関数を作成する](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-create-first-function-vs-code)
によれば、

- [Azure CLI](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Node.js](https://nodejs.org/) 推奨は 8.x か 10.x
- [Visual Studio Code](https://code.visualstudio.com/)
- [Azure Functions Core Tools](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#v2) 2.x
- VSCode に [Azure Functions 拡張機能](vscode:extension/ms-azuretools.vscode-azurefunctions)

を揃えて、なおかつ Portal でいろいろやんなくちゃならないのは辛い。
apt/yum、msi/msix まではともかく、
AWS Lambda みたいに zip でなんとかならないのか(なるよね?)
を確かめる。

参考: [Azure Functions の zip プッシュ デプロイ | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/deployment-zip-push)

## 調査

まず上のような開発環境で作る & 動作確認

できあがったものがこちら →
[heiwa4126/hello-function: Azure Functions & nodejs。vscodeを使った開発環境と、デプロイ用のzipを作るテスト](https://github.com/heiwa4126/hello-function)

## 結論

Azure CLI で zip を発行するのが

ポータルで、該当 function から、プラットフォーム->デプロイセンター
様々なデプロイが選べる。

- 継続的配置 (CI/CD)
- 手動配置 (プッシュ/同期)

の 2 種類がある。とりあえず手動配置(構成後「同期」ボタンをおして配信)の方から選ぶ。

## 結論0

[Azure Functions の zip プッシュ デプロイ](https://docs.microsoft.com/ja-jp/azure/azure-functions/deployment-zip-push)
にある通りの[Azure PowerShell](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps?view=azps-2.8.0)(Azure CLI とは違う)を使ったデプロイ。

※ Azure CLI (python 版)にも同じコマンドがあるので、
無理に powershell 版をいれなくても OK。
下のコマンドも行継続キャラを'^'にするだけで bat になる。Linux とかでも同様にできる。

ポータルで function を作り、azure powershell で azure に login 後、

```powershell
az functionapp deployment source config-zip `
 -g <functionのリソースグループ> `
 -n <function名> `
 --src <zipfile名>
```

実際に実行すると出力はこんな感じ(Powershell 版)

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

ログ出力代わりに warning 出すな、といいたい(Python 版の Azure CLI では警告でません)。

Azure powershell のインストールがめんどくさいので、
最初の 1 回とか、二度と変更しないような場合に使う。

Azure Functions Core Tools が入っていれば

```bash
func azure functionapp publish <app name> --build remote
```

の方が楽。

## 結論1

自分でデプロイするなら、External。

> パブリックの Git または Mercurial リポジトリからデプロイします。

「パブリックの」はインタネット上の、ぐらいの意味で、pull さえできれば
GitHub の private レポジトリでも OK

プラットフォーム->デプロイセンター->External->続行->App Service のビルド サービス->続行

- リポジトリ
- ブランチ
- リポジトリの種類 - Mercurial｜Git
- プライベート リポジトリ - いいえ｜はい
- ユーザー名 (プライベート リポジトリを「はい」にしたとき)
- パスワード (プライベート リポジトリを「はい」にしたとき)

最初の 1 回目は自動的に pull & npm install & function の再起動が行われる。
2 回め以降は「同期」ボタン。

これはなかなか便利なので、TODO:

- AWS lambda でも同様のことができないか試す。
- 継続的配置の GitHub のほうも試す。

## 結論2

git ってなんだ? っていう人が扱う場合には、FTPS

zip のダウンロードは

ポータルで、該当 function から、
アプリのコンテンツのダウンロード
サイトのコンテンツ、「ダウンロードにアプリ設定を含める」はチェックしない
ダウンロードボタン (たぶん cli でできる)

FTPS クライアントは WinSCP が使える。

ポータルで、該当 function から、

プラットフォーム->デプロイセンター->FTP->ダッシュボード

FTPS エンドポイント
アプリの資格情報タブで
ユーザ名
パスワード

これを WinSCP にコピペして、オープンしたら、
zip の中身を上書きコピーする。

functions の再起動はしないようなので、
関数の停止/開始を行う(再起動ではダメだった)。

git でデプロイ、と違って、npm install はやってくれないみたいで、
node_modules 以下も必要で、転送サイズが大きくなりがち。

# Linux

Azure Functions で Linux を使うとデプロイセンターが使えない。

# nodejs v12 LTS

(この項は古い。2020-04 現在 12.x 使える)

nodejs v12.13 LTS が出たので、アップグレードしたら
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

Functions の開発環境はしばらく 10.x で。

# 未整理メモ

「とりあえず」仕様

出力は Insights の Log Analytics に特殊な先頭文字付きで出し、
Kusto クエリで

```
traces
| where (cloud_RoleName == "hello9vaglet") and (isempty(severityLevel) != true ) and ( message matches regex "^\\*\\*\\*\\*\\ " )
| project timestamp, message
```

みたいな感じで。

queue に出力も簡単にできるのだが、意外とリードアウトがめんどくさい。

欠点: Log Analytics への出力が死ぬほど遅い。

# ホスティング プラン

[Azure Functions のスケールとホスティング | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-scale)

# よく使うfuncコマンド

## デプロイ

```bash
func azure functionapp publish <APP_NAME> --build remote
```

`--build remote`オプションをつけるとリモートビルドする(
`pip install -r requirements.txt`や
`npm install`をリモートでやってくれるらしい)

## 設定のダウンロード

```bash
func azure functionapp fetch-app-settings <APP_NAME>
```

local.settings.json に設定をダウンロードしてくれる。

# HTTPトリガのauthLevel

functio.json の authLevel で

- anonymous - わかる
- function - わかる。「関数固有の API キーが必要です。 何も指定されなかった場合は、これが既定値になります」
- admin - わからん。「マスター キーが必要です」

- [承認キー](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-bindings-http-webhook#authorization-keys)
- [Azure API Management の認証ポリシー | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/api-management/api-management-authentication-policies)

# invoke

AWS CLI の `aws lambda invoke` に相当するものがないらしい。

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

ということなので~/.profile などに`FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1`とか書いておく。

see: [Azure/azure-functions-core-tools: Command line tools for Azure Functions](https://github.com/Azure/azure-functions-core-tools)

# Docker

Azure Functions で docker を使うと、Function を停止しても料金が発生するので、辛い。

Linux ベースの functions(Python とか)はそうではなかったような気がする。

# 時は流れて2022-09

[コマンド ラインから Python 関数を作成する - Azure Functions | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/azure-functions/create-first-function-cli-python?tabs=azure-cli%2Cbash%2Ccurl)

それでも CLI コマンドたくさん必要で、
ちょっとしたスクリプト用意しないといけない。
プロジェクトを git clone して `sam build && sam deploy --guided` みたいには行かない。

デプロイ全般にわたって遅い。
リソースグループのデプロイが空だ(ARM template が一切使われていない)。

リソースグループ消すと全部消えるのは好き。

これ便利。`az config param-persist on`
[永続化されたパラメーター オプション – Azure CLI | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/param-persist-howto)

Terraform のほうがよさそう。
[Deploy Azure Functions with Terraform](https://www.maxivanov.io/deploy-azure-functions-with-terraform/)
