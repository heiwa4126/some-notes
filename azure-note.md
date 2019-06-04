# Azure忘備録

- [Azure忘備録](#azure忘備録)
- [azure-cliでアカウントの切り替え方](#azure-cliでアカウントの切り替え方)

# azure-cliでアカウントの切り替え方

```
az account show
```
でカレントのアカウント表示

```
az account list | less
```
アカウントリスト表示。

リストの"id"フィールドをコピペして
```
az account set -s <ここにidをペースト>
```
で、アカウント切り替え。

