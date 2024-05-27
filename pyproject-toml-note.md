# pyproject.toml のメモ

[PEP 518 – Specifying Minimum Build System Requirements for Python Projects | peps.python.org](https://peps.python.org/pep-0518/)

## project.scripts で 関数名を指定しないことはできる?

つまり `python パッケージのディレクトリ/モジュール名.py` を Entry points として書ける? という質問

project.scripts(Entry points) の仕様:

- [PEP 621 – Storing project metadata in pyproject.toml | peps.python.org](https://peps.python.org/pep-0621/)
- [Entry points](https://peps.python.org/pep-0621/#entry-points)
- [PEP 621 Metadata - PDM](https://pdm-project.org/latest/reference/pep621/)

できない。 必ず `main()` 関数的なものを書くこと。

Entry points の書き方は

- スクリプト名 = "パッケージ名:コール可能なオブジェクト名"
- スクリプト名 = "パッケージ名.モジュール名:コール可能なオブジェクト名"

だけ。
