# Azure Functions 忘備録

Ubuntu 18.04LTS上でPythonでAzure Functionsを書くメモ。
AWS Lambdaと全然違う。

- [Azure Functions 忘備録](#Azure-Functions-忘備録)
- [制限(2019-7)](#制限2019-7)
- [前提](#前提)
- [作業](#作業)
- [InsitesのLLog Analytics(Azure Monitor)で使えるクエリサンプル](#InsitesのLLog-AnalyticsAzure-Monitorで使えるクエリサンプル)
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

# InsitesのLLog Analytics(Azure Monitor)で使えるクエリサンプル

参考:
- [Overview - Azure Data Explorer | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/kusto/query/)


普通のlogっぽい出力を得る
```
traces | top 100 by timestamp desc | project timestamp, message
```

# 未整理メモ

「とりあえず」仕様

出力はInsitesのLog Analyticsに特殊な先頭文字付きで出し、
Kustoクエリで
```
traces
| where (cloud_RoleName == "hello9vaglet") and (isempty(severityLevel) != true ) and ( message matches regex "^\\*\\*\\*\\*\\ " )
| project timestamp, message
```
みたいな感じで。

queueに出力も簡単にできるのだが、意外とリードアウトがめんどくさい。


欠点: Log Analyticsへの出力が死ぬほど遅い。