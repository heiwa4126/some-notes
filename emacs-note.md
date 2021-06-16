# emacsメモ

- [emacsメモ](#emacsメモ)
- [sort & uniq](#sort--uniq)
- [init.elを分割](#initelを分割)
- [sharp qoute](#sharp-qoute)
- [rainbow-delimiters](#rainbow-delimiters)
- [use-package](#use-package)
- [packageまわりtips](#packageまわりtips)
- [help](#help)
- [LSPモード](#lspモード)
  - [LSPモード TIPS](#lspモード-tips)
- [コマンドの出力を自動スクロールする](#コマンドの出力を自動スクロールする)
- [ELPAのPGPキー](#elpaのpgpキー)
- [Ubuntu 1804にemacs27](#ubuntu-1804にemacs27)
- [コンソールからペーストするときインデントさせない](#コンソールからペーストするときインデントさせない)
- [git以下でバックアップファイルができない](#git以下でバックアップファイルができない)

# sort & uniq

よく使うのに忘れるのでメモ。なんかキーバインドしたほうがいいかも。
ソートしてなくても使える。

```
M-x delete-duplicate-lines
```

参考:
- [Emacs 24.4 の新機能・重複行を削除する delete-duplicate-lines - 雑文発散(2014-08-05)](https://suzuki.tdiary.net/20140805.html)
- [elisp - how to delete the repeat lines in emacs - Stack Overflow](https://stackoverflow.com/questions/13046791/how-to-delete-the-repeat-lines-in-emacs)

# init.elを分割

[設定ファイルを複数ファイルに分割して管理する構文のまとめ - Qiita](https://qiita.com/skkzsh/items/20af9affd5cc1e9678f8)

# sharp qoute

``# `ってやつ。

- [elisp - Elispで変数を指定する際 'hoge と #'hoge の違いとは - スタック・オーバーフロー](https://ja.stackoverflow.com/questions/29185/elisp%E3%81%A7%E5%A4%89%E6%95%B0%E3%82%92%E6%8C%87%E5%AE%9A%E3%81%99%E3%82%8B%E9%9A%9B-hoge-%E3%81%A8-hoge-%E3%81%AE%E9%81%95%E3%81%84%E3%81%A8%E3%81%AF)
- [elisp - When should sharp quotes be used? - Emacs Stack Exchange](https://emacs.stackexchange.com/questions/35988/when-should-sharp-quotes-be-used)


# rainbow-delimiters

- [Small rainbow-delimiters tutorial | Yoo Box](https://yoo2080.wordpress.com/2013/12/21/small-rainbow-delimiters-tutorial/)
- [rainbow-delimiters.elの括弧色付けをデフォルトより強調する方法 - 会者定離で(ダイアリーから)以降](https://murase-syuka.hatenablog.com/entry/20140815/1408061850)

# use-package

はやりすたりはあるけど

- [jwiegley/use-package: A use-package declaration for simplifying your .emacs](https://github.com/jwiegley/use-package)

# packageまわりtips

`M-x package-refresh-contents [RET]`

`M-x package-autoremove [RET]`


- [package: パッケージ管理ツール | Emacs JP](https://emacs-jp.github.io/packages/package)
- [Getting Started - MELPA](https://melpa.org/#/getting-started)

# help

よく忘れるので引用しとく。
元: [GNU Emacs Manual - Help](https://flex.phys.tohoku.ac.jp/texi/emacs-jp/emacs-jp_26.html)

```text
以下はヘルプコマンドの要約です．

C-h a string RET
指定したstringがコマンド名に含まれているコマンドのリストを表示します(command-apropos)．

C-h b
現在のキーの割り当て表を表示します．現在の主モードにローカルな割り当てを 最初に，そのあとにすべてのグローバル割り当てを表示します (describe-bindings)．

C-h c key
keyが実行するコマンド名を表示します(describe-key-briefly)． cは`character'のcです．keyについてさらに情報を得るには C-h kを使います．

C-h f function RET
functionの名前のLisp関数の説明を表示します (describe-function)． コマンドはLisp関数なのでコマンド名も使えます．

C-h i
Infoというドキュメントファイルを読むプログラムを実行します(info)． Emacsの完全なマニュアルがInfoでオンラインで見られます．

C-h k key
keyが実行するコマンド名とそのドキュメントを表示します (describe-key)．

C-h l
入力した最後の100文字を表示します(view-lossage)．

C-h m
現在の主モードについてのドキュメントを表示します(describe-mode)．

C-h n
Emacsの変更についてのドキュメントを，最も最近のものから表示します (view-emacs-news)．

C-h s
現在の構文表の内容とその意味を表示します(describe-syntax)．

C-h t
Emacsチュートリアルを表示します(help-with-tutorial)．

C-h v var RET
Lisp変数varのドキュメントを表示します(describe-variable)．

C-h w command RET
指定したコマンドを実行するキーを表示します(where-is)．
```


# LSPモード


- [LSP Mode - Language Server Protocol support for Emacs - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/)

各言語の設定は
[Languages - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/page/languages/)
から

Pythonで元祖pyls使うなら
- [Python (Palantir) - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/page/lsp-pyls/)
- [GitHub - palantir/python-language-server: An implementation of the Language Server Protocol for Python](https://github.com/palantir/python-language-server)






## LSPモード TIPS

"main.go not in project or it is blacklisted"
とか言われたら、

`M-x lsp-workspace-folder-add` でプロジェクトルートを追加する。

または

`M-x lsp-workspace-blacklist-remove` でブラックリストから削除する。

どちらも`~/.emacs.d/.lsp-session-v1`に反映される。

追加/削除したら、emacsを再起動。


フォーマットは
`M-x lsp-format-buffer`


# コマンドの出力を自動スクロールする

```
(setq shell-command-dont-erase-buffer 'end-last-out)
```

- [How to make *Shell Command Output* buffer scroll to the end? - Emacs Stack Exchange](https://emacs.stackexchange.com/questions/50299/how-to-make-shell-command-output-buffer-scroll-to-the-end)
- [https://www.gnu.org/software/emacs/manual/html_node/emacs/Single-Shell.html](https://www.gnu.org/software/emacs/manual/html_node/emacs/Single-Shell.html) - の一番下。



# ELPAのPGPキー

`M-x package-list-package`で

```
Failed to verify signature archive-contents.sig:
No public key for 066DAFCB81E42C40 created at 2021-04-15T06:05:02+0900 using RSA
```
になるとき。

正しい手順は以下の通り(2021-04頃)
```sh
mkdir ~/.emacs.d/elpa/gnupg -p --mode 0700
echo "keyserver hkp://keys.gnupg.net" > ~/.emacs.d/elpa/gnupg/gpg.conf
gpg --homedir ~/.emacs.d/elpa/gnupg --recv-keys 066DAFCB81E42C40
```

古いgpgだと`--receive-keys`オプションがないので`--recv-keys`

参考:
- [Cannot run melpa package refresh due to gpg errors - Emacs Stack Exchange](https://emacs.stackexchange.com/questions/60554/cannot-run-melpa-package-refresh-due-to-gpg-errors)
- [Emacs に yaml-mode をインストールできなかった。 - Qiita](https://qiita.com/ryo-sato/items/d42e301648175b41c522)


# Ubuntu 1804にemacs27

snapが簡単だが(`sudo snap install emacs`)
そこそこデカいし、パス設定も面倒なので(/snap/bin)
それ以外の方法。

```sh
sudo apt remove emacs emacs25 emacs25-nox
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt update
sudo apt install emacs27-nox
```
25を残しといて `sudo update-alternatives --config emacs`する手もあります。

LSPのバージョンが変わるので
`rm ~/.emacs.d/.lsp-session-v1`


# コンソールからペーストするときインデントさせない

[Any Emacs command like paste\-mode in vim? \- Stack Overflow](https://stackoverflow.com/questions/986592/any-emacs-command-like-paste-mode-in-vim)

```
M-x electric-indent-mode RET
```
呼ぶたびにON/OFFする。


# git以下でバックアップファイルができない

version controlあると`*~`ができない。まあ好き好きだろうけど。

```lisp
(setq vc-make-backup-files t)
```
でバックアップファイル

- [emacs does not backup files in git repo](https://stackoverflow.com/questions/56915816/emacs-does-not-backup-files-in-git-repo)
- [vc\-make\-backup\-file](https://ayatakesi.github.io/emacs/24.5/Backup.html)

履歴とかも含めて、init.elにはこうしてみた(ほぼコピペ)。
```lisp
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/backups/"))       ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t                      ; use versioned backups
 vc-make-backup-files t                 ; we need backup files under version control
)
```
