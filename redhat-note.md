Red Hat系メモ

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


RHEL Developer Subscription ってどうなったんだっけ?
https://developers.redhat.com/


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
[Linuxのパッケージをアップデートしたあとrestartが必要なプロセスを見つける方法](https://qiita.com/usiusi360/items/7b47be9d0ab5b1acd608)