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
  - VSCode の再起動 → ダメ
  - コマンドパレットで "Python: Clear Cache and Reload Window" → ダメ
- なんか `uv python list` で 3.12 -\> 3.12.8 のエリアスがあったみたいだけど消えた。
- `uv tool install` でインストールしてた poe が "誤ったインタプリタです" とか言い出した
  - しょうがないんで `uv tool install poethepoet --reinstall` したら治った
  - どうも `uv tool` のやつが全部ダメ

`uv python upgrade` が使えるようになったらまた試してみたい。

## `uv tool install` でインストールしたパッケージが使う Python のバージョンを知るには

```sh
uvx python -c "import sys; print(sys.version)"
```

uvx は
.python-version や pyproject.toml の tool.uv セクションも見て動くらしい。

## GitHub Dependabot

2025 年 3 月から uv がサポートされてた。(それまでは pip 使ってた)

- [Dependabot version updates now support uv in general availability - GitHub Changelog](https://github.blog/changelog/2025-03-13-dependabot-version-updates-now-support-uv-in-general-availability/)
- [Dependabot の uv サポートを試す - kakakakakku blog](https://kakakakakku.hatenablog.com/entry/2025/03/23/124812)

## vscode と使うときの障害 1

uv で作成した python のプロジェクトを vscode で開いたとき、
最初のターミナルが自動で.venv 環境にならない(もう 1 個ターミナルを開くと venv になる)。

最初のターミナルを venv にするには、どう設定すればいい?

まず「Python インタプリタを.venv の下のを選んでおく」は当然として

`.vscode/settings.json` に**どちらか**の設定を追加する:

```json
{
  // 1) ウィンドウを開いた直後に“初期ターミナル”が自動起動しないようにする
  "terminal.integrated.hideOnStartup": "always",

  // 2) すでに開いているターミナル(=最初のターミナル)にも環境を注入してアクティブ化する
  "python.terminal.activateEnvInCurrentTerminal": true
}
```

自分は 2 にしました。
ちょっと待つと最初のターミナルにも `source .venv/bin/activate` がニョロっと実行される。2 個目は早い

...これグローバル設定でもいいんじゃね?

## vscode で.venv 以下をデフォルトでデフォルトインタプリタにする

検索するといろいろ出てくるけど、どれも廃止されてる。
手動選択がいちばんいいみたい

## uv がビルドバックエンドとして使えるようになった

[Build backend | uv](https://docs.astral.sh/uv/concepts/build-backend/)

### バックエンド回りでありがちな設定メモ

src/ の下に \_test.py でテスト書くとき、パッケージに含めない設定。
tests/の方はオマケ(未検証)

```yaml
[tool.uv.build-backend]
source-exclude = [
  "**/*_test.py",
  "tests/**",
]
wheel-exclude = [
  "**/*_test.py",
  "tests/**",
]
```

[build-backend](https://docs.astral.sh/uv/reference/settings/#build-backend)

実際に `uv build` すると wheel の方にはライセンスや README とかも入らない。.gitignore なんかも。

## `uv run --isolated --no-project --with`

パッケージをビルドしたあとの検証に超便利。

## ミグレーション

これがいい感じ

- [migrate-to-uv](https://mkniewallner.github.io/migrate-to-uv/)
- [mkniewallner/migrate-to-uv: Migrate a project from Poetry/Pipenv/pip-tools/pip to uv package manager](https://github.com/mkniewallner/migrate-to-uv)

例:

```bash
uvx migrate-to-uv \
  --requirements-file requirements.txt \
  --dev-requirements-file requirements-dev.txt
```

参考: [パッケージマネージャー uv への移行ガイド](https://zenn.dev/diia/scraps/03b4d18a92f298)

## uv tool でインストールされたパッケージはどの Python で実行される?

どうも微妙にわからん。なんかパッケージ書いて試してみる

なんだか

```sh
uv tool install --python 3.10 awslabs.aws-diagram-mcp-server`
```

みたいに指定できるらしい。

`--python`オプションを指定しないときは、デフォルトの Python で、
デフォルトの Python は

```sh
cd
uv run python --verson
```

でわかる。

では`uv init`で作った`.python-version`がある場所で`uv tool install`するとどうなる?

実は隠し設定っぽいものがあるらしい。

- [Configuration files](https://docs.astral.sh/uv/concepts/configuration-files/)
- [Python versions | uv](https://docs.astral.sh/uv/concepts/python-versions/)
- [how to change default python version in uv? · Issue #8135 · astral-sh/uv](https://github.com/astral-sh/uv/issues/8135)
- [On Windows systems, how to manually configure user-level configuration files(uv.toml) · Issue #14553 · astral-sh/uv](https://github.com/astral-sh/uv/issues/14553)

以上より
XDG だと ~/.config/uv/config.toml

```toml
[python]
default = "3.12"
```

.python-version がない場合はグローバル設定としてこれが使われるみたい。

どちらもなければ最新安定版(現在は 3.12)を自動的に選択・インストールするらしい

## uvx で実行するパッケージはどの Python で実行される?

これも微妙にわからん。

ただ uvx のオプションで指定はできるので、
Python 3.10 が推奨の awslab の MCP とかでは
(典拠:[mcp/DEVELOPER_GUIDE.md at main · awslabs/mcp · GitHub](https://github.com/awslabs/mcp/blob/main/DEVELOPER_GUIDE.md))

```sh
uv python install 3.10
uvx --python 3.10 awslabs.aws-diagram-mcp-server@latest
# stdio MCP なので Ctrl+Cで停止
```

みたいにすればいいし、mcp.json でも args で書ける(はず)

## uv add で pypi 以外から

例:

```sh
pip install -i https://test.pypi.org/simple/ whoruv
# 上と等価
uv add --index-url https://test.pypi.org/simple/ whoruv
```

whoruv の情報:

- [heiwa4126/whoruv: Display Python version, executable path, and script path when run with uv](https://github.com/heiwa4126/whoruv)
- [whoruv · PyPI](https://pypi.org/project/whoruv/)
- [whoruv · TestPyPI](https://test.pypi.org/project/whoruv/)

実際にやると

```console
$ uv add --index-url https://test.pypi.org/simple/ whoruv

warning: Indexes specified via `--index-url` will not be persisted to the `pyproject.toml` file; use `--default-index` instead.

Resolved 2 packages in 1.00s
Prepared 1 package in 178ms
Installed 1 package in 4ms
 + whoruv==0.0.3a2
```

みたいな警告が出る。

```toml
[tool.uv.index]
url = "https://test.pypi.org/simple"
```

だと全部 testPypI になってしまう。

- uv にはまだ個別パッケージごとにインデックスを指定する構文はない
- uv.lock にも記録されない
- dependency-groups でも解決できない
- ただし直 URL は指定できるので TestPyPI へ行って URL を取得すれば `uv sync`で行ける

```sh
uv add https://test-files.pythonhosted.org/packages/4e/0e/1caef2b6329e5bca770150f5cc62b60cd6de5e476b68c80031c6265018ce/whoruv-0.0.3a2-py3-none-any.whl
```

というノリで行ける。pyproject.toml に

```toml
[tool.uv.sources]
whoruv = { url = "https://test-files.pythonhosted.org/packages/4e/0e/1caef2b6329e5bca770150f5cc62b60cd6de5e476b68c80031c6265018ce/whoruv-0.0.3a2-py3-none-any.whl" }
```

が追加される。

GitHub 上のやつとかもたぶん同じノリで (注: GitHub Packages には Python は無いので release とかで)

## uv と zScaler

`uv add` は問題ないんだけど `uv python install` 周りだけ SSL エラーになる。

こんな感じ

```console
$ uv python install 3.13

error: Failed to install cpython-3.13.9-linux-x86_64-gnu
  Caused by: Request failed after 3 retries
  Caused by: Failed to download https://github.com/astral-sh/python-build-standalone/releases/download/20251028/cpython-3.13.9%2B20251028-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz
  Caused by: error sending request for url (https://github.com/astral-sh/python-build-standalone/releases/download/20251028/cpython-3.13.9%2B20251028-x86_64-unknown-linux-gnu-install_only_stripped.tar.gz)
  Caused by: client error (Connect)
  Caused by: invalid peer certificate: UnknownIssuer
```

環境変数 SSL_CERT_FILE で回避できる。

```console
$ SSL_CERT_FILE=/etc/ssl/certs/ZscalerRootCertificate.pem uv python install 3.13

cpython-3.13.9-linux-x86_64-gnu (download) ------------------------------ 6.81 MiB/32.64 MiB
Installed Python 3.13.9 in 30.68s
 + cpython-3.13.9-linux-x86_64-gnu (python3.13)
```

SSL_CERT_FILE は OpenSSL やそれを利用する多くのアプリケーション(Python、Rust、curl など)で使われる標準的な環境変数なので

```sh
cat /etc/ssl/certs/ca-certificates.crt zscaler.pem > ~/custom-ca-bundle.pem
export SSL_CERT_FILE=~/custom-ca-bundle.pem
```

のようなノリで使うのがいいらしい。もしくは `update-ca-certificates` で zScaler.pem を追加するとか。

[TLS certificates | uv](https://docs.astral.sh/uv/concepts/authentication/certificates/)
によると
**uv はデフォルトで Mozilla の webpki-roots(Rust の webpki-roots crate) を使っていて、OS の CA ストアを参照していない。**

zscaler の CERT が OS ストアに入ってるなら
`export UV_NATIVE_TLS=true` か `--native-tls` がよさそう。

Windows の pwsh だと

```powershell
[Environment]::SetEnvironmentVariable("UV_NATIVE_TLS", "true", "User")
```

## uvx で TestPyPI 上のパッケージを動かすのはめんどくさい

例:

```sh
uvx --index-url https://test.pypi.org/simple --extra-index-url https://pypi.org/simple --index-strategy unsafe-best-match bumpuv@0.0.5a2 --version
```

[bumpuv 0.0.5a2 · TestPyPI](https://test.pypi.org/project/bumpuv/0.0.5a2/)

バージョンを表示するだけなんだけど

- そもそも uv が prerelease を禁止してるので `--index-strategy unsafe-best-match` をつけないと死ぬ
- 同じ理由で `bumpuv@latest` が使えないので、バージョンを明示(`@0.0.5a2`)する
- `--extra-index-url` をつけないと全部 TestPyPI を見に行くので、TestPyPI 上に依存パッケージが無いと死ぬ(上記の場合は gitpython)

`pipx` なら楽かな、と思ったけどそうでもない。

## ビルドバックエンド

「ビルドバックエンド不要」なのは、本当に個人的な使い捨てスクリプトくらい。

## "editable install"

`npm link` みたいなやつ。ただし uv では venv レベルでクローズなとこが違う。
PEP660 で規定。

uv でビルドバックエンドを指定すれば、`uv pip install -e .` みたいなことをやる必要はほとんどない。

`uv pip install -e .` が必要なのは
ビルドバックエンドがない場合だけ。

あと `uv pip install` は pyproject.toml を変更しないので、
あとから依存を再構築ができない。

```sh
uv init test1 --python 3.12 --build-backend uv
cd test1
uv sync
```

で

```console
$ uv pip list

Package Version Editable project location
------- ------- ------------------------------------------
test1   0.1.0   /home/user1/works/python/uv/editable/test1

$ tomlq .project.dependencies pyproject.toml

[]
```

親ディレクトリにもどって

```sh
uv init test2 --python 3.12 --build-backend uv
cd test2
uv sync
```

```console
$ uv pip list

(空)

$ uv pip install -e .

$ uv pip ls
Package Version Editable project location
------- ------- ------------------------------------------
test2   0.1.0   /home/user1/works/python/uv/editable/test2

$ tomlq .project.dependencies pyproject.toml

[]
```

続けて

```console
$ uv add ../test1  # test1の現在のパッケージが.venv以下にコピーされる
$ uv pip ls
Package Version Editable project location
------- ------- ------------------------------------------
test1   0.1.0
test2   0.1.0   /home/user1/works/python/uv/editable/test2

$ tomlq .project.dependencies pyproject.toml

["test1"]

$ ls -lad .venv/lib/python3.12/site-packages/test1/*
```

## uv workspace

モノレポで uv 管理のパッケージ test1 と test2 があるとして、test2 から test1 を使いたい。
開発中は test2 に test1 を editable install したい、デプロイ時には test2 では test1 依存にしたい。
というとき、どうすればいい?

## `uv audit` はない (いまのところ)

uv.lock を読む [uv-secure · PyPI](https://pypi.org/project/uv-secure/) を使う。`uvx uv-secure`
もしくは osv-scanner か trivy。

`uv tool install` したパッケージにはその手は使えないので

```sh
grype $(uv tool dir)
```

などで対処
