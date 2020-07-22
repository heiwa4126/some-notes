# Snappyメモ

- [Snappyメモ](#snappyメモ)
- [リンク](#リンク)
- [proxy](#proxy)
- [snapdで古いのを消す](#snapdで古いのを消す)
- [RHEL/CentOS 7でsnappy](#rhelcentos-7でsnappy)


# リンク

- [Snapcraft - Snaps are universal Linux packages](https://snapcraft.io/) - 公式サイト
- 一例として - [Install Go for Linux using the Snap Store | Snapcraft](https://snapcraft.io/go)
- 一例として - [Install GNU Emacs for Linux using the Snap Store | Snapcraft](https://snapcraft.io/emacs)
- [Snappy - Wikipedia](https://ja.wikipedia.org/wiki/Snappy)
- [Snappy (package manager) - Wikipedia](https://en.wikipedia.org/wiki/Snappy_(package_manager))


# proxy

proxyが`10.250.42.37`だとして
```
sudo emacs /etc/systemd/system/snapd.service.d/snap_proxy.conf
[Service]
Environment="HTTP_PROXY=http://10.250.42.37:3128"
Environment="HTTPS_PROXY=http://10.250.42.37:3128"
EOF
sudo systemctl daemon-reload
sudo systemctl restart snapd.service
sudo snap refresh
```

# snapdで古いのを消す

snapdは新しいのどんどん更新する。
ほっとくと以下のようになる。

例)
``` bash
$ snap list --all
Name              Version    Rev   Tracking  Publisher   Notes
amazon-ssm-agent  2.3.662.0  1455  stable/…  aws✓        disabled,classic
amazon-ssm-agent  2.3.672.0  1480  stable/…  aws✓        classic
core              16-2.41    7713  stable    canonical✓  core,disabled
core              16-2.42    7917  stable    canonical✓  core
go                1.13       4409  1.13      mwhudson    disabled,classic
go                1.13.1     4517  1.13      mwhudson    classic
```

１つ前のを残す仕掛けらしい。

で、古いのを消す例
```
snap remove core --revision=7713
```

まとめて消したいときは:

[How to remove disabled (unused) snap packages with a single line of command? - Ask Ubuntu](https://askubuntu.com/questions/1036633/how-to-remove-disabled-unused-snap-packages-with-a-single-line-of-command)


# RHEL/CentOS 7でsnappy

参考: [Install Snapd and Snap applications on Fedora 30 / Fedora 29/28 | ComputingForGeeks](https://computingforgeeks.com/install-snapd-and-snap-applications-on-fedora/)

``` bash
yum update -y
yum install yum-plugin-copr epel-release -y
yum copr enable ngompa/snapcore-el7 -y
yum install snapd bridge-utils -y
systemctl enable --now snapd.socket
systemctl enable --now snapd
ln -s /var/lib/snapd/snap /snap
```
PATHは`/etc/profile.d/snapd.sh`で入るので、
一旦ログアウトしてログインするのが楽。

[ngompa/snapcore-el7 Copr](https://copr.fedorainfracloud.org/coprs/ngompa/snapcore-el7/)

RHEL7でemacs26が使えるのが便利。
```sh
sudo snap install emacs --classic
```
