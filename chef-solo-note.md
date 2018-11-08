2018年だというのにChef Solo.

<!-- TOC -->

- [概要](#概要)
- [Ubuntu 1604LTSでテスト](#ubuntu-1604ltsでテスト)

<!-- /TOC -->

# 概要

なんか大人の事情でChef Soloで動いてるシステムのデバッグを頼まれて不幸だ。

Chef Soloとは

* ローカルで動くChef。
* 廃止されて、Chef Zero(Chef local mode)になった。
* Chef SoloからZeroへの以降はぜんぜん簡単じゃないらしい。

らしい。localなのでansibleのinventryみたいのは無い、ということらしい。

# Ubuntu 1604LTSでテスト

```
$ sudo apt install chef
$ chef-solo -v
Chef: 12.3.0
```

作業ディレクトリ作る
```
$ mkdir -p ~/works/chef-solo-tutorials ; cd !$
```

古すぎて`chef generate`が無い(というか/usr/bin/chefが無い)。
かわりに`knife`がchefパッケージに付いてる。

```
$ knife cookbook create hello
$ emacs cookbooks/hello/recipes/default.rb
```

cookbooks/hello/recipes/default.rb
```
#
# Cookbook Name:: hello
# Recipe:: default
#
# Copyright 2018, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
log "hello world!" <--これを追加するだけ
```

ローカルなテストなので
`/usr/share/chef/solo.rb`をコピーして
file_cache_pathとcookbook_pathを編集する。
```
$ cp /usr/share/chef/solo.rb .
$ emacs solo.rb
```

こんな感じに
```
base = File.expand_path('..', __FILE__)

file_cache_path    base+'/cache'

cookbook_path      [
  base+'/cookbooks',
  "/var/lib/chef/cookbooks"
]
```
あと
```
mkdir ./cache
```

実行
```
$ chef-solo -c ./solo.rb -o hello
...
[2018-11-02T18:47:21+09:00] INFO: hello world! <--こんな行が出たらOK
...
```