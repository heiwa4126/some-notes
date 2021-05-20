# Azure忘備録

- [Azure忘備録](#azure忘備録)
- [Azure CLI](#azure-cli)
  - [Debian/Ubuntu](#debianubuntu)
  - [Windows](#windows)
  - [Azure CLI コマンド補完](#azure-cli-コマンド補完)
- [azure-cliでアカウントの切り替え方](#azure-cliでアカウントの切り替え方)
- [テナントID](#テナントid)
- [Azure AD Graph API](#azure-ad-graph-api)
- [Azureでの時刻同期](#azureでの時刻同期)
- [hv-fcopy-daemon.service が fail](#hv-fcopy-daemonservice-が-fail)
- [omsagentをとめる](#omsagentをとめる)
- [Azureのスケーリング](#azureのスケーリング)
- [AADでLinuxログイン](#aadでlinuxログイン)

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


# Azureでの時刻同期

Azureでは
[Azure での Linux VM の時刻同期 | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/linux/time-sync)

hyper-vで同期する

はずなのでntpdもchronyもいらないはず、だが、2本立てが推奨されている。

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

