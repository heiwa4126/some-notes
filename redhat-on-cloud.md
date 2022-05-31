- [クラウド上のRed Hat Enterprise Linux](#クラウド上のred-hat-enterprise-linux)
  - [AWS](#aws)
  - [Azure](#azure)
- [そうは言ってもこのメッセージが気になる場合](#そうは言ってもこのメッセージが気になる場合)
- [AWS上でRHEL8の例](#aws上でrhel8の例)
- [Red Hat Developer Subscription のとりかたメモ](#red-hat-developer-subscription-のとりかたメモ)

# クラウド上のRed Hat Enterprise Linux

AWSではRHELがサブスクリプション無しでyumが使える。

ただsubscription-managerの練習にはならないので、
１つくらいは Red Hat Developer Subscription を取得しておくべき。

## AWS

> Red Hat Enterprise Linux (RHEL) のすべてのオンデマンド Amazon マシンイメージ (AMI) は、AWS で Red Hat Update Infrastructure (RHUI) を使用するように構成されています。
 
[Red Hat よくある質問](https://aws.amazon.com/jp/partners/redhat/faqs/)

## Azure

Red HatでもRHUI

[Red Hat Update Infrastructure - Azure Virtual Machines | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/virtual-machines/workloads/redhat/redhat-rhui)


# そうは言ってもこのメッセージが気になる場合

AzureやAWSのRed Hatでyum(dnf)使うと
"Unable to read consumer identity"
とか
"This system is not registered with an entitlement server. You can use subscription-manager to register."
出てくるのが気になる場合。

`/etc/yum/pluginconf.d/subscription-manager.conf`
の
`enabled=1`
を
`enabled=0`
にしましょう。

- [Solution for “This system is not registered with an entitlement server” | SahliTech, Inc](https://sahlitech.com/entitlement-server-fix/)
- [EC2(RHEL)で dnf upgrade を実行した際に「This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.」というエラーが発生した場合の対処方法 | DevelopersIO](https://dev.classmethod.jp/articles/tsnote-ec2-dnf-upgrade-error-001/)


# AWS上でRHEL8の例

2019-8-1 実行

AMI: RHEL-8.0.0_HVM-20190618-x86_64-1-Hourly2-GP2

```
# subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Unknown

System Purpose Status: Unknown

# yum repolist all
Updating Subscription Management repositories.
Unable to read consumer identity
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Last metadata expiration check: 0:00:14 ago on Thu 01 Aug 2019 05:11:16 AM UTC.
repo id                                              repo name                                                                    status
rhel-8-appstream-rhui-debug-rpms                     Red Hat Enterprise Linux 8 for x86_64 - AppStream from RHUI (Debug RPMs)     disabled
rhel-8-appstream-rhui-rpms                           Red Hat Enterprise Linux 8 for x86_64 - AppStream from RHUI (RPMs)           enabled:
rhel-8-appstream-rhui-source-rpms                    Red Hat Enterprise Linux 8 for x86_64 - AppStream from RHUI (Source RPMs)    disabled
rhel-8-baseos-rhui-debug-rpms                        Red Hat Enterprise Linux 8 for x86_64 - BaseOS from RHUI (Debug RPMs)        disabled
rhel-8-baseos-rhui-rpms                              Red Hat Enterprise Linux 8 for x86_64 - BaseOS from RHUI (RPMs)              enabled:
rhel-8-baseos-rhui-source-rpms                       Red Hat Enterprise Linux 8 for x86_64 - BaseOS from RHUI (Source RPMs)       disabled
rhui-client-config-server-8                          Red Hat Update Infrastructure 3 Client Configuration Server 8                enabled:
rhui-codeready-builder-for-rhel-8-rhui-debug-rpms    Red Hat CodeReady Linux Builder for RHEL 8 x86_64 (Debug RPMs) from RHUI     disabled
rhui-codeready-builder-for-rhel-8-rhui-rpms          Red Hat CodeReady Linux Builder for RHEL 8 x86_64 (RPMs) from RHUI           disabled
rhui-codeready-builder-for-rhel-8-rhui-source-rpms   Red Hat CodeReady Linux Builder for RHEL 8 x86_64 (Source RPMs) from RHUI    disabled

# yum update -y
Updating Subscription Management repositories.
Unable to read consumer identity
This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register.
Red Hat Update Infrastructure 3 Client Configuration Server 8                                                   1.8 kB/s | 2.1 kB     00:0
Red Hat Enterprise Linux 8 for x86_64 - AppStream from RHUI (RPMs)                                               18 MB/s | 7.7 MB     00:0
Red Hat Enterprise Linux 8 for x86_64 - BaseOS from RHUI (RPMs)                                                  15 MB/s | 4.7 MB     00:0
Dependencies resolved.
==========================================================================================================================================
 Package                           Arch               Version                                    Repository
==========================================================================================================================================
Upgrading:
 rh-amazon-rhui-client             noarch             3.0.19-1.el8                               rhui-client-config-server-8
 microcode_ctl                     x86_64             4:20180807a-2.20190618.1.el8_0             rhui-rhel-8-baseos-rhui-rpms
 vim-minimal                       x86_64             2:8.0.1763-11.el8_0                        rhui-rhel-8-baseos-rhui-rpms
 tzdata                            noarch             2019b-1.el8                                rhui-rhel-8-baseos-rhui-rpms
 bind-export-libs                  x86_64             32:9.11.4-17.P2.el8_0.1                    rhui-rhel-8-baseos-rhui-rpms

Transaction Summary
==========================================================================================================================================
Upgrade  5 Packages

Total download size: 4.2 M
Downloading Packages:
(1/5): rh-amazon-rhui-client-3.0.19-1.el8.noarch.rpm                                                            355 kB/s |  33 kB     00:0
(2/5): microcode_ctl-20180807a-2.20190618.1.el8_0.x86_64.rpm                                                     16 MB/s | 2.0 MB     00:0
(3/5): vim-minimal-8.0.1763-11.el8_0.x86_64.rpm                                                                 4.0 MB/s | 573 kB     00:0
(4/5): tzdata-2019b-1.el8.noarch.rpm                                                                            3.5 MB/s | 466 kB     00:0
(5/5): bind-export-libs-9.11.4-17.P2.el8_0.1.x86_64.rpm                                                          10 MB/s | 1.1 MB     00:0
------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                            16 MB/s | 4.2 MB     00:0
Running transaction check
(略)
```




# Red Hat Developer Subscription のとりかたメモ

[Red Hat アカウントの作成](https://www.redhat.com/wapps/ugc/register.html)でアカウントを作る。

そのアカウントで [Red Hat IDP](rhn.redhat.com) へログイン。

[Red Hat Enterprise Linux Download](https://developers.redhat.com/products/rhel/download) から、製品を1つダウンロード。
クラウドで使うつもりなら、一番サイズの小さいISOファイルを選ぶといいです。

[Red Hat Customer Portal](https://access.redhat.com/management/subscriptions) に、 Red Hat Developer Subscription が出現するのを確認。

あとは対象ホストで
```
# subscription-manager register
```
RHNのIDとパスワードを入れる。
