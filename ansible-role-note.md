# Ansible の role のメモ

さんざん書き捨ての playbook を書いてきたけど、role は使ったことも作ったこともないので調査

- [scaffolding](#scaffolding)
  - [vars/ と defaults/](#vars-と-defaults)
  - [ドキュメント](#ドキュメント)
  - [default のオーバーライド](#default-のオーバーライド)
  - [import_role の変なところ](#import_role-の変なところ)

## scaffolding

```sh
ansible-galaxy init sample1
## or
ansible-galaxy role init sample1
```

カレントディレクトリにこんな感じに生成される

```
sample1/
|-- README.md
|-- defaults
|   `-- main.yml
|-- files
|-- handlers
|   `-- main.yml
|-- meta
|   `-- main.yml
|-- tasks
|   `-- main.yml
|-- templates
|-- tests
|   |-- inventory
|   `-- test.yml
`-- vars
    `-- main.yml
```

### vars/ と defaults/

[What's the difference between defaults and vars in an Ansible role? - Stack Overflow](https://stackoverflow.com/questions/29127560/whats-the-difference-between-defaults-and-vars-in-an-ansible-role)

- [Using Variables — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
- [変数の使用 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_variables.html#ansible-variable-precedence)

- defaults/の var は playbook でオーバライドできる。
- vars/の var は playbook をオーバライドできる。

- オプション値を defaults/に書く。
- この role を使う上で絶対にこの値じゃなきゃダメ、というのを vars/に書く。

ほとんどは defaults/main.yml に書いとけばいいということだ。

### ドキュメント

- [ロール — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_reuse_roles.html)
- [Roles — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)

### default のオーバーライド

task で set_fact に書くか、import_role で vars に書く。

```yaml
tasks:
  - set_fact:
      foo: foo1
  - import_role:
      name: sample1

  # or
  - import_role:
      name: sample1
    vars:
      foo: foo2
```

### import_role の変なところ

tasks_from は指定した yml を実行するのに、
defaults_from は main と指定した yml を実行するところ。
