# uv (astral uv)のメモ

## uv にはタスクマネージャが無い

poethepoet か taskipy を使う。

- [PoeThePoet ドキュメント](https://github.com/nat-n/poethepoet)
- [Taskipy ドキュメント](https://taskipy.dev/)

PoeThePoet は project.json の run scripts のように shell で動くわけではないので、
そのまま "foo && bar" みたいには書けない。Taskipy は書ける。

```toml
[tool.poe.tasks]
test = { script = "flake8 && pytest" }
test.script = "flake8 && pytest" # これでもいいらしい
```

あと PoeThePoet は何も指定しなくても .venv に入るみたい。
[Change the executor type](https://poethepoet.natn.io/global_options.html#change-the-executor-type)
デフォルトが "auto"なので、3 番目の virtualenv に該当する。

ここに書いてあった。
[Usage with uv](https://poethepoet.natn.io/guides/without_poetry.html#usage-with-uv)

あと、poe の設定は `pyproject.toml` でなくて `poe_tasks.toml` に書けるらしい。 `tool.poe.` の後を書く感じ。
[Usage with with json or yaml instead of toml](https://poethepoet.natn.io/guides/without_poetry.html#usage-with-with-json-or-yaml-instead-of-toml)

## `uv sync`

`uv sync` は
`npm i` 相当。パッケージは更新される。

`npm ci` のようにロックファイルと同じバージョンを入れるなら `uv sync --lock`。

## uv で pyproject.toml で devDependencies に相当するもの

`npm i -D` に相当するのは `uv add --dev`。

`pyproject.toml` では

```toml
[dependency-groups]
dev = [
  "poethepoet>=0.30.0",
  "ruff>=0.7.4",
]
```

`uv sync` で project.dependencies 同様 .venv 以下にインストールされる。

参照: [Managing dependencies | uv](https://docs.astral.sh/uv/concepts/projects/dependencies/)

むかしは

```toml
[tool.uv]
dev-dependencies = ["ruff==0.5.0"]
```

だったが推奨されていない。

## `uv tool`

で、ruff とか PoeThePoet は

```sh
uv tool install ruff
uv tool install poethepoet
# `uv tool` は 1個づつしかできません
```

で、per user にインストールしたほうが楽は楽。

他 `uv tool` の便利コマンド

```sh
# インストールされているパス
uv tool dir -v
# インストールされているパッケージのリスト
uv tool list
# 全更新
uv tool upgrade --all
```

## requirements.txt を合成する

```sh
uv pip compile pyproject.toml -o requirements.txt
```

dev は `--extra` オプションで出来そうな気がするのだが、動かない。

## uv で PyTorch をインストールする

参照:

- [2\.5 CUDA 依存の PyTorch をインストールするための extra\-index\-url の設定](https://zenn.dev/turing_motors/articles/594fbef42a36ee#2.5-cuda%E4%BE%9D%E5%AD%98%E3%81%AEpytorch%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B%E3%81%9F%E3%82%81%E3%81%AEextra-index-url%E3%81%AE%E8%A8%AD%E5%AE%9A)
- [Previous PyTorch Versions | PyTorch](https://pytorch.org/get-started/previous-versions/)

## uv init の --build-backend オプション

パッケージにして PyPI にのせる予定なら、自分のよく使ってる build-backend を指定しておくといい。

自分は Hatch 　に慣れてるので
`uv init --build-backend hatch`
で。

参照:

- [Commands | uv](https://docs.astral.sh/uv/reference/cli/#uv-init)
- [build\-system table](https://peps.python.org/pep-0518/#build-system-table)

## uv sync

- `uv sync` - `npm i` 相当。モジュールを更新する。
- `uv sync --locked` - `npm ci` 相当。`uv.lock`に従ってモジュールをインストールする。

`uv sync --lock` という 「ロックファイルの更新を伴う`uv sync`」というオプションもあるので注意。

`uv sync` は `~= 0.9` みたいのも無視するらしい。
