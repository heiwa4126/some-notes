冪等性のこと考えると、Azure CLIで書くよりはずっと楽かもしれない。

- [参考リンク](#参考リンク)
- [Azure Cloud Shellで手っ取り早く](#azure-cloud-shellで手っ取り早く)
- [普通のホストで](#普通のホストで)
- [よく使いそうなモジュールへのリンク](#よく使いそうなモジュールへのリンク)
- [サンプルとチュートリアル](#サンプルとチュートリアル)


# 参考リンク

- [クイック スタート \- Ansible を使用して Azure で Linux 仮想マシンを構成する \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/vm-configure?tabs=ansible)
- [Azure の Ansible モジュールとバージョンのマトリックス \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/module-version-matrix)
- [Microsoft Azure ガイド — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/scenario_guides/guide_azure.html)
- [Cloud modules — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/modules/list_of_cloud_modules.html#azure) - 同じページにAzureだけでなくクラウド全般が載ってる
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

Azure Cloud shellについては
[Azure Cloud Shell のクイックスタート \- Bash \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cloud-shell/quickstart)
を参照。

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

参考:
- [GitHub \- ansible\-collections/azure: Development area for Azure Collections](https://github.com/ansible-collections/azure))
- [Ansible を仮想マシンにインストールする \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/install-on-linux-vm?tabs=ansible#install-ansible-on-the-virtual-machine) - CentOS7用だけど参考になる。


次に「Azure 資格情報の作成」になるわけだけど
(参考: [Azure 資格情報の作成 \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/install-on-linux-vm?tabs=ansible#create-azure-credentials))
`az login`
で、使えるようになったので、このへん曖昧。あとで調査する。


テストとして
シンプルなplaybookを実行

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


# よく使いそうなモジュールへのリンク

- [azure.azcollection.azure_rm_virtualmachine – Manage Azure virtual machines — Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_virtualmachine_module.html#azure-rm-virtualmachine-module) - VMを開始したり停止したりディアロケートしたり。

# サンプルとチュートリアル

[Azure 上の Ansible のドキュメント \- Ansible \| Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/developer/ansible/)
から結構な数のサンプルやチュートリアルへ行ける。

- [GitHub \- microsoft/AnsibleLabs: Ansible on Azure Lab playbooks and documentation](https://github.com/microsoft/AnsibleLabs)のlab1
- [GitHub \- Azure\-Samples/ansible\-playbooks: Ansible Playbook Samples for Azure](https://github.com/Azure-Samples/ansible-playbooks)
