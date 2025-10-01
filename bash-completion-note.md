# bash-completion メモ

bash の補完って、bash の機能ではないんだってさ。全然知らなかった。

[scop/bash-completion: Programmable completion functions for bash](https://github.com/scop/bash-completion?tab=readme-ov-file#readme)

## 手元の Ubuntu で

```console
$ locate bash-completion | grep bin/
/usr/bin/dh_bash-completion

$ dlocate /usr/bin/dh_bash-completion
bash-completion: /usr/bin/dh_bash-completion

$ apt show bash-completion
apt show bash-completion
Package: bash-completion
Version: 1:2.11-5ubuntu1
Priority: standard
Section: shells
Origin: Ubuntu
Maintainer: Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>
Original-Maintainer: Gabriel F. T. Gomes <gabriel@inconstante.net.br>
Bugs: https://bugs.launchpad.net/ubuntu/+filebug
Installed-Size: 1,499 kB
Provides: dh-sequence-bash-completion
Homepage: https://github.com/scop/bash-completion
Task: standard
Download-Size: 180 kB
APT-Manual-Installed: no
APT-Sources: http://archive.ubuntu.com/ubuntu jammy/main amd64 Packages
Description: bash シェル用のプログラム可能な補完機能
 bash completion は bash の標準的な補完処理をたった数ストロークで複雑なコマ
 ンドラインを実現できるように拡張します。このプロジェクトは最も普及した Linux/UNIX
 コマンド用のプログラム可能な補完ルーチンを作り出し、システム管理 者やプログラマが日常作業で必要なタイピングの量を削減するために始められました。
```

## per-user の completion

[FAQ](https://github.com/scop/bash-completion?tab=readme-ov-file#faq)
の "Q. Where should I install my own local completions?"

> A. Put them in the completions subdir of $BASH_COMPLETION_USER_DIR (defaults to $XDG_DATA_HOME/bash-completion or ~/.local/share/bash-completion if $XDG_DATA_HOME is not set) to have them loaded automatically on demand when the respective command is being completed. See also the next question's answer for considerations for these files' names, they apply here as well. Alternatively, you can write them directly in ~/.bash_completion which is loaded eagerly by our main script.

優先順位は:

0. `~/.bash_completion` → シェル起動時に「必ず」読み込まれる(eager load)

以下が lazy load (bash-completion v2) で、

1. ($BASH_COMPLETION_USER_DIRを設定してあれば) `$BASH_COMPLETION_USER_DIR/completions/`
2. (未設定なら) `$XDG_DATA_HOME/bash-completion/completions/`
3. ($XDG_DATA_HOME も未設定なら) `~/.local/share/bash-completion/completions/`

で、lazy load の場合命名規則があって、**ファイル名はコマンド名と完全一致させる**こと。

こんなノリで ↓

```bash
#!/bin/bash
BCPATH=~/.local/share/bash-completion/completions
mkdir -p "$BCPATH"

uv generate-shell-completion bash > "$BCPATH/uv"
poe _bash_completion > "$BCPATH/poe"
pnpm completion bash > "$BCPATH/pnpm"
aqua completion bash > "$BCPATH/aqua"
cosign completion bash > "$BCPATH/cosign"
```

これを時々実行する感じ。
