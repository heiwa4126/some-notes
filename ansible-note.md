# Ansible メモランダム

- [ansible の学習 2021](#ansible-の学習-2021)
- [感想](#感想)
- [インストール](#インストール)
  - [自分の好きな手順](#自分の好きな手順)
  - [RHEL7](#rhel7)
  - [Ubuntu/Debian](#ubuntudebian)
  - [pip](#pip)
  - [git](#git)
- [loop について](#loop-について)
  - [block で loop が使えない](#block-で-loop-が使えない)
  - [handlers で block が使えない](#handlers-で-block-が使えない)
  - [block は例外処理ができる](#block-は例外処理ができる)
  - [tempfile モジュールで作ったファイル/ディレクトリは、自動的に消えない](#tempfile-モジュールで作ったファイルディレクトリは自動的に消えない)
  - [Debian 系の/var/run/reboot-required](#debian-系のvarrunreboot-required)
  - [script モジュール](#script-モジュール)
  - [loop を item のままで使うと include でネストしたときに警告が](#loop-を-item-のままで使うと-include-でネストしたときに警告が)
  - [lookup](#lookup)
- [ansible_os_family のリスト](#ansible_os_family-のリスト)
- [include の変遷](#include-の変遷)
- [モジュール](#モジュール)
  - [Windows のモジュール](#windows-のモジュール)
  - [setup モジュール](#setup-モジュール)
  - [win_say モジュール](#win_say-モジュール)
  - [win_hostname モジュール](#win_hostname-モジュール)
- [yaml2json](#yaml2json)
- [changed_when, failed_when](#changed_when-failed_when)
- [TRANSFORM_INVALID_GROUP_CHARS](#transform_invalid_group_chars)
- [Interpreter Discovery](#interpreter-discovery)
- [user モジュールでパスワードの扱い](#user-モジュールでパスワードの扱い)
- [Windows を Ansible で管理できるようにする](#windows-を-ansible-で管理できるようにする)
  - [ansible 2.6.1 の win_reboot が壊れている](#ansible-261-の-win_reboot-が壊れている)
- ["when"が使えるのは?](#whenが使えるのは)
- [AmazonLinux2 と Ansible](#amazonlinux2-と-ansible)
- [roles の練習: epel](#roles-の練習-epel)
- [ansible-galaxy メモ](#ansible-galaxy-メモ)
  - [デフォルトの role の場所](#デフォルトの-role-の場所)
  - [非 root で書き込める場所を追加](#非-root-で書き込める場所を追加)
  - [role_path のサブディレクトリに role は置ける?](#role_path-のサブディレクトリに-role-は置ける)
  - [ansible-galaxy コマンド](#ansible-galaxy-コマンド)
    - [リスト](#リスト)
    - [取得](#取得)
    - [更新](#更新)
- [ansible のデバッグ](#ansible-のデバッグ)
- [参考になったプレイブック](#参考になったプレイブック)
  - [yum update -y](#yum-update--y)
- [hosts](#hosts)
  - [when 条件で hosts っぽいことをする例](#when-条件で-hosts-っぽいことをする例)
- [jinja2 の関数が使える](#jinja2-の関数が使える)
- [ansible-vault](#ansible-vault)
- [ansible.conf](#ansibleconf)
- [改行問題](#改行問題)
  - [win_template と template モジュールの違いは?](#win_template-と-template-モジュールの違いは)
  - [参考](#参考)
  - [改行 tips](#改行-tips)
- [Ansible 2.4 では loop が無い](#ansible-24-では-loop-が無い)
- [参照](#参照)
- [ssh まわり](#ssh-まわり)
- [公開鍵でなくパスワードで ssh 接続する](#公開鍵でなくパスワードで-ssh-接続する)
- [Windows 用の vars 例](#windows-用の-vars-例)
- [ansible.cfg の場所](#ansiblecfg-の場所)
- [Windows で化ける出力を得る](#windows-で化ける出力を得る)
- [local_action](#local_action)
- [fuser の verbose はなぜか stderr に出る](#fuser-の-verbose-はなぜか-stderr-に出る)
- [expect モジュール](#expect-モジュール)
  - [複数ホストの指定](#複数ホストの指定)
- [変数をかける場所と優先度](#変数をかける場所と優先度)
- [dict に key があるときないときの判別](#dict-に-key-があるときないときの判別)
- [playbook を中断する](#playbook-を中断する)
- [ansible-lint](#ansible-lint)
  - [ansible-lint tips](#ansible-lint-tips)
- [ansible.cfg](#ansiblecfg)
- [notify handler の実行順](#notify-handler-の実行順)
- [Windows ドメインアカウントで接続する](#windows-ドメインアカウントで接続する)
- [windows で become:true](#windows-で-becometrue)
- [Galaxy コレクション](#galaxy-コレクション)
- [yum モジュールの state の present と latest の違い](#yum-モジュールの-state-の-present-と-latest-の違い)
- [quote フィルタ](#quote-フィルタ)
- [ansible-playbook の便利オプション](#ansible-playbook-の便利オプション)
- [デバッガ](#デバッガ)
- [vars の優先順序](#vars-の優先順序)
- [トラブルシューティングいろいろ](#トラブルシューティングいろいろ)
  - [requests](#requests)
- [インストール済みのモジュールの一覧を表示する](#インストール済みのモジュールの一覧を表示する)
- [ansible.windows.win_package 用の product_id を探す。](#ansiblewindowswin_package-用の-product_id-を探す)
- [filter plugins のサンプルは](#filter-plugins-のサンプルは)
- [collection の開発](#collection-の開発)
- [roles_path=,collections_path= と \*\_plugins= のちがい](#roles_pathcollections_path-と-_plugins-のちがい)
- [roles や collections の files/や template/はオーバライドできるか?](#roles-や-collections-の-filesや-templateはオーバライドできるか)
- [RHEL 8](#rhel-8)
  - [ほかメモ](#ほかメモ)
- [RHEL8 ターゲットノードの Python](#rhel8-ターゲットノードの-python)
- [とりあえずインベントリーのチェックだけしたいとき](#とりあえずインベントリーのチェックだけしたいとき)
- [ansible-core と ansible](#ansible-core-と-ansible)
- [コンテナベースの Playbook 実行環境 - Ansible Navigator](#コンテナベースの-playbook-実行環境---ansible-navigator)
  - [Ansible Runner](#ansible-runner)
- [Ansible Runner](#ansible-runner-1)
- [ansible-lint 6](#ansible-lint-6)

## ansible の学習 2021

公式が日本語で読めるようになってた。時代はかわっていくんだねぇ。
[はじめに — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/intro_getting_started.html)

ansible.com のトップページも
[Ansible is Simple IT Automation](https://www.ansible.com/)
こんな感じに。

## 感想

- chef よりは簡単に使い始められる感じ。あと chef より軽い
- でも pip とか(--user とか、~/.local/bin とか)、python2,3 の話とかは慣れてないと辛いかも。
- あと git も慣れてるといいかも。
- 制御構造がわかりにくくて死ねる。
- バージョンによって結構変わる。
- YAML の syntax check のあるエディタを使わないと即死(emacs だと yaml-mode & flymark-yaml)
  - 実は Playbook や変数ファイルは JSON や INI で書いてもいいらしい
- デバッガーがあって嬉しい

それ以前に

- ssh を公開鍵暗号方式でつなげるようにする。
- ssh-agent(Mac だったら Keychain)でつなげるようにする。

という部分で敷居が高い人がいるようだけど...

[【Ansible】Inventory ファイルを利用せずに ansible コマンドを実行する | Developers.IO](https://dev.classmethod.jp/server-side/ansible/ansible-without-inventory/)

こういうの ↑ もできるけど、アカウントが違ったりするともうアウトだし。

## インストール

コントロールマシンに ansible をインストールする様々な方法。

個人的には pip で user に入れるのがいいと思う。

公式:

- [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Ansible のインストール — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/installation_guide/intro_installation.html)

### 自分の好きな手順

1. ディストリのパッケージで python3 入れる
2. [pypa/get-pip](https://github.com/pypa/get-pip) を使って、ユーザーローカルに pip3 を入れる(`curl -kL https://bootstrap.pypa.io/get-pip.py -O; python3 get-pip.py -U --user`)
3. ~/.local/bin に PATH を通す
4. `python3 -m pip install --user -U ansible "ansible-lint[community,yamllint]" pywinrm pexpect` する。

(2021-05) ansible-core==2.12 が python3.8 未満をサポートしなくなるので

pthon 3.6 の場合

```sh
PIP3="python3 -m pip"
$PIP3 install --user -U pip setuptools wheel
$PIP3 install --user -U 'ansible-core==2.11.*' ansible 'ansible-lint[community,yamllint]' pywinrm pexpect
```

pthon 3.8 以上の場合

```sh
PIP3="python3 -m pip"
$PIP3 install --user -U pip setuptools wheel
$PIP3 install --user -U ansible-core ansible 'ansible-lint[community,yamllint]' pywinrm pexpect
```

(2021-05-24)
ansible-core>=2.12 では Python 3.8 以上必須らしいので
Python 3.6 から上げにくいホストでは(RHEL7 など)
いろいろあるけどこんなかんじでおおむね OK

```sh
export PIP3="python3 -m pip"
$PIP3 install --user -U pip
hash -r
$PIP3 install --user -U setuptools wheel
$PIP3 install --user -U requests jinja2
$PIP3 install --user -U 'ansible-core==2.11.*' ansible 'ansible-lint[community,yamllint]' pywinrm pexpect
```

2.11.\*だと紫色で

> [DEPRECATION WARNING]: Ansible will require Python 3.8 or newer on the controller starting with Ansible 2.12. Current version: 3.6.9 (default,
> Jan 26 2021, 15:33:00) [GCC 8.4.0]. This feature will be removed from ansible-core in version 2.12. Deprecation warnings can be disabled by
> setting deprecation_warnings=False in ansible.cfg.

って言われるので、上にある通り`deprecation_warnings=False`って書くか(他の deprecation 警告も消えそうなのでおすすめしない)、
`2.10.*`にするか。

Ubuntu 18.04LTS だと公式の python3.8+venv でいけた。

[Ansible\-core 2\.12 — Ansible Core Documentation](https://docs.ansible.com/ansible-core/devel/roadmap/ROADMAP_2_12.html)

- 2021-10-25 Release

これまで ↑ にいろいろ準備する。

### RHEL7

ansible パッケージは別レポジトリなので

```
subscription-manager repos --list | grep -i ansible
```

して探す。2018 年末現在では

```
subscription-manager repos --enable=rhel-7-server-ansible-2-rpms
yum install ansible
```

ansible-2.7.5-1 が入る。

- rhel-7-server-ansible-2-rpms
- rhel-7-server-ansible-2.7-rpms

のようにマイナーバージョンつきのレポジトリがあるので
用途に合わせて選ぶこと。

あと sshpass は rhel-7-server-extras-rpms

参考:

- [第 33 章 Ansible を使用した Red Hat Enterprise Linux System Roles - Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/7.5_release_notes/technology_previews_red_hat_enterprise_linux_system_roles_powered_by_ansible)
- [Red Hat Enterprise Linux (RHEL) System Roles](https://access.redhat.com/articles/3050101)

### Ubuntu/Debian

Ubuntu/Debian で新し目の ansible をパッケージで入れる場合、
この辺参考:

- [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-ubuntu)
- [ansible : Ansible, Inc.](https://launchpad.net/~ansible/+archive/ubuntu/ansible)

Ubuntu の場合

```
apt-get update
apt-get install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install ansible
```

↑proxy 使っている場合は apt の proxy 設定以外に`export=https://...`の類が必要。

### pip

pip3 でインストールすれば、いきなり python3 で動くのがいい感じ。
~/.local/bin にパスを通して(RHEL7 だと標準で、ubuntu だと存在すればパスが通る)

```
sudo apt install python3-pip
pip3 install pip --user
hash -r
pip install ansible --user
hash -r
```

みたいな感じで.

RHEL7, CentOS7 では、

```
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
hash -r
pip install ansible --user
hash -r
```

がいいと思う。たぶん Debian, Ubuntu でも pip はこっちのほうが。

pip なので古いバージョンの ansible も取得できる

```
pip install ansible==2.6 --user
```

のような感じで。

### git

ansible をまるごと git clone しておくと捗る。Dymamic inventory などハードリンクすると楽。

- [Ansible on GitHub](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#ansible-on-github)
- [ansible/ansible - GitHub](https://github.com/ansible/ansible)

手順は

```
git clone https://github.com/ansible/ansible.git --recursive
```

で、時々

```
git pull
```

して更新。

最新環境を使うのは、clone 先で

```
source ./hacking/env-setup
```

する。

参照: これの"Running From Source"のところ

- [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#running-from-source)

git 版は python のモジュールまで用意してくれないので

```
sudo pip install -r ./requirements.txt
```

するか、パッケージ版の ansible をインストールすること。

## loop について

- [Loops — Ansible Documentation (超参考になる)](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)
- [2.6 から with_xxxx なループは loop に併合されました](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html?highlight=with_items#migrating-from-with-x-to-loop)

[これ](https://docs.ansible.com/ansible/latest/user_guide/playbooks_loops.html)の、
「with_xxxx はこう書き換えて」が超参考になる。

### block で loop が使えない

世界的に怨嗟の声が。

- [feature request: looping over blocks · Issue #13262 · ansible/ansible](https://github.com/ansible/ansible/issues/13262)

実際なんで使えないのかわからん。when は使えるのに。

### handlers で block が使えない

なんで?!

### block は例外処理ができる

[Blocks — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_blocks.html)

```
tasks:
 - name: Attempt and graceful roll back demo
   block:
     - debug:
         msg: 'I execute normally'
     - command: /bin/false
     - debug:
         msg: 'I never execute, due to the above task failing'
   rescue:
     - debug:
         msg: 'I caught an error'
     - command: /bin/false
     - debug:
         msg: 'I also never execute :-('
   always:
     - debug:
         msg: "This always executes"
```

すべてのエラーは rescue セクションで捕えられる。

自分は tempfile モジュールで作ったテンポラリディレクトリを削除するのに使っている。

### tempfile モジュールで作ったファイル/ディレクトリは、自動的に消えない

なんで。

### Debian 系の/var/run/reboot-required

実際に出現するのを見たのでメモ

```
heiwa@ip-172-31-1-134:~$ head /var/run/reboot-required*
==> /var/run/reboot-required <==
*** システムの再起動が必要です ***

==> /var/run/reboot-required.pkgs <==
linux-base
```

### script モジュール

[script - Runs a local script on a remote node after transferring it — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/script_module.html)

便利。

おそらく安全のため PATH が制限されていて、
`/usr/local/bin:/usr/bin`
ぐらいしか書かれていないので、自分で追加するかフルパスでコマンドを書く。

### loop を item のままで使うと include でネストしたときに警告が

こんな警告

```
[WARNING]: The loop variable 'item' is already in use. You should set the `loop_var` value in the `loop_control` option for the task to something else to avoid variable collisions and unexpected behavior.
```

loop_control の使用例

```
- loop: "{{initial_users}}"
  loop_control: {loop_var: user}
  include_tasks: include/create_a_user.yml
```

### lookup

[Lookup Plugins — Ansible Documentation](https://docs.ansible.com/ansible/latest/plugins/lookup.html#query)

面白そう。調べる。

## ansible_os_family のリスト

[[When] Condition: `ansible_os_family` Lists | ansible Tutorial](http://www.riptutorial.com/ansible/example/12268/-when--condition----ansible-os-family--lists)

ソースの何処かに埋め込まれているか... これとか?

[ansible/distribution.py at 1737b7be3ecaa6fea9372fe9ba7d8fe659a4e95f · ansible/ansible](https://github.com/ansible/ansible/blob/1737b7be3ecaa6fea9372fe9ba7d8fe659a4e95f/lib/ansible/module_utils/facts/system/distribution.py#L413)

Windows が無いようだが。

## include の変遷

- [Ansible 2.4 で import_tasks/include_tasks に tags を付けるときの注意点 - 無印吉澤](https://muziyoshiz.hatenablog.com/entry/2018/01/15/231213)
- [Creating Reusable Playbooks — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse.html)

パスは絶対パスで書かない場合、playbook の場所相対になるみたい。

## モジュール

モジュールのドキュメントのありか

- [Module Index — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/modules_by_category.html)

↑ カテゴリーインデックスで若干使いにくい。

- [All modules — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html)

コマンドラインで

```
ansible-doc {{module_name}}
```

も

### Windows のモジュール

- [Windows modules — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/list_of_windows_modules.html)

### setup モジュール

ホストの情報を取ってくる

- [setup - Gathers facts about remote hosts — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/setup_module)

使い方例

```
ansible all -i hosts -m setup
```

### win_say モジュール

[win_say - Text to speech module for Windows to speak messages and optionally play sounds — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_say_module.html)

クライアントが喋るらしい w。Example が面白い。

### win_hostname モジュール

2.6 から

[win_hostname - Manages local Windows computer name. — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_hostname_module.html#win-hostname-module)

名前しかダメ。プライマリ DNS サフィックスはどこで設定するのか...

net_system モジュールみたいのがほしい。

## yaml2json

(古い。yq を使うのが楽)

混乱したら JSON に変換してみるとらくだと思う。
python でワンライナーを書いてるひとがいたので(
[plist ファイルの代わりに YAML を使ってみた](https://qiita.com/kitsuyui/items/d254d3f0ba84c6a5d04d))
それを参考に

```
alias y2j="python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)'"
```

標準入力を変換なので、ちょっとだけ使いにくい。少し改造する。

ansible-playbook の`--syntax-check`オプションも。
ただし Playbook のチェックしかできない(include とかはダメ)。

## changed_when, failed_when

command モジュール類を使うときは必ず書くこと。

デフォルト動作は

- 必ず changed.
- return code が 0 以外は failed.

なので。

## TRANSFORM_INVALID_GROUP_CHARS

2.8 から
インベントリでグループに'-'があると警告が出るようになった。

```
[huge-hoga]
host1
host2
host3
```

とかいうのを

```
[huge_hoga]
host1
host2
host3
```

に直す。

Python はだいたいこれ。role でも task でも変数でもなんでも`-`は使わないほうがいい。

## Interpreter Discovery

2.8 から python3,2 で警告が出るようになった。

> [DEPRECATION WARNING]: Distribution Ubuntu 18.04 on host XXX should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html for more information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.

```
deprecation_warnings=False
```

しちゃうと、ありとあらゆる廃止の警告が消えてしまうであろうなので、[Interpreter Discovery — Ansible Documentation](https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html) にあるように
`./ansible.cfg`
に

```
[defaults]
interpreter_python=auto_silent
```

を追加した。

## user モジュールでパスワードの扱い

/etc/shadow に**そのまま**入るので、何らかのハッシュ化が必要。

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

これだと、var ファイルに平文記述になったりして、やや不安なので、事前に hash 化する。

```
python -c 'import crypt; print crypt.crypt("SuperSecretSecretPassword","$6$anySalt")'
```

`$6$salt`の書式
`$id$salt$encrypted`
については
[crypt(3) - Linux manual page](http://man7.org/linux/man-pages/man3/crypt.3.html)
の `glibc feature` を参照。

この方法でもハッシュ化されたパスワードがブルートフォースされるので扱いは注意。

## Windows を Ansible で管理できるようにする

正しく WinRM を有効にするのが
ずいぶん面倒だったものだが、
最近はスクリプト 1 個でなんとかなるので凄い。

これ → https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

以下のように powershell から入手&実行

```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
powershell -ExecutionPolicy RemoteSigned .\ConfigureRemotingForAnsible.ps1
```

追加: CredSSP も有効にしておくといいかも

```
Enable-WSManCredSSP -Role Server -Force
```

参考:

- [Ansible で Windows を操作する準備をする](https://qiita.com/yunano/items/f9d5652a296931a09a70)

WinRM の設定を確認。

```
winrm get winrm/config
```

↑ で

- BASIC 認証が有効
- HTTPS が有効
- TrustedHosts に ansible の host が入っていること

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

TrustedHosts は

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

設定は上書きなので注意(追加じゃない).

↑ 引用元:

- [PowerShell でリモートからコマンドを実行する - Masato's IT Library](https://mstn.hateblo.jp/entry/2016/09/13/193124)

Ubuntu 18.04 LTS では python2 用の winrm パッケージがなかった(python3 用はある)。`pip install pywinrm --user`で入れる。

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

**win_ping**モジュールでテスト(ping モジュールはダメ)。

```
ansible windows -i hosts-win -m win_ping
```

- [win_ping - A windows version of the classic ping module — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_ping_module.html#win-ping-module)

うまくいったら setup モジュールで fact を見てみる(setup は win_setup とか無い)。

**【注意】**
AD 環境とかで認証が異なる。 [Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html) 参照

`ansible_winrm_transport` で`ntml`を指定するのが楽そう(深く試していません)。

NTML より CredSSP が良さそう。
(機能比較表: [Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#authentication-options))
いろいろ追加準備がある(ansible 側にも、管理対象にも)。**今から Ansible 使うなら管理対象 Windows で CredSSP を有効にしておくべき。**
[Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#credssp)

### ansible 2.6.1 の win_reboot が壊れている

pip で取れる ansible 2.6.1 の win_reboot が壊れていた話。

こんな感じのメッセージが

```
fatal: [w1]: FAILED! => {"changed": false, "elapsed": 600, "msg": "timed out waiting for reboot uptime check success: Invalid settings supplied for _extras: Requested option _extras was not defined in configuration", "rebooted": true}
```

Ansible の Issues に上がってた。

- [win_reboot fails when windows VM hostname is changed · Issue #42294 · ansible/ansible](https://github.com/ansible/ansible/issues/42294)

↑ に従って、最新のをソースから実行 ↓

- [Installation Guide — Ansible Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#running-from-source)

```
$ source ./hacking/env-setup
$ ansible --version
ansible 2.7.0.dev0 (devel bea8e0200c) last updated 2018/07/19 14:34:25 (GMT +900)
(略)
```

これで win_reboot したらちゃんと動いた。

## "when"が使えるのは?

- Task
- Block
- Role

↓ これ見る
[Playbook Keywords — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html)

構造がわかりにくい。playbook.yml で配列になってるのが"Play"。上位構造から順に:

- Play
  - Role
    - ...
  - Task
    - Module
    - Block

みたいな感じ? 全然正確でない。

## AmazonLinux2 と Ansible

いまのところ AmazonLinux2 に対応した Role が少ないみたい。
RedHat 系ではなくて Amazon 系とかを設けるべきだ。

Amazon だけ
`ansible_distribution_major_version`が NA なので、
https://github.com/geerlingguy/ansible-role-nginx/blob/master/templates/nginx.repo.j2#L3
とかで、でたらめな URI になるし。

参考:

- [Ansible で Amazon Linux と Amazon Linux 2 を見分ける](https://blog.manabusakai.com/2017/12/ansible-for-amazon-linux-2/)

Ansible で
Amazon Linux がいたら
用心すること。

## roles の練習: epel

- [Amazon EC2 での EPEL の有効化](https://aws.amazon.com/jp/premiumsupport/knowledge-center/ec2-enable-epel/)

AWS の Red Hat も Cent も AmazonLinux も os_family は RedHat なのに、
こんなに手法が違う...

Amazon Linux 2 と Amazon Linux でまた違うのが辛い。

## ansible-galaxy メモ

### デフォルトの role の場所

- /usr/share/ansible/roles
- /etc/ansible/roles

### 非 root で書き込める場所を追加

~/.ansible.cfg などの設定ファイルで

```
[defaults]
role_path = ~/.ansible/roles
```

のように記述。':'で複数指定できるらしい。環境変数もあるらしい。

### role_path のサブディレクトリに role は置ける?

やってみたらできました。

### ansible-galaxy コマンド

#### リスト

```
ansible-galaxy list
```

#### 取得

[Ansible Galaxy](https://galaxy.ansible.com/home)の[Ansible Galaxy](https://galaxy.ansible.com/geerlingguy/nginx)を持ってくる例

```sh
ansible-galaxy install geerlingguy.nginx
```

#### 更新

「古いものを見つけて更新する」機能はいまのところない。
role フォルダ以下も git ではない。

```sh
ansible-galaxy install --force xxxx.xxx
```

で上書きはできる。

## ansible のデバッグ

debug モジュール

v オプション(v をたくさん)

ANSIBLE_LOG_PATH 環境変数

ANSIBLE_KEEP_REMOTE_FILES 環境変数を True にセットすると、リモートマシンの~/.ansible/tmp が消えなくなる。

`strategy: debug`で失敗時にデバッグモード。

- [Ansible2.0 に対応した ansible-playbook-debugger が便利!](https://qiita.com/Gin/items/740cb728471a82c3f1ba)
- [Ansible の playbook をデバッグしたいときのあれこれ - てくなべ](https://tekunabe.hatenablog.jp/entry/2017/11/03/ansible_debug)
- [Playbook Debugger — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html)
- [Strategies — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

ansible-playbook の`--syntax-check`オプションで YAML のチェック

## 参考になったプレイブック

### yum update -y

- [Ansible - Update And Reboot (if required) Amazon Linux Servers | Programster's Blog](https://blog.programster.org/ansible-update-and-reboot-if-required-amazon-linux-servers)

`name=*`は気が付かなかった。
[yum モジュールのドキュメント](https://docs.ansible.com/ansible/latest/modules/yum_module.html)の例参照

## hosts

- hosts キーワードがかけるのは Play だけ
  [Playbook Keywords — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/playbooks_keywords.html#play)

- hosts には例外が書けない
  (tag を使う)

参考:

- [ansible で実行対象を切り替える方法 — そこはかとなく書くよん。](http://tdoc.info/blog/2014/05/30/ansible_target_switching.html)
- [Tags — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html)

### when 条件で hosts っぽいことをする例

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

## jinja2 の関数が使える

[Template Designer Documentation — Jinja2 Documentation (2.10)](http://jinja.pocoo.org/docs/2.10/templates/#list-of-global-functions)

くだらないサンプル

```yaml
---
- name: jinja2 functions test
  hosts: all
  gather_facts: no

  tasks:
    - debug:
        var: lipsum()
```

## ansible-vault

パスワードなどを暗号化して、うっかり github に上げてしまっても安全に。

参考:

- [Ansible Vault — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/vault.html)
- [Ansible Vault を試す](https://qiita.com/yteraoka/items/d18e3c353b6e15ca84a8)
- [Ansible Vault を賢く使う](https://qiita.com/yteraoka/items/de9da64ca2d9261b0292)

暗号は実行時に展開される。キーは

- ansible.conf に vault_password_file オプションで指定
- 環境変数 ANSIBLE_VAULT_PASSWORD_FILE で指定
- 実行時にオプション`--vault-password-file`で指定

で、key ファイルを git 管理パス以外に置く。

暗号はデフォルトで AES256 らしいので、256bit(=32byte)の鍵があればいい。

例)

```sh
mkdir -p ~/.config/ansible
dd if=/dev/urandom of=~/.config/ansible/.ansible_vault bs=32 count=1
```

## ansible.conf

設定ファイル。優先順位がややこしい。

[Ansible Configuration Settings — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)

```
* ANSIBLE_CONFIG (environment variable if set)
* ansible.cfg (in the current directory)
* ~/.ansible.cfg (in the home directory)
* /etc/ansible/ansible.cfg
```

上にあるほど優先順位が高い。

- (in the current directory)があやしい。playbook と同じディレクトリ?
- $ HOME のだけ.dot で始まるので注意。
- ファイルの優先順序であって、「全部中身を読んでオーバライドする」式ではないことに注意(ファイルは 1 個しか読まない)

設定できる値の例(ansible 2.4)

- [Configuration file — Ansible Documentation](https://docs.ansible.com/ansible/2.4/intro_configuration.html)

デフォルトの ansible.cfg は examples の下参照

- [ansible/ansible\.cfg at devel · ansible/ansible](https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg)
  ↑ の raw を curl でもってきておくと便利。

## 改行問題

Windows にテンプレートを設定ファイルとして吐くとき、
改行が CRLF でないとまずい
というような場合(逆もありうる。Windows が Ansible のホストとか)
回避策はあるのか。

win_template モジュールの newline_sequence で設定できるらしい(2.4 から)
template モジュールにもある。

テストしてみた。
なるほど元の templete の改行コードに無関係に出力の改行を制御できる。

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

### win_template と template モジュールの違いは?

template モジュールで windows に送った場合、
owner:, group:, mode: が無視される。
オーナーは WinRM の接続ユーザ、モードは...readOnly とかにならないことは確か。

win_template には
owner:, group:, mode: が無い。

newline_sequence のデフォルト値が異なる。

### 参考

- [win_template - Templates a file out to a remote server — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/win_template_module.html#notes)
- [template - Templates a file out to a remote server — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/template_module.html#template-module)
- [win_template replaces CRLF (\r\n) with LF (\n) · Issue #1480 · ansible/ansible-modules-core](https://github.com/ansible/ansible-modules-core/issues/1480)
- [ansible で改行コードの変換 - HPC メモ](http://hpcmemo.hatenablog.com/entry/2017/04/07/142345)

Windos の場合だと UTF-8 の BOM 問題もあるなあ...

### 改行 tips

改行の確認は`od -c`がポータブル。
たくさんあるならもうすこし考える。

Windows だと`format-hex`が使える(Powershell 5 ぐらいか?)
[Format-HexFormat-Hex | Microsoft Docs](https://docs.microsoft.com/ja-jp/powershell/wmf/5.0/feedback_formathex)

## Ansible 2.4 では loop が無い

```
---
## 2.4では動かない(bug). 2.5ぐらいからOK
- name: loop test ex1
  hosts: all
  gather_facts: no
  tasks:
    - name: loop1
      debug:
        msg: Hello! ({{item}})
      loop:
        - one
        - two
        - three
```

2.4 では死ぬ。

[Issues using variables in loops · Issue #38314 · ansible/ansible](https://github.com/ansible/ansible/issues/38314)

with_items を使う。with_items は loop_control も使える。

例)

```
---
## loop test
## loopは2.4では動かない(loopは2.5から).

- name: loop test ex1
  hosts: redhat
  gather_facts: no
  vars:
    items:
        - one
        - two
        - three
  tasks:
    - name: test
      include_tasks: inc2.yml
      with_items: "{{items}}"
      loop_control: {loop_var: outer_item}
```

inc2.yml

```
---

- debug: var=outer_item
```

## 参照

- [Ansible ドキュメントを活用しよう! モジュールの調べ方 - 赤帽エンジニアブログ](https://rheb.hatenablog.com/entry/2018/10/25/ansible-document)

## ssh まわり

邪悪だが役に立つときもある

- [Ansible の SSH 接続エラーの回避設定 - Qiita](https://qiita.com/taka379sy/items/331a294d67e02e18d68d)
- [ansible sshpass error - Qiita](https://qiita.com/park-jh/items/d14cb20c9dfa0e2628d5)

## 公開鍵でなくパスワードで ssh 接続する

まあ、そういう環境もある。

sshpass 入れて、
`ansible_ssh_pass` にパスワードを書く。

で、そういう環境だと sudoer もちゃんと設定してなくて
su で root になれ、とかいうことがしばしば。

それは
`ansible_become_method` と `ansible_become_pass` で。
(ansible_su_pass よりはいい)

インベントリの all:vars に書いた例(もちろんホスト別にできる)

```
[all:vars]
ansible_port=22
ansible_user=foo
ansible_ssh_pass=sw0rdfizh
ansible_become_method=su
ansible_become_pass=p@ssW0rd
```

TODO: vault にする

参考:
[Inventory | ansible Tutorial](https://riptutorial.com/ansible/topic/1764/%E7%9B%AE%E9%8C%B2)

RHEL7 では sshpass は rhel-7-server-extras-rpms にあるので

```
subscription-manager repos --enable=rhel-7-server-extras-rpms
yum install -y sshpass
```

すること。CentOS7 は EPEL?

## Windows 用の vars 例

インベントリに書いた例

```
[windows:vars]
ansible_user=eraiadmin
ansible_password=himitsunokotoba
ansible_port=5986
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

急いでるときに使うこと。

TODO: ansible_winrm_server_cert_valid を ignore しないようにする方法。AD のときとか

## ansible.cfg の場所

[ansible.cfg を設定しコマンドをシンプルに - aboutnagaishi の日記](http://aboutnagaishi.hatenablog.com/entry/2015/02/14/155734)
から引用 & 修正

ansible tutorial によれば以下の順番で ansible.cfg を探す。

1. カレントディレクトリ
2. 環境変数の ANSIBLE_CONFIG or ~/.ansible.cfg
3. /etc/ansible/ansible.cfg

ansible.cfg 設定例

```
[defaults]
inventory = ./hosts

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

むかしは`inventory`でなく`hostfile`だった。

ssh_connection のところは
[Ansible の SSH 接続エラーの回避設定 - Qiita](https://qiita.com/taka379sy/items/331a294d67e02e18d68d)
からのコピペで、意味はそちらを参照。

ansible.cfg はパッケージでは`/etc/ansible/ansible.cfg`
git 版では`examples/ansible.cfg`
にあるので、それをコピーして編集すると苦労が減ると思う。

## Windows で化ける出力を得る

ansible で情報を引っ張ってくるケースはよくあるんだけれど、
たまに CP932 しか吐かないコマンドがあるので、
それの対応。

[Windows の CP932 に苦闘している件](https://www.slideshare.net/HidetoshiHirokawa/windowscp932-95190631)
にない別解

利点は nkf がいらないこと。

コツは 2 つ:

- win_shell モジュールで、powershell でなく cmd.exe を使う
- 出力をいったんファイルに落とす

w32tm を使った playbook の例

```
---
## sjis vs asnsible
- name: Windows ntpq
  hosts: all
  become: no
  vars:
    outpath: ./var/w32tm
  gather_facts: False

  tasks:
    - name: Ensures ouput directory exists.
      local_action: file path={{outpath}} state=directory
      run_once: true

    - name: create remote temporary directory
      win_tempfile:
        state: directory
        suffix: temp
      register: tmpfile
      changed_when: no

    - name: Run a command.
      win_shell: w32tm /query /status > {{tmpfile.path}}/status.log
      args:
        executable: cmd
      # powershellだと化けるのでcmd.exeを使う
      changed_when: no
      ignore_errors: True
      # 標準出力だと化けるので、registerでなく一旦ファイルに落とす

    - name: Fetch output file
      fetch:
        src: "{{ tmpfile.path }}/status.log"
        dest: "{{ outpath }}/{{inventory_hostname}}.log"
        flat: yes

    - name: remove remote temporary directory
      win_file:
        path: "{{ tmpfile.path }}"
        state: absent
      changed_when: no
```

なぜか改行コードが LF になる。

TODO: 得たファイルを `iconv -f cp932 -t utf8` する。

## local_action

local_action はローカル(コントロールマシン)で実行されるのだけど、
このときにも become の設定が効くので、
`become: yes`だとローカルで sudo/su しようとする。

local_action を使う場合は、
そのタスクに`become: no`をつけとく習慣にするべき。

あるいは必要なところにだけ become: yes するか。
become のデフォルトは no(false)。

ほかから呼ばれる可能性もあるので、
明示したほうがいいかもしれない。

playbook の例。
netstat の-p オプションは su がいるので。

```
---
- name: gather 'netstat -tapn'
  hosts: all
  gather_facts: False
  vars:
    outpath: ./var/netstat-tapn
  tasks:
    - name: Ensures ouput directory exists.
      local_action: file path={{outpath}} state=directory
      run_once: true

    - shell: LANG=C netstat -tapn
      become: yes
      register: rc
      changed_when: no
      ignore_errors: True

    - name: Write result to output file.
      local_action: copy content={{rc.stdout}} dest={{outpath}}/{{inventory_hostname}}.log
```

参考:

- [Understanding Privilege Escalation — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/become.html#id1)

## fuser の verbose はなぜか stderr に出る

しかも PID は stdout に出る。なので
`/sbin/fuser -vn tcp 80`
の出力を集めたいときは

```
- shell: "/sbin/fuser -vn tcp 80 |& cat"
  become: yes
  register: rc
  ignore_errors: True
  changed_when: no
```

みたいなタスクにしないとダメ。

## expect モジュール

- [expect – Executes a command and responds to prompts. — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/expect_module.html)

pexpect >= 3.3 がコントロールマシンではなく
remote 側に必要。

Ununtu 18.04LTS だと
python-pexpect 4.2.1-1
パッケージがあるので簡単だが、

RHEL7, CentOS7 だと、古いパッケージしかなくて、
公式が
「7 では出さない」とか言ってるので
[Does Red Hat ship pexpect 3.3 ? - Red Hat Customer Portal](https://access.redhat.com/solutions/3440581)
pip 入れて、pip install pexpect するしかない。

とりあえず
root の user ディレクトリに

```
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
pip install pexpect -U --user
```

して、影響が外へ出ないようにしてやれば大丈夫(なはず)。

rhscl にも pip はあるのだが、
これで入れてちゃんと動くとは思えない。

いまのところ ansible に win_pexpect はないので誰か contribute してください。

- [expect module fails for windows target systems · Issue #31051 · ansible/ansible · GitHub](https://github.com/ansible/ansible/issues/31051)
- [Windows で pexpect を利用する - Qiita](https://qiita.com/shita_fontaine/items/c2ceb1e66450d7e09490)

### 複数ホストの指定

ちょっと複数ホストや複数グループで ansible を実行したいときに
インベントリーにグループを書くのは面倒。

リスト形式で複数指定できる。

```bash
ansible -m play host1,host2
```

ansible-playbook の-l オプションでも同様。

## 変数をかける場所と優先度

- [Using Variables — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html)
- [Working with Inventory — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

最近の Google 翻訳は大したもんだ。

- [Google 翻訳](https://translate.google.com/translate?hl=&sl=en&tl=ja&u=https%3A%2F%2Fdocs.ansible.com%2Fansible%2Flatest%2Fuser_guide%2Fplaybooks_variables.html)
- [Google 翻訳](https://translate.google.com/translate?hl=&sl=en&tl=ja&u=https%3A%2F%2Fdocs.ansible.com%2Fansible%2Flatest%2Fuser_guide%2Fintro_inventory.html)

## dict に key があるときないときの判別

- [Is there a way to check that a dictionary key is not defined in ansible task? - Server Fault](https://serverfault.com/questions/857973/is-there-a-way-to-check-that-a-dictionary-key-is-not-defined-in-ansible-task)

```yaml
- name: in and not-in
  hosts: localhost
  become: no
  gather_facts: False
  vars:
    d1:
      localhost: 1
    d2:
      nolocalhost: 1

  tasks:
    - debug: var=inventory_hostname

    - debug: msg=OK
      when: 'inventory_hostname in d1'

    - debug: msg=OK
      when: 'inventory_hostname not in d2'

    - debug: msg=WRONG
      when: 'inventory_hostname not in d1'

    - debug: msg=WRONG
      when: 'inventory_hostname in d2'
```

OK が 2 個、WRONG が 0 個出力されるはず

## playbook を中断する

fail モジュールや meta モジュールの `meta: end_host`が使える.

- [fail – Fail with custom message — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/fail_module.html)
- [meta – Execute Ansible ‘actions’ — Ansible Documentation](https://docs.ansible.com/ansible/latest/modules/meta_module.html#meta-module)

## ansible-lint

使おう!
[ansible-community/ansible-lint: Best practices checker for Ansible](https://github.com/ansible-community/ansible-lint)

インストールはだいたい以下の通り

```sh
pip3 install -U --user "ansible-lint[community,yamllint]"
```

参考: [Installing — Ansible Lint Documentation](https://ansible-lint.readthedocs.io/en/latest/installing.html#using-pip)

使い方は:

```sh
ansible-lint foo.yml
```

playbook の複数指定できるので、find や xargs と組み合わせて使える。
include/import してる tasks も見る。

メッセージの意味は以下参照:

- [Default Rules — Ansible Lint Documentation](https://ansible-lint.readthedocs.io/en/latest/default_rules.html)
- [ansible-lint のルールに関するメモ - 遠い叫び](https://magai.hateblo.jp/entry/2018/04/20/162648)

### ansible-lint tips

警告の抑制は

```yaml
- name: Run shell.
  shell: '{{ cmd }}' # noqa command-instead-of-shell
```

こんな感じに`noqa`でできる。

[Rules — Ansible Lint Documentation](https://ansible-lint.readthedocs.io/en/latest/rules.html)

## ansible.cfg

オリジナルは github 上にある。

[ansible/ansible.cfg at devel · ansible/ansible](https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg)

```sh
curl -O https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
```

優先順位は(引用元:[Ansible の動作の制御: 優先順位のルール — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html))

- ANSIBLE_CONFIG (environment variable if set)
- ansible.cfg (in the current directory)
- ~/.ansible.cfg (in the home directory)
- /etc/ansible/ansible.cfg

ANSIBLE_CONFIG は独自の.cfg ファイルのパス

## notify handler の実行順

**yaml に書いた順に上から実行される。**

## Windows ドメインアカウントで接続する

いまのところローカルアドミンでしかつないだことないんだけど、
あとでやるかもしれないのでメモ

ansible_winrm_transport で Kerberos を指定するらしい。
[【Ansible】Windows ドメインアカウントで接続する - Qiita](https://qiita.com/myalpine/items/9361ecd46e3705d8425e)

Kerberos だとローカルアカウントには接続できないのに注意。

必要な手順は ↑ よりは公式参照。各ディストリで要るライブラリ書いてある。

- [Windows リモート管理 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/windows_winrm.html#id2)
- [Windows リモート管理 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/windows_winrm.html#id8)

あと ansible_winrm_transport のデフォルトは NTLM
[Windows Remote Management — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#ntlm)

## windows で become:true

[権限昇格の理解: become — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/become.html#become-windows)

## Galaxy コレクション

> コレクションは、Playbook、ロール、モジュール、およびプラグインを含むことができる Ansible コンテンツのディストリビューション形式です

よくわからん。

- [コレクションの使用 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/collections_using.html)
- [Using collections — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)

## yum モジュールの state の present と latest の違い

- [centos - What is the difference between two "state" option values, "present" and "installed", available in Ansible's yum module? - Stack Overflow](https://stackoverflow.com/questions/40410270/what-is-the-difference-between-two-state-option-values-present-and-install#:~:text=State%20as%20'Present'%20and%20',of%20the%20latest%20available%20version.)
- [6 practices for super smooth Ansible experience - Max Chernyak](https://max.engineer/six-ansible-practices#separate-your-setup-and-deploy-playbooks)

## quote フィルタ

[Using filters to manipulate data — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#manipulating-strings)

```yaml
- name: Run a shell command
  ansible.builtin.shell: echo {{ string_value | quote }}
```

このページ、全体に面白い。

## ansible-playbook の便利オプション

- --syntax-check - playbook のシンタックスチェックだけ。実行しない
- --list-hosts - 対象になるホストのリストを出力して終わる
- --list-tasks - 実行されるであろう全タスクをリスト
- --list-tags - 全タグをリスト
- --check (-C) - 変更はしないで、起こるかもしれない変化のいくつかを予測する
- --diff (-D) - ファイルやテンプレートを変更したときに、それらのファイルの差分を表示。--check と一緒に使うと効果的

`-C`オプションは便利だけど、shell 実行するとことかでは無力。

## デバッガ

普通のデバッガとはかなりちがうけど、一応ある。

[Debugging tasks — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html)

## vars の優先順序

[変数の優先度 - 変数の使用 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_variables.html#ansible-variable-precedence)

> 追加変数 `-e` は常に優先される

[コマンドラインで変数を渡す - 変数の使用 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_variables.html#passing-variables-on-the-command-line)

`-e @xxxx`とすれば xxxx はファイルとみなす。yaml か json が使える。

よくある例: vars2.yml

```yaml
---
- name: vars example 2
  hosts: localhost
  become: false
  gather_facts: false
  vars:
    msg1: 'world'

  tasks:
    - debug:
        msg: 'Hello, {{ msg1 }}!'
```

読みこむファイル: `vars2.json`

```json
{
  "msg1": "こんにちは"
}
```

```
$ ap vars2.yml
(略)
TASK [debug] **********************************************************************************************************************************
ok: [localhost] =>
  msg: Hello, world!
(略)

$ ap vars2.yml -e msg1=goodbye
TASK [debug] **********************************************************************************************************************************
ok: [localhost] =>
  msg: Hello, goodbye!

$ ap vars2.yml -e "@vars2.json"
TASK [debug] **********************************************************************************************************************************
ok: [localhost] =>
  msg: Hello, こんにちは!
```

playbook vars をデフォルト値として(role の default みたいな)、
`-e`でオーバライド、みたいに使うのがいいかな。

## トラブルシューティングいろいろ

### requests

> urllib3 (1.26.4) or chardet (3.0.4) doesn't match a supported version!

みたいのが出たら、requests を更新しましょう

```sh
pip3 install --user -U requests
```

## インストール済みのモジュールの一覧を表示する

```sh
ansible-doc -l
```

特定のモジュールのドキュメントを参照するには以下のように実行します。

```sh
ansible-doc yum
```

## ansible.windows.win_package 用の product_id を探す。

まとめるとこんなかんじ。要管理者権限

```powershell
$a = Get-ChildItem -Path(
  'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
  'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
  'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
)|
?{$_.PSChildName -like '{*' -and $_.PSChildName -like '*}'}|
%{[PSCustomObject]@{"id"=$_.PSChildName.ToUpper();"Name"=($_|Get-ItemProperty).DisplayName}}|
Sort-Object -Property Name
$a
$a|Export-Csv -NoTypeInformation -Encoding default -Path test1.csv
```

これで見つからなければ、コンパネに表示されるプロダクト名は DisplayName として保存されてるので、
regedit で検索。おなじ場所に UninstallString という名前で削除方法が書かれてる。

## filter plugins のサンプルは

[ansible/core\.py at devel · ansible/ansible · GitHub](https://github.com/ansible/ansible/blob/devel/lib/ansible/plugins/filter/core.py)
で `FilterModule`を検索。

## collection の開発

- [Developing collections — Ansible Documentation](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections.html)
- [コレクションの開発 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/dev_guide/developing_collections.html)

作業ディレクトリ作って、デフォルトのコレクションパスに symlink 置く、という手法でいく。

```sh
mkdir -p workdir ; cd workdir
ansible-galaxy collection init heiwa4126.helloworld
cd heiwa4126
ln -s `pwd -p` ~/.ansible/collections/ansible_collections
```

で、`ansible-galaxy collection list`に`heiwa4126.helloworld`があれば OK

```sh
cd helloworld/roles
ansible-galaxy role init helloworld
cd helloworld
emacs tasks/main.yml
```

```yaml
---
- debug: msg="hello world"
```

とか書いて、

playbook は

```yaml
---
- hosts: localhost
  roles:
    - heiwa4126.helloworld.helloworld
```

で OK

role だけでは寂しいので、`collections/heiwa4126/helloworld/plugins/filter/star.py`として

```python
class FilterModule(object):
    def filters(self):
        return {
            "add_stars": lambda str: f"** {str} **",
        }
```

で、playbook を

```yaml
- hosts: localhost
  become: false
  gather_facts: false
  roles:
    - heiwa4126.helloworld.helloworld
  tasks:
    - debug:
        msg: '{{ "hello" | heiwa4126.helloworld.add_stars }}'
```

長いな。namespace だけでも import できないのか。

[\[Ansible\] 自作のコレクションを作って Galaxy で公開するまで \- Qiita](https://qiita.com/zaki-lknr/items/4771b65b2385591e0678)

## roles_path=,collections_path= と \*\_plugins= のちがい

どうも roles_path=,collections_path=は、書いたパスしか探しに行かないけど、
\*\_plugins=はデフォルトパスも探しに行くみたい。

ソース読むか...

## roles や collections の files/や template/はオーバライドできるか?

playbook 側でオーバライドできるか。またオーバライドされたくないときはどうするかをチェックする。

サーチパスが
標準では
ロール側の templates/のほうが優先なので、
playbook でオーバライドできない。
この順: [ansible はどこから template を探すのか? - gom68 の日記](https://gom.hatenablog.com/entry/2018/03/06/183000)

公式ドキュメントはこれかな。 [Search paths in Ansible — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbook_pathing.html)

defaults/に変数書いて、それを playbook で書き換えるしかなさそう。

## RHEL 8

とりあえず古い(2.9)けど RedHat がメンテしてると思うので、これでもいいなら。

参考:

- https://access.redhat.com/articles/3174981
- https://access.redhat.com/ja/articles/4208241

```sh
sudo subscription-manager repos --enable=ansible-2-for-rhel-8-rhui-rpms
sudo yum repolist | grep ansible-2-for-rhel-8-rhui-rpms
sudo yum install ansible -y
```

AWS とか Azure の RedHat ではシステムが registered されてなくて
subscription-manager 使えないとか言われるかもしれないけど
その場合は

```sh
grep -i ansible /etc/yum.repos.d/*.repo
```

でファイルを見つけて、該当部分を enabled=1 にしてださい。

```sh
sudo yum-config-manager --enablerepo ansible-2-for-rhel-8-rhui-rpms
```

みたいのは RHEL8 ではできません。

入れた結果:

```
$ ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/user1/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.6/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.6.8 (default, Jan 14 2022, 11:04:20) [GCC 8.5.0 20210514 (Red Hat 8.5.0-7)]
```

EPEL から入れたほうが楽だとは思うけど
なんか不幸な現場でこういう方法もあり。

ここに RPM もあるので、いよいよダメならここからどうぞ
https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/

このパッケージ版の ansible の使う python ってどこにあるの?
/usr/libexec/platform-python (Python 3.6)を使うらしい。

### ほかメモ

> Red Hat Enterprise Linux (RHEL) のすべてのオンデマンド Amazon マシンイメージ (AMI) は、AWS で Red Hat Update Infrastructure (RHUI) を使用するように構成されています。

[Red Hat よくある質問](https://aws.amazon.com/jp/partners/redhat/faqs/)

## RHEL8 ターゲットノードの Python

RHEL7 までは必ず python2 が入っていて、コントロールマシン以外ではそれを使っていたわけだけど、
RHEL8 からは /usr/libexec/platform-python 式になって、パスに`python`が無い。

[RHEL8 系ディストリビューションで Python 3 を使う - Qiita](https://qiita.com/yamada-hakase/items/ed38a66ac10cf9cfe07e)

んで

[RHEL8 を Ansible から触ってみよう! - 赤帽エンジニアブログ](https://rheb.hatenablog.com/entry/ansible_on_rhel8)

いいのかこんなんで。まあ RedHat の人が書いてるんだからいいんでしょうけど。

いま Red Hat 8.6 とパッケージ版の ansible2.9 でやってみたら
/usr/libexec/platform-python を discover したので
なんの設定もいらないみたい。なんか環境依存っぽいような気もする。

## とりあえずインベントリーのチェックだけしたいとき

```sh
ansible --list-hosts all
```

でホストのリストがでます。

`all` のところは好きなグループを。
認証がどうでもネットワークがなにもなくとも動きます。

こういうのも

```sh
ansible -m debug all
```

## ansible-core と ansible

```
$ pip3 list | grep ansible

ansible                5.8.0
ansible-compat         2.1.0
ansible-core           2.12.6
ansible-lint           6.2.2

$ cd $HOME/.local/lib/python3.10/site-packages/
$ ls ansible* -d

/home/heiwa/.local/lib/python3.10/site-packages/ansible
/home/heiwa/.local/lib/python3.10/site-packages/ansible-5.8.0.dist-info
/home/heiwa/.local/lib/python3.10/site-packages/ansible_collections
/home/heiwa/.local/lib/python3.10/site-packages/ansible_compat
/home/heiwa/.local/lib/python3.10/site-packages/ansible_compat-2.1.0.dist-info
/home/heiwa/.local/lib/python3.10/site-packages/ansible_core-2.12.6.dist-info
/home/heiwa/.local/lib/python3.10/site-packages/ansible_lint-6.2.2.dist-info
/home/heiwa/.local/lib/python3.10/site-packages/ansible_test
/home/heiwa/.local/lib/python3.10/site-packages/ansiblelint
```

## コンテナベースの Playbook 実行環境 - Ansible Navigator

- [Ansible Navigator Documentation — Ansible Navigator Documentation](https://ansible-navigator.readthedocs.io/en/latest/)
- [2022 年の Ansible とわたし - 赤帽エンジニアブログ](https://rheb.hatenablog.com/entry/ansible_future_2022)
- [Ansible Navigator Creator ガイド Red Hat Ansible Automation Platform 2.0-ea | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_ansible_automation_platform/2.0-ea/html/ansible_navigator_creator_guide/index)
- [(512) つまずき Ansible 【Part36】ansible-navigator - YouTube](https://www.youtube.com/watch?v=q2DBQ-4fK18&list=PLf_-SnMN4mXMnwXkRefiN2FExpdUVCIsw&index=1)
- [ansible/ansible-navigator: A text-based user interface (TUI) for the Red Hat Ansible Automation Platform.](https://github.com/ansible/ansible-navigator)

### Ansible Runner

- [ansible/ansible-runner · Quay](https://quay.io/repository/ansible/ansible-runner)
- [Ansible Runner — ansible-runner documentation](https://ansible-runner.readthedocs.io/en/stable/)
- [Ansible Runner v2.0.0 を触ってみた - Qiita](https://qiita.com/aoen210/items/ccfdb9060229b9b7fb16)

## Ansible Runner

```bash
pip3 install --user -U ansible-runner
```

## ansible-lint 6

ansible-lint 6 から ansible-core 2.11 以上をインストールするようになったので、

core でない古い ansible と ansible-lint を使いたいときは、

```bash
pip3 install --user -U 'ansible==2.9.*' 'ansible-lint==5.*'
```

にしないとダメ。
