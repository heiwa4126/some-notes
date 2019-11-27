# EPEL & IUS ノート

なぜかこの2019年にRHEL6を新しく作る作業をして、
EPELとIUSの設定をググるのに若干時間がかかったので
メモしておく。

# install

公式:
[Getting Started - IUS](https://ius.io/GettingStarted/)

RHEL6

``` bash
sudo yum install -y \
 https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm \
 https://rhel6.iuscommunity.org/ius-release.rpm
```

RHEL7

``` bash
sudo yum install -y \
 https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 https://rhel7.iuscommunity.org/ius-release.rpm
```

よく使うものセット

``` bash
sudo yum install tmux git222 etckeeper jq -y
sudo etckeeper init
sudo etckeeper commit "Initial"
```

gitは既に入ってるかも。その場合はyum remove。
git2u, git222など新しいのあるかも。

python36uは
RHEL7の場合公式レポジトリ(rhel-7-server-rpms)に
python3が入ったので、そっちを。

RHEL8ならApplication Streamsで。
[Red Hat Enterprise Linux 8にPythonをインストールする ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/in-search-of-lost-python-at-rhel-8/)
