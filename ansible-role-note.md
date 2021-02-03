ansibleのroleのメモ

さんざん書き捨てのplaybookを書いてきたけど、roleは使ったことも作ったこともないので調査

- [scaffolding](#scaffolding)
  - [vars/ と defaults/](#vars-と-defaults)
- [ドキュメント](#ドキュメント)

# scaffolding

```sh
ansible-galaxy init sample1
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

## vars/ と defaults/

[What's the difference between defaults and vars in an Ansible role? - Stack Overflow](https://stackoverflow.com/questions/29127560/whats-the-difference-between-defaults-and-vars-in-an-ansible-role)


- [Using Variables — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable)
- [変数の使用 — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_variables.html#ansible-variable-precedence)

- defaults/のvarはplaybookでオーバライドできる。
- vars/のvarはplaybookをオーバライドできる。

- オプション値をdefaults/に書く。
- このroleを使う上で絶対にこの値じゃなきゃダメ、というのをvars/に書く。

ほとんどはdefaults/main.ymlに書いとけばいいということだ。

# ドキュメント

- [ロール — Ansible Documentation](https://docs.ansible.com/ansible/2.9_ja/user_guide/playbooks_reuse_roles.html)
- [Roles — Ansible Documentation](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
