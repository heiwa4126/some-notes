# Sixel メモ

(2025-02 現在)

Windows Terminal 1.22 から
[Sixel](https://en.wikipedia.org/wiki/Sixel)
が使えるようになったらしいので試してみる。

- [Windows Terminal が Sixel 画像表示をサポート。ターミナル画面内で精細なグラフなど表示可能に － Publickey](https://www.publickey1.jp/blog/24/windows_terminalsixel.html)
- [Windows Terminal Preview 1.22 Release - Windows Command Line](https://devblogs.microsoft.com/commandline/windows-terminal-preview-1-22-release/#sixel-image-support)
- [Release Windows Terminal v1.22.10352.0 · microsoft/terminal](https://github.com/microsoft/terminal/releases/tag/v1.22.10352.0) (2025-02 現在)

## 問題点

- tmux で使えない。フォークはある。[csdvrx/sixel-tmux: sixel-tmux is a fork of tmux, with just one goal: having the most reliable support of graphics](https://github.com/csdvrx/sixel-tmux)
- (Windows Terminal でないけど) VScode のターミナルで使えない。拡張機能もない

## libsixel

```sh
sudo apt install libsixel-bin
img2siexl foo.png
```

## python-sixel

Python のモジュールは
[sixel · PyPI](https://pypi.org/project/sixel/)
がある。
これ ↑ は [termios](https://docs.python.org/ja/3.13/library/termios.html)
に依存しており、Windows は動かない
(Windows は POSIX ではないので)。

CLI で
[sixelconv](https://github.com/lubosz/python-sixel?tab=readme-ov-file#sixelconv)
がついてる。たぶん libsixel なしで動く

## tmux 問題

端末エミュレータは Sixel サポートしてるのに tmux だと表示されない問題。
OpenAI-o3 mini に聞いてみた結果を以下にコピペしておきます。
**本当かどうかは不明**。

---

tmux（ターミナルマルチプレクサ）で Sixel 画像を表示できない問題に対する対策として、以下の方法を試すことができます。

### 1. tmux を Sixel 対応でビルドする

tmux はデフォルトでは Sixel をサポートしていませんが、`--enable-sixel`オプションを指定してビルドすることで対応可能です。以下の手順で tmux を再ビルドしてください[2][3][5]：

```bash
$ git clone https://github.com/tmux/tmux.git
$ cd tmux
$ ./autogen.sh
$ ./configure --enable-sixel
$ make
$ sudo make install
```

ビルド後、`tmux -V`でバージョンを確認し、「tmux next-3.6」のように表示されれば成功です。

### 2. Sixel 対応の tmux フォークを使用する

公式の tmux ではなく、Sixel 対応に特化したフォーク版「sixel-tmux」を利用する方法もあります。このフォークは Sixel シーケンスを適切に処理し、画像表示をサポートします[5][7]。

### 3. tmux の設定変更

Sixel プロトコルを有効にした tmux でも、設定が不足していると動作しない場合があります。以下の設定を`~/.tmux.conf`に追加してください[3]：

```bash
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

その後、tmux サーバーを再起動します：

```bash
$ tmux kill-server && tmux
```

### 4. 一時的に tmux 外で画像表示

tmux 内で画像表示が難しい場合、一時的に tmux セッションから抜けて画像を表示する方法もあります。以下はその例です[1]：

```bash
tmux detach -E 'img2sixel image.png; sleep 5; tmux attach'
```

このコマンドは一時的にセッションから抜けて画像を表示し、その後自動的に再接続します。

### 5. 注意点

- **パフォーマンス問題**: tmux 内で画像をスクロールするとちらつきや遅延が発生することがあります[2]。
- **互換性**: 使用するターミナルエミュレータが Sixel 対応である必要があります（例: XTerm, mlterm, mintty など）[5]。

これらの手法を試すことで、問題の解決が期待できます。

Citations:

[1] https://toxicfrog.github.io/images-in-the-terminal/
[2] https://note.com/ryobeam/n/n4169da15665e
[3] https://yazi-rs.github.io/docs/image-preview/
[4] https://bugs.launchpad.net/bugs/2068393
[5] https://www.arewesixelyet.com
[6] https://zenn.dev/ispec_inc/articles/tmux-sixel-build
[7] https://github.com/csdvrx/sixel-tmux/blob/main/RANTS.md
[8] https://github.com/tmux/tmux/issues/1613
[9] https://www.reddit.com/r/linuxquestions/comments/1hqg7pu/in_2025_what_features_do_you_want_in_a_terminal/
[10] https://jvns.ca/blog/2025/02/05/some-terminal-frustrations/
[11] https://forums.theregister.com/forum/all/2025/01/08/ghostty_1/
[12] https://www.reddit.com/r/tmux/comments/np7rjj/what_terminal_emulator_goes_well_with_tmux/
[13] https://github.com/mintty/wsltty/issues/344
[14] https://qiita.com/arakiken/items/3e4bc9a6e43af0198e46
[15] https://news.ycombinator.com/item?id=40598629
[16] https://news.ycombinator.com/item?id=28756701
[17] https://news.ycombinator.com/item?id=42579472
[18] https://juliapackages.com/p/sixel
[19] https://cyberpanel.net/blog/best-terminal-emulator-linux
[20] https://news.ycombinator.com/item?id=35936331
[21] https://github.com/mfontanini/presenterm/issues/72
[22] https://www.reddit.com/r/neovim/comments/14mjsvr/adding_image_support_to_neovim_kitty_tmux_amazing/
[23] https://raw.githubusercontent.com/tmux/tmux/3.5/CHANGES
[24] https://news.ycombinator.com/item?id=21644566
[25] https://www.reddit.com/r/linuxquestions/comments/1bdh3n2/is_there_a_way_to_view_images_in_a_tmux_terminal/
[26] https://github.com/tmux/tmux/issues/4208
[27] https://discourse.julialang.org/t/ann-kittyterminalimages-jl-display-julia-output-images-directly-in-your-terminal/44831
[28] https://www.reddit.com/r/tmux/comments/oijul9/cant_display_images_in_the_terminal_while_on_tmux/
[29] https://www.reddit.com/r/commandline/comments/1f365z7/yazi_image_preview_doesnt_work_inside_tmux_on_a/
[30] https://gitlab.freedesktop.org/terminal-wg/specifications/-/issues/26
[31] https://www.reddit.com/r/tmux/comments/o85fck/sixel_support/
[32] https://www.reddit.com/r/bashonubuntuonwindows/comments/1eimdn6/how_to_render_img2sixel_output_properly_in_wsl/
[33] https://github.com/tmux/tmux/issues/3684
