RHELのvirt-whoメモ

- [概要](#%E6%A6%82%E8%A6%81)
- [事前にいるもの](#%E4%BA%8B%E5%89%8D%E3%81%AB%E3%81%84%E3%82%8B%E3%82%82%E3%81%AE)
- [vCenterに「読み取り専用」のユーザを作る](#vcenter%E3%81%AB%E8%AA%AD%E3%81%BF%E5%8F%96%E3%82%8A%E5%B0%82%E7%94%A8%E3%81%AE%E3%83%A6%E3%83%BC%E3%82%B6%E3%82%92%E4%BD%9C%E3%82%8B)
- [RHELゲストにvirt-whoをインストール](#rhel%E3%82%B2%E3%82%B9%E3%83%88%E3%81%ABvirt-who%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
- [virt-who 設定](#virt-who-%E8%A8%AD%E5%AE%9A)
- [その後](#%E3%81%9D%E3%81%AE%E5%BE%8C)
- [そのほか](#%E3%81%9D%E3%81%AE%E3%81%BB%E3%81%8B)
- [参考](#%E5%8F%82%E8%80%83)

# 概要

ESXi(vCenterあり)と
Red Hat Enterprise Linux for Virtual Datacentersサブスクリプション(仮想データーセンターサブスクリプション)で、
RHELのVMを動かすのに、virt-whoを動かしてみたのでそのメモ。

Virtual DatacentersサブスクリプションはESXiホスト単位で買って、
そのホストでいくつRHELゲストを動かしてもいい、というすごいライセンス。


# 事前にいるもの

virt-whoを動かすゲストから、vCenterまで443/tcp(HTTPS)でつながること。HTTPSなのでover proxy可らしい(未検証)。

RHELゲストからRed Hat Customer PortalまたはSAM(Subscription Asset Manager)までの通信。
要は`subscription-manager register`が出来ること。

ちなみに、virt-whoを動かしたり、Virtual DatacentersサブスクリプションをESXiにアタッチする前でも
ゲストは`subscription-manager register`はできる(エンタイトルメント不要。半購読状態になる)。


# vCenterに「読み取り専用」のユーザを作る

管理者権限のユーザでvCenterにログインして、
メニュー -> 管理 -> ユーザおよびグループ

ドメインを選んで(今回はSSOのvsphere.localを使った)、「ユーザを追加」をクリック。virt-whoユーザを作った(ユーザ名は自由)。

次に「グローバル権限」でいま作ったvirt-whoユーザを検索、
ロールで「読み取り専用」を選択、「子へ伝達」をチェック。
OKボタンで確定。

いったんログアウトして、vCenterにvirt-whoで入れるかを確認する。


# RHELゲストにvirt-whoをインストール

前述のようにvirt-whoが動いていない状態でも、
ゲストのregisterの後(attach不要で)、
`yum install virt-who`できる。

* [virt-who を使用して Red Hat カスタマーポータルに VMware ESXi ゲストを登録する](https://access.redhat.com/ja/solutions/3032111)
* [virt-who を使用して Virtual Datacenter エンタイトルメントを持つ Esxi ホストを登録する](https://access.redhat.com/ja/solutions/2849291) - 機械翻訳で変だけど参考になる
* [10.4. virt-who の手動インストール - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/manual-install-virt-who)


を参照。

DVDからは
[How to install virt-who on disconnected RHEL 7 server?](https://access.redhat.com/solutions/1527923)
を参照。

↑のrepoではうまくいかなくて、*.repoに
```
gpgcheck=1
gpgkey=file:///mnt/RPM-GPG-KEY-redhat-release
```
が必要だった。

終わったらunmountしてenable=0にしておくこと。

RHELインストール時にパッケージグループを選んでもよいらしいが
未確認。


# virt-who 設定

`/etc/sysconfig/virt-who`

SAM(Subscription Asset Manager)があれば編集。

`/etc/virt-who.d/{vCenter名}.conf`

ファイル名は自由。
同じディレクトリにtemplate.confがあるので
コピーして編集する。

例)
```
## Terse version of the config template:
[myvcenter001]
type=esx
server=111.222.333.444
username=vsphere.local\virt-who
password=hugahoge
# encrypted_password=
owner=99999999
env=Library
hypervisor_id=hostname
```
usernameは`virt-who@vsphere.local`だとうまくいかなかった。

ownerは
```
LANG=C subscription-manager identity
```
で出てくる、`org ID`の値。

または https://access.redhat.com/management/activation_keys

の`組織 ID のアクティベーションキー: `の後ろの数字。


# その後

1. `systemctl restart virt-who`
2. `systemctl status virt-who -l`

正常に動けば[ポータルのシステム](https://access.redhat.com/management/systems)に
ESXiが「ハイパーバイザー」として追加されるので(15分ぐらいかかる)、
各々のシステムを選んで、「サブスクリプション」タブからエンタイトル。

あとは各々のRHELゲストを register & attach


# そのほか


正常にvert-whoが動くことを確認したら
`virt-who-passwd`でパスワードを暗号化しておく。

[暗号化されたパスワードで virt-who を設定する ](https://access.redhat.com/ja/solutions/2325761)


virt-whoを複数立てると、冗長性が上がるのでおすすめ。
ただし、virt-who-passwdでの暗号は流用できないので、
encrypted_passwordの含まれた.confをコピーしてもダメ。

各々のvirt-whoホストで実行すること(saltにホスト名か何かが入ってるらしい)

`/etc/sysconfig/virt-who`の
`VIRTWHO_SAM=1`は0にしないほうがいいと思う。
デフォルトは1なので特にいじる必要はない。



# 参考

* [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_subscription_management/1/html/virtual_instances_guide/)
* [RHEL サブスクリプション (2013 パッケージ) の使用: シナリオ 5 仮想データセンター](https://access.redhat.com/ja/articles/1435793)
* [virt-whoとは何か](https://www.slideshare.net/moriwaka/virtwho)
* [Red Hat Virtualization Agent (virt-who) Configuration Helper | Red Hat Customer Portal Labs](https://access.redhat.com/labs/virtwhoconfig/)
* [暗号化されたパスワードで virt-who を設定する](https://access.redhat.com/ja/solutions/2325761)
* [仮想インスタンスガイド - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_satellite/6.3/html/virtual_instances_guide/)
* [10.5. virt-who のトラブルシューティング - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/troubleshooting-virt-who) - あんまり役に立たない