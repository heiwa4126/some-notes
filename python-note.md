# pythonのメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

## pip --user のパス

```
python -c "import site; print(site.USER_BASE)"
```
この出力の/binにPATHを通せばいろいろ捗る。

参考:
- [pipに--userをつけた時のインストール先を変える - Qiita](https://qiita.com/ronin_gw/items/cdf8112b61649ca455f5)
- [29.13. site — サイト固有の設定フック — Python 3.6.5 ドキュメント](https://docs.python.jp/3/library/site.html)


## 古いパッケージを見つける

グローバルは
```
pip list --o
```
`--user`つければユーザインストール


```
pip install -U packageName
```
でアップグレード

一括アップグレードはいまのところ無いので
[pipで一括アップデート - Qiita](https://qiita.com/manji-0/items/d3d824d77c18c2f28569)
などを参考に。

参考:
- [pip で更新可能なパッケージを一覧表示 - Qiita](https://qiita.com/Klein/items/a3110d20532ba9f9057b)


## vscodeとpipenv

pipenvまたはvirtualenvで作業すると、グローバルやユーザにインストールした
pylintやautopep8をvscodeが見つけてくれない。

virtualenv下にpylintやautopep8をインストールすればいいのだが、
結構サイズがデカいので、
`.vscode/settings.json`で
該当バージョンのpythonに対応したパスを指定してやる。
以下は例:
```
{
    ...
    "python.linting.pylintPath": "C:\\ProgramData\\Anaconda3\\Scripts\\pylint.exe",
    "python.formatting.autopep8Path": "C:\\ProgramData\\Anaconda3\\Scripts\\autopep8.exe",
    ...
}
```

また`"python.pythonPath"`もvirtualenv下のpythonを指定する。

さらに`.vscode/settings.json`をgitに含めないようにしておく。

もっと楽な方法がありそうだがなあ。


# pip10問題

* [pip install --upgrade pip (10.0.0) 後の奇妙な挙動について - 雑記](http://icchy.hatenablog.jp/entry/2018/04/17/064443)

Ubuntu16.04LTSのpython3.5でpip10に更新すると
```
$ pip
Traceback (most recent call last):
  File "/usr/bin/pip", line 9, in <module>
    from pip import main
ImportError: cannot import name main
```
こんな感じになる問題。

自分は↑のリンクを受けて
~/.profileに
```
alias pip='python3 -m pip'
alias pip3='python3 -m pip'
```
を書いていちおう解決、ということにしましたけど。

ただAWSやAzureで立てたUbuntuでは何もしないでもエラーにならなくて
よくわからない。

# magic

`magic`という名前のモジュールが何種類もあるらしい。

* [julian-r/python-magic: A python wrapper for libmagic](https://github.com/julian-r/python-magic) MIME判別用のmagic. 下のmagicのフォークだが、バイナリ付きでWindowsやMacでも動く
* [ahupp/python-magic: A python wrapper for libmagic](https://github.com/ahupp/python-magic) MIME判別用のmagic(WindowsやMacでは動かない)

他にImageMagickのPythonラッパーもあって
[Develop @ ImageMagick](http://www.imagemagick.org/script/develop.php#python)
ますますわけがわからない。


