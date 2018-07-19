
ansibleメモランダム

# tips

ansibleをまるごとgit cloneしておくと捗る。Dymamic inventoryなどハードリンクすると楽。
* [ansible/ansible: Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy. Avoid writing scripts or custom code to deploy and update your applications — automate in a language that approaches plain English, using SSH, with no agents to install on remote systems. https://docs.ansible.com/ansible/](https://github.com/ansible/ansible)


コマンドにverboseオプション(-v)がある。4つまでいけるみたい(-vvvv)。

# 感想

- chefよりは簡単に使い始められる感じ。あとchefより軽い。
- でもpipとか(--userとか、~/.local/binとか)、python2,3の話とかは慣れてないと辛いかも。
- あとgitも慣れてるといいかも。

# モジュール

モジュールのドキュメントのありか

* [Module Index — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html)

↑カテゴリーインデックスで若干使いにくい。[Index of /ansible/latest/modules](https://docs.ansible.com/ansible/latest/modules/)の方が楽なときも。

```
ansible-doc {{module_name}}
```
も

## Windowsのモジュール

* [Windows modules — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/list_of_windows_modules.html)


## setup

ホストの情報を取ってくる

* [setup - Gathers facts about remote hosts — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/setup_module)

使い方例
```
ansible all -i hosts -m setup
```

# WindowsをAnsibleで管理できるようにする

正しくWinRMを有効にするのが
ずいぶん面倒だったものだが、
最近はスクリプト1個でなんとかなるので凄い。

これ→ https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

以下のようにpowershellから入手&実行
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
powershell -ExecutionPolicy RemoteSigned .\ConfigureRemotingForAnsible.ps1
```

参考:
* [AnsibleでWindowsを操作する準備をする](https://qiita.com/yunano/items/f9d5652a296931a09a70)


WinRMの設定を確認。
```
winrm get winrm/config
```

↑で
* BASIC認証が有効
* HTTPSが有効
* TrustedHostsにansibleのhostが入っていること

をチェック。以下例(抜粋):

```
   Client
       NetworkDelayms = 5000
       URLPrefix = wsman
       AllowUnencrypted = false
       Auth
           Basic = true <- ここ
           Digest = true
           Kerberos = true
           Negotiate = true
           Certificate = true
           CredSSP = false
       DefaultPorts
           HTTP = 5985
           HTTPS = 5986 <- ここ
       TrustedHosts = xx.xxx.xx.xx <-ここ
```

TrustedHostsは
```
Set-Item WSMan:\localhost\Client\TrustedHosts -Value {{ホスト名やIP}}}
```
で。

例:
```
* 複数のホスト名やIPアドレスを設定する場合
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "host1, host2"

* すべてのホストを信頼する場合
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*"

* 現在設定されているTrustedHostsを確認
Get-Item WSMan:\localhost\Client\TrustedHosts

* 設定されているTrustedHostsをすべて消去
Clear-Item WSMan:\localhost\Client\Trustedhosts
```

↑引用元:
* [PowerShellでリモートからコマンドを実行する - Masato's IT Library](https://mstn.hateblo.jp/entry/2016/09/13/193124)


Ubuntu 18.04 LTS では python2 用の winrmパッケージがなかった(python3用はある)。`pip install pywinrm --user`で入れる。

こんなインベントリを書く。

```
[windows]
w1 ansible_host=XXXXX

[windows:vars]
ansible_user=administrator
ansible_password=XXXXXX
ansible_port=5986
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

**win_ping**モジュールでテスト(pingモジュールはダメ)。
```
ansible windows -i hosts-win -m win_ping
```
* [win_ping - A windows version of the classic ping module — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_ping_module.html#win-ping-module)

うまくいったらsetupモジュールでfactを見てみる(setupはwin_setupとか無い)。

