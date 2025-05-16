# pnpm のメモ

## pnpm 自体の更新

最近は corepack 経由でやってると思うので

```sh
corepack prepare pnpm@latest --activate
```

で。

## pnpm でパッケージをまとめて latest に

```sh
pnpm up --latest
```

## pnpm でキャッシュを消す

pnpm 用語では、キャッシュでなくストアというらしい。

```sh
# ストアから参照されていないパッケージを削除する
pnpm store prune
```

<https://pnpm.io/cli/store#prune>

## bash で補完

[Command line tab-completion | pnpm](https://pnpm.io/completion)

```sh
pnpm completion bash > completion-for-pnpm.bash
sudo mv completion-for-pnpm.bash /etc/bash_completion.d/
```
