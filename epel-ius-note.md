# EPEL & IUS ノート

なぜかこの2019年にRHEL6を新しく作る作業をして、
EPELとIUSの設定をググるのに若干時間がかかったので
メモしておく。

# install

公式:
[Getting Started - IUS](https://ius.io/GettingStarted/)

RHEL6

``` bash
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm https://rhel6.iuscommunity.org/ius-release.rpm
```

よく使うものセット

``` bash
sudo yum install tmux git2u etckeeper python36u jq
sudo etckeeper init
```
