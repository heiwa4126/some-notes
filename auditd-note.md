

[6.6. Audit ログファイルについて Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/sec-understanding_audit_log_files)

[6.3. audit サービスの設定 Red Hat Enterprise Linux 7 | Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/sec-configuring_the_audit_service)

ログローテーションに関しては
- max_log_file - ログファイルの最大サイズ(MB)
- num_logs - ログファイルの個数


# 概要

[第6章 システム監査 Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/chap-system_auditing#sec-audit_system_architecture)


インストール
```sh
sudo yum install audit
```

設定ファイル: [/etc/audit/auditd\.conf](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/sec-configuring_the_audit_service)


# auditdのテスト

```
auditctl -m "test"
```
`/var/log/audit/audit.log`に

```
 msg='test exe="/usr/sbin/auditctl" hostname=r7 addr=? terminal=pts/2 res=success'
```
みたいのが書かれます。


# auditdの一時停止

`systemctl stop auditd`はできません。

```sh
auditctl -e0
```

eオプションの引数:
- 0 - 無効
- 1 - 有効
- 2 - 設定ファイルのロック?

参照:
- [6\.5\. Audit ルールの定義 Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/sec-defining_audit_rules_and_controls)
- [How to stop and disable auditd on RHEL 7 \-](http://kb.ictbanking.net/article.php?id=632)

ずっと止めるなら
```sh
systemctl disable auditd
```
で。

[LLinux Auditd ルールの読み方](https://runble1.com/linux-auditd-rule/)から引用

Linux Auditd のルールには3種類ある。

- 制御ルール : Audit システム自体の動作設定
- ファイルシステムのルール : 特定のファイルまたはディレクトリーへのアクセスを記録するための設定
- システムコールのルール : 特定のプログラムが実行するシステムコールを記録するための設定

# audit rules ファイルシステムルール

こっちはかんたん
```
auditctl -w /tmp
```

`-p`省略時は`-p rwxa`と同じ。


# audit rules システムコールルール

- [auditctl\(8\) \- Linux man page](https://linux.die.net/man/8/auditctl)


```sh
# ルールを追加
auditctl -a ...
# ルールを全部削除
auditctl -D
```

例)
```
#-- ルールを全部削除
$ sudo auditctl -D
No rules

#-- lsとidを起動したときにauditする設定を追加
$ sudo auditctl -a always,exit -F exe=/bin/ls -F arch=b64 -S execve -k ls
$ sudo auditctl -a always,exit -F exe=/bin/id -F arch=b64 -S execve -k id

#-- ルールのリスト表示
$ sudo auditctl -l
-a always,exit -F arch=b64 -S execve -F exe=/bin/ls -F key=ls
-a always,exit -F arch=b64 -S execve -F exe=/bin/id -F key=id

#-- キーを指定してリスト表示
$ sudo auditctl -l -k ls
-a always,exit -F arch=b64 -S execve -F exe=/bin/ls -F key=ls

#-- キーを指定してルール削除
$ sudo auditctl -D -k ls
$ sudo auditctl -l
-a always,exit -F arch=b64 -S execve -F exe=/bin/id -F key=id

#-- ルールを全部削除
$ sudo auditctl -D
No rules
```

`-a`の後ろはlist,action または action,list (つまりactionとlistの順序はどっちでもいい)

action:
- never - 監査記録を生成しない
- always - 監査記録を生成する(syscall終了時に)

listの方はちょっとむずかしい。
- task
- exit
- user
- exclude

あと新し目のkernelだと`filesystem`というのがlistに追加されている。

> 整理すると、アプリケーションからシステムコールが呼出されると、カーネル内で４つのフィルタが働く。userはuidやpidなどのユーザ情報によるフィルタリング、taskは特定のシステムコール（fork, clone）のみ有効なフィルタリング、exitは全システムコールに対するフィルタリング、excludeは特定のイベント条件（msgtype）によるフィルタリングとなる。user, task, exitフィルタは個別に動作し、これらからのイベントはexcludeフィルタに送られ、そこで除外されなければユーザモードで起動しているauditdへ送信される。

引用元: [RHELのAudit設定（ファイルアクセス監査） \- Qiita](https://qiita.com/ch7821/items/03bd936dd4cb070001b5)

その他参照:
- [Linux auditdによる監査ログ設定（CentOS 7） \| cloudpack\.media](https://cloudpack.media/52532)

## examples

全部のプログラムの起動を監査。ただし/bin/idに関するものを除外
```
auditctl -a never,exit -S all -F exe=/bin/id
auditctl -a always,exit -F arch=b64 -S execve
auditctl -a always,exit -F arch=b32 -S execve
```

サンプルのリンク:
- [テキストマッチングを利用したAudit\.logの監視について \| セキュリティ専門企業発、ネットワーク・ログ監視の技術情報 \- KnowledgeStare（ナレッジステア）](https://www.secuavail.com/kb/tech-blog/tb-201015_01/)

# システムコール

`-S`で指定するシステムコールの一覧。

- [Man page of SYSCALLS](https://linuxjm.osdn.jp/html/LDP_man-pages/man2/syscalls.2.html)
- `ausyscall --dump`
- `/usr/include/asm/unistd_64.h`


# 永続的ルールの作り方

[6.5.3. 永続的な Audit ルールの定義と /etc/audit/audit.rules ファイルでの制御](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/sec-defining_audit_rules_and_controls#sec-Defining_Audit_Rules_and_Controls_in_the_audit.rules_file)

1. `/etc/audit/rules.d/` に `*.rules`としてルールを書く。
2. `augenrules --load` で `/etc/audit/audit.rules` を生成&ロードする。
3. `auditctl -l`でルールを確認。

RHEL7の場合
`/usr/share/doc/audit-2.8.5/rules/`に
サンプルルールが入ってる(バージョンは変わるかも)。



# TIPS

## なぜ `auditctl -l` で `No rules`なのに、logが出るのか?

[security \- What does auditd log by default \(i\.e\. when no rules are defined?\) \- Server Fault](https://serverfault.com/questions/774862/what-does-auditd-log-by-default-i-e-when-no-rules-are-defined)

`rpm -q --whatrequires audit-libs` で表示されるやつが出る。
`aureport -x --summary` でも。

kernel command line に `audit=0` で止められる。

## auditdがsuspendしてるか知る方法

[How to tell if auditd has suspended logging? \- Server Fault](https://serverfault.com/questions/778121/how-to-tell-if-auditd-has-suspended-logging)