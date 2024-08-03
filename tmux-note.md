# tmux メモ

- [接続が切れたあとで tmux a したときに ssh-agent が切れる話](#接続が切れたあとで-tmux-a-したときに-ssh-agent-が切れる話)
- [tmux のコピーモード](#tmux-のコピーモード)
- [新しいウインドウやペインを開いたときに cwd を引き継ぐ](#新しいウインドウやペインを開いたときに-cwd-を引き継ぐ)

## 接続が切れたあとで tmux a したときに ssh-agent が切れる話

[tmux ssh-agent - Google 検索](https://www.google.co.jp/search?hl=ja&q=tmux+ssh-agent&lr=lang_ja)
で検索するとたくさん出てくる。

とりあえずこれを使ってます
[ssh 先の tmux で ssh-agent の接続が切れてしまう問題の回避策 - Qiita](https://qiita.com/yamasaki-masahide/items/cbf57c07ff21b4100056)

上記から引用: ~/.bashrc に

```sh
# for tmux
[[ $SSH_AUTH_SOCK != $HOME/.ssh/sock && -S $SSH_AUTH_SOCK ]] \
  && ln -snf "$SSH_AUTH_SOCK" "$HOME/.ssh/sock" \
  && export SSH_AUTH_SOCK="$HOME/.ssh/sock"
```

を追加

欠点:
もう 1 個別のターミナルからつなぐと死ぬ。
本来の SSH_AUTH_SOCK が毎回違う名前になってるのはちゃんと理由がある、ということ。
すこし考えないとダメ。

## tmux のコピーモード

ぐぐるとなんだか vi モードの話しか出てこない。デフォルトの emacs キーアサインは

1. prefix [ または prefix pageup
1. カーソルキーで移動。または `g` で行番号
1. c-space または c-@ で選択開始
1. カーソルキーで移動。または `g` で行番号
1. c-w で copy と同時に copy-mode 抜け
1. prefix ] でペースト

これでバッファに入るので、tmux 立ち上げたサーバで

```sh
# copyバッファのリスト
tmux list-buffers
# ファイルの書き出し
tmux save-buffer -a ~/foo.log
tmux save-buffer -b 0 ~/bar.log
tmux save-buffer -a | clip.exe  # for WSL
# copyバッファの削除
tmux delete-buffer -b 0  # -a はないみたい
```

あと現在のキーバインドは
`tmux list-keys | less`
で見れる。

## 新しいウインドウやペインを開いたときに cwd を引き継ぐ

```conf
# .tmux.conf

# 新しいウィンドウを作成したときに、カレントディレクトリを引き継ぐ
bind c new-window -c "#{pane_current_path}"

# 新しいペインを作成したときに、カレントディレクトリを引き継ぐ
bind % split-window -h -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
```
