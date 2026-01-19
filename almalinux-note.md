CentOS7 からの移行で調査。
2022 年にもなって何をしてるんだか、とか 2022 年らしいとか。

# Azure

cockpit 入ってた。

```sh
sudo yum install python39 git tmux -y
sudo yum remove cockpit -y
sudo yum autoremove -y
sudo systemctl disable --now waagent-network-setup.service
```

etckeeper と snap がない

```sh
sudo dnf config-manager --set-enabled powertools
sudo dnf install epel-release -y
sudo git config --global init.defaultBranch main
sudo git config --global core.symlinks true
sudo dnf install etckeeper -y
sudo etckeeper init
sudo dnf install snapd -y
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install emacs --classic
```

```sh
sudo yum install ansible -y
```

python36 要求される

```sh
sudo update-alternatives --config python3
```

で 39 選ぶ

nc も-vz が使えるバージョンに

```bash
sudo yum install netcat
sudo update-alternatives --config netcat
```

update-alternatives、非対話式に選べないの? 調べる

この記事の後半とか。
[Ubuntu - Python 3.9のインストール方法](https://codechacha.com/ja/ubuntu-install-python39/)
ただシステムワイドに python のバージョンを変更するのはやめとけ。

日本語いるなら

```bash
sudo yum install langpacks-ja.noarch -y
sudo localectl set-locale LANG=ja_JP.UTF-8
/etc/locale.conf
```

なんか /etc/profile.d/lang.sh 無視されるな...

# AWS

ec2-user だった。

```bash
aws ec2 describe-images --owners aws-marketplace \
  --query 'reverse(sort_by(Images, &Name))[].[Name,ImageId,CreationDate]' --output table \
  --filters 'Name=name,Values="AlmaLinux OS 8*x86_64*"'
```

marketplace 似た名前のがいろいろあってヤバい。

```
#cloud-config
repo_update: true
repo_upgrade: none
# repo_upgrade: all だとなぜかkernelが更新されない。runcmdでやる。

locale: ja_JP.utf8
timezone: Asia/Tokyo

# packages:
#  - tmux
#  - git
#  - emacs-nox

runcmd:
 - yum remove cockpit-bridge cockpit-system cockpit-ws -y
 - yum autoremove -y
 - yum config-manager --set-enabled powertools -y
 - yum install epel-release -y
 - yum upgrade -y
 - yum install emacs-nox tmux git etckeeper mlocate -y
 - reboot
```

# resolver

Alma って systemd-resolved じゃないのか... Cent もそうだな。
RHEL8 は systemd-resolved だったような。

[第40章 異なるドメインでの各種 DNS サーバーの使用 Red Hat Enterprise Linux 8 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/using-different-dns-servers-for-different-domains_configuring-and-managing-networking)
