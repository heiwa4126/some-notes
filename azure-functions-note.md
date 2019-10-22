# Azure Functions 忘備録

Ubuntu 18.04LTS上でPythonでAzure Functionsを書くメモ。
AWS Lambdaと全然違う。

- [Azure Functions 忘備録](#azure-functions-忘備録)
- [制限(2019-7)](#制限2019-7)
- [前提](#前提)
- [作業](#作業)
- [InsightsのLog Analytics(Azure Monitor)で使えるクエリサンプル](#insightsのlog-analyticsazure-monitorで使えるクエリサンプル)
- [Azure Functionsのデプロイがめんどくさすぎる問題](#azure-functionsのデプロイがめんどくさすぎる問題)
  - [発端](#発端)
  - [調査](#調査)
  - [結論](#結論)
  - [結論0](#結論0)
  - [結論1](#結論1)
  - [結論2](#結論2)
- [未整理メモ](#未整理メモ)


# 制限(2019-7)

- [Azure Functions on Linux Preview · Azure/Azure-Functions Wiki · GitHub](https://github.com/Azure/Azure-Functions/wiki/Azure-Functions-on-Linux-Preview)

使えるリージョンがいまのところ
- West US
- East US
- West Europe
- East Asia

GUIも使えたり使えなかったり。
コードの編集も
テストランもできません。

# 前提

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

# 作業

venv環境へ移動(毎回最初に実行)
```
python3 -m venv .env
source .env/bin/activate
```

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

ローカル設定ファイル`local.settings.json`で
AzureWebJobsStorageの接続文字列を編集する。
設定しないとfunctionはなにも動かないので仕方がない。
[Azure ストレージ エミュレーター](https://docs.microsoft.com/ja-jp/azure/storage/common/storage-use-emulator)も使えるらしいのだが、Linux版が無い。

[ストレージ接続文字列の取得](https://docs.microsoft.com/ja-jp/azure/azure-functions/functions-run-local#get-your-storage-connection-strings)を参考にして接続文字列を得る。

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

# Azure Functionsのデプロイがめんどくさすぎる問題

## 発端

開発をしない、デプロイだけする人のことを考える(SIer的な)。

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

Powershell版のAzure CLIでzipを発行するのが


ポータルで、該当functionから、プラットフォーム->デプロイセンター
様々なデプロイが選べる。

- 継続的配置 (CI/CD)
- 手動配置 (プッシュ/同期)

の2種類がある。とりあえず手動配置(構成後「同期」ボタンをおして配信)の方から選ぶ。

## 結論0

[Azure Functions の zip プッシュ デプロイ](https://docs.microsoft.com/ja-jp/azure/azure-functions/deployment-zip-push)
にある通りの[Azure PowerShell](https://docs.microsoft.com/ja-jp/powershell/azure/install-az-ps?view=azps-2.8.0)(Azure CLIとは違う)を使ったデプロイ。

ポータルでfunctionを作り、azure powershellでazureにlogin後、
``` powershell
az functionapp deployment source config-zip `
 -g <functionのリソースグループ> `
 -n <function名> `
 --src <zipfile名>
```

実際に実行すると出力はこんな感じ
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
ログ出力代わりにwarning出すな、といいたい。

めんどくさいので、最初の1回とか、二度と変更しないような場合に使う。


## 結論1

自分でデプロイするなら、External。

> パブリックの Git または Mercurial リポジトリからデプロイします。

「パブリックの」はインタネット上の、ぐらいの意味で、pullさえできれば
GitHubのprivateレポジトリでもOK

プラットフォーム->デプロイセンター->External->続行->App Service のビルド サービス->続行

リポジトリ 
ブランチ 
リポジトリの種類 Mercurial｜Git
プライベート リポジトリ いいえ｜はい
ユーザー名 
パスワード

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