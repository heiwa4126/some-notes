Red Hat系メモ

- [インストール済みパッケージ一覧](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E6%B8%88%E3%81%BF%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E4%B8%80%E8%A6%A7)
- [パッケージ一覧](#%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E4%B8%80%E8%A6%A7)
- [有効になっているレポジトリのリスト](#%E6%9C%89%E5%8A%B9%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E3%81%84%E3%82%8B%E3%83%AC%E3%83%9D%E3%82%B8%E3%83%88%E3%83%AA%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%88)
- [例: 古いカーネルを入手してインストールする](#%E4%BE%8B-%E5%8F%A4%E3%81%84%E3%82%AB%E3%83%BC%E3%83%8D%E3%83%AB%E3%82%92%E5%85%A5%E6%89%8B%E3%81%97%E3%81%A6%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)
- [古いカーネルを消す](#%E5%8F%A4%E3%81%84%E3%82%AB%E3%83%BC%E3%83%8D%E3%83%AB%E3%82%92%E6%B6%88%E3%81%99)
- [コマンドが含まれているパッケージを探す](#%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%81%8C%E5%90%AB%E3%81%BE%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%82%92%E6%8E%A2%E3%81%99)
- [proxy設定あちこち](#proxy%E8%A8%AD%E5%AE%9A%E3%81%82%E3%81%A1%E3%81%93%E3%81%A1)
- [RHELの登録](#rhel%E3%81%AE%E7%99%BB%E9%8C%B2)
- [「デスクトップ」とかを英語にする](#%E3%83%87%E3%82%B9%E3%82%AF%E3%83%88%E3%83%83%E3%83%97%E3%81%A8%E3%81%8B%E3%82%92%E8%8B%B1%E8%AA%9E%E3%81%AB%E3%81%99%E3%82%8B)
- [ホストの再起動が必要かどうか知る](#%E3%83%9B%E3%82%B9%E3%83%88%E3%81%AE%E5%86%8D%E8%B5%B7%E5%8B%95%E3%81%8C%E5%BF%85%E8%A6%81%E3%81%8B%E3%81%A9%E3%81%86%E3%81%8B%E7%9F%A5%E3%82%8B)
- [パッケージのpin](#%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E3%81%AEpin)
- [yum4/dnf](#yum4dnf)
- [RHEL7の役立つドキュメント](#rhel7%E3%81%AE%E5%BD%B9%E7%AB%8B%E3%81%A4%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88)
- [AWSでRHEL](#aws%E3%81%A7rhel)
  - [example](#example)
- [AzureでRHEL](#azure%E3%81%A7rhel)
- [サブスクリプションが難しい](#%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%8C%E9%9B%A3%E3%81%97%E3%81%84)
- [「サービスレベルの設定」とは](#%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%83%AC%E3%83%99%E3%83%AB%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%A8%E3%81%AF)
- [CentOSをVirtualBoxのゲストとして使う](#centos%E3%82%92virtualbox%E3%81%AE%E3%82%B2%E3%82%B9%E3%83%88%E3%81%A8%E3%81%97%E3%81%A6%E4%BD%BF%E3%81%86)
- [永続的にIPv6を止める](#%E6%B0%B8%E7%B6%9A%E7%9A%84%E3%81%ABipv6%E3%82%92%E6%AD%A2%E3%82%81%E3%82%8B)
- [RHELの発音](#rhel%E3%81%AE%E7%99%BA%E9%9F%B3)
- [virbr0を消す](#virbr0%E3%82%92%E6%B6%88%E3%81%99)
- [起動に失敗したデーモンのリスト](#%E8%B5%B7%E5%8B%95%E3%81%AB%E5%A4%B1%E6%95%97%E3%81%97%E3%81%9F%E3%83%87%E3%83%BC%E3%83%A2%E3%83%B3%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%88)
- [AWSでホスト名を変更する](#aws%E3%81%A7%E3%83%9B%E3%82%B9%E3%83%88%E5%90%8D%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B)
- ["Require IPv4 addressing for this connection to complete"](#%22require-ipv4-addressing-for-this-connection-to-complete%22)
- [GRUB2の再インストール](#grub2%E3%81%AE%E5%86%8D%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
- [RHELのバックアップ・リストア](#rhel%E3%81%AE%E3%83%90%E3%83%83%E3%82%AF%E3%82%A2%E3%83%83%E3%83%97%E3%83%BB%E3%83%AA%E3%82%B9%E3%83%88%E3%82%A2)
- [ReaR (Relax-and-Recover)](#rear-relax-and-recover)
- [RHELを見た目ダウングレードさせる](#rhel%E3%82%92%E8%A6%8B%E3%81%9F%E7%9B%AE%E3%83%80%E3%82%A6%E3%83%B3%E3%82%B0%E3%83%AC%E3%83%BC%E3%83%89%E3%81%95%E3%81%9B%E3%82%8B)


# インストール済みパッケージ一覧

複数のホストで同じパッケージにしたいときなど。

yum-utilsパッケージで
```
repoquery -a --installed
```

`rpm -qa`だと、そのままyumで使えない。

`yum list installed`だと長いパッケージ名を勝手に折り返す。
[yum listの出力を折り返さない - (っ´∀｀)っ ゃー | 一撃](https://nullpopopo.blogcube.info/2015/05/yumlist-sed.html)
```
$ yum list | sed -e "s/[[:space:]]\+/\t/g" | sed -e ':loop; N; $!b loop; ;s/\n[[:space:]]/\t/g'
```

のような方法もあるが、覚えられない。


# パッケージ一覧

現在の設定でレポジトリにある全パッケージのリスト
```
yum --showduplicates list
```
ただしこれも`yum list installed`同様長いパッケージ名が折り返される。


# 有効になっているレポジトリのリスト

```
yum repolist
```

全リストは
```
yum repolist all
```

# 例: 古いカーネルを入手してインストールする

```
# yum --showduplicates list kernel
# LANG=C yum --showduplicates list kernel
Loaded plugins: etckeeper, fastestmirror, langpacks
Loading mirror speeds from cached hostfile
 * epel: mirrors.kernel.org
 * remi-php56: repo1.sea.innoscale.net
 * remi-safe: repo1.sea.innoscale.net
Installed Packages
kernel.x86_64                                                    3.10.0-862.3.3.el7                                                     @updates
kernel.x86_64                                                    3.10.0-862.6.3.el7                                                     @updates
kernel.x86_64                                                    3.10.0-862.11.6.el7                                                    @updates
Available Packages
kernel.x86_64                                                    3.10.0-862.el7                                                         base
kernel.x86_64                                                    3.10.0-862.2.3.el7                                                     updates
kernel.x86_64                                                    3.10.0-862.3.2.el7                                                     updates
kernel.x86_64                                                    3.10.0-862.3.3.el7                                                     updates
kernel.x86_64                                                    3.10.0-862.6.3.el7                                                     updates
kernel.x86_64                                                    3.10.0-862.9.1.el7                                                     updates
kernel.x86_64                                                    3.10.0-862.11.6.el7                                                    updates

#  yum install kernel-3.10.0-862.el7
...
```


# 古いカーネルを消す

[How to Install and Use 'yum-utils' to Maintain Yum and Boost its Performance](https://www.tecmint.com/linux-yum-package-management-with-yum-utils/)

```
# package-cleanup --oldkernels
```

残すカーネルの数を指定することもできる
```
# package-cleanup --oldkernels --count=3
```
[yum-utilsを使って/bootの不要なカーネルを削除する方法 | OXY NOTES](https://oxynotes.com/?p=7297)


# コマンドが含まれているパッケージを探す

digを探す例。
```
yum provides \*bin/dig
```
filelists_dbを引っ張ってきて探してくれる。

`yum provides dig`
や
`yum provides \*/dig`
だとダメ(やってみるとわかるよ)。


# proxy設定あちこち

RHEL7ではグローバルのproxy設定がなくなった。

環境変数http_proxy類はもちろん使えるので、
`/etc/profile.d/ourproxy.sh`または`/etc/environment`に書く。
(この2つでは書き方が異なるので注意。)

他
* `/etc/rhsm/rhsm.conf`
* `/etc/yum.conf`


# RHELの登録

ああめんどくさい。

Xがあれば`subscription-manager-gui`かメニューから。

[RHEL の簡易登録 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)

CLIなら
* [3.2. コマンドラインを使用したサブスクリプションのアタッチと削除 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/sub-cli)
* [インストールしたRHEL7をRHNに登録する | 猫の目](http://www.neko-no-me.net/2015/05/12/984/)

RHELの登録については
[Red Hat Developer | Red Hat Enterprise Linux Hello-world](https://developers.redhat.com/products/rhel/hello-world/)
これがよくまとまっている。



# 「デスクトップ」とかを英語にする

```
LC_ALL=C xdg-user-dirs-gtk-update
```
設定後、一旦ログアウトしてログイン。


# ホストの再起動が必要かどうか知る

```
# needs-restarting -r
```

参考:
[Linuxのパッケージをアップデートしたあとrestartが必要なプロセスを見つける方法]
(https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)


# パッケージのpin

例)
/etc/yum.conf
```
[main]
...
#exclude=kernel-* kmod-* redhat-release-* perf-* python-perf-*
exclude=kernel-* redhat-release-*
```

問題としては`kernel-*`が`kernel-headers`まで含んでしまうこと。

yumコマンドのオプションでexclude無視ができるので、個別に使うとよい
```
--disableexcludes=[all|main|repoid]
```

* allは全ての除外項目を無効。
* mainはmainセクションで設定した除外項目を無効。
* repoidはリポジトリの除外項目を無効にする。

# yum4/dnf

yum遅っそいので。

インストール方法はいろいろあるけれど
CentOS7の場合:
```
# yum install epel-release
# yum install centos-release-yum4
# yum install yum4
(proxyの設定などを/etc/dnf/dnf.confに)
# yum4 install dnf-plugins-core
```
が一番簡単。

あとはyumの代わりに、yum4またはdnfを使えば(おおむね)OK.

参考:
[YUM4/DNF for CentOS 7 updates – Blog.CentOS.org](https://blog.centos.org/2018/04/yum4-dnf-for-centos-7-updates/)

(TODO)RHELでは?

# RHEL7の役立つドキュメント

Red Hat Network上にあるドキュメント。公式だからそれなりに安心。英語/日本語/フランス語 x HTML.PDF/ePubがある。

* [インストールガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/installation_guide/index)
* [システム管理者のガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/index)
* [ネットワークガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/index)

目次は [Product Documentation for Red Hat Enterprise Linux 7 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/)

* [Red Hat サブスクリプション管理のワークフローの概要 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/introduction_to_red_hat_subscription_management_workflows/)
* [Red Hat Network サブスクリプション管理 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_customer_portal/1/html/red_hat_network_certificate-based_subscription_management/index)
* [RHEL の簡易登録 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)
* [ライフサイクルとアップデートポリシー - Red Hat Customer Portal](https://access.redhat.com/ja/support/policy/update_policies)
* [アドバイザリーメール設定](https://www.redhat.com/wapps/ugc/protected/notif.html)


英語のほうがわかりやすいかも
* [RHSM Subscription Issues Troubleshooting Do's and Don'ts](https://access.redhat.com/solutions/1522143)
* [RHSM サブスクリプション問題のトラブルシューティングに関する注意事項](https://access.redhat.com/ja/solutions/2705411)

virt-who
* [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/virtual_instances_guide/)
* [RHEL サブスクリプション (2013 パッケージ) の使用: シナリオ 5 仮想データセンター](https://access.redhat.com/ja/articles/1435793)
* [virt-whoとは何か](https://www.slideshare.net/moriwaka/virtwho)
* [Red Hat Virtualization Agent (virt-who) Configuration Helper | Red Hat Customer Portal Labs](https://access.redhat.com/labs/virtwhoconfig/)
* [暗号化されたパスワードで virt-who を設定する](https://access.redhat.com/ja/solutions/2325761)
* [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_satellite/6.3/html/virtual_instances_guide/)

LinuxからESXi(vCenter)
* [LinuxからコマンドラインでvCenterを構築する。 | LONE WOLF](https://loner.jp/vcenter-linux-cli-construction)
* [vCenter Server ルート証明書をダウンロードしてインストールして、Web ブラウザ証明書の警告を防ぐ方法 (2148936)](https://kb.vmware.com/s/article/2148936?lang=ja)
* [vSphere 6.0 の覚え書き - Web Client の SSL 証明書エラーを消す （簡易版） - 仮想化でプリセールスしてるSEの一日](http://d.hatena.ne.jp/ogawad/20160131/1454243457)




# AWSでRHEL

RHELはサブスクリプションマネージャが難しすぎるので、テスト環境がほしいところ。

AWSのAMI(ami-6b0d5f0d)でRed Hatを普通に作って、Red Hat Developer SubscriptionでRHNに登録すれば、
普通にsubscription-managerが使える。

例)
```
subscription-manager register --username fooami --password supersecret
subscription-manager attach --auto
subscription-manager repos --enable=rhel-7-server-optional-rpms
# ↑は↓でもOK
yum-config-manager --enable rhel-7-server-optional-rpms

# 確認
subscription-manager list | less
subscription-manager repos --list-enabled
```

どうやらsubscription-manager registerかsubscribeの時点で
/etc/yum.repos.d/redhat.repoがダウンロードされるようだ...

Developer Subscriptionは
https://developers.redhat.com/
でアカウント作って(RHN全体でSSOみたい)
https://developers.redhat.com/products/rhel/download/
でダウンロードすれば1年分もらえるみたい。(違うかもしれない)

https://access.redhat.com/management
で確認。

https://developers.redhat.com/products/rhel/help/
も面白い。

[RHEL Developer subscription not finding repos - Stack Overflow](https://stackoverflow.com/questions/52780825/rhel-developer-subscription-not-finding-repos)
など。

## example

このシステムに割り当てられたサブスクリプションを見てみる("--consumed show the subscriptions being consumed by this system")
```
# subscription-manager list --consumed
+-------------------------------------------+
   Consumed Subscriptions
+-------------------------------------------+
Subscription Name:   Red Hat Developer Subscription
Provides:            Red Hat Enterprise Linux High Availability - Update Services for SAP Solutions
                     Red Hat Enterprise Linux Atomic Host
                     Red Hat Container Development Kit
                     MRG Realtime
                     Red Hat Enterprise Linux Atomic Host Beta
                     Red Hat Developer Tools (for RHEL Server)
                     Red Hat Container Images
                     Red Hat Developer Tools Beta (for RHEL Server)
                     Red Hat Container Images Beta
                     Red Hat Developer Toolset (for RHEL Server)
                     Red Hat Enterprise Linux High Performance Networking (for RHEL Server)
                     Red Hat Enterprise Linux High Performance Networking (for RHEL Server) - Extended Update Support
                     Red Hat Enterprise Linux High Performance Networking (for RHEL Compute Node)
                     Red Hat Enterprise Linux Resilient Storage (for RHEL Server)
                     Red Hat Enterprise Linux Resilient Storage (for RHEL Server) - Extended Update Support
                     dotNET on RHEL (for RHEL Server)
                     Red Hat Enterprise Linux Scalable File System (for RHEL Server)
                     Red Hat Enterprise Linux Server - Extended Update Support
                     dotNET on RHEL Beta (for RHEL Server)
                     Red Hat Enterprise Linux Scalable File System (for RHEL Server) - Extended Update Support
                     Red Hat Enterprise Linux for ARM 64
                     Red Hat Beta
                     Red Hat EUCJP Support (for RHEL Server) - Extended Update Support
                     Oracle Java (for RHEL Server)
                     RHEL for SAP (for IBM Power LE) - Update Services for SAP Solutions
                     Red Hat Enterprise Linux for SAP Hana
                     Red Hat Enterprise Linux for ARM 64 Beta
                     Red Hat Enterprise Linux for Real Time
                     Red Hat Enterprise Linux Server - Update Services for SAP Solutions
                     RHEL for SAP - Update Services for SAP Solutions
                     Red Hat Software Collections (for RHEL Server)
                     Red Hat Enterprise Linux for SAP
                     RHEL for SAP - Extended Update Support
                     Oracle Java (for RHEL Server) - Extended Update Support
                     RHEL for SAP HANA - Update Services for SAP Solutions
                     Red Hat Beta
                     Red Hat EUCJP Support (for RHEL Server) - Extended Update Support
                     Oracle Java (for RHEL Server)
                     RHEL for SAP (for IBM Power LE) - Update Services for SAP Solutions
                     Red Hat Enterprise Linux for SAP Hana
                     Red Hat Enterprise Linux for ARM 64 Beta
                     Red Hat Enterprise Linux for Real Time
                     Red Hat Enterprise Linux Server - Update Services for SAP Solutions
                     RHEL for SAP - Update Services for SAP Solutions
                     Red Hat Software Collections (for RHEL Server)
                     Red Hat Enterprise Linux for SAP
                     RHEL for SAP - Extended Update Support
                     Oracle Java (for RHEL Server) - Extended Update Support
                     RHEL for SAP HANA - Update Services for SAP Solutions
                     Red Hat S-JIS Support (for RHEL Server) - Extended Update Support
                     RHEL for SAP HANA - Extended Update Support
                     Red Hat Software Collections Beta (for RHEL Server)
                     Red Hat Enterprise Linux High Availability (for RHEL Server)
                     Red Hat Enterprise Linux High Availability (for RHEL Server) - Extended Update Support
                     Red Hat Ansible Engine
                     Red Hat Enterprise Linux Load Balancer (for RHEL Server)
                     Red Hat Enterprise Linux Load Balancer (for RHEL Server) - Extended Update Support
                     Red Hat Enterprise Linux Server
SKU:                 RH00798
Contract:
Account:             0000000
Serial:              0000000000000000000
Pool ID:             zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
Provides Management: No
Active:              True
Quantity Used:       1
Service Level:       Self-Support
Service Type:
Status Details:      Subscription is current
Subscription Type:   Standard
Starts:              13/42/2018
Ends:                13/42/2019
System Type:         Physical
```

# AzureでRHEL

[AzureでRHEL7を使うには - 赤帽エンジニアブログ](https://rheb.hatenablog.com/entry/running_rhel7_on_azure)

# サブスクリプションが難しい

参考: [RHEL の簡易登録](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)

まず `register` して
> 新規システムをサブスクリプションサービスに対し登録または特定します。

つぎに `attach` することで
> マシンに特定のサブスクリプションをアタッチします。

更新できるようになる。(登録解除はunregister コマンドの実行のみでOK。[登録解除](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/un-registering)参照)

さらに `repos` で
> このシステムが使用することができるリポジトリを一覧表示する

レポジトリをリスト/追加する。



# 「サービスレベルの設定」とは

RHNポータルのシステムのページにある「サービスレベルの設定」とは

* [4. コンシューマーの管理 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_customer_portal/1/html/red_hat_network_certificate-based_subscription_management/managing-consumers#sla)
* [製品サポートのサービスレベルアグリーメント - Red Hat Customer Portal](https://access.redhat.com/ja/support/offerings/production/sla)

...よくわからない。設定するとauto attach時のサブスクリプション決定アルゴリズムに影響がある、ということ?

# CentOSをVirtualBoxのゲストとして使う

たまにやるのでメモ。CentOS6,7でOK。
dkmsを使う方法。
カーネルをアップデートしてもvboxguestがちゃんと動くのが良い。

参照: [HowTos/Virtualization/VirtualBox/CentOSguest - CentOS Wiki](https://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest)

```
yum install epel-release -y
yum install dkms -y
yum groupinstall "Development Tools" -y
yum install kernel-devel -y
```
VirtualBoxGuestCDをマウントして、CDのディレクトリで
```
 ./VBoxLinuxAdditions.run
```

# 永続的にIPv6を止める

```
cat <<EOS > /etc/sysctl.d/disable_ipv6.conf
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
EOS
sysctl --system
```

たぶんDebian系でもいっしょ。

あと`sysctl -p`は`/etc/sysctl.cfg`しか読みません。
`/etc/sysctl.d/*.conf`を反映したいなら`sysctl --system`で。

ブート時には`sysctl --system`が使われるみたい。

# RHELの発音

発音は「レル」(ライセンス管理の研修で聞いた話)


# virbr0を消す

```
systemctl stop libvirtd
systemctl disable libvirtd
```
virbr0がdownする。再起動するとvirbr0は消える。


参考: [virbr0 インターフェイスは何に使用されますか? 無効にするにはどうしたら良いですか?](https://access.redhat.com/ja/solutions/2318431)


# 起動に失敗したデーモンのリスト

```
systemctl list-units --state=failed
# `faild` is alias.
systemctl list-units --failed
```

[systemd - What are the systemctl options to "List all failed units" - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/341060/what-are-the-systemctl-options-to-list-all-failed-units)


# AWSでホスト名を変更する

```
[root@ip-172-31-1-155 ~]# hostname
ip-172-31-1-155.ap-northeast-1.compute.internal
```
みたいなIPベースのホスト名がつくので、複数ターミナルを使うと、どっちがどっちだったか間違える。

* [Amazon EC2 Linux の静的ホスト名 RHEL7 Centos7](https://aws.amazon.com/jp/premiumsupport/knowledge-center/linux-static-hostname-rhel7-centos7/)
* [Linux インスタンスのホスト名の変更 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-hostname.html)
* [Amazon EC2 Linux 静的ホスト名](https://aws.amazon.com/jp/premiumsupport/knowledge-center/linux-static-hostname/)* 

**↑これらを実行しても、その名前でDNS引いたりできるわけではないので意味がない。**

NICKNAMEつけて表示だけかえるのがいいと思う。

# "Require IPv4 addressing for this connection to complete"

nmのguiとnmtuiでの設定。日本語だと「この接続には IPv4 アドレス設定が必要になります」。

チェックをはずすと、IPv4の設定に失敗した場合でもIPv6の設定が行われる。

参照:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_ipv4_settings


# GRUB2の再インストール

* [Red Hat Enterprise Linux 7 25.7. Reinstalling GRUB 2 - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)
* [Red Hat Enterprise Linux 7 25.7. GRUB 2 の再インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)


# RHELのバックアップ・リストア

ReaR(Relax-and-Recover )は別項目に
* [dump および restore コマンドで Red Hat Enterprise Linux 全体をバックアップおよびリストアする](https://access.redhat.com/ja/solutions/122373)
* [パーティションテーブルをバックアップおよび復元する方法](https://access.redhat.com/ja/solutions/800283)
  
# ReaR (Relax-and-Recover)

* [Relax-and-Recover - Linux Disaster Recovery](http://relax-and-recover.org/)
* [Red Hat Enterprise Linux 7 第26章 Relax-and-Recover (ReaR) - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear)
* [Relax and Recoverでのシステム回復](https://redhat.sios.jp/relax-and-recover)
* [rear/03-configuration.adoc at master · rear/rear · GitHub](https://github.com/rear/rear/blob/master/doc/user-guide/03-configuration.adoc)  - CIFSのconfig

# RHELを見た目ダウングレードさせる

プロプライエタリ製品はマイナーバージョンにうるさいやつが多いので。

以下は7.3に見た目ダウングレードする例。

```
# yum --showduplicate list redhat-release-server | grep 7.3
server.x86_64           7.3-7.el7             rhel-7-server-rpms
# yum --showduplicate list initscripts | grep 7.3
initscripts.x86_64             9.49.37-1.el7_3.1             rhel-7-server-rpms
# yum downgrade \
redhat-release-server-7.3-7.el7.x86_64 \
initscripts-9.49.37-1.el7_3.1.x86_64
```

終わったら/etc/yum.confのexcludeにredhat-release-*とinitscriptsを追加しておくと、
yum updateが簡単になる。

以下は例:
```
exclude=kernel-* kmod-* redhat-release-* perf-* python-perf-* initscripts
```

# RHELを特定のバージョンに固定する

yumの$releasever変数を指定する。

例)
```
echo 7.4 > /etc/yum/vars/releasever
```

設定すると
```
yum distribution-synchronization
```
でダウングレードもできるはずだが、実際にはほとんど無理。

[Red Hat Enterprise Linux 7 9.5. Yum と Yum リポジトリーの設定 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-Configuring_Yum_and_Yum_Repositories#sec-Using_Yum_Variables)によると、
> yum は /etc/yum.conf 設定ファイルにある distroverpkg=value の行から $releasever の値を取得します

とあるので、そちらを設定するほうがいいかもしれない(優先度不明)

デフォルトは
```
distroverpkg=redhat-release
```
なので
redhat-releaseをyum.confのexcludeに追加する(たぶんinitscriptsも)
だけで同じ効果があると思われる。


あったりまえですが固定すると
> 最新以外または古いマイナーリリースへのアップデートには、セキュリティーおよびバグのエラータが含まれないことに注意してください

なので注意。

登録時にリリースを設定することもできるけど、これは「固定」になるかはわからない。
```
subscription-manager register --autosubscribe --release=6.4

# 確認 
subscription-manager release --list

# あとから追加
subscription-manager release --set=6.3
```



参考:
* [Red Hat Enterprise Linux の特定のアップデートにシステムを指定する](https://access.redhat.com/ja/solutions/743243)
* [Red Hat Enterprise Linux 6 8.4.3. Using Yum Variables - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-using_yum_variables)
* [Red Hat Enterprise Linux 6 5.6.3. コマンドラインで希望するオペレーティングシステムのリリースバージョンを設定する - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/preferred-os)



