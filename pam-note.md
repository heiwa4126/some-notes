
# pam_pwqualityで強固なパスワードの強制

> Red Hat Enterprise Linux 7 では、pam_pwquality PAM モジュールが pam_cracklib に置き換えられました。

引用元: [第4章 ツールおよびサービスを使用したシステムのハードニング Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/chap-hardening_your_system_with_tools_and_services)

```sh
find /etc/pam.d -type f | xargs grep -e pam_pwquality -e pam_cracklib | fgrep :password
```
symlink以外の設定ファイルでpam_pwqualityかpam_cracklibがあるところを探す

で、このうちmodule_interfaceが
`password`(ユーザーのパスワード変更に使用される)
ものを見る。


[第2章 ネットワークのセキュリティー保護 Red Hat Enterprise Linux 6 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/security_guide/chap-security_guide-securing_your_network#sect-Security_Guide-Password_Security-Creating_User_Passwords_Within_an_Organization)

「2.1.4.1. 強固なパスワードの強制」

pam_pwquality(pam_cracklib)のオプション

- [6\.2\. pam\_cracklib \- checks the password against dictionary words](http://www.linux-pam.org/Linux-PAM-html/sag-pam_cracklib.html)
- [CentOS/パスワードの長さや文字などの制限事項を設定する方法 \- Linuxと過ごす](https://linux.just4fun.biz/?CentOS/%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89%E3%81%AE%E9%95%B7%E3%81%95%E3%82%84%E6%96%87%E5%AD%97%E3%81%AA%E3%81%A9%E3%81%AE%E5%88%B6%E9%99%90%E4%BA%8B%E9%A0%85%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)


```
$ rpm -qf /usr/lib64/security/pam_cracklib.so /usr/lib64/security/
pam_pwquality.so

pam-1.1.8-23.el7.x86_64
libpwquality-1.2.3-5.el7.x86_64
```

# pamを使ってるか確認

lddでlibpamがあればOK

例)
```
# ldd `which passwd` | grep pam
        libpam.so.0 => /lib64/libpam.so.0 (0x00007f2685eb6000)
        libpam_misc.so.0 => /lib64/libpam_misc.so.0 (0x00007f2685cb2000)

# ldd `which login` | grep pam
        libpam.so.0 => /lib64/libpam.so.0 (0x00007f767ff55000)
        libpam_misc.so.0 => /lib64/libpam_misc.so.0 (0x00007f767fd51000)

# ldd `which sshd` | grep pam
        libpam.so.0 => /lib64/libpam.so.0 (0x00007ffb4ffd8000)
```

で、例えばsshdだったら

- /etc/pam.d/system-auth (symlinkかも)
- /etc/pam.d/sshd (symlinkかも)

が設定ファイルになる。(Appのpam設定が`/etc/pam.d/App`、というのは慣習らしい。)

`/etc/pam.d/system-auth`
は
`/etc/pam.d/sshd`
でincludeで読み込まれてる。

includeについては
例えば`sudo`は`su`のincludeだけでできてるはず。

# links

- [A Linux\-PAM page](http://www.linux-pam.org/) - PAM本家
- [The Linux\-PAM System Administrators' Guide](http://www.linux-pam.org/Linux-PAM-html/Linux-PAM_SAG.html)
- [Understanding PAM Authentication and Security](https://www.aplawrence.com/Basics/understandingpam.html)
- [Configure and Use Linux\-PAM \- Like Geeks](https://likegeeks.com/linux-pam-easy-guide/)
- [PAM \(Pluggable Authentication Modules\) \- Carpe Diem](https://christina04.hatenablog.com/entry/pluggable-authentication-module)

# /etc/pam.d/*

[pam\.d\(5\): PAM config files \- Linux man page](https://linux.die.net/man/5/pam.d)

[8\.5\. PAM \(プラグ可能な認証モジュール\) Red Hat Enterprise Linux 6 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/migration_planning_guide/sect-migration_guide-security_authentication-pam)

> PAM サービス用の共通設定は /etc/pam.d/system-auth-ac

`*-auth`や`*-auth-ac`は、includeやsubstackされるものらしい。


- [第10章 PAM \(プラグ可能な認証モジュール\) の使用 Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/pluggable_authentication_modules)
- [10\.2\. PAM 設定ファイルについて Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/pam_configuration_files) - 重要

> 警告
> PAM の設定には、PAM 設定ファイルを手動で編集するのではなく、authconfig ツールを使用することが強く推奨されます。

configの各行
```
module_interface	control_flag	module_name module_arguments
# or
service type control module-path module-arguments
```
[4\.1\. Configuration file syntax](http://www.linux-pam.org/Linux-PAM-html/sag-configuration-file.html)

- モジュールの目的 (PAM インターフェース) 
- a
- モジュールの名前
- モジュールの引数


`-`で始まる行。
「モジュールが存在しない場合でもエラーにしない」

>  If the type value from the list above is prepended with a -
character the PAM library will not log to the system log if it is not
possible to load the module because it is missing in the system. This
can be useful especially for modules which are not always installed on
the system and are not required for correct authentication and
authorization of the login session.

[PAMで特定のユーザだけ別の認証をしたい場合 \- Qiita](https://qiita.com/knqyf263/items/15b6032a1215e3603d59#pam%E3%81%AE%E8%A8%AD%E5%AE%9A)
[Linuxの各アプリケーションが共通して利用する「PAM認証」について \| OXY NOTES](https://oxynotes.com/?p=4393)
[PAMによる認証の仕組みを調べてみた \- GeekFactory](https://int128.hatenablog.com/entry/20090726/1248622071)

# includeとsubstack

- [pam\.d\(5\): PAM config files \- Linux man page](https://linux.die.net/man/5/pam.d)
- [知っているようで知らないPAMのお話](https://www.slideshare.net/serverworks/pam-53731680)

- include - 引数で指定したファイルを読み込み、記述に従って処理する。指定インターフェースのすべての行を含める。
- substack - includeと異なるのは、サブスタック内のdoneおよびdieアクションの評価が、モジュールスタック全体の残りの部分をスキップするのではなく、サブスタックのみをスキップすることです。サブスタック内でジャンプしても評価が飛び出すことはなく、親スタック内でジャンプした場合はサブスタック全体を1つのモジュールとしてカウントします。

# authconfig

[2\.2\. authconfig の使用 Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/authconfig-install)


# try_first_pass

[6\.37\. pam\_unix \- traditional password authentication](http://www.linux-pam.org/Linux-PAM-html/sag-pam_unix.html)

> Before prompting the user for their password, the module first tries the previous stacked module's password in case that satisfies this module as well.

[PAM 構成ファイル \(Solaris のシステム管理 \(第 2 巻\)\)](https://docs.oracle.com/cd/E19455-01/806-2718/refer-4/index.html)

> 最初の 3 つのエントリでは try_first_pass オプションが使用されています。この場合、ユーザーの最初のパスワードを使用して認証が行われます。最初のパスワードを使用するとは、複数のメカニズムが表示されていても、ユーザーは別のパスワードを要求されないという意味です。指定されていない、認証を必要とするすべてのエントリのデフォルトとして other エントリが 1 つ含まれています。


# local_users_only

> The module will not test the password quality for users that are not present in the /etc/passwd  file.  The  module
still  asks  for the password so the following modules in the stack can use the use_authtok option.  This option is
off by default.

このモジュールは、/etc/passwd ファイルに存在しないユーザーのパスワード品質をテストしません。 
モジュールはモジュールは依然としてパスワードを要求するので、スタック内の次のモジュールは use_authtok オプションを使うことができます。 
このオプションはデフォルトではオフになっています。

# PAM設定のデバッグ

[Debugging PAM configuration \- Red Hat Customer Portal](https://access.redhat.com/articles/1314883)

