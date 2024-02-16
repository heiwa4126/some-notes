# pydoc(docstring)メモ

定義は
[PEP 257 – Docstring Conventions | peps.python.org](https://peps.python.org/pep-0257/)
なんだけど、これ「パラメーターはこう書け」みたいのがなにも記述されてない。

Javadoc なんかとは思想がちがうらしい。

そんな理由で Docstring の書式にはいくつかの「スタイル」が自然発生していて、
以下にメジャーなものをメモする。

## Numpy スタイル

[Style guide — numpydoc Manual](https://numpydoc.readthedocs.io/en/latest/format.html#docstring-standard)

```python
def my_function(param1, param2):
    """
    この関数は何かを行います。

    Parameters
    ----------
    param1 : param1の型
        パラメータ1についての説明。
    param2 : param2の型
        パラメータ2についての説明。

    Returns
    -------
    戻り値の型
        戻り値についての説明。

    Examples
    --------
    使用例を示します。

    >>> my_function(1, 2)
    result
    """
    # 関数の実装
    pass
```

## Google スタイル

- [styleguide | Style guides for Google-originated open-source projects](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
- [Example Google Style Python Docstrings — napoleon documentation](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/example_google.html)

```python
def my_function(param1, param2):
    """
    この関数は何かを行います。

    Args:
        param1 (param1の型): パラメータ1についての説明。
        param2 (param2の型): パラメータ2についての説明。

    Returns:
        戻り値の型: 戻り値についての説明。
    """
    # 関数の実装
    pass
```

型については
[型ヒント](https://docs.python.org/ja/3/library/typing.html)
に任せて docstring には記述しないほうがいいかも。

## reStructuredText スタイル

reStructuredText で docstring を書くスタイル

```python
def my_function(param1, param2):
    """
    この関数は何かを行います。

    :param param1: パラメータ1についての説明。
    :type param1: param1の型
    :param param2: パラメータ2についての説明。
    :type param2: param2の型
    :return: 戻り値についての説明。
    :rtype: 戻り値の型
    """
    # 関数の実装
    pass
```

## 結局どのスタイルをつかうのがいいの?

オープンソースで一番メジャーなのは Google スタイル。

ただし正直どれ使ってもいいらしい(例えば Javadoc スタイルで書いてもいいわけ)。VSCode では markdown とみなしてポップアップが表示されるし、

月並みですが:

- チームで開発している場合は、チーム内で統一されたスタイルを決めておくのが良いでしょう。
- 個人で開発している場合は、自分の好みや用途に合わせてスタイルを選ぶと良いでしょう。
- ドキュメント生成ツールを使用する場合は、そのツールが対応しているスタイルを選ぶ必要があります。

みたいなことしか言えないようです。

## GitHub Copilot のプロンプトでスタイルを制御できる?

いろいろやってみたけど無理っぽい。

## 参考

- [[Python] docstring のスタイルと書き方 #Python - Qiita](https://qiita.com/flcn-x/items/393c6f1f1e1e5abec906)
- [docstring の style3 種の例 #Python - Qiita](https://qiita.com/yokoc1322/items/ebf25c9cb779ff5ebc9c)
- [autoDocstring/docs at master · NilsJPWerner/autoDocstring · GitHub](https://github.com/NilsJPWerner/autoDocstring/tree/master/docs)
