# uv (Astral UV) のメモ

## Astral 社について

Astral は今や uv, ruff, rye を管理している。

> Rye の開発者である Armin Ronacher は、Rye プロジェクトの管理と開発の責任を Astral に引き継ぎました。

とのこと。

- [The Catch in Rye: Seeding Change and Lessons Learned](https://ep2024.europython.eu/session/the-catch-in-rye-seeding-change-and-lessons-learned/)
- [The Catch in Rye: Seeding Change and Lessons Learned — Armin Ronacher - YouTube](https://www.youtube.com/watch?v=skTKaHVIL1c)

### ビデオの要約(by Gemini):

このビデオでは、Python のパッケージ管理ツール「Rye」の開発者である Armin Ronacher 氏が、Rye の開発経緯や、Python のパッケージ管理における課題と展望について語っています。

**Rye の開発背景**

- Ronacher 氏は、Rust の開発者体験に感銘を受け、Python のパッケージ管理にも同様の体験を提供したいと考えました。
- Rust の優れたパッケージ管理システム「Cargo」を参考に、Python のパッケージ管理を簡素化し、開発者の負担を軽減することを目指しました。

**Rye の主な特徴**

- **自動的な Python インストール:** Rye は、必要な Python バージョンを自動的にダウンロードしてインストールします。これにより、ユーザーは手動で Python をインストールする必要がなくなり、環境構築が容易になります。
- **仮想環境の自動管理:** Rye は、プロジェクトごとに仮想環境を自動的に作成し、管理します。これにより、プロジェクト間の依存関係を分離し、開発環境を安定させることができます。
- **パッケージの自動インストール:** Rye は、プロジェクトの依存関係を自動的に解析し、必要なパッケージをインストールします。これにより、ユーザーは手動でパッケージをインストールする手間が省けます。

**Rye の課題と展望**

- **依存関係の解決:** 依存関係の解決は、Python のパッケージ管理における大きな課題です。Rye は、依存関係の解決に UV というツールを使用していますが、依然として課題が残っています。
- **開発者体験の統一:** さまざまなツールが独自の方式で依存関係を管理しているため、開発者体験が統一されていません。Ronacher 氏は、コミュニティとして協力して、統一された開発者体験を実現することを提唱しています。
- **標準化の必要性:** 依存関係の宣言方法や、開発環境の構築方法など、さまざまな側面で標準化が必要です。Ronacher 氏は、コミュニティとして議論を重ね、共通の標準を策定することを提唱しています。

**まとめ**

Ronacher 氏は、Rye を通じて、Python のパッケージ管理をよりシンプルかつ効率的にすることを目指しています。また、コミュニティとの協力を通じて、Python のパッケージ管理の課題を解決し、より良い開発者体験を提供することを目指しています。

## uv にはタスクマネージャが無い

[Using \`uv run\` as a task runner · Issue #5903 · astral-sh/uv](https://github.com/astral-sh/uv/issues/5903)
を見てると、もうすぐ `uv task` でいけるようになるみたい。

それまでは
PoeThePoet か taskipy を使う。

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

`uv sync` は `npm ci` 相当。パッケージは `uv.lock` に従う。

`npm up`に相当するのは `uv lock --upgrade` して `uv sync`

`--upgrade` は `-U` でもいい。

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

自分は Hatch に慣れてるので
`uv init --build-backend hatch`
で。

参照:

- [Commands | uv](https://docs.astral.sh/uv/reference/cli/#uv-init)
- [build\-system table](https://peps.python.org/pep-0518/#build-system-table)

## uv sync

- `uv sync` - `npm i` 相当。モジュールを更新する。
- `uv sync --locked` - `npm ci` 相当。`uv.lock`に従ってモジュールをインストールする。

`uv sync` は `~= 0.9` みたいのも無視するらしい(不明)

### Docker とかに便利

`uv sync --locked --compile-bytecode --link-mode copy`

環境変数でもいける。

参考: [uv-docker-example/standalone.Dockerfile at main · astral-sh/uv-docker-example](https://github.com/astral-sh/uv-docker-example/blob/main/standalone.Dockerfile)

## uv でモジュールのアップデート

`uv lock -U && uv sync`

参考: [uv cache](https://docs.astral.sh/uv/reference/cli/#uv-publish)

特定のパッケージのみ更新する
`uv lock --upgrade-package xxx`
もあります。

## uv で使える Python を列挙

```sh
# 全部列挙
uv python list --all-versions
# インストールされてるもののみ
uv python list --only-installed
# 普通はこれで
uv python list
```

## uv でキャッシュを削除

- [Caching | uv](https://docs.astral.sh/uv/concepts/cache/#clearing-the-cache)
- [uv cache](https://docs.astral.sh/uv/reference/cli/#uv-cache)

とりあえず

```sh
# 使用されていないキャッシュエントリのみを削除
uv cache prune
```

でいいのでは。Python のキャッシュけっこうでかいので、マメに消すといいとおもう。

一年に 1 度ぐらい以下を実行

```sh
# キャッシュ内のすべてのパッケージを削除
uv cache clean
```

## uv のシェル補完

uv はあんまり補完つかわないかも。

[Shell autocompletion](https://docs.astral.sh/uv/getting-started/installation/#shell-autocompletion)

bash ならとりあえずこんなノリで

```bash
uv generate-shell-completion bash > uv.bash-completion
sudo mv uv.bash-completion /etc/bash_completion.d/
```

`uv.bash-completion` けっこう長いので別ファイルがいいと思います。

## uv には `npm version patch` みたいなやつがない

しょうがないので PyPI でパッケージを探す。

これなんかよさそう:
[bump-my-version · PyPI](https://pypi.org/project/bump-my-version/)

使い方がわからん...

## uv の venv で使ってる Python のパッチバージョンを上げる

3.12.8 を 3.12.11 にしたときのメモ。

```sh
uv python list | grep -Fi 3.12
uv python install 3.12.11
uv venv
uv python uninstall 3.12.8
```

懸念事項

- VSCode の右下のバージョン表示がかわらない
- なんか `uv python list` で 3.12 -\> 3.12.8 のエリアスがあったみたいだけど消えた。
