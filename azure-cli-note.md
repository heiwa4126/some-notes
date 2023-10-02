# Azure CLI (az)のメモ

よく使うコマンドなど

## az login

```console
$ az login

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code HZZZZZZZZZ to authenticate.
```

## az account list

だいたい必要なのは name と SubscriptionId なので

```bash
az account list --query "[].{name:name,id:id}" -o json
```

output を table にするとなぜか SubscriptionId が表示されない。

## az account set

```bash
az account set --subscription "your-subscription-name"
```

your-subscription-name は name か id

## az account show

カレントのサブスクリプションを表示

```bash
az account show
```

## サービスプリンシパルの作成

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```
