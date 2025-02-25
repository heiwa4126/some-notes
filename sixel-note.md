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
