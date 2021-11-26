# Visual Studio Code メモ

- [Visual Studio Code メモ](#visual-studio-code-メモ)
- [Remote Development](#remote-development)
	- [step1](#step1)
	- [step 2](#step-2)
	- [step 3](#step-3)
	- [メモ](#メモ)
- [Powershell 7がWindows Storeで配布されるようになった](#powershell-7がwindows-storeで配布されるようになった)
- [Widnows11で"Open with Code"が出ない件](#widnows11でopen-with-codeが出ない件)
- [ゼロ幅スペース (Zero Width Space: U+200B)](#ゼロ幅スペース-zero-width-space-u200b)

# Remote Development

ここから始める: [Developing on Remote Machines using SSH and Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh)

使えるSSHクライアントは: [Visual Studio Code Remote Development Troubleshooting Tips and Tricks](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client)

Git for Windowsに入ってるMINGWのsshが使える。

- 開発してるならGit for Windowsは入ってるはず
- このMINGWには [connect.c](https://gist.github.com/rurban/360940) (connect.exe, connect-proxy)のバイナリがついてる。
  - http proxyの下でもすぐ使える。

## step1

Git bashを起動して、.ssh/configを修正 & id_rsaを適当に配置 etc。`ssh <host>`でつながるとこまで設定。

.ssh/confiのexample
```
Protocol 2
ForwardAgent yes

Host foo1
	User foobar
	Hostname foo1.example.net
	Port 4126
  IdentityFile ~/.ssh/id_rsa
	ProxyCommand "C:\Program Files\Git\mingw64\bin\connect.exe" -H proxy.example.com:8080 %h %p
	Compression yes

Host *
	User foobar
  Compression no
  IdentityFile ~/.ssh/id_rsa
```

コツはProxyCommandにconnect.exeをフルパスで書くこと。

Git bashでssh-agentを上げとくと超ラク

``` bash
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
code
```

## step 2

vscodeに`Remote Development`拡張を入れる。

設定で
- remote.SSH.configFile
- remote.SSH.path

を設定する。どっちもフルパス

## step 3

vscodeでf1押して`Remote-SSH: Connect to Host`を実行。.ssh/configに書いたhostが出るので選択する。

`フォルダを開く`で作業フォルダを開く。あとは普通に作業する。

次からはリモートエクスプローラのペインから作業フォルダが開ける。


## メモ

いまのところ(2019-10)、`ProxyJump`が使えないらしい。
MINGWのsshでは通るけど、vscodeでつなごうとすると死ぬ。


# Powershell 7がWindows Storeで配布されるようになった

pwsh.exeへのパスは通っているので、

設定で
```json
"terminal.integrated.shell.windows": "pwsh.exe",
```
にすればとりあえず動く。
フルパスはユーザプロファイルの下だっりするので、syncしてると辛い。

Windows Storeだと更新が楽だからなぁ...


# Widnows11で"Open with Code"が出ない件

エクスプローラー拡張の
「Codeで開く」
が出てこない件。

[Integrate with the Windows 11 Context Menu · Issue \#127365 · microsoft/vscode](https://github.com/microsoft/vscode/issues/127365)



# ゼロ幅スペース (Zero Width Space: U+200B)

MS-OfficeやWEBからコピペしたりすると混入するときがある。
「ゼロ幅スペース」なんで目で見えない。

vscodeでは
\u200bを正規表現で置換
すると消せる。

![UI](./imgs/u200b.png)
