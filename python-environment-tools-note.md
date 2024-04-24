# Python の Environment Tools メモ

パッケージ管理ツール、とも言うけど... 多分正しくない

pip は npm じゃない。

## 欲しい機能など

- `npm init -y` みたいなやつが欲しい。そこそこの pyproject.toml 作ってくれるやつ
- タスクランナーはあるといいけど、npm の run-scripts はダメだ。
- venv を作って入れるやつ。Windows と POSIX でコマンド違うの説明がめんどう
- `pip install -e .` は良いと思う
- できればシステムにインストールしてある Python バージョンでなんとかやってくれるやつ。Python のバイナリ落とすのは過激すぎ
- できれば VScode で補完が効くやつ

## 有名どころ

- [pipenv](https://pipenv.pypa.io/) 元祖
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

## Pipenv vs Hatch

Pipenv と Hatch は、Python のパッケージ管理ツールで、両者には次のような違いがあります。

| 機能                     | Pipenv            | Hatch               |
| ------------------------ | ----------------- | ------------------- |
| パッケージ管理           | ✔️                | ✔️                  |
| 仮想環境の作成・管理     | ✔️                | ✔️                  |
| 依存関係の固定           | ✔️ (Pipfile.lock) | ✔️ (pyproject.lock) |
| プロジェクトの初期化     | ✔️                | ✔️                  |
| プロジェクトテンプレート | ✘                 | ✔️                  |
| 自動テスト実行           | ✘                 | ✔️                  |
| ビルド・パッケージ化     | 一部サポート      | ✔️                  |
| 設定ファイル             | Pipfile           | pyproject.toml      |
| コミュニティ             | 中規模            | 小規模              |

主な違いは以下の通りです:

- Hatch は、プロジェクトテンプレート、自動テスト、ビルド・パッケージ化などの高度な機能を備えています。
- Hatch は比較的新しく、コミュニティは小さめですが、poetry に次ぐ新しい標準になる可能性があります。
- Pipenv は古くから使われており、コミュニティが大きいですが、新しい機能への対応が遅れがちです。

要約すると、Hatch は新しく高機能ですが、Pipenv は馴染みが深く安定しています。
プロジェクトの要件に応じて適切なツールを選択することが重要です。

## hatch の環境はどこに?

`~/.local/share/hatch/env/virtual/`

## hatch には `pip install` 的なものがない

1. pyproject.toml で dependencies 書き換える
2. `hatch run python foo.py` する

こんなノリ。toml から消せばパッケージも消える。

あと `pip install -e .` 的なこともやってくれるらしい(タイミング不明)なので、自分自身を名前で import できる。ありがたい。

## `hatch new` のときにテンプレート参照できない?

pytest じゃなくて unittest で十分、とかあるでしょう?

## `__about__.py` とは何ですか? どのように使いますか?

hatch 以外では `__init__.py` に書くようなメタデータを書くファイル。

- [Reasoning behind \`\_\_about\_\_.py\` for metadata · pypa/hatch · Discussion #551](https://github.com/pypa/hatch/discussions/551) - "ちょっと聞きたいのですが、\_\_version\_\_ のメタデータを保存するために別の\_\_about\_\_.py をデフォルトで使用する理由は何ですか?"
- [Versioning Python Projects With Hatch](https://waylonwalker.com/hatch-version/)

- **ファイル作成**: `__about__.py`というファイルをプロジェクトのルートディレクトリに作成します。
- **メタ情報の定義**: 以下のようにメタ情報を`__about__.py`に記述します。

  ```python
  __author__ = 'John Doe'[^1^][1]
  __author_email__ = 'john@doe.com'[^2^][2]
  __version__ = '1.2.3'[^3^][3]
  ```

- **情報のインポート**: `setup.py`やプロジェクトの他のサブモジュールからこのメタ情報をインポートできます。
- **利用例**:
  `setup.py`で以下のようにメタ情報をインポートして使用することができます。

  ```python
  import superproject.__about__[^4^][4]
  setup(
      author=superproject.__about__.__author__,[^4^][4]
      author_email=superproject.__about__.__author_email__,
      version=superproject.__about__.__version__,[^4^][4]
      # その他の設定
  )
  ```

  また、プロジェクト内の`__init__.py`で以下のようにインポートして、`superproject.__version__`としてアクセスすることも可能です。

  ```python
  from . import __about__
  __version__ = __about__.__version__
  ```

これにより、`setup.py`やプロジェクト内で一貫したメタ情報を簡単に管理し、利用することができます。プロジェクトのコードに大きな変更を加えることなく、`setup.py`の複雑さを増すことなく、メタ情報を効果的に活用することが可能です。

\_\_about\_\_.py のサンプル (hatch 以外):

- [cryptography/src/cryptography/\_\_about\_\_.py at main · pyca/cryptography](https://github.com/pyca/cryptography/blob/main/src/cryptography/__about__.py)
