
ansibleメモランダム

# tips

## git

ansibleをまるごとgit cloneしておくと捗る。Dymamic inventoryなどハードリンクすると楽。
* [ansible/ansible: Ansible is a radically simple IT automation platform that makes your applications and systems easier to deploy. Avoid writing scripts or custom code to deploy and update your applications — automate in a language that approaches plain English, using SSH, with no agents to install on remote systems. https://docs.ansible.com/ansible/](https://github.com/ansible/ansible)

手順は
```
git clone https://github.com/ansible/ansible.git --recursive
```

参考: これの"Running From Source"のところ
* [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#running-from-source)

## verbose

コマンドにverboseオプション(-v)がある。4つまでいけるみたい(-vvvv)。

# 感想

- chefよりは簡単に使い始められる感じ。あとchefより軽い。
- でもpipとか(--userとか、~/.local/binとか)、python2,3の話とかは慣れてないと辛いかも。
- あとgitも慣れてるといいかも。
- 制御構造がわかりにくくて死ねる。
- バージョンによって結構変わる。
- YAMLのsyntax checkのあるエディタを使わないと即死(emacsだとyaml-mode & flymark-yaml)
  - 実はPlaybookや変数ファイルはJSONやINIで書いてもいいらしい

# loopについて

* [Loops — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)
* [2.6からwith_xxxxなループはloopに併合されました](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html?highlight=with_items#migrating-from-with-x-to-loop)

## Blockでloopが使えない

世界的に怨嗟の声が。
* [feature request: looping over blocks · Issue #13262 · ansible/ansible](https://github.com/ansible/ansible/issues/13262)

実際なんで使えないのかわからん。


## loopをitemのままで使うとincludeでネストしたときに警告が

こんな警告
```
[WARNING]: The loop variable 'item' is already in use. You should set the `loop_var` value in the `loop_control` option for the task to
something else to avoid variable collisions and unexpected behavior.
```

loop_controlの使用例
```
    - loop: "{{initial_users}}"
      loop_control: {loop_var: user}
      include_tasks: include/create_a_user.yml
```

## lookup
[Lookup Plugins — Ansible Documentation](https://docs.ansible.com/ansible/latest/plugins/lookup.html#query)

面白そう。調べる。

# ansible_os_familyのリスト

[[When] Condition: `ansible_os_family` Lists | ansible Tutorial](http://www.riptutorial.com/ansible/example/12268/-when--condition----ansible-os-family--lists)

ソースの何処かに埋め込まれているか... これとか?

[ansible/distribution.py at 1737b7be3ecaa6fea9372fe9ba7d8fe659a4e95f · ansible/ansible](https://github.com/ansible/ansible/blob/1737b7be3ecaa6fea9372fe9ba7d8fe659a4e95f/lib/ansible/module_utils/facts/system/distribution.py#L413)

Windowsが無いようだが。


# includeの変遷

* [Ansible 2.4 で import_tasks/include_tasks に tags を付けるときの注意点 - 無印吉澤](https://muziyoshiz.hatenablog.com/entry/2018/01/15/231213)
* [Creating Reusable Playbooks — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html)


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


## setupモジュール

ホストの情報を取ってくる

* [setup - Gathers facts about remote hosts — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/setup_module)

使い方例
```
ansible all -i hosts -m setup
```

## win_sayモジュール

[win_say - Text to speech module for Windows to speak messages and optionally play sounds — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_say_module.html)

クライアントが喋るらしいw。Exampleが面白い。


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

## ansible 2.6.1のwin_rebootが壊れている

pipで取れるansible 2.6.1のwin_rebootが壊れていた話。

こんな感じのメッセージが
```
fatal: [w1]: FAILED! => {"changed": false, "elapsed": 600, "msg": "timed out waiting for reboot uptime check success: Invalid settings supplied for _extras: Requested option _extras was not defined in configuration", "rebooted": true}
```

AnsibleのIssuesに上がってた。

* [win_reboot fails when windows VM hostname is changed · Issue #42294 · ansible/ansible](https://github.com/ansible/ansible/issues/42294)

↑に従って、最新のをソースから実行↓

* [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#running-from-source)

```
$ source ./hacking/env-setup
$ ansible --version
ansible 2.7.0.dev0 (devel bea8e0200c) last updated 2018/07/19 14:34:25 (GMT +900)
(略)
```

これでwin_rebootしたらちゃんと動いた。


# "when"が使えるのは?

- Task
- Block
- Role

↓これ見る
[Playbook Keywords — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

構造がわかりにくい。playbook.ymlで配列になってるのが"Play"。上位構造から順に:
- Play
  - Role
    - ...
  - Task
    - Module
    - Block

みたいな感じ?




# rolesの練習: epel

* [Amazon EC2 での EPEL の有効化](https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-enable-epel/)

AWSのRed HatもCentもAmazonLinuxもos_familyはRedHatなのに、
こんなに手法が違う...

Amazon Linux 2とAmazon Linuxでまた違うのが辛い。