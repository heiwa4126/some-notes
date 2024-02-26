# Python のパッケージングについてのメモ

[Python Packaging User Guide](https://packaging.python.org/en/latest/)
([日本語版](https://packaging.python.org/ja/latest/))を読め。

終

以下蛇足。

[Python におけるパッケージングに関する概要 - Python Packaging User Guide](https://packaging.python.org/ja/latest/overview/) - 難しい。「概要」はおおむねよくわからないものなので、飛ばしてもいいのでは。

いきなり [Python のプロジェクトをパッケージングする - Python Packaging User Guide](https://packaging.python.org/ja/latest/tutorials/packaging-projects/) を読んだ方がいいかも

## setup.py が出てきたら避ける

「Python の自作ライブラリを pip に公開する方法」などで検索してでてきたページが `setup.py` を使っていたらそれは古い資料なので避けること。

`setup.py` は使えないわけじゃないし、廃止になったわけでもない。
[setup.py は非推奨になりましたか? - Python Packaging User Guide](https://packaging.python.org/ja/latest/discussions/setup-py-deprecated/) 参照。

## わざわざパッケージングする目的

- 再利用を容易にする
- 配布と更新を容易にする

pip の素は PyPI 以外にできる。

## wheels と sdist

Python パッケージの配布用のバイナリ形式フォーマット。

- wheels(.whl) - ビルド済配布物
- sdist - ソースコード配布物(Red Hat の.srpm みたいなものか)

圧縮形式は zip (wheels の方)と tar.gz (sdist の方) なので
`python -m build` で ./dist にできるファイルに

```sh
zipinfo dist/*.whl
tar ztvf dist/*.tar.gz
```

で見られるし、

```sh
# wheelsの場合
pip3 install dist/*.whl
# またはsdistの場合(ビルドも伴う)
pip3 install dist/*.tar.gz
```

でインストールできる。

[ビルド成果物](https://packaging.python.org/ja/latest/flow/#build-artifacts) 参照

## API トークンのところのコピペ

https://test.pypi.org/manage/account/#api-tokens
の最後のところのコピペ

**このトークンを使用する**

この API トークンを使うには:

- username に`__token__`を設定する
- Set your password to the token value, including the `pypi-` prefix

例えば、[Twine](https://pypi.org/project/twine/)を使ってプロジェクトを PyPI にアップロードする場合、次のように`$HOME/.pypirc`を設定してください:

```toml
[testpypi]
username = __token__
password = pypi-zzzzzzz....
```

このトークンの使い方に関するより知りたければ、[PyPI のヘルプページ](https://test.pypi.org/help#apitoken)を参照してください。
