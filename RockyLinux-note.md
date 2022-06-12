
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

# Azure

`Rocky Enterprise Software`でマーケットプレイスを探せば出てくる。
