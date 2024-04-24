# Python の Environment Tools メモ

pip は npm じゃない。

## 欲しい機能など

- `npm init -y` みたいなやつが欲しい。そこそこの pyproject.toml 作ってくれるやつ
- タスクランナーはあるといいけど、npm の run-scripts はダメだ。
- venv を作って入れるやつ。Windows と POSIX でコマンド違うの説明がめんどう
- `pip install -e .` は良いと思う
- できればシステムにインストールしてある Python バージョンでなんとかやってくれるやつ。Python のバイナリ落とすのは過激すぎ
- できれば VScode で補完が効くやつ

## 有名どころ

- [pipenv](https://pipenv.pypa.io/)
- [Poetry](https://python-poetry.org/)
- [PDM](https://pdm-project.org/latest/)
- [Rye](https://rye-up.com/)
- [Hatch](https://hatch.pypa.io/latest/)
  - [Hatch is a modern, extensible Python project manager](https://zenn.dev/mnagaa/articles/3a02ebc0431f36)

## 参考リンク

- [Python Package Manager Comparison 📦 - DEV Community](https://dev.to/adamghill/python-package-manager-comparison-1g98)
- [Environment Tools: PDM, Poetry and Rye](https://www.playfulpython.com/environment-tools-pdm-poetry-rye/) -[プロジェクト概要 - Python Packaging User Guide](https://packaging.python.org/ja/latest/key_projects/)

Hatch 関係は移動する

## PyPA とは?

PyPA は、Python パッケージ作者(Python Package Authors)のことを指します。具体的には以下のような役割を果たします。

- Python パッケージの作成、メンテナンス
- Python パッケージリポジトリ(PyPI)へのパッケージのアップロード
- パッケージのドキュメントの作成
- バグ修正やアップデートのリリース
- ユーザーからの質問への対応

PyPA は Python の発展に大きく貢献しており、Python コミュニティにとって重要な存在です。彼らによってさまざまな優れたサードパーティ製パッケージが公開され、Python の機能が大幅に強化されています。

[PyPA には公式サイト](https://www.pypa.io/)があり、パッケージ作成の手引きや最新情報が掲載されています。また、メーリングリストやフォーラムなどを通じて、パッケージ作者同士の情報交換やサポートも行われています。

pip や pipx, pipenv 作ってるところ。
[Python Packaging User Guide](https://packaging.python.org/ja/latest/) は読んだことがあるでしょう。

## hatch の環境はどこに?

`~/.local/share/hatch/env/virtual/`
