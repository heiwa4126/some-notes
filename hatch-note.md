# Hatch メモ

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
