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
