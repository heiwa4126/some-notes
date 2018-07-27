
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
- デバッガーがあって嬉しい

# loopについて

* [Loops — Ansible Documentation (超参考になる)](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)
* [2.6からwith_xxxxなループはloopに併合されました](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html?highlight=with_items#migrating-from-with-x-to-loop)

## Blockでloopが使えない

世界的に怨嗟の声が。
* [feature request: looping over blocks · Issue #13262 · ansible/ansible](https://github.com/ansible/ansible/issues/13262)

実際なんで使えないのかわからん。whenは使えるのに。


## loopをitemのままで使うとincludeでネストしたときに警告が

こんな警告
```
[WARNING]: The loop variable 'item' is already in use. You should set the `loop_var` value in the `loop_control` option for the task to something else to avoid variable collisions and unexpected behavior.
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

↑カテゴリーインデックスで若干使いにくい。

* [All modules — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html)

コマンドラインで
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

## win_hostnameモジュール

2.6から

[win_hostname - Manages local Windows computer name. — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_hostname_module.html#win-hostname-module)


名前しかダメ。プライマリDNSサフィックスはどこで設定するのか...

net_systemモジュールみたいのがほしい。

# yaml2json

混乱したらJSONに変換してみるとらくだと思う。
pythonでワンライナーを書いてるひとがいたので(
[plist ファイルの代わりに YAML を使ってみた](https://qiita.com/kitsuyui/items/d254d3f0ba84c6a5d04d))
それを参考に
```
alias y2j="python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'"
```
標準入力を変換なので、ちょっとだけ使いにくい。少し改造する。


ansible-playbookの`--syntax-check`オプションも。
ただしPlaybookのチェックしかできない(includeとかはダメ)。


# userモジュールでパスワードの扱い

/etc/shadowに**そのまま**入るので、何らかのハッシュ化が必要。

平文パスワードを渡すつもりなら `password_hash()`フィルタが便利。
[Filters — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#hashing-filters)

例)
```
- name: Create a user
  user:
    name: "{{user.user}}"
    password: "{{user.pass|password_hash('sha512')}}"
    group: "{{user.user}}"
    groups: "{{initial_groups[ansible_os_family]}}"
    shell: /bin/bash
    create_home: Yes
  register: create_a_user_result
  vars:
    initial_groups:
      RedHat: [users, wheel]
      Debian: [sudo]
```

これだと、varファイルに平文記述になったりして、やや不安なので、事前にhash化する。
```
python -c 'import crypt; print crypt.crypt("SuperSecretSecretPassword","$6$anySalt")'
```

`$6$salt`の書式
`$id$salt$encrypted`
については
[crypt(3) - Linux manual page](http://man7.org/linux/man-pages/man3/crypt.3.html)
の `glibc feature` を参照。

この方法でもハッシュ化されたパスワードがブルートフォースされるので扱いは注意。


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

追加: CredSSPも有効にしておくといいかも
```
Enable-WSManCredSSP -Role Server -Force
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
           CredSSP = true <- ここも追加
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

**【注意】**
AD環境とかで認証が異なる。 [Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html) 参照

`ansible_winrm_transport` で`ntml`を指定するのが楽そう(深く試していません)。

NTMLよりCredSSPが良さそう。
(機能比較表: [Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#authentication-options))
いろいろ追加準備がある(ansible側にも、管理対象にも)。**今からAnsible使うなら管理対象WindowsでCredSSPを有効にしておくべき。**
[Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#credssp)



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

みたいな感じ? 全然正確でない。

# AmazonLinux2とAnsible

いまのところAmazonLinux2に対応したRoleが少ないみたい。
RedHat系ではなくてAmazon系とかを設けるべきだ。

Amazonだけ
`ansible_distribution_major_version`がNAなので、
https://github.com/geerlingguy/ansible-role-nginx/blob/master/templates/nginx.repo.j2#L3
とかで、でたらめなURIになるし。

参考:
* [Ansible で Amazon Linux と Amazon Linux 2 を見分ける](https://blog.manabusakai.com/2017/12/ansible-for-amazon-linux-2/)

Ansibleで
Amazon Linuxがいたら
用心すること。


# rolesの練習: epel

* [Amazon EC2 での EPEL の有効化](https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-enable-epel/)

AWSのRed HatもCentもAmazonLinuxもos_familyはRedHatなのに、
こんなに手法が違う...

Amazon Linux 2とAmazon Linuxでまた違うのが辛い。


# ansible-galaxyメモ

## デフォルトのroleの場所

- /usr/share/ansible/roles
- /etc/ansible/roles

## 非rootで書き込める場所を追加

~/.ansible.cfgに
```
[defaults]
role_path = ~/.ansible/roles
```
のように記述。':'で複数指定できるらしい。環境変数もあるらしい。

## role_pathのサブディレクトリにroleは置ける?

やってみたらできました。


## ansible-galaxy コマンド

### リスト

```
ansible-galaxy list
```

### 取得

[Ansible Galaxy](https://galaxy.ansible.com/home)の[Ansible Galaxy](https://galaxy.ansible.com/geerlingguy/nginx)を持ってくる例

```
ansible-galaxy install geerlingguy.nginx
```

### 更新

「古いものを見つけて更新する」機能はいまのところない。
roleフォルダ以下もgitではない。

```
ansible-galaxy install --force xxxx.xxx
```
で上書きはできる。


# ansibleのデバッグ

debugモジュール

vオプション(vをたくさん)

ANSIBLE_LOG_PATH環境変数

ANSIBLE_KEEP_REMOTE_FILES環境変数をTrueにセットすると、リモートマシンの~/.ansible/tmpが消えなくなる。

`strategy: debug`で失敗時にデバッグモード。
* [Ansible2.0に対応したansible-playbook-debuggerが便利！](https://qiita.com/Gin/items/740cb728471a82c3f1ba)
* [Ansible の playbook をデバッグしたいときのあれこれ - てくなべ](https://tekunabe.hatenablog.jp/entry/2017/11/03/ansible_debug)
* [Playbook Debugger — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html)
* [Strategies — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)


ansible-playbookの`--syntax-check`オプションでYAMLのチェック

# 参考になったプレイブック

## yum update -y

* [Ansible - Update And Reboot (if required) Amazon Linux Servers | Programster's Blog](https://blog.programster.org/ansible-update-and-reboot-if-required-amazon-linux-servers)

`name=*`は気が付かなかった。
[yumモジュールのドキュメント](https://docs.ansible.com/ansible/latest/modules/yum_module.html)の例参照


# hosts

- hostsキーワードがかけるのはPlayだけ
[Playbook Keywords — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#play)

- hostsには例外が書けない
  (tagを使う)

参考:
* [ansibleで実行対象を切り替える方法 — そこはかとなく書くよん。](http://tdoc.info/blog/2014/05/30/ansible_target_switching.html)
* [Tags — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html)

## when条件でhostsっぽいことをする例

例)
```
---
- name: インベントリで"redhat"グループに属するものを処理
  hosts: all
  gather_facts: no

  tasks:
    - name: 例1 group_namesマジック変数を使う
      debug: msg="{{ ansible_host }} in 'redhat'"
      when: "'redhat' in group_names"

    - name: 例2 groupsマジック変数とinventory_hostnameを使う
      debug: msg="{{inventory_hostname}} in 'redhat'"
      when: "inventory_hostname in groups['redhat']"
```

# jinja2の関数が使える

[Template Designer Documentation — Jinja2 Documentation (2.10)](http://jinja.pocoo.org/docs/2.10/templates/#list-of-global-functions)

くだらないサンプル
```
---
- name: jinja2 functions test
  hosts: all
  gather_facts: no

  tasks:
    - debug:
        var: lipsum()
```

# ansible-vault

パスワードなどを暗号化して、うっかりgithubに上げてしまっても安全に。

参考:
* [Ansible Vault を試す](https://qiita.com/yteraoka/items/d18e3c353b6e15ca84a8)
* [Ansible Vault を賢く使う](https://qiita.com/yteraoka/items/de9da64ca2d9261b0292)

暗号は実行時に展開される。キーは

- ansible.confにvault_password_fileオプションで指定
- 実行時にオプションで指定

# ansible.conf

設定ファイル。優先順位がややこしい。

[Ansible Configuration Settings — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)

```
* ANSIBLE_CONFIG (environment variable if set)
* ansible.cfg (in the current directory)
* ~/.ansible.cfg (in the home directory)
* /etc/ansible/ansible.cfg
```

＄HOMEのだけ.dotで始まるので注意

設定できる値の例(ansible 2.4)
* [Configuration file — Ansible Documentation](https://docs.ansible.com/ansible/2.4/intro_configuration.html)


# 改行問題

Windowsにテンプレートを設定ファイルとして吐くとき、
改行がCRLFでないとまずい
というような場合(逆もありうる。WindowsがAnsibleのホストとか)
回避策はあるのか。

win_templateモジュールのnewline_sequenceで設定できるらしい(2.4から)
templateモジュールにもある。

テストしてみた。
なるほど元のtempleteの改行コードに無関係に出力の改行を制御できる。

例(抜粋)
```
  tasks:
    - name: test1a-lf-crlf
      template:
        src: template/test1.j2
        dest: /tmp/remove-me-test1.conf
        owner: "{{test_user}}"
        group: "{{test_group}}"
        mode: "{{test_mode}}"
        newline_sequence: "\r\n"
```
みたいなことができる。

win_templateとtemplateモジュールの違いは? 

見つけた範囲では
- owner, groupが指定できない (たぶんWinRMアカウントになる。要確認)


参考:
* [win_template - Templates a file out to a remote server — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_template_module.html#notes)
* [template - Templates a file out to a remote server — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/template_module.html#template-module)
* [win_template replaces CRLF (\r\n) with LF (\n) · Issue #1480 · ansible/ansible-modules-core](https://github.com/ansible/ansible-modules-core/issues/1480)
* [ansibleで改行コードの変換 - HPCメモ](http://hpcmemo.hatenablog.com/entry/2017/04/07/142345)

Windosの場合だとUTF-8のBOM問題もあるなあ...


## 改行tips

改行の確認は`od -c`がポータブル。
たくさんあるならもうすこし考える。
