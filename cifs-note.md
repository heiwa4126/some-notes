# たまにしかつかわない CIFS メモ

## 例

```sh
# Red Hat 系
yum install samba-client cifs-util -y
# Debian系
apt-get install cifs-utils -yum
# AWSのUbuntuの場合はこれも実行
apt install -y linux-modules-extra-aws

# マウントポイント作る
mkdir /mnt/unkan

# いちばんかんたんなパターン.
mount.cifs -o "username=bakabaka,password=ahoaho" //111.222.333.444/e$ /mnt/unkan

# 埋め込みやばいのでクレデンシャルファイルにする
mount.cifs -o uid=1001,credentials=/etc/credentials/unkan //111.222.333.444/e$ /mnt/unkan
## chown root /etc/credentials/unkan ; chmod og= /etc/credentials/unkan を忘れないこと

# /etc/fstabに 書くときはsystemdのオートマウントにする。
# ファイルサーバが死んでるときや、ネットワークが死んでるときに、マウントが失敗してもホストが起動できるようにする
## /mnt/unkan   cifs  noauto,nofail,_netdev,x-systemd.device-timeout=30,x-systemd.automount,credentials=/etc/credentials/unkan  0 0
```

最後の行の解説:

- `/mnt/unkan`は、ローカルマシン上のマウントポイントです。
- `cifs`は、マウントするファイルシステムの種類を指定しており、ここでは Common Internet File System(CIFS)を使用することを示しています。
- `noauto`は、システム起動時に自動的にマウントしないことを意味します。
- `nofail`は、マウントに失敗しても起動プロセスを続行することを示しています。
- `_netdev`は、ネットワークが起動した後にマウントを試みることを意味します。
- `x-systemd.device-timeout=30`は、マウントの試行を 30 秒で打ち切ることを指定しています。
- `x-systemd.automount`は、systemd による自動マウントを有効にします。
- `credentials=/etc/credentials/unkan`は、マウントに必要な認証情報が `/etc/credentials/unkan` ファイルに格納されていることを示しています。
- 最後の `0 0` は、ファイルシステムのバックアップ(dump)と、ファイルシステムの整合性チェック(fsck)のオプションを指定していますが、ここでは無視されています。

2024 年現在では若干 deprecated や obsolete なオプションがある。
