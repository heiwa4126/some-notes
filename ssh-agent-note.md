# ssh-agent まわりのメモ

パスフレースを入力する回数をなるべく減らす。

- [ssh-agent まわりのメモ](#ssh-agent-まわりのメモ)
  - [Windows の ssh-agent](#windows-の-ssh-agent)
  - [Mac の](#mac-の)
  - [Linux の](#linux-の)
  - [WSL で](#wsl-で)
  - [WSL で Windows 側の ssh-agent を使う](#wsl-で-windows-側の-ssh-agent-を使う)

## Windows の ssh-agent

便利。ssh-add するとシークレットストアに入るらしい。ユーザログインで復帰する。

未確認なのが
複数ユーザの時と、
"Administrator ずっと立ち上げっぱなし"(Windows Server なんかでよくある)問題。

## Mac の

`ssh-add --apple-use-keychain` というのがあるらしい。

[SSH パスフレーズ 省略したい！\~ config 設定するか Keychain 登録自動化するか \~](https://zenn.dev/luvmini511/articles/65786667221313)

## Linux の

**サーバーで使わないのが安全。** (Linux クライアントは別)

もし使うなら

- ログインしたら `eval $(ssh-agent) && ssh-add ...`
- ログアウトするときに `pkill ssh-agent`

しかない。あとは ssh_config で`ForwardAgent yes` で、ターミナル側で持つとか。

## WSL で

WSL で「作業で使って帰るときにシャットダウン」という使用法なら keychain が使える。

- [Using SSH-Agent the right way in Windows 10/11 WSL2 · Esc.sh](https://esc.sh/blog/ssh-agent-windows10-wsl2/)
- [Ubuntu Manpage: keychain - re-use ssh-agent and/or gpg-agent between logins](https://manpages.ubuntu.com/manpages/noble/en/man1/keychain.1.html)
- [Funtoo Keychain Project - Funtoo](https://www.funtoo.org/Funtoo:Keychain)

```sh
sudo apt-get install keychain -y
```

で、

```bash
# ~/.bashrc
# For Loading the SSH key
/usr/bin/keychain -q --nogui $HOME/.ssh/pubkey1
/usr/bin/keychain -q --nogui $HOME/.ssh/pubkey2 # 好きなだけ追加
source $HOME/.keychain/$(hostname)-sh
```

~/.profile と ~/.bashrc に分けてもいい。

```bash
# ~/.profile
# For Loading the SSH key
/usr/bin/keychain -q --nogui $HOME/.ssh/pubkey1
/usr/bin/keychain -q --nogui $HOME/.ssh/pubkey2 # 好きなだけ追加

# ~/.bashrc
# For Loading the SSH key
source $HOME/.keychain/$(hostname)-sh
```

最初にログインしたときにパスフレーズを聞かれる(上の例では pubkey1, pubkey2)。

確認は `ssh-add -l` or `ssh-add -L` で。

問題点は:

- 秘密鍵公開鍵両方とも必要

なこと。

## WSL で Windows 側の ssh-agent を使う

できるらしい。
