# ssh tips

- [ssh tips](#ssh-tips)
- [sshdのconfigtest](#sshdのconfigtest)
- [sshd_configでまちがいやすい設定メモ](#sshd_configでまちがいやすい設定メモ)
	- [AllowUsers](#allowusers)
	- [Port](#port)
- [.ssh/configでhostごとのUserがoverrideできない](#sshconfigでhostごとのuserがoverrideできない)
- [SELinux](#selinux)
- [ProxyJump](#proxyjump)
- [DynamicForward](#dynamicforward)
- [LocalForward](#localforward)
	- [実験](#実験)
- [ControlPersist](#controlpersist)
- [各ディストリのsshd_configのCiphersのデフォルト値](#各ディストリのsshd_configのciphersのデフォルト値)
- [sshの接続でどんなcipherが使われるか確認](#sshの接続でどんなcipherが使われるか確認)
- [Windows 10のssh](#windows-10のssh)
- [どうしてもパスワード認証になってしまうホスト](#どうしてもパスワード認証になってしまうホスト)
- [sshdのホストキーを作り直す](#sshdのホストキーを作り直す)
- [private keyからpublic key](#private-keyからpublic-key)
- [Putty Alternatives](#putty-alternatives)
- [Windows の OpenSSH](#windows-の-openssh)
	- [やりなおし](#やりなおし)
	- [おどろいたこと](#おどろいたこと)
	- [欠点](#欠点)
- [Simple SSH Security](#simple-ssh-security)
	- [弱い素数を削除](#弱い素数を削除)
	- [強力な暗号のみ使う](#強力な暗号のみ使う)
- [sftpをscpのように使う例](#sftpをscpのように使う例)
- [sftpのみ かつ chrootするユーザを作るときのコツ](#sftpのみ-かつ-chrootするユーザを作るときのコツ)


# sshdのconfigtest

```sh
sshd -t
```
...そのまんまですね。


# sshd_configでまちがいやすい設定メモ

## AllowUsers
複数ユーザは` `(whitespace)で区切る

## Port
複数ポートは書けない。コンマで区切る、とか無い。
```
Port 22
Port 2222
```
みたいに複数行にする。


# .ssh/configでhostごとのUserがoverrideできない

だめな例
```
User foo
...
Host h1
  User bar
```

`ssh h1` するとユーザfooでつなぎに行く。

正しい例
```
Host h1
  User bar

Host *
  User foo
```

- [linux - OpenSSH ~/.ssh/config host-specific overrides not working - Super User](https://superuser.com/questions/718346/openssh-ssh-config-host-specific-overrides-not-working)


# SELinux

↑みたいに複数ポートにしたとき、selinuxが有効だと動きません。
SELinuxを無効にするのは簡単だけど。

参考: [「SELinuxのせいで動かない」撲滅ガイド - Qiita](https://qiita.com/yunano/items/857ab36faa0d695573dd)


```sh
sudo semanage port -a -t ssh_port_t -p tcp 2222
```
オプションの`-a`はappend、`-m`はmodify。
tcp/2222がすでに別で使ってたら`-a`じゃなくて`-m`にする。

確認は
```sh
sudo semanage port -l | grep 2222
```

# ProxyJump

(TODO)

* [OpenSSH 7.3 の ProxyJump 機能の使い方 - TIM Labs](http://labs.timedia.co.jp/2016/08/openssh-73-proxyjump.html)
* [OpenSSH/Cookbook/Proxies and Jump Hosts - Wikibooks, open books for an open world](https://en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)


PuttyにはProxyJumpはないのでProxyCommandで実現する
(OpenSSHでも昔はProxyCommandで実現していた)

* [SSH/多段接続/PuTTYのRemoteCommandを使う - yanor.net/wiki](http://yanor.net/wiki/?SSH/%E5%A4%9A%E6%AE%B5%E6%8E%A5%E7%B6%9A/PuTTY%E3%81%AERemoteCommand%E3%82%92%E4%BD%BF%E3%81%86)
* [SSH/多段接続 - yanor.net/wiki](http://yanor.net/wiki/?SSH/%E5%A4%9A%E6%AE%B5%E6%8E%A5%E7%B6%9A)
* [windows \- How to setup proxy jump with PuTTY \- Super User](https://superuser.com/questions/1448180/how-to-setup-proxy-jump-with-putty)
* [ssh \- PuTTY configuration equivalent to OpenSSH ProxyCommand \- Stack Overflow](https://stackoverflow.com/questions/28926612/putty-configuration-equivalent-to-openssh-proxycommand)


# DynamicForward

(TODO)

* [SSHのDynamic ForwardでSOCKS Proxyしてみる - ぱせらんメモ](https://pasela.hatenablog.com/entry/20090217/dynamic_forward)


Puttyもsocks proxyになれる。

* [SSHをSOCKS Proxyにする](https://blog.cles.jp/item/2839)

ただDNSは引けるようになっていないと実用にならない。


# LocalForward

-Lでトンネリング

(TODO)
```
ssh xxx.example.com -L 8080:127.0.0.1:8080 -g -N -f
```
みたいの。-Lは複数使えることなど。
ssh_configにはどう書くのか. RemoteForward など

> ssh (SSH サーバのアドレス) -L (ローカルで使用するポート):(目的サーバのアドレス):(目的サーバで待ち受けてるポート番号)
> ssh (SSH サーバのアドレス) -R (ローカルで待ち受けてるポート):(SSH サーバのアドレス):(SSH サーバで待ち受けるポート番号)

* [楽しいトンネルの掘り方(オプション: -L, -R, -f, -N -g) — 京大マイコンクラブ (KMC)](https://www.kmc.gr.jp/advent-calendar/ssh/2013/12/09/tunnel2.html)
* [.ssh/config ファイルによるSSHオプション - HEPtech](https://heptech.wpblog.jp/2017/08/10/ssh-options-in-config-file/)


## 実験

前提:
- sa1とsa2というサーバ。どちらもssh(22/tcp), httpd(80/tcp)が動いている。

sa2からsa1へssh接続して、
sa2の28080/tcpをsa1の80/tcpにする。
(正ssh tunneling)
```sh
# sa2で実行
ssh sa1 -L 28080:127.0.0.1:80 -g -N -f
ss -tapn | grep 28080
curl http://127.0.0.1:28080/
pkill -f 'ssh sa1 -L'
```

sa2からsa1へssh接続して、
sa1の28080/tcpをsa2の80/tcpにする。
(逆ssh tunneling)
```sh
# sa2で実行
ssh sa1 -R 28080:127.0.0.1:80 -g -N -f
# sa1で実行
ss -tapn | grep 28080
curl http://127.0.0.1:28080/
# sa2で実行
pkill -f 'ssh sa1 -R'
```
> ssh (SSH サーバのアドレス) -R (ローカルで待ち受けてるポート):(SSH サーバのアドレス):(SSH サーバで待ち受けるポート番号)



# ControlPersist

(TODO)

* [OpenSSHのセッションを束ねるControlMasterの使いにくい部分はControlPersistで解決できる - Gマイナー志向](https://matsuu.hatenablog.com/entry/20120707/1341677472)
* [Speed Up SSH by Reusing Connections | Puppet](https://puppet.com/blog/speed-up-ssh-by-reusing-connections)


# 各ディストリのsshd_configのCiphersのデフォルト値

RHEL7 default Ciphers
```
Ciphers chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,blowfish-cbc,cast128-cbc,3des-cbc
```
(man sshd_config参照)

Ubunts 18.04LTS
```
Cipers  chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
```

RHEL7のは流石にまずいので、弱いのは外すべき。

**ssh_configの設定だけど**
[ssh config最強設定 - Qiita](https://qiita.com/keiya/items/dec9a1142ac701b19bd9)
にあるのが参考になると思う。

以下引用:
```
##### セキュリティ系！重要！！ #####
# 以下は、OpenSSH 6.8を参考にしたもの。
# NSAフリーなChacha20を優先的に、そのあとは暗号強度の順。aes-cbcはダメらしい
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
```


# sshの接続でどんなcipherが使われるか確認

```
$ ssh -vvv <host>
...
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes[111/343]penssh.com
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
...
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: zlib@openssh.com
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: zlib@openssh.com
```

aesにするとハードウエアアクセラレーションが効く、という話を聞いたので
/etc/sshdのCiphersで並びを変えてみる(man sshd_config)。

```
#Ciphers  chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
Ciphers  aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr
```

...微塵も変わらない... 単に並びを変えただけじゃダメみたい(続く)


# Windows 10のssh

Windows 10ではMicrosoft 提供のsshクライアントが簡単に使える。

- [Windows Server 用 OpenSSH のインストール | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse)
- [【図解・Mac・Windows】VSCodeでRemote Developmentを使うときのSSHの設定いろいろ【多段・HTTPプロキシ(認証あり・なし)・Socks5プロキシ・Port指定】 - Qiita](https://qiita.com/ko-he-8/items/06ae39f77dd5189df59b)


管理者として PowerShell を起動して

```powershell
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
# ↑で表示されるバージョンに↓をあわせる。(アップデートは?)
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

で、
```
C:\> ssh -V
OpenSSH_for_Windows_7.7p1, LibreSSL 2.6.5

C:\> where ssh
C:\Windows\System32\OpenSSH\ssh.exe

C:\> dir "C:\Windows\System32\OpenSSH\"
(略)
2018/09/16  01:55    <DIR>          .
2018/09/16  01:55    <DIR>          ..
2018/09/16  01:55           322,560 scp.exe
2018/09/16  01:55           390,144 sftp.exe
2018/09/16  01:55           491,520 ssh-add.exe
2018/09/16  01:55           384,512 ssh-agent.exe
2018/09/16  01:55           637,952 ssh-keygen.exe
2018/09/16  01:55           530,432 ssh-keyscan.exe
2018/09/16  01:55           882,688 ssh.exe
```
ssh-agentもついてるんだ...

[connect.c](https://gist.github.com/rurban/360940),
[connect-proxy](https://github.com/larryhou/connect-proxy)
は Git for Windows shellについてるやつを使う。
パスは微妙だが `C:\Program Files\Git\mingw64\bin\connect.exe`など。
(Git Bush起動してwhere connectで調べる)

.ssh/configのデフォルトは `%USERPROFILE%`の下。
%HOME%とか設定しても見てくれない。
あきらめて`C:\User\ユーザ名\.ssh`に置く。

.ssh/configの例:
```
Protocol 2
ForwardAgent yes

Host s1
	User heiwa
	Hostname s1.example.net
	Port 22
	IdentityFile C:\Users\xxxxxxxxx\.ssh\id_rsa
	ProxyCommand  C:\Program Files\Git\mingw64\bin\connect.exe -H proxy.your.co.uk:8080 %h %p
	Compression yes
```
ダブルクオートが不要なのがコツ。

`id_rsa`のパーミッションはAdministratorsとSystemと自分だけ。


```
C:\> ssh-agent
unable to start ssh-agent service, error :1058
```
とか言われるとき。どうもssh-serverが要るらしい(なんで)。
WSUSの環境だとインストールできないので諦めてくらはい。

- [unable to start ssh-agent service, error :1058 - Qiita](https://qiita.com/tmak_tsukamoto/items/c72399a4a6d7ff55fcdb)
- [Windows 10 に OpenSSH サーバをインストールする - Qiita](https://qiita.com/iShinkai/items/a12c9d26f8f4264897f9)


# どうしてもパスワード認証になってしまうホスト

```sh
chmod og= ~
```
で治るかもしれない。雑で申し訳ない。

ただgroupに権限ないと困るときがあるよなあ。なんか設定で変更できると思うんだけど。


# sshdのホストキーを作り直す

仮想マシンをクローンしたときなど。クラウドだとCloud-Initに書くやつ。

もちろん/etc/sshの下のキーを全部消して作り直せばいいのだけど
専用のコマンドがあると楽。

Ubuntuの場合 (たぶんDebianも):
[How To: Ubuntu / Debian Linux Regenerate OpenSSH Host Keys - nixCraft](https://www.cyberciti.biz/faq/howto-regenerate-openssh-host-keys/)

```sh
sudo rm /etc/ssh/ssh_host_*key*
sudo dpkg-reconfigure openssh-server
```

Red Hat系には残念ながらそういう便利コマンドがない模様。

rootで
```sh
cd /etc/ssh
rm -f ssh_host_*key*
ssh-keygen -A
rm ssh_host_key ssh_host_key.pub -f
chmod 0640 ssh_host_*key
chown root:ssh_keys ssh_host_*key
chmod 0644 ssh_host_*key.pub
```
して
```sh
systemctl restart sshd
```
でOK。


# private keyからpublic key

RSAだと
```sh
ssh-keygen -y -f ~/.ssh/id_rsa
```
が出来る。他のアルゴリズムでは?


# Putty Alternatives

[Putty Alternatives for SSH/Telnet/HTTPS Client Transfers & Connections](https://www.ittsystems.com/putty-alternatives/)


# Windows の OpenSSH

Windows 10 1803+ / Server 2016/2019 1803+ならMicrosoftがビルドしたOpenSSHが使える。らしい。

- [OpenSSH をインストールする \| Microsoft Docs](https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse)
- [Windows 用 OpenSSH キーの管理 \| Microsoft Docs](https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_keymanagement)

ssh-agentがサービスなのがちょっとイヤ。

[Windows 用 OpenSSH キーの管理](https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_keymanagement)
に書いてある手順だと、いきなり
```powershell
Install-Module -Force OpenSSHUtils -Scope AllUsers
```
でエラーがでる。

[PowerShell Gallery \| OpenSSHUtils 1\.0\.0\.1](https://www.powershellgallery.com/packages/OpenSSHUtils/1.0.0.1)
なんか
> The owner has unlisted this package. This could mean that the module is deprecated or shouldn't be used anymore.
とか書いてある。だめじゃん。

- [混沌を極めるWindowsのssh-agent事情 - Qiita](https://qiita.com/slotport/items/e1d5a5dbd3aa7c6a2a24)
- [Windows10 で ssh\-agent のサービスを登録する \- Qiita](https://qiita.com/mizutoki79/items/074d11cf9bc82b87385f)

どうも公式のドキュメントに従うとうまくいかないようだ。

```
c:> sc query | findstr "OpenSSH"
DISPLAY_NAME: OpenSSH Authentication Agent
```

## やりなおし

- [OpenSSH をインストールする \| Microsoft Docs](https://docs.microsoft.com/ja-jp/windows-server/administration/openssh/openssh_install_firstuse)

でsshをインストールする。ssh-agentのサービスも同時にインストールされるみたい。

scコマンドでチェック。
```
c:\> sc query state= all | findstr "OpenSSH"
DISPLAY_NAME: OpenSSH Authentication Agent
```
(allの前に空白が必要)

services.mscかなにかで
`OpenSSH Authentication Agent`が起動していることを確認する。

`%USERPROFILE%\.ssh`に .sshの内容を置く。
ここ以外に置くとパーミッションがすごくややこしい。

で `ssh-add %USERPROFILE%\.ssh\id_rsa` してパスフレーズいれる。
(`id_rsa`のところはアレンジ)

エージェントにはいったキーは`ssh-add -l`で確認できる。

であとはsshで接続。.ssh/configも書くと完璧。
ちゃんとForwardAgentも動く。

## おどろいたこと

ssh-agent、再起動してもキーを覚えてる。

削除するには `ssh-add -k {file}`。
削除できない場合はいっぺん同じキーを追加してから削除(なんでや)。

## 欠点

cmd.exeでもpowershell.exeでもWindows Terminalでも
xtermみたいには使えない。

- middle clickでペーストができない
- C-SPCもC-@も手前で喰われてemacsが使えない

あとProxyJumpは使えない。 ProxyCommandではいけるらしい。
`posix_spawn: no such file or directory proxyjump` で検索。


# Simple SSH Security

* [Simple SSH Security \| Disk Notifier](https://disknotifier.com/blog/simple-ssh-security/)
* ↑のGoogle翻訳 [シンプルなSSHセキュリティ| ディスク通知機能](https://disknotifier-com.translate.goog/blog/simple-ssh-security/?_x_tr_sl=en&_x_tr_tl=ja&_x_tr_hl=ja&_x_tr_pto=nui)

/etc/ssh/sshd_configで

KbdInteractiveAuthenticationをnoに設定。
ChallengeResponseAuthenticationはこれの別名だけど、この名前で設定しないこと(わかりにくいから)。

PasswordAuthenticationをnoに設定。

ここで `systemctl reload sshd.service`

## 弱い素数を削除

```sh
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli
```

## 強力な暗号のみ使う

`/etc/ssh/sshd_config.d/ssh_hardening.conf`
という名前で以下を作成
```
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com

HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
```

で `systemctl reload sshd.service`

確認は
`ssh -c aes128-cbc localhost`
で、接続に失敗するはず。


# sftpをscpのように使う例

- [linux \- Using sftp like scp \- Super User](https://superuser.com/questions/1434225/using-sftp-like-scp)
- [15 Examples of SFTP command in Linux](https://geekflare.com/sftp-command-examples/)

アップロード
```sh
scp {local-path} {user}@{remote-host}:{remote-path}
# ↑は↓と同じ
sftp {user}@{host}:{remote-path} <<< $'put {local-path}'
# or 
echo 'put {local-path}' | sftp {user}@{host}:{remote-path}
```

ダウンロードはもっと普通
```sh
sftp {user}@{remote-host}:{remote-file-name} {local-file-name}
```

# sftpのみ かつ chrootするユーザを作るときのコツ

参考:
- [ssh - "client_loop: send disconnect: Broken pipe" for chroot sftp user, with correct password? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/598520/client-loop-send-disconnect-broken-pipe-for-chroot-sftp-user-with-correct-p)
- [SSHD_CONFIG(5) - ファイルフォーマット - YOS OPENSONAR](http://www.yosbits.com/opensonar/rest/man/freebsd/man/ja/man5/sshd_config.5.html?l=ja)

ChrootDirectory で指定するディレクトリは

> パス名のすべての構成要素は、いかなる他のユーザまたはグループによって書き込み可能でない root で所有されているディレクトリでなければなりません。

これにハマることが多いので注意。
