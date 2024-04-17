# Python パッケージメモ

python には ./node_modules が無くて npm も無い。

## ドキュメント

- [Python Packaging User Guide](https://packaging.python.org/en/latest/)
- [Python パッケージユーザーガイド](https://packaging.python.org/ja/latest/)

あと pyproject.toml と setuptools

- [pyproject.toml - pip documentation v24.0](https://pip.pypa.io/en/stable/reference/build-system/pyproject-toml/)
- [Package Discovery and Namespace Packages - setuptools 69.2.0.post20240313 documentation](https://setuptools.pypa.io/en/latest/userguide/package_discovery.html#)

## Python 用タスクランナー invoke

- `python3 -m unittest`
- `python3 -m build`

を npm みたいに

- `npm test`
- `npm run build`

のようにすることはできますか?

また Windows だと`python3`じゃなくて`py` なのを吸収できますか?

---

[invoke · PyPI](https://pypi.org/project/invoke/) がある。

```sh
pip install --user -U invoke
# Ubuntuだとパッケージもある
sudo apt install python3-invoke -y
```

で、 ./tasks.py に

```python
import sys
from invoke import task

PYTHON = "py" if sys.platform == "win32" else "python3"

@task
def test(c):
    """Run unit tests"""
    c.run(f"{PYTHON} -m unittest")

@task
def build(c):
    """Build project"""
    c.run(f"{PYTHON} -m build")
```

と書いて

```sh
invoke test
# invoke のかわりに inv でもOK
inv build
```

のようにする。

## pyproject.toml の linter はありますか?

npm だったら
[tclindner/npm-package-json-lint: Configurable linter for package.json files](https://github.com/tclindner/npm-package-json-lint)
みたいなやつ、はないみたい。

[abravalheri/validate-pyproject: Validation library for simple check on \`pyproject.toml\`](https://github.com/abravalheri/validate-pyproject/)
が近いかも。あんまりメンテされてるようではない。

## npm の scope(namespace) 的なものは?

名前空間パッケージ ("namespace package") というものがある。

[名前空間パッケージをパッケージする - Python Packaging User Guide](https://packaging.python.org/ja/latest/guides/packaging-namespace-packages/)

## pyproject.toml の例

[a-full-example - Writing your pyproject.toml - Python Packaging User Guide](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#a-full-example)

## pyproject.toml の project.classifiers に書けるものの一覧

[pypi.org/pypi?%3Aaction=list_classifiers](https://pypi.org/pypi?%3Aaction=list_classifiers)

## pyproject.toml でどう書けば "Home-page" が METADATA に付く?

`pip show` で表示される `Home-page:` の項目は pyproject.toml のどこに書けばいい?

project.urls.Homepage に書けばいいと思うでしょ? (または Home-page)

- [Show 'home-page' project URL when Home-Page metadata value is not set · Issue #11221 · pypa/pip](https://github.com/pypa/pip/issues/11221)
- [show: populate missing home-page from project-urls if possible by ichard26 · Pull Request #12569 · pypa/pip](https://github.com/pypa/pip/pull/12569)
- [Set homepage in pyproject.toml · Issue #606 · pypa/packaging-problems](https://github.com/pypa/packaging-problems/issues/606)

なんかバグっぽい。

同様に `Author:` も変。 project.authors[] に name= だけのを作る。
