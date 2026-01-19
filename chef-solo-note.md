2018 年だというのに Chef Solo.

- [概要](#概要)
- [Ubuntu 1604LTSでテスト](#ubuntu-1604ltsでテスト)
- [defaultにhashをmergeする方法](#defaultにhashをmergeする方法)
- [Ubuntu 1804LTSでテスト](#ubuntu-1804ltsでテスト)

# 概要

なんか大人の事情で Chef Solo で動いてるシステムのデバッグを頼まれて不幸だ。

Chef Solo とは

- ローカルで動く Chef。
- 廃止されて、Chef Zero(Chef local mode)になった。
- Chef Solo から Zero への以降はぜんぜん簡単じゃないらしい。

らしい。local なので ansible の inventry みたいのは無い、ということらしい。

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

古すぎて`chef generate`が無い(というか/usr/bin/chef が無い)。
かわりに`knife`が chef パッケージに付いてる。

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
file_cache_path と cookbook_path を編集する。

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

# defaultにhashをmergeする方法

attributes/\*.rb で default に hash を merge したい時

```
default.merge!(h)
```

だと、default に h が代入されてしまう。(他の\*.rb で設定された値が消える)

```
h.each { |k, v| default[k].merge!(v) }
```

とかすると「とりあえず」動く。「とりあえず」なのは下の枝がそっくり置き換えられてしまうから。

参考:

- [Class: Chef::Node::VividMash — Documentation for chef/chef (master)](https://www.rubydoc.info/github/chef/chef/Chef/Node/VividMash)
- [Module: Chef::Mixin::DeepMerge — Documentation for opscode/chef (master)](https://www.rubydoc.info/github/opscode/chef/Chef/Mixin/DeepMerge)

# Ubuntu 1804LTSでテスト

1804 だと chef-zero になってるはず。
`apt install chef`で入れてバージョン確認

```
$ chef-solo --version
Chef: 12.14.60
```

12.3.0 で作った
簡単な solo プロジェクトを置いて実行してみると、
エラーと警告がぞろぞろ出る。

なんだか
超めんどくさい。
