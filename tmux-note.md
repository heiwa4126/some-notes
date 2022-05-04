# 接続が切れたあとでtmux aしたときにssh-agentが切れる話

[tmux ssh-agent - Google 検索](https://www.google.co.jp/search?hl=ja&q=tmux+ssh-agent&lr=lang_ja)
で検索するとたくさん出てくる。

とりあえずこれを使ってます
[ssh先のtmuxでssh-agentの接続が切れてしまう問題の回避策 - Qiita](https://qiita.com/yamasaki-masahide/items/cbf57c07ff21b4100056)

上記から引用: ~/.bashrcに
```sh
# for tmux
[[ $SSH_AUTH_SOCK != $HOME/.ssh/sock && -S $SSH_AUTH_SOCK ]] \
  && ln -snf "$SSH_AUTH_SOCK" "$HOME/.ssh/sock" \
  && export SSH_AUTH_SOCK="$HOME/.ssh/sock"
```
を追加