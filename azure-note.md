# Azure忘備録

- [Azure忘備録](#azure忘備録)
- [Azure CLI](#azure-cli)
  - [Debian/Ubuntu](#debianubuntu)
  - [Windows](#windows)
  - [Azure CLI コマンド補完](#azure-cli-コマンド補完)
- [azure-cliでアカウントの切り替え方](#azure-cliでアカウントの切り替え方)
- [whoami](#whoami)
- [persist](#persist)
- [テナントID](#テナントid)
- [Azure AD Graph API](#azure-ad-graph-api)
- [Azureでの時刻同期](#azureでの時刻同期)
- [hv-fcopy-daemon.service が fail](#hv-fcopy-daemonservice-が-fail)
- [omsagentをとめる](#omsagentをとめる)
- [Azureのスケーリング](#azureのスケーリング)
- [AADでLinuxログイン](#aadでlinuxログイン)
- [Azure AZ](#azure-az)
- [MSIとは](#msiとは)
- [az cli よくつかうコマンド](#az-cli-よくつかうコマンド)
- [azcopy](#azcopy)
- [168.63.129.16](#1686312916)
- [AzureのストレージアカウントでSFTP](#azureのストレージアカウントでsftp)
- [「仮想マシンエージェントの状態の準備ができていません」](#仮想マシンエージェントの状態の準備ができていません)
- [「セキュリティを強化するには、この VM でJust-In-Time アクセスを有効にします」](#セキュリティを強化するにはこの-vm-でjust-in-time-アクセスを有効にします)
- [複数NIC](#複数nic)

# Azure CLI

[Azure CLI のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli)

## Debian/Ubuntu

[apt を使用して Linux に Azure CLI をインストールする | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli-apt)

``` bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

pipでもインストールできるが、

> Azure CLI のパッケージによって独自の Python インタープリターがインストールされ、システム上の Python は使用されません。

なので、pipを使うのはやめたほうがいい。


## Windows

**pipでインストールしないこと。MSIでインストールすること。**

[Windows での Azure CLI のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli-windows)

PowerShell でのインストール例も出てるけど、けっこう時間がかかって不安になるので、おすすめしない。
Azureなどでは使えるかも?(win_msiモジュールを使うと思う)


## Azure CLI コマンド補完

aptで入れたら
`/etc/bash_completion.d/azure-cli`
がインストールされるので
特に追加作業はない。


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

参考:
[Azure CLI を使用するためのヒント | Microsoft Learn](https://learn.microsoft.com/ja-jp/cli/azure/use-cli-effectively?tabs=bash%2Cbash2)

# whoami

whoami的なもの

```bash
az ad signed-in-user show
```

[az ad signed-in-user | Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/ad/signed-in-user?view=azure-cli-latest#az-ad-signed-in-user-show)


# persist

便利。 [永続化されたパラメーター オプション – Azure CLI | Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/param-persist-howto)

```bash
az config param-persist on
```

カレントディレクトリで設定されてる値を見る。
```bash
az config param-persist show
```

設定は(いまのところ) .azure/.local_context_ユーザ名 というファイルに保存される。
ドキュメントにある .param_persist ってのはウソ (昔はこれだった、とかはあるかも)。




# テナントID

テナントIDはAAD(Azure Active Directory)を一意に識別するID。
ディレクトリIDと呼ばれることもある。

ってか「AAD ID」にしとけばいいのにまたまたまたまた変なことをしやがってMS.

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


# Azureでの時刻同期

Azureでは
- [Azure での Linux VM の時刻同期 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync)
- [Manage Hyper-V Integration Services | Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services#start-and-stop-an-integration-service-from-a-linux-guest)

hyper-vで同期する(統合サービス (hv_utils) )

はずなのでntpdもchronyもいらないはず、だが、2本立てが推奨されている。

ソースは [PTP クロック ソースを確認する](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync#check-for-ptp-clock-source) で確認すること。

```
lsmod | grep hv_utils
ps -ef | grep hv
ls /sys/class/ptp
cat /sys/class/ptp/ptp0/clock_name
```
で確認。

PTPソースを使えるchronyで
```
refclock PHC /dev/ptp0 poll 3 dpoll -2 offset 0
```
のように設定。

systemd-timesyncdはPTPをサポートしてない

設定してしばらく後
```
# chronyc sources
210 Number of sources = 2
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
#* PHC0                          0   3   377    11    -63ns[ +758ns] +/- 1711ns
^- 40.74.70.63                   2   6   377   111    -31ms[  -31ms] +/-  116ms
```
(NTPサーバはtime.windows.comを指定してみた)





# hv-fcopy-daemon.service が fail

Azure上のUbuntu 1804で hv-fcopy-daemon.serviceがfailする。

```
$ systemctl status hv-fcopy-daemon
● hv-fcopy-daemon.service - Hyper-V File Copy Protocol Daemon
   Loaded: loaded (/lib/systemd/system/hv-fcopy-daemon.service; enabled; vendor preset: enabled)
   Active: failed (Result: exit-code) since Tue 2019-06-18 12:03:52 JST; 3min 9s ago
  Process: 969 ExecStart=/usr/sbin/hv_fcopy_daemon -n (code=exited, status=1/FAILURE)
 Main PID: 969 (code=exited, status=1/FAILURE)

 6月 18 12:03:52 u9 systemd[1]: Started Hyper-V File Copy Protocol Daemon.
 6月 18 12:03:52 u9 HV_FCOPY[969]: starting; pid is:969
 6月 18 12:03:52 u9 HV_FCOPY[969]: open /dev/vmbus/hv_fcopy failed; error: 2 No such file or directory
 6月 18 12:03:52 u9 systemd[1]: hv-fcopy-daemon.service: Main process exited, code=exited, status=1/FAILURE
 6月 18 12:03:52 u9 systemd[1]: hv-fcopy-daemon.service: Failed with result 'exit-code'.
```
確かに/dev/vmbus/hv_fcopyは無い。(つづく)


# omsagentをとめる

[Disable monitoring in Azure Monitor for VMs - Azure Monitor | Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/vminsights-optout)



# Azureのスケーリング

- [Azure 仮想マシン スケール セットの概要 \- Azure Virtual Machine Scale Sets \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machine-scale-sets/overview)
- [仮想マシン スケール セットを使用してスケーラブルなアプリケーションを構築する \- Learn \| Microsoft Docs](https://docs.microsoft.com/ja-jp/learn/modules/build-app-with-scale-sets/)

- スケールアップ/ダウン(垂直スケーリング vertical scaling)
- スケールアウト/イン(水平スケーリング horizontal scaling)

の両方が出来る。

- スケジュールスケーリング
- 自動スケーリング

も。

# AADでLinuxログイン

調べ中

- [Linux ログインをAzureADで認証する！！](https://www.cloudou.net/azure-active-directory/aad009/) - 非sssd。まあAADは死なないと思うけど
- [Ubuntu VM を Azure AD Domain Services に参加させる \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory-domain-services/join-ubuntu-linux-vm)

公開鍵認証ができないみたい。


# Azure AZ

可用性セット(Availability Set)だけじゃなく、
可用性ゾーン(Availability Zones)が指定できるようになってた。

- [ASCII\.jp：Azureに登場した「アベイラビリティ・ゾーン」とは](https://ascii.jp/elem/000/001/556/1556413/#:~:text=Azure%20AZ%E3%81%AF%E3%80%81IaaS%E3%81%AE,%E3%81%A8%E3%81%97%E3%81%A6%E8%A8%AD%E8%A8%88%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%81%BE%E3%81%99%E3%80%82)
- [Availability Zones をサポートする Azure サービス \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/availability-zones/az-region)
- [Azure のリージョンと Availability Zones \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/availability-zones/az-overview)


# MSIとは

またMicrosoftが名前変えやがった。
> Azure リソースのマネージド ID は、以前のマネージドサービス ID (MSI) の新しい名前です。

[Azure リソースのマネージド ID | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/overview)


```
$ az login --identity
Failed to connect to MSI. Please make sure MSI is configured correctly.
Get Token request returned http error: 400, reason: Bad Request
```

MSI とは Managed Service Identity

- [Keep credentials out of code: Introducing Azure AD Managed Service Identity | Azure のブログと更新プログラム | Microsoft Azure](https://azure.microsoft.com/ja-jp/blog/keep-credentials-out-of-code-introducing-azure-ad-managed-service-identity/)
- [Azure リソースのマネージド ID | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure VM 上でマネージド ID を使用してサインインする \- Azure ADV \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-sign-in)


VMに割り当てられているマネージドIDは?

[チュートリアル\`:\` マネージド ID を使用して Azure Resource Manager にアクセスする \- Windows \- Azure AD \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-arm)


まず システム割り当てマネージドID(system-assigned managed identity)が有効になってるかを確認する方法

[Azure リソースのマネージド ID を使ったセキュアなパスワード管理 \| SBテクノロジー \(SBT\)](https://www.softbanktech.co.jp/special/blog/cloud_blog/2019/0006/)

ポータルから
azureポータルのVMの左ペインから「ID」を選ぶ。
追加できるけど削除するUIがない... (2021-07)


- [Azure CLI を使用して、リソースにマネージド ID アクセスを割り当てる \- Azure AD \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/howto-assign-access-cli)

もうちょっと狭い範囲のスコープのロールを作る方法を考える。

- [はじめての Azure リソース マネージド ID (概要編) - Qiita](https://qiita.com/Shinya-Yamaguchi/items/edd75f7ee47471a98670)
- [マネージド ID をサポートする Azure サービス - Azure AD | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/active-directory/managed-identities-azure-resources/services-support-managed-identities#azure-services-that-support-managed-identities-for-azure-resources)

# az cli よくつかうコマンド

VM一覧
```sh
az vm list -d -o table
#
az vm list -d --query "[].{Name:name,privateIps:privateIps}" -o table
```


# azcopy

blobへアップロード・ダウンロードしてみる

ストレージアカウトを作るか既存のものをえらぶ。
左ペインから「コンテナー」
今回はコンテナーを新規に作る。手抜きでパブリック・アクセスレベルはBLOBで
いまつくったコンテナーを選択して、
共有アクセストークンから
アクセス許可を全部選んで「SASトークン及びURLを作成」
でURLを得る。

長いんで環境変数BLOBURLに設定して

[AzCopy v10 を使用して Azure Storage にデータをコピーまたは移動する | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/storage/common/storage-use-azcopy-v10)

```sh
wget https://aka.ms/downloadazcopy-v10-linux
tar zxvf downloadazcopy-v10-linux
azcopy_linux_amd64_10.11.0/azcopy --version
sudo mv azcopy_linux_amd64_10.11.0/azcopy /usr/local/bin
```

で
```sh
# upload
azcopy cp test.txt "$BLOBURL"
# download
azcopy cp "$BLOBURL" x --recurse
```

fileだとどうか?
共有/ディレクトリSAS認証(Share/directory SAS authentication)とはなにか?

[Azure SAS入門 \- Qiita](https://qiita.com/azaraseal/items/2eaea4cbb9e3faa57517)


「Storage Explorer (プレビュー)」でfileのフォルダを右クリックすると
「Shared Access Signatureの取得」がある。

[逆引き Azure CLI: Azure ストレージの SAS トークンを生成する (storage container generate-sas)｜まくろぐ](https://maku.blog/p/n4yqdys/)
[Azure Key Vault と Azure CLI を使用してストレージ アカウント キーを管理する \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/key-vault/secrets/overview-storage-keys)
[Microsoft Azure でマネージドストレージアカウントを展開する](https://blog.ipswitch.com/jp/deploy-a-managed-storage-account-in-microsoft-azure)


# 168.63.129.16

[IP アドレス 168.63.129.16 とは | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-network/what-is-ip-address-168-63-129-16)

Azure VMのスペシャルIPらしい。メモ。


# AzureのストレージアカウントでSFTP

[Azure Blob Storage の SFTP のサポート (プレビュー) | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/storage/blobs/secure-file-transfer-protocol-support)


# 「仮想マシンエージェントの状態の準備ができていません」

お前は何を言ってるんだ。
こういう場合は英語モードにする。

"virtual machine agent status is not ready."

このへんらしい。

- [Linux 用の Azure VM 拡張機能とその機能 - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/features-linux?WT.mc_id=Portal-Microsoft_Azure_Support)
- [Azure Linux VM エージェントの概要 - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/extensions/agent-linux)
- [GitHub - Azure/WALinuxAgent: Microsoft Azure Linux Guest Agent](https://github.com/Azure/WALinuxAgent)

```sh
git clone https://github.com/Azure/WALinuxAgent.git
cd WALinuxAgent/
sudo python3 setup.py install --register-service
```

[Azure VMでLinuxインスタンスを起動したら最初にやっておくべき初期設定［PR］ - Build Insider](https://www.buildinsider.net/pr/microsoft/azure/dictionary04)


# 「セキュリティを強化するには、この VM でJust-In-Time アクセスを有効にします」

お前は何を言ってるんだ。

「Just-In-Time アクセスを有効にするため Security Center サブスクリプションをアップグレードする」だそうです。


# 複数NIC

VMのサイズと使えるNIC枚数のリストがほしい。

- [［Azure失敗と対策］仮想マシンのNICの枚数に制限がある | 日経クロステック（xTECH）](https://xtech.nikkei.com/it/atcl/column/16/041400085/041900009/)
- [一歩先行く Azure Computing シリーズ（全3回） 第2回 Azure VM どれを選ぶの？ Azure VM 集中講座](https://www.slideshare.net/ssuser2602c6/azure-computing-3-2-azure-vm-azure-vm)

このへん?
- [Azure Cloud Services (クラシック) の仮想マシンのサイズ | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cloud-services/cloud-services-sizes-specs)
- [azure-content/virtual-networks-multiple-nics.md at master · toddkitta/azure-content](https://github.com/toddkitta/azure-content/blob/master/articles/virtual-network/virtual-networks-multiple-nics.md)
