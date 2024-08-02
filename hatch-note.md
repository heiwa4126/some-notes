# Hatch メモ

## Hatch の Windows の gui 版

Python が不要 w

Hatch インストールしたら

```powershell
hatch new hello-python
cd hello-python
hatch run code .
```

で開始できる。

注意: もし Hatch インストール前に、すでに VSCode が起動していたら、VSCode を全部終了させること。hatch への path が通っていないので。

## completion

[CLI usage - Hatch](https://hatch.pypa.io/latest/cli/about/#tab-completion)

```bash
_HATCH_COMPLETE=bash_source hatch > ~/.hatch-complete.bash
```

Hatch わりとバージョンによってコマンドが変わるので、別出しにして .profile で読む にしといたほうがいいみたい。

`/etc/bash_completion.d/` の per user があるといいんだけど(「作ればある」)。

とりあえず .profile に

```bash
# Hatch
if [ -f "$HOME/.hatch-complete.bash" ] ; then
  # _HATCH_COMPLETE=bash_source hatch > ~/.hatch-complete.bash
  # (see https://hatch.pypa.io/latest/cli/about/#tab-completion)
  . "$HOME/.hatch-complete.bash"
  alias hr="hatch run"
fi
```

と書いといた。

## hatch で lock ファイル

なんだかんだ言っても
`package-lock.json`
とか
`Gemfile.lock`
が無いと、
「7 年前のコードを動かしたい」みたいなときに困るので。

[juftin/hatch-pip-compile: hatch plugin to use pip-compile (or uv) to manage project dependencies and lockfiles](https://github.com/juftin/hatch-pip-compile#readme)

pip-compile(pip-tools)ベースで、パッケージのロックファイル(デフォルト requrements.txt)を作ってくれる
hatch のプラグイン。

設定簡単。uv も使える。(uv は hatch 内部でも使ってるので使わない手はない)

pyproject.toml に追加するだけ

```toml
[tool.hatch.env]
requires = [
  "hatch-pip-compile",
]

[tool.hatch.envs.default]
type = "pip-compile"
pip-compile-resolver = "uv"
```

## uv

[How to select the installer - Hatch](https://hatch.pypa.io/1.12/how-to/environment/select-installer/)

なんかやりたいほうだいな感じ
