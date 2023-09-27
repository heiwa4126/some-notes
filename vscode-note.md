# Visual Studio Code メモ

- [Visual Studio Code メモ](#visual-studio-code-メモ)
  - [Remote Development](#remote-development)
    - [step1](#step1)
    - [step 2](#step-2)
    - [step 3](#step-3)
    - [メモ](#メモ)
  - [Powershell 7 が Windows Store で配布されるようになった](#powershell-7-が-windows-store-で配布されるようになった)
  - [Widnows11 で"Open with Code"が出ない件](#widnows11-でopen-with-codeが出ない件)
  - [ゼロ幅スペース (Zero Width Space: U+200B)](#ゼロ幅スペース-zero-width-space-u200b)
  - [bash のキーアサイン](#bash-のキーアサイン)

## Remote Development

ここから始める: [Developing on Remote Machines using SSH and Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh)

使える SSH クライアントは: [Visual Studio Code Remote Development Troubleshooting Tips and Tricks](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client)

Git for Windows に入ってる MINGW の ssh が使える。

- 開発してるなら Git for Windows は入ってるはず
- この MINGW には [connect.c](https://gist.github.com/rurban/360940) (connect.exe, connect-proxy)のバイナリがついてる。
  - http proxy の下でもすぐ使える。

### step1

Git bash を起動して、.ssh/config を修正 & id_rsa を適当に配置 etc。`ssh <host>`でつながるとこまで設定。

.ssh/confi の example

```config
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

コツは ProxyCommand に connect.exe をフルパスで書くこと。

Git bash で ssh-agent を上げとくと超ラク

```bash
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
code
```

### step 2

vscode に`Remote Development`拡張を入れる。

設定で

- remote.SSH.configFile
- remote.SSH.path

を設定する。どっちもフルパス

### step 3

vscode で f1 押して`Remote-SSH: Connect to Host`を実行。.ssh/config に書いた host が出るので選択する。

`フォルダを開く`で作業フォルダを開く。あとは普通に作業する。

次からはリモートエクスプローラのペインから作業フォルダが開ける。

### メモ

いまのところ(2019-10)、`ProxyJump`が使えないらしい。
MINGW の ssh では通るけど、vscode でつなごうとすると死ぬ。

## Powershell 7 が Windows Store で配布されるようになった

pwsh.exe へのパスは通っているので、

設定で

```json
"terminal.integrated.shell.windows": "pwsh.exe",
```

にすればとりあえず動く。
フルパスはユーザプロファイルの下だっりするので、sync してると辛い。

Windows Store だと更新が楽だからなぁ...

## Widnows11 で"Open with Code"が出ない件

エクスプローラー拡張の
「Code で開く」
が出てこない件。

[Integrate with the Windows 11 Context Menu · Issue \#127365 · microsoft/vscode](https://github.com/microsoft/vscode/issues/127365)

## ゼロ幅スペース (Zero Width Space: U+200B)

MS-Office や WEB からコピペしたりすると混入するときがある。
「ゼロ幅スペース」なんで目で見えない。

vscode では
\u200b を正規表現で置換
すると消せる。

![UI](./imgs/u200b.png)

全ファイル検索すると、ログのメモとかにけっこう混入してた。

## bash のキーアサイン

WSL や ssh remote で vscode を使うと、
ターミナルで ctrl+K などの bash でよく使うキーアサインが効かないのをなんとかできないか?

設定のリモートで、こんな感じのを入れて vscode を再起動すれば行けるらしい。

```json
{
  "terminal.integrated.commandsToSkipShell": [
    "workbench.action.terminal.clear",
    "workbench.action.terminal.clearSelection",
    "workbench.action.terminal.copySelection",
    "workbench.action.terminal.paste",
    "workbench.action.terminal.selectAll",
    "-workbench.action.quickOpen" // ctrl+E が復活する
  ],
  "terminal.integrated.allowChords": false // ctrl+K が復活する
}
```

- [VS Code のターミナルで Ctrl + p を使えるようにする | 穀風](https://kokufu.blogspot.com/2020/03/vs-code-ctrl-p.html)
- [Advanced Terminal Usage in Visual Studio Code](https://code.visualstudio.com/docs/terminal/advanced#_keybinding-and-the-shell)
- [統合ターミナルのシェルで実行したいキーバインドが VSCode で実行される - Qiita](https://qiita.com/m_zuma/items/06d989b0c60f7f2e9301)
- [keyboard shortcuts - VSCode: how to make Ctrl+k kill till the end of line in the terminal? - Stack Overflow](https://stackoverflow.com/questions/50569100/vscode-how-to-make-ctrlk-kill-till-the-end-of-line-in-the-terminal)

理屈はそういう感じだけど、ctrl+K や ctrl+E が `workbench.action.terminal.*` のどれだかはどうやってわかる?

ctrl+E は "-workbench.action.quickOpen" だった。これは困る。

なんか「一部のキーを vscode に渡す」設定にしてほしい...
