# Red Hat 7

Azureで入れてみた。
[Red Hat Enterprise Linux 8 (.latest, LVM) - Microsoft Azure](https://portal.azure.com/#create/hub)


Pythonもperlも入ってないのがすごい。LVMだし。さすがにGPTではなかった。

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

emacsは26

```
yum install langpacks-ja tmux emacs-nox
```

Red HatのPythonで書かれたコードは
例えばyum(dnf-3)
/usr/libexec/platform-pythonを使う。

```
# ls -la /usr/libexec/platform-python
lrwxrwxrwx. 1 root root 20 Apr  4 02:28 /usr/libexec/platform-python -> ./platform-python3.6
# rpm -qf /usr/libexec/platform-python3.6
platform-python-3.6.8-2.el8_0.x86_64
```

これで勝手にpipとかでライブラリ入れても問題ないわけだ。

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

これだとpythonでpython3が使えない。

```
man unversioned-python
```
を参考に

```
alternatives --set python /usr/bin/python3
```

あとはper userで
```
pip3 install --user -U pip
```

sshdで
```
PermitRootLogin yes
```
になってる。コメントアウトする。ポート追加する。

```
semanage port -l | grep ssh
semanage port -a -t ssh_port_t -p tcp 4126
semanage port -l | grep ssh
```
あとfirewalldも。
