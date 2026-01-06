# Visual Studio Code メモ

- [Remote Development](#remote-development)
  - [step1](#step1)
  - [step 2](#step-2)
  - [step 3](#step-3)
  - [メモ](#メモ)
- [Powershell 7 が Windows Store で配布されるようになった](#powershell-7-が-windows-store-で配布されるようになった)
- [Widnows11 で"Open with Code"が出ない件](#widnows11-でopen-with-codeが出ない件)
- [ゼロ幅スペース (Zero Width Space: U+200B)](#ゼロ幅スペース-zero-width-space-u200b)
- [bash のキーアサイン](#bash-のキーアサイン)
- [VSCode server](#vscode-server)
- [VScode server が CPU 100%](#vscode-server-が-cpu-100)
- [現在 VScode にインストールされている拡張機能の ID を得るには?](#現在-vscode-にインストールされている拡張機能の-id-を得るには)
- [VScode で Javascript/Typescript の import を並び変える](#vscode-で-javascripttypescript-の-import-を並び変える)
- [VSCode で WSL 上の Typescript をデバッグしようとすると異常に時間がかかる](#vscode-で-wsl-上の-typescript-をデバッグしようとすると異常に時間がかかる)
  - [いちおう解決](#いちおう解決)
- [.vscode/ はレポジトリに含めるべき?](#vscode-はレポジトリに含めるべき)
- [.vscode/tasks.json に書いたタスクはどうやって動かす?](#vscodetasksjson-に書いたタスクはどうやって動かす)
- [.vscode/tasks.json と launch.json はどう使い分ける?](#vscodetasksjson-と-launchjson-はどう使い分ける)
- [VScode のターミナルでどんなコマンドを叩いても "Argument list too long" と言われるとき](#vscode-のターミナルでどんなコマンドを叩いても-argument-list-too-long-と言われるとき)
- [拡張機能のフィルタ](#拡張機能のフィルタ)
- [VSCode のターミナルで Ctrl+K を使う](#vscode-のターミナルで-ctrlk-を使う)
- [折りたたみ(Folding)系](#折りたたみfolding系)
- [VSCode に GPU を使わせない設定](#vscode-に-gpu-を使わせない設定)
- [折り返しの有効無効](#折り返しの有効無効)
- [マルチカーソルで折り返しを無視する](#マルチカーソルで折り返しを無視する)
- [VSCode の Jupyter 拡張で Pylance が reportMissingImports と言ってくるとき](#vscode-の-jupyter-拡張で-pylance-が-reportmissingimports-と言ってくるとき)
  - [ひとつの解決案](#ひとつの解決案)
- [VSCode でプロファイルの複製で WSL の拡張が複製されない](#vscode-でプロファイルの複製で-wsl-の拡張が複製されない)
- [VSCode の terminal での completion がウザい](#vscode-の-terminal-での-completion-がウザい)
- [ワークスペース単位で拡張を無効にできる](#ワークスペース単位で拡張を無効にできる)
- [Pylance を軽くする](#pylance-を軽くする)
- [Code Spell Checker](#code-spell-checker)
  - [Code Spell Checker で exclude files を設定する](#code-spell-checker-で-exclude-files-を設定する)

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

```conf
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

## VSCode server

`~/.vscode-server` の下に、**拡張機能も含めて**インストールされている。

たまに VSCode server が高負荷で固まる時があるので、`rm -rf ~/.vscode-server` して
[Manually install vscode on server side](https://gist.github.com/bindiego/b6d9a7ef876e6418eda31d62a5a37c7e)
に従って再インストールする。

コミットコードを渡すのがちょっとめんどう。これ自動化できないかなあ。

現在インストールされている拡張機能は

```sh
ls ~/.vscode-server/extensions
```

にある。

## VScode server が CPU 100%

SSH-Remote などで接続しているとき VScode server が CPU を食い尽くすことがある。

VSCode の設定で

```json
"search.follow.symlink": false
```

- [rg process taking up all my CPU · Issue #98594 · microsoft/vscode](https://github.com/microsoft/vscode/issues/98594)
- [Fix 100% CPU | VSCODE-Server | Simple Remote SSH Guide - YouTube](https://www.youtube.com/watch?v=36Hm1DEl82M)

もう 1 つ

```json
"files.watcherExclude": {
  "**/.*/**": true,
  "**/cdktf.out/**": true,
  "**/node_modules/**": true,
  "**/build/**": true,
  "**/dist/**": true,
  "**/__pycache__/**": true,
  "**/.git/objects/**": false,
  "**/.git/subtree-cache/**": false,
  "**/.hg/store/**": false,
  "**/node_modules/*/**": false
}
```

上記は自分の設定。
全部除外してる人もいる。
[Visual Studio Code での SSH 接続により、EC2 サーバーが高負荷になり動かなくなった - エキサイト TechBlog.](https://tech.excite.co.jp/entry/2022/09/27/153341)

設定したら VSCode Server を 1 回終わらせる。サーバ側で

```sh
pkill -f /.vscode-server/code
```

VSCode 側で VSCode Server を止めることもできるけど (F1+"kill serve"で出てくる)

## 現在 VScode にインストールされている拡張機能の ID を得るには?

```sh
code --list-extensions

# バージョン付き
code --list-extensions --show-versions
```

## VScode で Javascript/Typescript の import を並び変える

Organize imports (Shift + Alt/Option + O)

## VSCode で WSL 上の Typescript をデバッグしようとすると異常に時間がかかる

```console
$ ps f
 7088 pts/3    Ssl+   0:00 /home/heiwa/.vscode-server/bin/863d2581ecda6849923a2118d93a088b0745d9d6/node -e c
 (略)
 7563 pts/1    Sl+    0:00              |   \_ /usr/bin/node ./build/index.js
 7570 pts/1    S+     0:00              |       \_ nc -z 127.0.0.1 53782
```

謎の nc でポートスキャンが走ってるのが見える。これがなんだかわからない

Windows 上や Remote-SSH では起きない。

### いちおう解決

WSL2 が mirror モードだった(IPv6 を使いたかった)のを、元の NAT に戻したら治った。

でも IPv6 も使いたい... もっと調べる

## .vscode/ はレポジトリに含めるべき?

(GPT に聞いてみた。当たり障りのない答えが返ってきた)

.vscode ディレクトリは、Visual Studio Code の設定やタスク、デバッグ設定などを含む場合があります。これらの設定がプロジェクト固有であり、他の開発者と共有する必要がある場合は、.vscode ディレクトリをリポジトリに含めることが推奨されます。

ただし、個々の開発者に固有の設定(例えば、特定の拡張機能の設定やエディタの見た目に関する設定など)はリポジトリに含めない方が良いでしょう。これらは .vscode ディレクトリに含めず、各開発者が自分のローカル環境で管理するべきです。

また、.vscode ディレクトリをリポジトリに含める場合でも、一部のファイル(例えば、settings.json の一部など)は .gitignore ファイルを使用してリポジトリから除外することもあります。これはプロジェクトと開発チームのニーズによります。

## .vscode/tasks.json に書いたタスクはどうやって動かす?

2 通り。

1. コマンドパレットで "Run task" (デフォルトではショートカットキーはない)。プルダウンからタスクを選ぶ。
2. ターミナルの "+" のプルダウンに「タスクの実行(Run Task)」があるので、そこから。

## .vscode/tasks.json と launch.json はどう使い分ける?

(launch.json はデバッグ専用らしい)

`.vscode/tasks.json` と `.vscode/launch.json` は Visual Studio Code で異なる目的で使われます。

**.vscode/tasks.json**

- タスクの自動化やビルドプロセスの定義に使用されます
- コードのコンパイル、テスト実行、デプロイなどの作業をタスクとして定義できます
- 例えば、TypeScript コードを JavaScript にトランスパイルするタスク、Sass ファイルをコンパイルするタスクなどを定義できます

**.vscode/launch.json**

- デバッガーの設定に使用されます
- アプリケーションのデバッグ時の動作を制御するための設定を定義できます
- 例えば、Node.js アプリケーションをデバッグする際の実行環境やブレークポイントを設定できます

つまり、tasks.json はビルド等の作業自動化に、launch.json はデバッグ時の挙動制御に主に使われる違いがあります。

実際の使い分けとしては、例えば次のようになります:

1. tasks.json で TypeScript のコンパイルタスクを定義
2. launch.json でコンパイル済みの JavaScript コードを Node.js でデバッグする設定を定義
3. コーディング
4. F5 キーでデバッガーを起動し、ブレークポイントを置いてデバッグ
5. コード変更後、保存して自動でコンパイルタスクが実行され、最新の JS コードが生成される

このように tasks.json と launch.json を使い分けて開発を行うことで、コーディング、ビルド、デバッグの作業フローを効率化できます。

## VScode のターミナルでどんなコマンドを叩いても "Argument list too long" と言われるとき

環境変数 PATH が変。たぶん長すぎ。.profile か.bashrc かそれ的なやつをチェックして直す。

[linux - Argument list too long - No command is working in VS Code - Stack Overflow](https://stackoverflow.com/questions/74341831/argument-list-too-long-no-command-is-working-in-vs-code)

## 拡張機能のフィルタ

[Extensions view filters](https://code.visualstudio.com/docs/editor/extension-marketplace#_extensions-view-filters)

## VSCode のターミナルで Ctrl+K を使う

[keyboard shortcuts - VSCode: how to make Ctrl+k kill till the end of line in the terminal? - Stack Overflow](https://stackoverflow.com/questions/50569100/vscode-how-to-make-ctrlk-kill-till-the-end-of-line-in-the-terminal)

これがいちばん簡単

```json
{
  "terminal.integrated.allowChords": false
}
```

## 折りたたみ(Folding)系

- `Ctrl + K Ctrl + 0` - ブロックを全部折りたたむ
- `Ctrl + K Ctrl + [数字]` - 指定したレベルのブロックを折りたたむ
- `Ctrl + K Ctrl + J` - ブロックを全部展開
- `Ctrl + K Ctrl + L` - カーソルのあるブロックを折りたたむ / 展開
- `Ctrl + Shift + [`- カーソルのあるブロックを折りたたむ
- `Ctrl + Shift + ]`- カーソルのあるブロックを展開

## VSCode に GPU を使わせない設定

[How can I disable GPU rendering in Visual Studio Code - Stack Overflow](https://stackoverflow.com/questions/29966747/how-can-i-disable-gpu-rendering-in-visual-studio-code)

argv.json に

```json
"disable-hardware-acceleration": true
```

または

```sh
code --disable-gpu
```

## 折り返しの有効無効

`Alt+Z`

## マルチカーソルで折り返しを無視する

完璧な方法はない。なんかショートカットでできるといいのにねえ。

`Alt+Z`で切り替えろ。

設定で論理行のみにするには

```json
{
  "editor.wordWrap": "off"
  # 言語ごとにもOK
}
```

だけど。

## VSCode の Jupyter 拡張で Pylance が reportMissingImports と言ってくるとき

> インポート "xxxxxx" を解決できませんでした Pylance(reportMissingImports)

みたいのが出るとき。特に .venv 使ってるとよく出る。

1. Jupyter のカーネルを選択する
2. コマンドパレットで `Python: Restart Language Server`

なんかこれ自動でやってくれないの?

### ひとつの解決案

VSCode のワークスペースの設定(`.vscode/settings.json`)で

```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python"
}
```

こうしておくのはいい考えかも。POSIX ならこれで。

Windows だとどうかな...

## VSCode でプロファイルの複製で WSL の拡張が複製されない

バグ。 [Cannot create new profile via copying default one · Issue #198518 · microsoft/vscode](https://github.com/microsoft/vscode/issues/198518)
いまのところリモートごとに設定する必要がある。

ので、

1. もとになるプロファイルを Windows で開く。「新しいウインドウ」
2. 複製プロファイルを作る
3. WSL 側でプロファイル指定して code を開く `code --profile hoge .`
4. 拡張機能から「WSL へインストール」を押しまくる

が楽(楽じゃないけど)。

## VSCode の terminal での completion がウザい

PowerShell はともかく、bash/zsh でやられても辛いので

```json
{
  "terminal.integrated.shellIntegration.enabled": true,
  "terminal.integrated.suggest.enabled": false
}
```

こんな感じでしばらく使ってみる

## ワークスペース単位で拡張を無効にできる

「TypeScript のプロジェクトで Python 関連をとめる」みたいなことができる。

Python の例でいくと
拡張機能一覧で Python の右側にある歯車アイコン → 「無効化」 → 「ワークスペースで無効化」

`.vscode/settings.json` には設定が**書き込まれない**ので、
ほかのホストで作業する場合は、そのつど設定が必要

## Pylance を軽くする

[Pylance Configuration Tips · microsoft/pylance-release Wiki](https://github.com/microsoft/pylance-release/wiki/Pylance-Configuration-Tips)

## Code Spell Checker

便利
[Code Spell Checker - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

### Code Spell Checker で exclude files を設定する

例:

```json
{
  // .vscode/settings.json などに記述
  "cSpell.ignorePaths": [
    "**/node_modules/**",
    "**/*.lock", // 任意の拡張の .lock を除外
    "**/*-lock.json", // npm系の -lock.json を除外（例：package-lock.json）
    "**/pnpm-lock.yaml",
    "**/yarn.lock"
  ],
  // 必要なら .gitignore も尊重させる
  "cSpell.useGitignore": true
}
```

参考:
[Files, Folders, and Workspaces | VS Code Spell Checker](https://streetsidesoftware.com/vscode-spell-checker/docs/configuration/files-folders-and-workspaces)
