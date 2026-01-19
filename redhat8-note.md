# Red Hat Enterprise Linux 8

- [Red Hat Enterprise Linux 8](#red-hat-enterprise-linux-8)
- [install](#install)
- [dnf-makecache](#dnf-makecache)
- [yum-config-manager](#yum-config-manager)

# install

Azure で入れてみた。
[Red Hat Enterprise Linux 8 (.latest, LVM) - Microsoft Azure](https://portal.azure.com/#create/hub)

Python も perl も入ってないのがすごい。LVM だし。さすがに GPT ではなかった。

```
# lsblk
NAME              MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                 8:0    0   32G  0 disk
|-sda1              8:1    0    1G  0 part /boot
`-sda2              8:2    0   31G  0 part
  |-rootvg-tmplv  253:0    0    2G  0 lvm  /tmp
  |-rootvg-usrlv  253:1    0   10G  0 lvm  /usr
  |-rootvg-optlv  253:2    0    2G  0 lvm  /opt
  |-rootvg-homelv 253:3    0    1G  0 lvm  /home
  |-rootvg-varlv  253:4    0    8G  0 lvm  /var
  `-rootvg-rootlv 253:5    0    8G  0 lvm  /
sdb                 8:16   0    4G  0 disk
`-sdb1              8:17   0    4G  0 part /mnt/resource
sr0                11:0    1  628K  0 rom
```

emacs は 26

```
yum install langpacks-ja tmux emacs-nox
```

Red Hat の Python で書かれたコードは
例えば yum(dnf-3)
/usr/libexec/platform-python を使う。

```
# ls -la /usr/libexec/platform-python
lrwxrwxrwx. 1 root root 20 Apr  4 02:28 /usr/libexec/platform-python -> ./platform-python3.6
# rpm -qf /usr/libexec/platform-python3.6
platform-python-3.6.8-2.el8_0.x86_64
```

これで勝手に pip とかでライブラリ入れても問題ないわけだ。

```
# yum install python3
Failed to set locale, defaulting to C
Last metadata expiration check: 0:05:08 ago on Fri Aug  9 13:41:22 2019.
Dependencies resolved.
========================================================================================================================
 Package             Arch    Version                                  Repository                                   Size
========================================================================================================================
Installing:
 python36            x86_64  3.6.8-2.module+el8.0.0+2975+e0f02136     rhui-rhel-8-for-x86_64-appstream-rhui-rpms   19 k
Installing dependencies:
 python3-pip         noarch  9.0.3-13.el8                             rhui-rhel-8-for-x86_64-appstream-rhui-rpms   18 k
 python3-setuptools  noarch  39.2.0-4.el8                             rhui-rhel-8-for-x86_64-baseos-rhui-rpms     162 k
Enabling module streams:
 python36                    3.6

Transaction Summary
========================================================================================================================
Install  3 Packages

Total download size: 200 k
Installed size: 466 k
```

これだと python で python3 が使えない。

```
man unversioned-python
```

を参考に

```
alternatives --set python /usr/bin/python3
```

あとは per user で

```
pip3 install --user -U pip
```

sshd で

```
PermitRootLogin yes
```

になってる。コメントアウトする。ポート追加する。

```
semanage port -l | grep ssh
semanage port -a -t ssh_port_t -p tcp 4126
semanage port -l | grep ssh
```

あと firewalld も。

# dnf-makecache

よくエラーが出ている。

```
$ systemctl status dnf-makecache.timer
  dnf-makecache.timer - dnf makecache --timer
   Loaded: loaded (/usr/lib/systemd/system/dnf-makecache.timer; enabled; vendor preset: enabled)
   Active: active (waiting) since Wed 2022-03-30 00:56:13 UTC; 10min ago
  Trigger: Wed 2022-03-30 01:33:28 UTC; 26min left

Mar 30 00:56:13 drill-r8.nexs-demo.com systemd[1]: Started dnf makecache --timer.


$ cat /usr/lib/systemd/system/dnf-makecache.timer
[Unit]
Description=dnf makecache --timer
ConditionKernelCommandLine=!rd.live.image
# See comment in dnf-makecache.service
ConditionPathExists=!/run/ostree-booted
Wants=network-online.target

[Timer]
OnBootSec=10min
OnUnitInactiveSec=1h
RandomizedDelaySec=60m
Unit=dnf-makecache.service

[Install]
WantedBy=timers.target


$ cat /usr/lib/systemd/system/dnf-makecache.service
[Unit]
Description=dnf makecache
# On systems managed by either rpm-ostree/ostree, dnf is read-only;
# while someone might theoretically want the cache updated, in practice
# anyone who wants that could override this via a file in /etc.
ConditionPathExists=!/run/ostree-booted

After=network-online.target

[Service]
Type=oneshot
Nice=19
IOSchedulingClass=2
IOSchedulingPriority=7
Environment="ABRT_IGNORE_PYTHON=1"
ExecStart=/usr/bin/dnf makecache --timer

$ sudo dnf makecache
(略)
```

止めるときは

```bash
sudo systemctl disable dnf-makecache.timer
sudo systemctl stop dnf-makecache.timer
```

あるいは

```bash
sudo systemctl disable dnf-makecache.timer --now
```

# yum-config-manager

8 系では dnf のサブコマンド(プラグイン)になった。

[DNF config\-manager Plugin — dnf\-plugins\-core 4\.3\.1\-1 documentation](https://dnf-plugins-core.readthedocs.io/en/latest/config_manager.html)

あとこれも参照
[DNF ツールを使用したソフトウェアの管理 Red Hat Enterprise Linux 9 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/9/html-single/managing_software_with_the_dnf_tool/index#proc_listing-repositories_assembly_searching-for-rhel-9-content)

epel(あれば)をちょっと無効にして、また有効にしてみるテスト。

```bash
dnf repolist epel  # 現状の表示
sudo dnf config-manager --disable epel
dnf repolist epel  # 結果の表示
sudo dnf config-manager --enable epel
dnf repolist epel  # 結果の表示
```
