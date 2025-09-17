# nektos/act のメモ

[nektos/act: Run your GitHub Actions locally 🚀](https://github.com/nektos/act)

## サンプルやってみる

[How Does It Work?](https://github.com/nektos/act?tab=readme-ov-file#how-does-it-work)
にあるサンプルをやってみる。

act 自体は aqua で入れた。

```console
$ git clone https://github.com/cplee/github-actions-demo.git

$ cd github-actions-demo

$ act

INFO[0000] Using docker host 'unix:///var/run/docker.sock', and daemon socket 'unix:///var/run/docker.sock'
? Please choose the default image you want to use with act:
  - Large size image: ca. 17GB download + 53.1GB storage, you will need 75GB of free disk space, snapshots of GitHub Hosted Runners without snap and pulled docker images
  - Medium size image: ~500MB, includes only necessary tools to bootstrap actions and aims to be compatible with most actions
  - Micro size image: <200MB, contains only NodeJS required to bootstrap actions, doesn't work with all actions

Default image and other options can be changed manually in /home/user1/.config/act/actrc (please refer to https://nektosact.com/usage/index.html?highlight=configur#configuration-file for additional information about file structure)  [Use arrows to move, type to filter, ? for more help]
  Large
> Medium
  Micro
```

そもそも docker が要るらしい。Medium でやってみるよ。
参照: [Runners](https://nektosact.com/usage/runners.html#runners)

あとで `~/.actrc` も書いてみる。

リスト:

```console
$ act -l
INFO[0000] Using docker host 'unix:///var/run/docker.sock', and daemon socket 'unix:///var/run/docker.sock'
Stage  Job ID  Job name  Workflow name  Workflow file  Events
0      test    test      CI             main.yml       push
```

アクションの中身は
[github-actions-demo/.github/workflows/main.yml at master · cplee/github-actions-demo](https://github.com/cplee/github-actions-demo/blob/master/.github/workflows/main.yml)

```yaml
name: CI
on: push

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v1
      - run: npm install
      - run: npm test
```

全部実行

```console
$ act

INFO[0000] Using docker host 'unix:///var/run/docker.sock', and daemon socket 'unix:///var/run/docker.sock'
[CI/test] ⭐ Run Set up job
[CI/test] 🚀  Start image=catthehacker/ubuntu:act-latest
[CI/test]   🐳  docker pull image=catthehacker/ubuntu:act-latest platform= username= forcePull=true
[CI/test] using DockerAuthConfig authentication for docker pull
[CI/test]   🐳  docker create image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[CI/test]   🐳  docker run image=catthehacker/ubuntu:act-latest platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[CI/test]   🐳  docker exec cmd=[node --no-warnings -e console.log(process.execPath)] user= workdir=
[CI/test]   ✅  Success - Set up job
[CI/test]   ☁  git clone 'https://github.com/actions/setup-node' # ref=v1
[CI/test] ⭐ Run Main actions/checkout@v2
[CI/test]   🐳  docker cp src=/home/user1/works/github-actions/github-actions-demo/. dst=/home/user1/works/github-actions/github-actions-demo
[CI/test]   ✅  Success - Main actions/checkout@v2 [19.18957ms]
[CI/test] ⭐ Run Main actions/setup-node@v1
[CI/test]   🐳  docker cp src=/home/user1/.cache/act/actions-setup-node@v1/ dst=/var/run/act/actions/actions-setup-node@v1/
[CI/test]   🐳  docker exec cmd=[/opt/acttoolcache/node/18.20.8/x64/bin/node /var/run/act/actions/actions-setup-node@v1/dist/index.js] user= workdir=
| [command]/opt/hostedtoolcache/node/10.24.1/x64/bin/node --version
| v10.24.1
| [command]/opt/hostedtoolcache/node/10.24.1/x64/bin/npm --version
| 6.14.12
[CI/test]   ❓ add-matcher /run/act/actions/actions-setup-node@v1/.github/tsc.json
[CI/test]   ❓ add-matcher /run/act/actions/actions-setup-node@v1/.github/eslint-stylish.json
[CI/test]   ❓ add-matcher /run/act/actions/actions-setup-node@v1/.github/eslint-compact.json
[CI/test]   ✅  Success - Main actions/setup-node@v1 [534.348375ms]
[CI/test]   ⚙  ::add-path:: /opt/hostedtoolcache/node/10.24.1/x64/bin
[CI/test] ⭐ Run Main npm install
[CI/test]   🐳  docker exec cmd=[bash -e /var/run/act/workflow/2] user= workdir=
| added 280 packages from 643 contributors and audited 280 packages in 2.866s
|
| 24 packages are looking for funding
|   run `npm fund` for details
|
| found 49 vulnerabilities (11 low, 13 moderate, 21 high, 4 critical)
|   run `npm audit fix` to fix them, or `npm audit` for details
[CI/test]   ✅  Success - Main npm install [3.319902337s]
[CI/test] ⭐ Run Main npm test
[CI/test]   🐳  docker exec cmd=[bash -e /var/run/act/workflow/3] user= workdir=
|
| > github-actions-demo@1.0.0 test /home/user1/works/github-actions/github-actions-demo
| > mocha ./tests --recursive
|
|
|
|   GET /
|     ✓ should respond with hello world
|
|
|   1 passing (11ms)
|
[CI/test]   ✅  Success - Main npm test [354.414459ms]
[CI/test] ⭐ Run Complete job
[CI/test] Cleaning up container for job test
[CI/test]   ✅  Success - Complete job
[CI/test] 🏁  Job succeeded
```

あと actionlint すると pin しろ、って言ってくるので、`pinact run` してアップグレードもしてみる。

...なんかアクション、ダウンロードしてる。どこかにキャッシュされてる? `docker volume ls` するとそれらしいのが

`pinact run -u` したらロックファイルが古いって警告が山ほど。

## キャッシュの場所

`~/.cache/act` らしい。時々消した方がいいかも

他キャッシュ系のオプション:

- **--action-cache-path**  
  → actions がキャッシュされるパスを指定できる。デフォルトは ~/.cache/act らしい。
- **--action-offline-mode**  
  → 既にキャッシュがある場合、再フェッチ・再 pull しない。
- **--use-new-action-cache**  
  → 新しいキャッシュの仕組みを有効化する。これがなんだかよくわからん。新しいから良いものなのでは w
- **--cache-server-\*** 系  
  → actions/cache 用のローカルキャッシュサーバの保存場所やポートを設定する。

## 設定ファイルの場所

設定ファイルの優先順位(低い順から高い順):

1. `~/.config/act/actrc` - XDG Base Directory 仕様に従った場所
2. `~/.actrc` - ホームディレクトリ
3. `./.actrc` - プロジェクトディレクトリ(実行時の作業ディレクトリ)

[Configuration file](https://nektosact.com/usage/index.html#configuration-file)

> Act can be configured using .actrc files. All found arguments will be parsed and appended to a list, in order of: .actrc as per the XDG spec, .actrc in HOME directory, .actrc in invocation directory, cli arguments.

自分の`~/.config/act/actrc`の例

```config
-P ubuntu-latest=catthehacker/ubuntu:act-latest
-P ubuntu-22.04=catthehacker/ubuntu:act-22.04
-P ubuntu-20.04=catthehacker/ubuntu:act-20.04
-P ubuntu-18.04=catthehacker/ubuntu:act-18.04
# 以下追加.ほんとはコメントは使えないので注意
--use-new-action-cache
--action-offline-mode
```

## なんかいろいろ裏技があるらしい
