
[99designs/aws\-vault: A vault for securely storing and accessing AWS credentials in development environments](https://github.com/99designs/aws-vault)

Ubuntu 22.04LTSで (2022-06)

```bash
curl -L 'https://github.com/99designs/aws-vault/releases/download/v6.6.0/aws-vault-linux-amd64' -o aws-vault
chmod +x aws-vault
sudo mv aws-vault /usr/local/bin
```

```
$ aws-vault --version
v6.6.0

$ aws-vault add test1
aws-vault: error: Specified keyring backend not available, try --help
```

なんかキーストアのバックエンドが要る。
[Vaulting Backends](https://github.com/99designs/aws-vault#vaulting-backends)
CLIで使えるやつがあるかな。

[Pass](https://www.passwordstore.org/) がXでもCLIでも使えるらしい。

参考: [Pass for Ubuntu](https://linuxhint.com/pass-ubuntu/)

```bash
sudo apt install pass
```

GPG Keyがないので作る。対話式。
```bash
gpg --full-generate-key
```
パスフレーズは簡単なのじゃダメ。

> gpg: 鍵AAAAAAAAAAAAAAAAを究極的に信用するよう記録しました

これがID。

```bash
pass init AAAAAAAAAAAAAAAA
# or
pass init メールアドレス
```


このへんの変数を.profileに
```bash
export AWS_VAULT_BACKEND=/usr/bin/pass
export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_SESSION_TOKEN_TTL=3h
export GPG_TTY=$(tty)
```

tmuxだと.bashrcにも
```bash
export GPG_TTY=$(tty)
```
は要ると思う。
