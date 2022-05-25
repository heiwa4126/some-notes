

# Azure

cockpit入ってた。

```sh
sudo systemctl disable --now waagent-network-setup.service
sudo yum install python39 git tmux -y
sudo yum remove cockpit python36 -y
sudo yum autoremove -y
```

etckeeperとsnapがない

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
python36要求される

```sh
sudo update-alternatives --config python3
```
で39選ぶ

ncも-vzが使えるバージョンに
```bash
sudo yum install netcat
sudo update-alternatives --config netcat
```
