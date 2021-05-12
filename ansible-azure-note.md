

冪等性のこと考えると、Azure CLIで書くよりはずっと楽かもしれない。

- [クイック スタート \- Ansible を使用して Azure で Linux 仮想マシンを構成する \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/vm-configure?tabs=ansible)
- [Azure の Ansible モジュールとバージョンのマトリックス \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/module-version-matrix)
- [Microsoft Azure ガイド — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/scenario_guides/guide_azure.html)
- [Cloud modules — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/modules/list_of_cloud_modules.html#azure)
- [Ansible Galaxy](https://galaxy.ansible.com/azure/azcollection?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW)
- [クイック スタート \- Azure CLI を使用して Ansible を構成する \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/install-on-linux-vm?tabs=ansible)


# Azure Cloud Shellで手っ取り早く

[Azure Cloud Shell](https://portal.azure.com/#cloudshell/)にはAnsibleが入っていて、認証認可の設定も不要。
```
a@Azure:~$ date
Mon 10 May 2021 06:40:18 AM UTC

a@Azure:~$ ansible --version
ansible 2.10.2
　(略)
  python version = 3.7.3 (default, Jul 25 2020, 13:03:44) [GCC 8.3.0]
```

# 普通のホストで

(2021-05ごろ)

参考: [クイック スタート \- Azure CLI を使用して Ansible を構成する \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/install-on-linux-vm?tabs=ansible)

Azure cliは要るみたいので、
[Azure CLI のインストール \| Microsoft Docs](https://docs.microsoft.com/ja-jp/cli/azure/install-azure-cli)
読んでインストール。

さらに `az login` しておく。

ごく普通にansibleをインストールする
```sh
PIP3="python3 -m pip"
$PIP3 install --user -U pip
$PIP3 install --user -U ansible 'ansible-lint[community,yamllint]' pywinrm pexpect
```

2021-05現在ではバージョンはこんな感じ
```
$ pip3 freeze | grep ansible
(略)
ansible==3.3.0
ansible-base==2.10.9
ansible-lint==5.0.4
```

2.10.xから`pip 'ansible[azure]'`はできない。
以下のようにしてコレクションを追加。

```sh
curl -O https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip install --user -U -r requirements-azure.txt
rm requirements-azure.txt
ansible-galaxy collection install azure.azcollection
```
(参考: [GitHub \- ansible\-collections/azure: Development area for Azure Collections](https://github.com/ansible-collections/azure))


でシンプルなplaybookを実行

```yaml
- name: Get facts for resource groups
  hosts: localhost
  connection: local
  gather_facts: False
  become: False

  tasks:
    - name: Get facts for resource groups
      azure_rm_resourcegroup_info:
      register: rc

    - debug: var=rc
```
既存のリソースグループを取得して表示する。