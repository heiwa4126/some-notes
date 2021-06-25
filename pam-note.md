
# pam_pwqualityで強固なパスワードの強制

> Red Hat Enterprise Linux 7 では、pam_pwquality PAM モジュールが pam_cracklib に置き換えられました。

これ逆だ。

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
- [Linux PAM \- Wikipedia](https://en.wikipedia.org/wiki/Linux_PAM)
- [GitHub \- linux\-pam/linux\-pam: Linux PAM \(Pluggable Authentication Modules for Linux\) project](https://github.com/linux-pam/linux-pam)
- [10\.2\. PAM 設定ファイルについて Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/system-level_authentication_guide/pam_configuration_files)
- [PAMを利用して認証を行う](https://www.atmarkit.co.jp/flinux/samba/sambatips02/sambatips02.html)


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


# man 8 pam_pwquality

[pam\_pwquality\(8\) \- Linux man page](https://linux.die.net/man/8/pam_pwquality)

(DeepLで翻訳して、ちょっとづつ修正)

## 概要

このモジュールは、あるサービスのパスワードスタックにプラグインして、パスワードの強度チェックをプラグインで提供することができます。このコードは元々 pam_cracklib モジュールをベースにしており、このモジュールはそのオプションとの下位互換性があります。

このモジュールの動作は、ユーザにパスワードの入力を促し、システムの辞書と、不適切な選択を識別するためのルールのセットに対して、その強度をチェックすることです。

最初のアクションは、1つのパスワードを入力させ、その強度をチェックし、強度が高いと判断された場合は、2回目のパスワード入力を促します（1回目に正しく入力されたかどうかを確認するためです）。問題がなければ、そのパスワードは後続のモジュールに渡され、新しい認証トークンとしてインストールされます。

まず、Cracklibルーチンが呼び出され、パスワードが辞書に含まれているかどうかがチェックされます。これらのチェックは次のとおりです。

### 回文
新しいパスワードが回文であるか？

### 大文字小文字の変更のみ
新しいパスワードは、古いパスワードの大文字と小文字を変えただけのものか？

### 類似
新しいパスワードが古いパスワードに似すぎているか？
これは主に1つの引数、difokによって制御されており、古いものと新しいものの間のいくつかの変更が新しいパスワードを受け入れるのに十分である。

### 単純
新しいパスワードが小さすぎませんか？
これは5つの引数 minlen, dcredit, ucredit, lcredit, ocredit で制御されます。
これらがどのように機能するのか、またデフォルト値については、引数のセクションを参照してください。

### 回転
新しいパスワードは古いパスワードを回転させたものですか？

### 同じ連続した文字
オプションで、同じ連続した文字をチェックします。

### ユーザー名を含むか
オプションで、パスワードに何らかの形でユーザー名が含まれているかどうかをチェックします。

これらのチェックは、モジュールの引数を使用するか、`/etc/security/pwquality.conf` 設定ファイルを変更することで設定できます。

## オプション

### debug
このオプションは、モジュールの動作を示す情報をsyslog(3)に書き込ませます（このオプションでは、ログファイルにパスワード情報は書き込まれません）。

### authtok_type=XXX
デフォルトの動作は、モジュールがパスワードを要求する際に以下のプロンプトを使用することです。
"New UNIX password: " および "Retype UNIX password: "
この例のUNIXという単語はこのオプションで置き換えることができ、デフォルトでは空になっています。

### retry=N
エラーで戻る前に、最大でN回、ユーザーにプロンプトを表示します。デフォルトは1です。

### difok=N

この引数は、古いパスワードと新しいパスワードの変更文字数をデフォルトの5から変更します。

### minlen=N

(注: この節ややこしいです。例えば単にminlen=8とか設定しただけでは最小パスワード長が8文字にはなりません。例を参照)

新しいパスワードの最小許容サイズ。
(「クレジット」が無効化されていない場合、この値に+1が最小許容サイズになります。デフォルトでは「クレジット」は無効化されていません。
注:「クレジット」についてはこのあとdcreditなどで説明されます)

異なる種類の文字（英大文字、英小文字、英数字、それ以外の文字）ごとに長さ+1が与えられます。

このパラメータのデフォルトは9です。

なお、Cracklibにも長さ制限のペアがあります。
「あまりにも短すぎる」として設定された制限は4で(これはハードコーディングされています)
そしてコンパイル時に定義される制限(=6)は、
minlenの設定と無関係にチェックされます。


### dcredit=N

(N >= 0の場合)
これは、新しいパスワードに数字が含まれている場合の最大クレジットです。

英数字がN桁未満またはN桁の場合、各桁は現在のminlen値を満たすために+1としてカウントされます。
(注:要は「
英数字の数が
0だったらクレジット0
N以下だったらクレジットは英数字の数、
N+1以上だったらクレジットはN、
」ということらしい)

dcreditのデフォルトは1で、これはminlenが10以下の場合に推奨される値です。

(N < 0の場合)
新しいパスワードに必要な最小の英数字数です。

(注:たとえばdcredit=-2だったら最低でも2文字英数字が必要)

### ucredit=N

dcredit=Nの項参照。英大文字

### lcredit=N

dcredit=Nの項参照。英小文字

### ocredit=N

dcredit=Nの項参照。「英小文字、英大文字、数字」以外の文字

### maxrepeat=N

N個以上の同じ連続した文字を含むパスワードを拒否します。デフォルトは0で、このチェックが無効になっていることを意味します。

### maxclassrepeat=N

同じクラスの連続したN個以上の文字を含むパスワードを拒否します。デフォルトは0で、このチェックが無効になっていることを意味します。

(注: クラスは英小文字、英大文字、数字、それ以外のあれです)

### gecoscheck=N

ゼロ以外の場合は、ユーザーのpasswd GECOSフィールドの3文字を超える個々の単語が新しいパスワードに含まれているかどうかを確認します。デフォルトは0で、このチェックが無効になっていることを意味します。

(注: GECOSフィールドは`/etc/passwd`の5番目のカラムでユーザのフルネームなどを入れるのに使用します。要はユーザのフルネームに基づいたパスワードを拒否するかどうか、の設定)

### badwords=<list of words>

このスペースで区切られたリストから3文字以上の単語が個別に検索され、新しいパスワードでは禁止されます。デフォルトでは、このリストは空で、このチェックは無効になっています。

(TODO: リストをダブルクォートで囲むとかそういうのが不明。単に並べるだけでいいのか確認すること)


### enforce_for_root

このモジュールは、パスワードを変更するユーザーが root であっても、チェックに失敗するとエラーを返します。このオプションはデフォルトではオフになっており、デフォルトではrootユーザはチェックに失敗したというメッセージだけが出力され、パスワードを変更することができます。

(注: 逆に言うと、一般ユーザが自分のパスワードを変更する場合には、ポリシーチェックにひっかかるとエラーになってパスワード変更ができない、ということ)


### use_authtok

この引数は、ユーザーに新しいパスワードの入力を求めず、
前にスタックされたpasswordモジュールによって提供されれたものを使用するように強制します。

(注: pam_pwqualityのオプションではない。下の例参照)


### dictpath=/path/to/dict

cracklibで使う辞書ファイルのパス


## 提供されるモジュールタイプ

passwordモジュールタイプのみ提供されます。

## 戻り値

(注: `_pam_types.h`で定義されています)

### PAM_SUCCESS
新しいパスワードは、すべてのチェックをパスしました。

### PAM_AUTHTOK_ERR
新しいパスワードが入力されなかった、
またはユーザー名が判別できない、
または新しいパスワードが強度チェックに失敗した。

### PAM_AUTHTOK_RECOVERY_ERR

以前のパスワードが、スタックモジュールによって供給されなかったか、
ユーザーから要求されなかった。

最初のエラーは use_authtok が指定されている場合に発生します。

### PAM_SERVICE_ERR

内部エラーが起きた。

## 例

このモジュールの使用例として、[pam\_unix\(8\)](https://linux.die.net/man/8/pam_unix) のパスワードコンポーネントと組み合わせた場合を示します。

```
#
# これらの行は、2つのパスワードタイプのモジュールをスタックします。
# この例では、ユーザは強力なパスワードを入力する機会を3回与えられます。
# use_authtokオプションは、pam_unixモジュールがパスワードの入力を
# 求めないようにし、代わりにpam_pwqualityによって提供されたもの
# を使用します。
#
passwd  password required       pam_pwquality.so retry=3
passwd  password required       pam_unix.so use_authtok
```

もうひとつは（`/etc/pam.d/passwd`形式）は、md5パスワード暗号化を使用したい場合の例です:

```
#%PAM-1.0
#
# 最低でも14バイト長のパスワード (注: 誤訳でもtypoでもないです)
# ただし英数字の場合は最大2の追加クレジット、
# その他文字種の場合は最大2の追加クレジットがあり、
# 新しいパスワードには古いパスワードに存在しない文字が
# 少なくとも3バイトが必要です。
#
password  required pam_pwquality.so \
               difok=3 minlen=15 dcredit= 2 ocredit=2
password  required pam_unix.so use_authtok nullok md5
```

また、クレジットを使用したくない場合には、別の例があります。

```
#%PAM-1.0
#
# この設定では、ユーザーは最低8の長さで、
# 少なくとも1桁の数字、1つの大文字、1つのその他の文字を含む
# パスワードを選択する必要があります。
#
password  required pam_pwquality.so \
               dcredit=-1 ucredit=-1 ocredit=-1 lcredit=0 minlen=8
password  required pam_unix.so use_authtok nullok md5
```



# pam_pwquality の minlen,dcredit,ucredit,lcredit and ocredit の例

文字種に関係なく、最小パスワード長10
```
lcredit=0 ucredit=0 dcredit=0 ocredit=0 minlen=10
```

文字種に関係なく
数字が入っていれば最小パスワード長9、そうでなければ最小パスワード長10
```
lcredit=0 ucredit=0 dcredit=1 ocredit=0 minlen=10
```




参考:
- [How to enforce password complexity on Linux \| Network World](https://www.networkworld.com/article/2726217/how-to-enforce-password-complexity-on-linux.html)
- [LX139\-1\.pdf](https://www.neclearning.jp/sample_text/LX139-1.pdf)
- [\[CentOS 7\] パスワードポリシーを設定する方法](https://mseeeen.msen.jp/how-to-set-password-policy-in-centos7/)

パスワードの長さは
`/etc/login.defs` の `PASS_MIN_LEN`
でも制御される。

こんなの間違いなく設定することができようとは思えない。
[GitHub \- libpwquality/libpwquality: Password quality checking library](https://github.com/libpwquality/libpwquality)
のpython bindとかないのか?

python2.7用のパッケージはある。

libpwquality付属の
`pwscore`が使えそうだが、
設定が、`/etc/security/pwquality.conf` に固定だ。

設定変えられるといいんだけど...

オマケでパスワードを作る`pwmake`もlibpwquality付属
(Ubuntuだと`apt install libpwquality-tools`)
```
$ rpm -ql libpwquality | grep bin/
/usr/bin/pwmake
/usr/bin/pwscore

$ pwmake 128 | pwscore
100
$ pwmake 56 | pwscore
67
$ pwmake 64 | pwscore
100
$ seq 10 | xargs -i{} pwmake 64
UjZiH.yqOk3pGo
JUHpIl5apmacoL
Yh9AdTER84PIPd
]YDzifGuv4Dj3w
YPuG#AmyGrUqhe
DELetDInn4Satu
Q4RZavuHKIzEzP
laq%idJ4pocb4b
2IniR&Afv4Loh3
24xmImHeHPob3M
```


[第4章 ツールおよびサービスを使用したシステムのハードニング Red Hat Enterprise Linux 7 \| Red Hat Customer Portal](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/security_guide/chap-hardening_your_system_with_tools_and_services)
[意外に複雑なLinuxのパスワード生成事情とパスワード生成方法 \- Qiita](https://qiita.com/yamada-hakase/items/7b4c8c662767f451edf7)