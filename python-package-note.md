# Python パッケージメモ

python には ./node_modules が無くて npm も無い。

## python 用タスクランナー invoke

- `python3 -m unittest`
- `python3 -m build`

を npm みたいに

- `npm test`
- `npm run build`

のようにすることはできますか?

また Windows だと`python3`じゃなくて`python` なのを吸収できますか?

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

PYTHON = "python" if sys.platform == "win32" else "python3"

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
