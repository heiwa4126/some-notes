# Azure忘備録

- [Azure忘備録](#azure忘備録)
- [azure-cliでアカウントの切り替え方](#azure-cliでアカウントの切り替え方)
- [テナントID](#テナントid)
- [Azure AD Graph API](#azure-ad-graph-api)

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


# テナントID

テナントIDはAAD(Azure Active Directory)を一意に識別するID。
ディレクトリIDと呼ばれることもある。

1つのテナント(AAD)には、複数のサブスクリプションが関連付けられる。
「関連付け」は「信頼」ということもある。

- [Azure サブスクリプション、リソース、ロール、Azure AD の関係 その1 - Qiita](https://qiita.com/junichia/items/e8cf118314a173efcb68)
- [Azure サブスクリプションと Azure AD の管理者 – Japan Azure Identity Support Blog](https://blogs.technet.microsoft.com/jpazureid/2017/11/04/azure-subscription-azuread-admin/)


複数の信頼されたAD,AADのグループを「フェデレーション(federation)」という

[Azure AD とのフェデレーションとは | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/hybrid/whatis-fed)


# Azure AD Graph API

[Microsoft Graph](https://developer.microsoft.com/ja-jp/graph)とは別物。機能は似ている。

[Azure AD Graph API](https://docs.microsoft.com/ja-jp/azure/active-directory/develop/active-directory-graph-api)
のほうが古いし、今後徐々にサポートされなくなる(2019年2月)。

違いは
[Microsoft ID プラットフォーム (v2.0) に更新する理由 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/develop/azure-ad-endpoint-comparison)
