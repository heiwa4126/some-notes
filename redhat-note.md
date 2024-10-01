# Red Hat 系メモ

- [Red Hat 系メモ](#red-hat-系メモ)
  - [インストール済みパッケージ一覧](#インストール済みパッケージ一覧)
  - [パッケージ一覧](#パッケージ一覧)
  - [RHEL のパッケージを WWW で探す](#rhel-のパッケージを-www-で探す)
  - [特定のレポジトリに含まれるパッケージのリストを得る](#特定のレポジトリに含まれるパッケージのリストを得る)
  - [有効になっているレポジトリのリスト](#有効になっているレポジトリのリスト)
  - [全レポジトリのパッケージのリストを得る](#全レポジトリのパッケージのリストを得る)
  - [例: 古いカーネルを入手してインストールする](#例-古いカーネルを入手してインストールする)
  - [Software collections で nginx をインストールする例](#software-collections-で-nginx-をインストールする例)
  - [古いカーネルを消す](#古いカーネルを消す)
  - [yum のキャッシュを消す](#yum-のキャッシュを消す)
  - [依存パッケージを表示する](#依存パッケージを表示する)
  - [パッケージが最新か確認する](#パッケージが最新か確認する)
  - [コマンドが含まれているパッケージを探す](#コマンドが含まれているパッケージを探す)
  - [proxy 設定あちこち](#proxy-設定あちこち)
  - [RHEL の登録](#rhel-の登録)
  - [「デスクトップ」とかを英語にする](#デスクトップとかを英語にする)
  - [ホストの再起動が必要かどうか知る](#ホストの再起動が必要かどうか知る)
  - [パッケージの pin](#パッケージの-pin)
  - [yum4/dnf](#yum4dnf)
    - [yum4 参考](#yum4-参考)
  - [RHEL7 の役立つドキュメント](#rhel7-の役立つドキュメント)
  - [タイムゾーンを日本に](#タイムゾーンを日本に)
  - [ロケールを日本に](#ロケールを日本に)
  - [AWS で RHEL](#aws-で-rhel)
    - [example](#example)
  - [Azure で RHEL](#azure-で-rhel)
  - [サブスクリプションが難しい](#サブスクリプションが難しい)
  - [「サービスレベルの設定」とは](#サービスレベルの設定とは)
  - [CentOS を VirtualBox のゲストとして使う](#centos-を-virtualbox-のゲストとして使う)
  - [永続的に IPv6 を止める](#永続的に-ipv6-を止める)
  - [RHEL の発音](#rhel-の発音)
  - [virbr0 を消す](#virbr0-を消す)
  - [起動に失敗したデーモンのリスト](#起動に失敗したデーモンのリスト)
  - [AWS でホスト名を変更する](#aws-でホスト名を変更する)
  - ["Require IPv4 addressing for this connection to complete"](#require-ipv4-addressing-for-this-connection-to-complete)
  - [GRUB2 の再インストール](#grub2-の再インストール)
  - [RHEL のバックアップ・リストア](#rhel-のバックアップリストア)
  - [ReaR (Relax-and-Recover)](#rear-relax-and-recover)
  - [RHEL を見た目ダウングレードさせる](#rhel-を見た目ダウングレードさせる)
  - [RHEL の特定マイナーバージョンに属するカーネルを探す手順](#rhel-の特定マイナーバージョンに属するカーネルを探す手順)
  - [RHEL を特定のバージョンに固定する](#rhel-を特定のバージョンに固定する)
  - [RHEL のホスト名](#rhel-のホスト名)
  - [インストールされているパッケージのリストを構造のある形式で出力する](#インストールされているパッケージのリストを構造のある形式で出力する)
  - [起動時に ntpdate](#起動時に-ntpdate)
  - [reposync](#reposync)
  - [RHEL7 で後から X](#rhel7-で後から-x)
  - [RHEL7 で xrdp](#rhel7-で-xrdp)
  - [subscription manager 以前](#subscription-manager-以前)
  - [NetworkManager-wait-online.service](#networkmanager-wait-onlineservice)
  - [No dialect specified on mount.](#no-dialect-specified-on-mount)
  - [RHEL でネットワークに苦しんだら](#rhel-でネットワークに苦しんだら)
  - [sosreport](#sosreport)
  - [Red Hat 7 の apache(httpd)でモジュールを無効にする時](#red-hat-7-の-apachehttpdでモジュールを無効にする時)
  - [yum でコマンドを探す](#yum-でコマンドを探す)
  - [RPM のキャッシュ](#rpm-のキャッシュ)
  - [errata](#errata)
  - [ELS の設定](#els-の設定)
  - [apt-cron 的なもの](#apt-cron-的なもの)
    - [DNF Automatic](#dnf-automatic)
  - [yum-changelog plugin](#yum-changelog-plugin)
  - [サブスクリプションの数](#サブスクリプションの数)
    - [質問](#質問)
    - [答](#答)

## インストール済みパッケージ一覧

複数のホストで同じパッケージにしたいときなど。

yum-utils パッケージで

```sh
repoquery -a --installed
```

`rpm -qa`だと、そのまま yum で使えない。

`yum list installed`だと長いパッケージ名を勝手に折り返す。
[yum list の出力を折り返さない - (っ ́∀ `)っ ゃー | 一撃](https://nullpopopo.blogcube.info/2015/05/yumlist-sed.html)

```sh
$ yum list | sed -e "s/[[:space:]]\+/\t/g" | sed -e ':loop; N; $!b loop; ;s/\n[[:space:]]/\t/g'
```

のような方法もあるが、覚えられない。

## パッケージ一覧

現在の設定でレポジトリにある全パッケージのリスト

```sh
yum --showduplicates list
```

ただしこれも`yum list installed`同様長いパッケージ名が折り返される。

```sh
repoquery -a --releasever=7Server --showduplicates | sort | uniq
```

が適切だが、repoquery には`--disableexcludes=all`が無い。
そのかわり`--queryformat`が使える。

## RHEL のパッケージを WWW で探す

[Red Hat Enterprise Linux Server 7 - Red Hat カスタマーポータル](https://access.redhat.com/downloads/content/69/ver=/rhel---7/7.6/x86_64/packages)

ただこれは rhel-7-server-rpms レポジトリしかリストされないようで、
例えば rhel-7-server-extras-rpms などは検索されない。

8, 9 はこっち
[Red Hat Enterprise Linux for x86_64 9 - Red Hat Customer Portal](https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.4/x86_64/packages)

## 特定のレポジトリに含まれるパッケージのリストを得る

例えば Oracle Java の含まれる rhel-7-server-supplementary-rpm を検索して
パッケージ一覧を得る例

```sh
yum --disablerepo '*' --enablerepo rhel-7-server-supplementary-rpms list available
```

## 有効になっているレポジトリのリスト

```sh
yum repolist
```

全リストは

```sh
yum repolist all
```

## 全レポジトリのパッケージのリストを得る

ソースパッケージ、ベータ、アーカイブ、その他は除く。
カレントディレクトリに`{{パッケージID}}.lst`形式のファイルができる。

```sh
##!/bin/sh
LANG=C
for repo in $(\
yum repolist all | tail -n +4 | cut -d / -f1 | \
 grep -vi -e : -e source -e debug -e REGION -e dvd -e test -e archive -e beta | \
 tr -d ! \
)
do
    echo $repo
    yum --disablerepo '*' --enablerepo "$repo" list available > "$repo.lst"
done
```

ごれを grep すると
例えば RHEL では
PHP 7.2 や python 3.6 が
の rhel-server-rhscl-7-eus-rpms レポジトリにあることがわかる。

(EUS とは、
Extended Update Support)

ansible2 の最新(2.7.8)も
rhel-7-server-ansible-2.7-rpms よりは
rhel-7-server-ansible-2-rpms を enable にしたほうがいいのがわかる。

リストは更新されるので、
定期的に実行すること。

## 例: 古いカーネルを入手してインストールする

```console
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

## Software collections で nginx をインストールする例

**注意**: SCL を普通のレポジトリと同じ感覚で使わないこと。特にアップデートに関して。

[nginx 1.14 — Software Collections](https://www.softwarecollections.org/en/scls/rhscl/rh-nginx114/)

RHEL7 での例

```sh
subscription-manager repos --enable=rhel-server-rhscl-7-rpms
yum install rh-nginx114 -y
systemctl start rh-nginx114-nginx
systemctl enable rh-nginx114-nginx
```

パッケージは普通じゃないところにインストールされる。

```sh
$ man nginx
nginx というマニュアルはありません
$ scl enable rh-nginx114 bash
$ man nginx
....
```

.profile に

```sh
. scl_source enable rh-nginx114
```

みたいに書いておく手もあり(enable にできるものは複数書ける)

- [ソフトウェアコレクション(SCL:Software Collections)とは? – StupidDog's blog](http://stupiddog.jp/note/archives/1074)
- [4.7. Software Collections および scl-utils - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/developer_guide/scl-utils)
- [Directory — Software Collections](https://www.softwarecollections.org/en/scls/)
- [Red Hat Software Collections と SCL について調べたメモ – 走って登る](https://blog.liclab.com/2017-10-10/rhscl/)

SCL はデメリットも多いが、野良ビルドよりはよっぽどマシだと思う (It depends)。

## 古いカーネルを消す

[How to Install and Use 'yum-utils' to Maintain Yum and Boost its Performance](https://www.tecmint.com/linux-yum-package-management-with-yum-utils/)

```console
# package-cleanup --oldkernels -y
```

残すカーネルの数を指定することもできる

```console
# package-cleanup --oldkernels --count=3
```

[yum-utils を使って/boot の不要なカーネルを削除する方法 | OXY NOTES](https://oxynotes.com/?p=7297)

RHEL8 では
package-cleanup から oldkernels オプションがなくなった。

どうも自動で古いのが消えるみたいだが、いくつ残すか、など制御する方法が不明。

[CentOS8 で古いカーネルを削除する \- らくがきちょう](https://sig9.hatenablog.com/entry/2019/09/30/000000)

これだ
[How to properly remove old kernels RHEL/CentOS 8 | GoLinuxCloud](https://www.golinuxcloud.com/remove-old-kernels-rhel-centos-8/)

```console
# grep limit /etc/dnf/dnf.conf
installonly_limit=3
```

## yum のキャッシュを消す

標準のキャッシュ(`/var/cache/yum/*`)を消す

```sh
yum clean packages
```

## 依存パッケージを表示する

例)

```sh
rpm -q --whatrequires audit-libs
```

## パッケージが最新か確認する

例)

```console
# yum --disableexcludes=all --showduplicates list openssh-server
読み込んだプラグイン:langpacks, product-id, search-disabled-repos, subscription-manager
インストール済みパッケージ
openssh-server.x86_64                                7.4p1-16.el7                                    @rhel-7-server-rpms
利用可能なパッケージ
openssh-server.x86_64                                6.4p1-8.el7                                     rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-11.el7                                  rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-12.el7_1                                rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-22.el7                                  rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-23.el7_2                                rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-25.el7_2                                rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-31.el7                                  rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-33.el7_3                                rhel-7-server-rpms
openssh-server.x86_64                                6.6.1p1-35.el7_3                                rhel-7-server-rpms
openssh-server.x86_64                                7.4p1-11.el7                                    rhel-7-server-rpms
openssh-server.x86_64                                7.4p1-12.el7_4                                  rhel-7-server-rpms
openssh-server.x86_64                                7.4p1-13.el7_4                                  rhel-7-server-rpms
openssh-server.x86_64                                7.4p1-16.el7                                    rhel-7-server-rpms
```

## コマンドが含まれているパッケージを探す

dig を探す例。

```sh
yum provides \*bin/dig
```

filelists_db を引っ張ってきて探してくれる。

`yum provides dig`
や
`yum provides \*/dig`
だとダメ(やってみるとわかるよ)。

## proxy 設定あちこち

RHEL7 ではグローバルの proxy 設定がなくなった。

環境変数 http_proxy 類はもちろん使えるので、
`/etc/profile.d/ourproxy.sh`または`/etc/environment`に書く。
(この 2 つでは書き方が異なるので注意。)

他

- `/etc/rhsm/rhsm.conf`
- `/etc/yum.conf`

## RHEL の登録

ああめんどくさい。

X があれば`subscription-manager-gui`かメニューから。

[RHEL の簡易登録 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)

CLI なら

- [3.2. コマンドラインを使用したサブスクリプションのアタッチと削除 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/sub-cli)
- [インストールした RHEL7 を RHN に登録する | 猫の目](http://www.neko-no-me.net/2015/05/12/984/)

RHEL の登録については
[Red Hat Developer | Red Hat Enterprise Linux Hello-world](https://developers.redhat.com/products/rhel/hello-world/)
これがよくまとまっている。

## 「デスクトップ」とかを英語にする

```
LC_ALL=C xdg-user-dirs-gtk-update
```

設定後、一旦ログアウトしてログイン。

## ホストの再起動が必要かどうか知る

```
## needs-restarting -r
```

参考:
[Linux のパッケージをアップデートしたあと restart が必要なプロセスを見つける方法]
(https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)

## パッケージの pin

例)
/etc/yum.conf

```
[main]
...
##exclude=kernel-* kmod-* redhat-release-* perf-* python-perf-*
exclude=kernel-* redhat-release-*
```

問題としては`kernel-*`が`kernel-headers`まで含んでしまうこと。

yum コマンドのオプションで exclude 無視ができるので、個別に使うとよい

```
--disableexcludes=[all|main|repoid]
```

- all は全ての除外項目を無効。
- main は main セクションで設定した除外項目を無効。
- repoid はリポジトリの除外項目を無効にする。

## yum4/dnf

yum3 遅っそいので。

```
yum install nextgen-yum4 dnf-plugins-core yum-utils
```

設定ファイルは`/etc/dnf/dnf.conf` (いまのところ)

あとは yum の代わりに、yum4 または dnf を使えば(おおむね)OK.

参考:
[YUM4/DNF for CentOS 7 updates – Blog.CentOS.org](https://blog.centos.org/2018/04/yum4-dnf-for-centos-7-updates/) - 古い

RHEL では?

[第 36 章 システムとサブスクリプション管理 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/7.6_release_notes/technology_previews_system_and_subscription_management)

```
subscription-manager repos --enable=rhel-7-server-extras-rpms
yum install nextgen-yum4 dnf-plugins-core yum-utils
```

### yum4 参考

- [YUM is dead. Long live YUM! (PDF)](https://people.redhat.com/mskinner/rhug/q3.2018/MSP-RHUG-YUM-is-dead-Long-live-YUM.pdf)
- [Changes in DNF CLI compared to YUM — DNF 4.0.10-1 documentation](https://dnf.readthedocs.io/en/latest/cli_vs_yum.html)

## RHEL7 の役立つドキュメント

Red Hat Network 上にあるドキュメント。公式だからそれなりに安心。英語/日本語/フランス語 x HTML.PDF/ePub がある。

- [インストールガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/installation_guide/index)
- [システム管理者のガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/index)
- [ネットワークガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/index)

目次は [Product Documentation for Red Hat Enterprise Linux 7 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/)

- [Red Hat サブスクリプション管理のワークフローの概要 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/introduction_to_red_hat_subscription_management_workflows/)
- [Red Hat Network サブスクリプション管理 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_customer_portal/1/html/red_hat_network_certificate-based_subscription_management/index)
- [RHEL の簡易登録 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)
- [ライフサイクルとアップデートポリシー - Red Hat Customer Portal](https://access.redhat.com/ja/support/policy/update_policies)
- [アドバイザリーメール設定](https://www.redhat.com/wapps/ugc/protected/notif.html)

英語のほうがわかりやすいかも

- [RHSM Subscription Issues Troubleshooting Do's and Don'ts](https://access.redhat.com/solutions/1522143)
- [RHSM サブスクリプション問題のトラブルシューティングに関する注意事項](https://access.redhat.com/ja/solutions/2705411)

virt-who

- [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/virtual_instances_guide/)
- [RHEL サブスクリプション (2013 パッケージ) の使用: シナリオ 5 仮想データセンター](https://access.redhat.com/ja/articles/1435793)
- [virt-who とは何か](https://www.slideshare.net/moriwaka/virtwho)
- [Red Hat Virtualization Agent (virt-who) Configuration Helper | Red Hat Customer Portal Labs](https://access.redhat.com/labs/virtwhoconfig/)
- [暗号化されたパスワードで virt-who を設定する](https://access.redhat.com/ja/solutions/2325761)
- [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_satellite/6.3/html/virtual_instances_guide/)

Linux から ESXi(vCenter)

- [Linux からコマンドラインで vCenter を構築する。 | LONE WOLF](https://loner.jp/vcenter-linux-cli-construction)
- [vCenter Server ルート証明書をダウンロードしてインストールして、Web ブラウザ証明書の警告を防ぐ方法 (2148936)](https://kb.vmware.com/s/article/2148936?lang=ja)
- [vSphere 6.0 の覚え書き - Web Client の SSL 証明書エラーを消す (簡易版) - 仮想化でプリセールスしてる SE の一日](http://d.hatena.ne.jp/ogawad/20160131/1454243457)

## タイムゾーンを日本に

```
timedatectl set-timezone Asia/Tokyo
```

## ロケールを日本に

簡単じゃない。

システムワイドでいいのなら

```
localectl set-locale LANG=ja_JP.utf8
```

確認は

```
localectl status
```

参考:

- [RHEL7 のシステムロケールを変更する](https://access.redhat.com/ja/solutions/1562183)
- [Red Hat EL7 の基本設定(ロケールとタイムゾーン) | Skyarch Broadcasting](https://www.skyarch.net/blog/?p=247)
- [【 localectl 】 システムのロケールやキーボードレイアウトを管理する 【 Linux コマンドまとめ 】 | Linux Fan](https://linuxfan.info/localectl)

## AWS で RHEL

RHEL はサブスクリプションマネージャが難しすぎるので、テスト環境がほしいところ。

AWS の AMI(ami-6b0d5f0d)で Red Hat を普通に作って、Red Hat Developer Subscription で RHN に登録すれば、
普通に subscription-manager が使える。

例)

```
subscription-manager register --username fooami --password supersecret
subscription-manager attach --auto
subscription-manager repos --enable=rhel-7-server-optional-rpms
## ↑は↓でもOK
yum-config-manager --enable rhel-7-server-optional-rpms

## 確認
subscription-manager list | less
subscription-manager repos --list-enabled
```

どうやら subscription-manager register か subscribe の時点で
/etc/yum.repos.d/redhat.repo がダウンロードされるようだ...

Developer Subscription は
https://developers.redhat.com/
でアカウント作って(RHN 全体で SSO みたい)
https://developers.redhat.com/products/rhel/download/
でダウンロードすれば 1 年分もらえるみたい。(違うかもしれない)

https://access.redhat.com/management
で確認。

https://developers.redhat.com/products/rhel/help/
も面白い。

[RHEL Developer subscription not finding repos - Stack Overflow](https://stackoverflow.com/questions/52780825/rhel-developer-subscription-not-finding-repos)
など。

### example

このシステムに割り当てられたサブスクリプションを見てみる("--consumed show the subscriptions being consumed by this system")

```
## subscription-manager list --consumed
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

## Azure で RHEL

[Azure で RHEL7 を使うには - 赤帽エンジニアブログ](https://rheb.hatenablog.com/entry/running_rhel7_on_azure)

## サブスクリプションが難しい

参考: [RHEL の簡易登録](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/)

まず `register` して

> 新規システムをサブスクリプションサービスに対し登録または特定します。

つぎに `attach` することで

> マシンに特定のサブスクリプションをアタッチします。

更新できるようになる。(登録解除は unregister コマンドの実行のみで OK。[登録解除](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/quick_registration_for_rhel/un-registering)参照)

さらに `repos` で

> このシステムが使用することができるリポジトリを一覧表示する

レポジトリをリスト/追加する。

## 「サービスレベルの設定」とは

RHN ポータルのシステムのページにある「サービスレベルの設定」とは

- [4. コンシューマーの管理 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_customer_portal/1/html/red_hat_network_certificate-based_subscription_management/managing-consumers#sla)
- [製品サポートのサービスレベルアグリーメント - Red Hat Customer Portal](https://access.redhat.com/ja/support/offerings/production/sla)

...よくわからない。設定すると auto attach 時のサブスクリプション決定アルゴリズムに影響がある、ということ?

## CentOS を VirtualBox のゲストとして使う

たまにやるのでメモ。CentOS6,7 で OK。
dkms を使う方法。
カーネルをアップデートしても vboxguest がちゃんと動くのが良い。

参照: [HowTos/Virtualization/VirtualBox/CentOSguest - CentOS Wiki](https://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest)

```
yum install epel-release -y
yum install dkms -y
yum groupinstall "Development Tools" -y
yum install kernel-devel -y
```

VirtualBoxGuestCD をマウントして、CD のディレクトリで

```
./VBoxLinuxAdditions.run
```

## 永続的に IPv6 を止める

```
cat <<EOS > /etc/sysctl.d/disable_ipv6.conf
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
EOS
sysctl --system
```

たぶん Debian 系でもいっしょ。

あと`sysctl -p`は`/etc/sysctl.cfg`しか読みません。
`/etc/sysctl.d/*.conf`を反映したいなら`sysctl --system`で。

ブート時には`sysctl --system`が使われるみたい。

## RHEL の発音

発音は「レル」(ライセンス管理の研修で聞いた話)

## virbr0 を消す

```
systemctl stop libvirtd
systemctl disable libvirtd
```

virbr0 が down する。再起動すると virbr0 は消える。

参考: [virbr0 インターフェイスは何に使用されますか? 無効にするにはどうしたら良いですか?](https://access.redhat.com/ja/solutions/2318431)

## 起動に失敗したデーモンのリスト

```
systemctl list-units --state=failed
## `faild` is alias.
systemctl list-units --failed
```

[systemd - What are the systemctl options to "List all failed units" - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/341060/what-are-the-systemctl-options-to-list-all-failed-units)

## AWS でホスト名を変更する

```
[root@ip-172-31-1-155 ~]# hostname
ip-172-31-1-155.ap-northeast-1.compute.internal
```

みたいな IP ベースのホスト名がつくので、複数ターミナルを使うと、どっちがどっちだったか間違える。

- [Amazon EC2 Linux の静的ホスト名 RHEL7 Centos7](https://aws.amazon.com/jp/premiumsupport/knowledge-center/linux-static-hostname-rhel7-centos7/)
- [Linux インスタンスのホスト名の変更 - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-hostname.html)
- [Amazon EC2 Linux 静的ホスト名](https://aws.amazon.com/jp/premiumsupport/knowledge-center/linux-static-hostname/)\*

**↑ これらを実行しても、その名前で DNS 引いたりできるわけではないので意味がない。**

NICKNAME つけて表示だけかえるのがいいと思う。

## "Require IPv4 addressing for this connection to complete"

nm の gui と nmtui での設定。日本語だと「この接続には IPv4 アドレス設定が必要になります」。

チェックをはずすと、IPv4 の設定に失敗した場合でも IPv6 の設定が行われる。

参照:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-configuring_ipv4_settings

## GRUB2 の再インストール

- [Red Hat Enterprise Linux 7 25.7. Reinstalling GRUB 2 - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)
- [Red Hat Enterprise Linux 7 25.7. GRUB 2 の再インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/sec-reinstalling_grub_2)

## RHEL のバックアップ・リストア

ReaR(Relax-and-Recover )は別項目に

- [dump および restore コマンドで Red Hat Enterprise Linux 全体をバックアップおよびリストアする](https://access.redhat.com/ja/solutions/122373)
- [パーティションテーブルをバックアップおよび復元する方法](https://access.redhat.com/ja/solutions/800283)

## ReaR (Relax-and-Recover)

- [Relax-and-Recover - Linux Disaster Recovery](http://relax-and-recover.org/)
- [Red Hat Enterprise Linux 7 第 26 章 Relax-and-Recover (ReaR) - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-relax-and-recover_rear)
- [Relax and Recover でのシステム回復](https://redhat.sios.jp/relax-and-recover)
- [rear/03-configuration.adoc at master · rear/rear · GitHub](https://github.com/rear/rear/blob/master/doc/user-guide/03-configuration.adoc) - CIFS の config

## RHEL を見た目ダウングレードさせる

プロプライエタリ製品はマイナーバージョンにうるさいやつが多いので。

以下は 7.3 に見た目ダウングレードする例。

```
## yum --showduplicate list redhat-release-server | grep 7.3
server.x86_64           7.3-7.el7             rhel-7-server-rpms
## yum --showduplicate list initscripts | grep 7.3
initscripts.x86_64             9.49.37-1.el7_3.1             rhel-7-server-rpms
## yum downgrade \
redhat-release-server-7.3-7.el7.x86_64 \
initscripts-9.49.37-1.el7_3.1.x86_64
```

終わったら/etc/yum.conf の exclude に redhat-release-\*と initscripts を追加しておくと、
yum update が簡単になる。

以下は例:

```
exclude=kernel-* kmod-* perf-* python-perf-* redhat-release-* initscripts
```

## RHEL の特定マイナーバージョンに属するカーネルを探す手順

```
kernel-* kmod-* perf-* python-perf-* redhat-release-* initscripts-*
```

```bash
yum --showduplicate --disableexcludes=all list | fgrep 3.10.0-514.26.2.el7 > krpms.lst

## 対象パッケージ
cut -d' ' -f1 < krpms.lst  | sort | uniq

## 対象パッケージ バージョン付き
cut -d' ' -f1 < krpms.lst  | sort | uniq | fgrep . | sed 's/\./-3.10.0-514.26.2.el7./' > prpms.lst

## RPMをダウンロード
cat prpms.lst | xargs yumdownloader --disableexcludes=all
```

```
exclude=kernel-* perf-* python-perf-* redhat-release-* initscripts
```

kmod なしで

```
rm -f /etc/yum/vars/releasever
subscription-manager release --set=7Server
yum clean all
(yum.confいじる)
yum update -y
...
rpm -ivh --force (kernelだけ)
rpm -Uvh --force (kernel以外)
```

`yum localinstall`はうまくいかない。
`--oldpackage`いるかも

けっこう複雑なので

```
rpm -qa kernel kernel-abi-whitelists kernel-debug kernel-debug-debuginfo kernel-debug-devel kernel-debuginfo kernel-devel kernel-doc kernel-headers kernel-tools kernel-tools-debuginfo kernel-tools-libs kernel-tools-libs-devel perf perf-debuginfo python-perf python-perf-debuginfo
```

のリストで 7.3,7.5,6.x の決め打ちでいくしかない。

## RHEL を特定のバージョンに固定する

この項うそ。これでは固定できない。

```
[main]
exclude=kernel-* kmod-* perf-* python-perf-* redhat-release-* initscripts
```

して、kernel 群だけを手で入れるしか無い。

**これ以下嘘。**

yum の$releasever 変数を指定する。

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

とあるので、そちらを設定するほうがいいかもしれない(優先度不明.両方やっとけばいいのでは)

デフォルトは

```
distroverpkg=redhat-release
```

なので「ISO などでインストールした時点からリリースを変更したくない」ときは
redhat-release を yum.conf の exclude に追加する(たぶん initscripts も)
だけで同じ効果があると思われる。

こんな感じか?

```
[main]
exclude=redhat-release-* initscripts
```

あったりまえですが固定すると

> 最新以外または古いマイナーリリースへのアップデートには、セキュリティーおよびバグのエラータが含まれないことに注意してください

なので注意。

登録時にリリースを設定することもできるけど、これは「固定」になるかはわからない。

```
subscription-manager register --autosubscribe --release=6.4

## 確認
subscription-manager release --list

## あとから追加
subscription-manager release --set=6.3
## or
subscription-manager release --set=7Server
```

参考:

- [Red Hat Enterprise Linux の特定のアップデートにシステムを指定する](https://access.redhat.com/ja/solutions/743243)
- [Red Hat Enterprise Linux 6 8.4.3. Using Yum Variables - Red Hat Customer Portal](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-using_yum_variables)
- [Red Hat Enterprise Linux 6 5.6.3. コマンドラインで希望するオペレーティングシステムのリリースバージョンを設定する - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/deployment_guide/preferred-os)

## RHEL のホスト名

- [Red Hat Enterprise Linux 7 第 3 章 ホスト名の設定 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/ch-configure_host_names)
- [Red Hat Enterprise Linux 7 3.3. hostnamectl を使ったホスト名の設定 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/networking_guide/sec_configuring_host_names_using_hostnamectl)

## インストールされているパッケージのリストを構造のある形式で出力する

XML, JSON, YANL, CSV などでパッケージリストを得る方法

```
rpm -qa --xml
```

実際に実行すると、データ量が多くて死ぬ。

`--queryformat (--qf)` を使うとタグが選択できる。

例)

```
$ rpm --qf "<name>%{NAME}</name><version>%{version}</version>\n" -q systemd
<name>systemd</name><version>219</version>
```

使えるタグ一覧は

```
rpm --querytags
```

で得られる。

みんな大好き CSV で出力するワンライナーの例

```
(echo "name","version","release","arch","filename" ; rpm --qf='"%{name}","%{version}","%{release}","%{arch}","%{name}-%{version}-%{release}.%{arch}.rpm"\n' -qa | sort -f ) > rpms.csv
```

参考:

- [rpm.org - RPM Query Formats](https://rpm.org/user_doc/query_format.html)
- [rpm(8): RPM Package Manager - Linux man page](https://linux.die.net/man/8/rpm)

## 起動時に ntpdate

[18.16. ntpdate サーバーの設定 - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system_administrators_guide/s1-configure_ntpdate_servers)

1. yum install ntpdate
1. /etc/ntp/step-tickers に ntp サーバを列挙
1. systemctl enable ntpdate

ただこれが必要なのは ntpd のオプションに`-g`がないときであって、

> -g
> 通常、 ntpd はオフセットが正気限界 (sanity limit) を越えている場合は終了します。 この値のデフォルトは 1000 秒です。 正気限界を 0 に設定した場合、正気限界のチェックを行なわず、 オフセットがどのような値でも受理します。 このオプションはこの制限を無視し、 どの時刻にも制限なく設定できるようにします。 しかしこれは一度のみ起り得ます。 この後は、制限を超過すると、 ntpd は終了します。 このオプションは、 -q オプションとともに使用することができます。

引用元: [ntpd(8) man ページ](https://nxmnpg.lemoda.net/ja/8/ntpd)

RHEL7 の ntpd の設定は`-g`つきで起動されているはずなので確認すること。
(そもそもデフォルトは chronyd のはず)

調べた。
CentOS7 だけど

```
## systemctl restart ntp
(略)
 Main PID: 4326 (ntpd)
   CGroup: /system.slice/ntpd.service
           └─4326 /usr/sbin/ntpd -u ntp:ntp -g
(略)
```

なので多分`-g`つき。

## reposync

- [RHEL を定期的にアップデートする際の課題と対策](https://www.redhat.com/cms/managed-files/RHEL_update_solutions.pdf) - pdf
- [RHEL を定期的にアップデートする際の課題と対策](https://www.slideshare.net/moriwaka/rhel-86721836) - slideshare 版
- [How to synchronize repository on system registered to CDN via subscription-manager - Red Hat Customer Portal](https://access.redhat.com/articles/1355053)

> subscription-manager で登録後、そのシステムで利用可能なリポジトリを reposync コマンドでミラーできる

## RHEL7 で後から X

[How to install a graphical user interface (GUI) for Red Hat Enterprise Linux - Red Hat Customer Portal](https://access.redhat.com/solutions/5238)

```bash
yum groupinstall gnome-desktop x11 fonts
```

or

```bash
yum groupinstall "Server with GUI"
```

## RHEL7 で xrdp

EPEL をレポジトリに追加

```bash
yum groupinstall "Server with GUI"
yum install xrdp tigervnc-server xterm -y
systemctl daemon-reload
systemctl stop xrdp
systemctl start xrdp
systemctl enable xrdp
```

## subscription manager 以前

`RHN classic`と呼ぶ。
ちゃんと登録されていれば`/etc/sysconfig/rhn/systemid`に ID が入っているはず。

[システムのアップデートに RHN Classic と RHSM のどちらを使用しているかを確認する - Red Hat Customer Portal](https://access.redhat.com/ja/solutions/1350833)

`/usr/bin/rhn_register`

## NetworkManager-wait-online.service

なぜかこのサービスが failed になる。

[A systemd service sometimes failed to start with network connectivity problem on system boot in Red Hat Enterprise Linux 7 - Red Hat Customer Portal](https://access.redhat.com/solutions/3450402)

```
ExecStart=/usr/bin/nm-online -s -q --timeout=60        # Modify here
```

にしたらなおった。という話(未確認)

[Why 'NetworkManager-wait-online.service' fails to start with error 'code=exited, status=2/INVALIDARGUMENT' ? - Red Hat Customer Portal](https://access.redhat.com/solutions/2851711)

Kernel 更新したら治った、という話。

[network manager - What does NetworkManager-wait-online.service do? - Ask Ubuntu](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do)

そんなもん無効にしろ、という話。

## No dialect specified on mount.

`No dialect specified on mount. Default has changed to a more secure ... SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.`

[CentOS 7 の CIFS で - 身の回り 4 畳半近辺の日記](https://b3g.hatenablog.com/entry/20181127/p1)

例)

```
mount -t cifs -o vers=2.1,username=user,password=pass,domain=dom //srv/share /mnt
```

## RHEL でネットワークに苦しんだら

役に立つ**かもしれない**資料

[(PDF)Red Hat Enterprise Linux 7 ネットワークガイド - RHEL 7 でネットワーク、ネットワークインターフェース、およびネットワークサービスの設定および管理](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/pdf/networking_guide/Red_Hat_Enterprise_Linux-7-Networking_Guide-ja-JP.pdf)

## sosreport

- [Red Hat Enterprise Linux 上での sosreport の役割と取得方法 - Red Hat Customer Portal](https://access.redhat.com/ja/solutions/78443)

インストール

```sh
sudo yum install sos -y
```

実行

```sh
sudo sosreport
```

かなり長い時間と、巨大なレポートができる。

途中

```
Please enter the case id that you are generating this report for []:
```

とか訊かれるので、かっこいい名前を考えておくこと。

例) `Trinity666`

名前を考えるのがめんどくさい場合は`--batch`オプションがあります。

```
sudo sosreport --batch
```

> ユーザーおよびアカウント情報をインタラクティブに入力しないで済むように、--batch オプションを指定してバッチモードで実行することができます。この場合、ユーザー情報はシステムの RHN 設定ファイルから取得されます。

`--batch`オプションが CentOS だとどうなるかは知らない。

他参考:

- [Red Hat Enterprise Linux 上での sosreport の役割と取得方法 - Red Hat Customer Portal](https://access.redhat.com/ja/solutions/78443#command)
- [[Linux] サーバトラブルへの備えと情報採取の手順 - 技術情報・詳細: 技術情報・検索一覧 | NEC](https://www.support.nec.co.jp/View.aspx?id=3140000151)

## Red Hat 7 の apache(httpd)でモジュールを無効にする時

`/etc/httpd/conf.modules.d`の下の、例えば proxy のやつなんかを
`/etc/httpd/conf.modules.d/unused`に移動していたんだけど、
これだと httpd パッケージが更新されたときに復活してしまう。

`/etc/httpd/conf.modules.d/unused`にバックアップして、
元の場所にサイズ 0 の同じファイルを置く、
あるいは`chmod -r`してまう
がいいと思う。

## yum でコマンドを探す

「このコマンドはどのパッケージに入っているか?」という場合。
`yum provides`が使える

例:

```sh
sudo yum provides docker-compose
```

## RPM のキャッシュ

```sh
yum install xxxx --downloadonly
```

でキャッシュしたパッケージは`/var/cache/yum`の下に入る。

```sh
find /var/cache/yum -type f -name \*.rpm
find /var/cache/yum -type d
```

で見れる。

## errata

eratta の一覧: [Red Hat Product Errata - Red Hat Customer Portal](https://access.redhat.com/errata/)

RHN のアカウント不要

フィルタリングができるので、例えば RHEL6 ELS のやつなら
[こんな感じ](https://access.redhat.com/errata/#/?q=&p=1&sort=portal_publication_date%20desc&rows=10&portal_product=Red%20Hat%20Enterprise%20Linux&portal_product_variant=Red%20Hat%20Enterprise%20Linux%20Server%20-%20Extended%20Life%20Cycle%20Support&portal_product_version=6&portal_architecture=x86_64)で。

## ELS の設定

アタッチの仕方: [How to attach "Red Hat Enterprise Linux Extended Life Cycle Support " subscription to RHEL6 systems registered to Subscription Management \- Red Hat Customer Portal](https://access.redhat.com/solutions/2941791) (要 RHN アカウント)

ELS を virt-who 用に大量に買う、なんてこともあるかもしれない。
ライセンスは 2 種類ある。

- Red Hat Enterprise Linux Extended Life Cycle Support (Physical or Virtual Nodes) - SKU : RH00270
- Red Hat Enterprise Linux Extended Life Cycle Support (Unlimited Guests) - SKU : RH00271

ELS レポジトリは自動で有効にならないらしい(RHEL6 だけ?)

```sh
subscription-manager repos --enable=rhel-6-server-els-rpms
```

とかする。

## apt-cron 的なもの

- RHEL7 - yum-cron - [How to use yum-cron to automatically update RHEL/CentOS Linux - nixCraft](https://www.cyberciti.biz/faq/fedora-automatic-update-retrieval-installation-with-cron/)
- RHEL8 以降 - dnf-automatic - [How to enable automatic updates for RHEL/CentOS 8 - nixCraft](https://www.cyberciti.biz/faq/install-enable-automatic-updates-rhel-centos-8/)

### DNF Automatic

[DNF Automatic — dnf latest documentation](https://dnf.readthedocs.io/en/latest/automatic.html)

## yum-changelog plugin

[yum-changelog(1) - Linux man page](https://linux.die.net/man/1/yum-changelog)

インストール

```sh
sudo yum install yum-changelog
```

シンプルな使い方

```sh
## さいきんの
sudo yum changelog recent | less
## 特定のパッケージ
sudo yum changelog openssl | less
```

Debian/Ubuntu だと

```sh
## 特定のパッケージ
apt changelog openssl
```

RHEL8 ではどうなの?

## サブスクリプションの数

### 質問

以下のスペックのホストに
`Red Hat Enterprise Linux Server, Standard (Physical or Virtual Nodes) (L3 Only) (SKU:RH00080)`
はいくつ必要ですか?

- core(s)\_per_socket : 8
- cpu(s) : 16
- cpu_socket(s) : 1

### 答

ご質問のスペックの Red Hat Enterprise Linux Server を利用する場合、以下の点を考慮します。

- Red Hat Enterprise Linux Server の Standard 版のライセンスは、物理サーバまたは仮想マシンごとに必要です。
- ライセンスではソケット数ではなくコア数が指定されています。
- 質問のサーバは 1 ソケット、コア数 16 の構成です。
- Standard 版のライセンスは 8 コアまでの使用が可能です。

以上から、このサーバのスペックに対して Red Hat Enterprise Linux Server の Standard ライセンスが 2 つ必要となります。

1 つのライセンスで 8 コアまでの使用が可能なため、16 コアをカバーするには 2 つのライセンスが必要です。
