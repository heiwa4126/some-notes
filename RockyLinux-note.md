
# AWSのAMI

[クラウドイメージ | Rocky Linux](https://rockylinux.org/ja/cloud-images/)

ここでリージョンを選ぶとAMIが。Almaと違って コミュニティAMI

AWS版はcockpit入ってた。

[cockpit 🚀 - uninstall/remove cockpit | bleepcoder.com](https://bleepcoder.com/cockpit/477748908/uninstall-remove-cockpit)

User-Data
```sh
#!/bin/sh
sudo yum remove cockpit-bridge cockpit-system cockpit-ws -y
sudo yum autoremove
sudo yum install epel-release -y
sudo yum clean all
sudo yum install emacs-nox tmux git etckeeper mlocate -y
sudo yum update -y
```

cloud-config 試作
```
#cloud-config
repo_update: true
repo_upgrade: none

locale: ja_JP.utf8
timezone: Asia/Tokyo

# packages:
#  - tmux
#  - git
#  - emacs-nox

runcmd:
 - yum remove cockpit-bridge cockpit-system cockpit-ws -y
 - yum autoremove -y
 - yum install epel-release -y
 - yum upgrade -y
 - yum install emacs-nox tmux git etckeeper mlocate -y
 - reboot
```

なんだかマーケットプレイスのせいか、スクリーンショットもとれない...

ログインユーザは `rocky`


# Azure

`Rocky Enterprise Software`でマーケットプレイスを探せば出てくる。
