ansibleメモランダム2

- [用語](#用語)
- [2.9から2.10へアップグレード](#29から210へアップグレード)

# 用語

- [Glossary — Ansible Documentation](https://docs.ansible.com/ansible/latest/reference_appendices/glossary.html)

最近のGoogle翻訳はすごい…

<dt>Playbook
<dd>プレイブックは、Ansibleがシステムを編成、構成、管理、または展開するための言語です。それはスポーツのたとえであり(以下ジョークらしいがよくわからんので略)

<dt>Plays
<dd>プレイブックはプレイのリストです。
プレイは最小限、ホスト指定子によって選択された一連のホスト（通常はグループによって選択されるが、時にはホスト名globによって選択される）と、それらのシステムが実行する役割を定義するためにそれらのホストで実行されるタスクの間のマッピングです。
プレイブックには1つまたは複数のプレイがあります。

<dt>Task
<dd>プレイブックはタスクを実行するために存在します。
タスクは、アクション（モジュールとその引数）を名前、およびオプションで他のキーワード（ループディレクティブなど）と組み合わせます。
ハンドラもタスクですが、タスクがリモートシステムで根本的な変更を報告したときに名前で通知されない限り実行されない特別な種類のタスクです。

<dt>Handlers
<dd>ハンドラはAnsibleプレイブックの通常のタスクに似ています（タスク参照）が、タスクにnotifyディレクティブが含まれていてそれが何かを変更したことを示す場合にのみ実行されます。 たとえば、設定ファイルが変更された場合、設定ファイルのテンプレート化操作を参照するタスクは、サービス再起動ハンドラに通知することができます。 つまり、サービスを再開する必要がある場合に限り、サービスをバウンスできます。 ハンドラはサービスの再起動以外の目的にも使用できますが、サービスの再起動が最も一般的な使用方法です。

<dt>Roles
<dd>(TODO: ちゃんと訳す) 役割はAnsibleの組織の単位です。 役割をホストのグループ（または一連のグループ、あるいはホストパターンなど）に割り当てることは、それらが特定の動作を実装する必要があることを意味します。 役割には、特定の変数値、特定のタスク、および特定のハンドラを適用すること、またはこれらのうち1つ以上を適用することが含まれます。 ロールに関連付けられたファイル構造のため、ロールは再配布可能な単位になり、プレイブック間で（または他のユーザーとでも）動作を共有できます。

# 2.9から2.10へアップグレード

書いてある通りですが...

```
pgrading directly from ansible-2.9 or less to ansible-2.10 or greater with pip is
                known to cause problems.  Please uninstall the old version found at:

                /home/niteadmin/.local/lib/python3.6/site-packages/ansible/__init__.py

                and install the new version:

                    pip uninstall ansible
                    pip install ansible

                If you have a broken installation, perhaps because ansible-base was installed before
                ansible was upgraded, try this to resolve it:

                    pip install --force-reinstall ansible ansible-base
```
