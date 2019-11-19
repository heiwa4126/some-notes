# pythonのメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

- [pythonのメモ](#python%e3%81%ae%e3%83%a1%e3%83%a2)
- [pipをユーザーローカルに入れる](#pip%e3%82%92%e3%83%a6%e3%83%bc%e3%82%b6%e3%83%bc%e3%83%ad%e3%83%bc%e3%82%ab%e3%83%ab%e3%81%ab%e5%85%a5%e3%82%8c%e3%82%8b)
- [pip --user のパス](#pip---user-%e3%81%ae%e3%83%91%e3%82%b9)
- [古いパッケージを見つける](#%e5%8f%a4%e3%81%84%e3%83%91%e3%83%83%e3%82%b1%e3%83%bc%e3%82%b8%e3%82%92%e8%a6%8b%e3%81%a4%e3%81%91%e3%82%8b)
- [pipで更新可能なものをすべて更新するスクリプト](#pip%e3%81%a7%e6%9b%b4%e6%96%b0%e5%8f%af%e8%83%bd%e3%81%aa%e3%82%82%e3%81%ae%e3%82%92%e3%81%99%e3%81%b9%e3%81%a6%e6%9b%b4%e6%96%b0%e3%81%99%e3%82%8b%e3%82%b9%e3%82%af%e3%83%aa%e3%83%97%e3%83%88)
- [vscodeとpipenv](#vscode%e3%81%a8pipenv)
- [RHEL7にpip](#rhel7%e3%81%abpip)
- [RHEL6にpip](#rhel6%e3%81%abpip)
- [pip10問題](#pip10%e5%95%8f%e9%a1%8c)
- [magic](#magic)


# pipをユーザーローカルに入れる

python2とpython3があって、
ディストリのパッケージでは古いpipしか入らなくて、
みたいな状況のとき
(Ubuntu 18.04LTS)

``` bash
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python2 get-pip.py -U --user
python3 get-pip.py -U --user
hash -r
rm get-pip.py
```

これでpip2,pip3,pip(=pip3)が使える。

Ubuntuのデフォルトの.profileでは
`%HOME/.local/bin`が存在するときのみPATHに追加、
という仕様になってるので、(RHEL7とかでは無条件に追加)
最初の1回は

``` bash
PATH="$HOME/.local/bin:$PATH"
hash -r
```
する。

RHEL7/CentOS7では ~/.bash_profileで
``` bash
# User specific environment and startup programs
# PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=$HOME/.local/bin:$PATH:$HOME/bin
```
`.local/bin`が先になるように修正しておく。


# pip --user のパス

```
python -c "import site; print(site.USER_BASE)"
```
この出力の/binにPATHを通せばいろいろ捗る。

参考:
- [pipに--userをつけた時のインストール先を変える - Qiita](https://qiita.com/ronin_gw/items/cdf8112b61649ca455f5)
- [29.13. site — サイト固有の設定フック — Python 3.6.5 ドキュメント](https://docs.python.jp/3/library/site.html)




# 古いパッケージを見つける

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


# pipで更新可能なものをすべて更新するスクリプト

依存関係で問題があるかもしれない。
```
#!/bin/bash
pip3 list --user --outdated --format=freeze | \
  grep -v '^\-e' | \
  cut -d = -f 1  | \
  xargs -r -n1 pip3 install --user -U
hash -r
```

python2用はpip3をpip2にする。

`--user`でなく、システムワイドに実行するのはやめたほうがいい。
OSディストリのパッケージを消す時があるから。(certbotで失敗した)

同様の理由で`rootで--user`もやめたほうがいい。


おまけ: certbot & nginx を再インストールするapt
```
apt-get install --reinstall certbot python-certbot-nginx python3-certbot python3-certbot-nginx
```


# vscodeとpipenv

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


# RHEL7にpip

最近の(2019-11)RHEL7では公式レポジトリにPython3.6が入っていて、ちょっと古めのpip3も入る。
``` bash
sudo yum install python3
```
で。


以下古い情報。

RHELはチャネル(レポジトリ)が細分化されててめんどくさい。

引用元: [How to install pip on Red Hat Enterprise Linux?](https://access.redhat.com/solutions/1519803)

```
# subscription-manager repos --enable rhel-server-rhscl-7-rpms
# yum install python27-python-pip -y
# scl enable python27 bash
# pip install --upgrade pip
```
こうすると` /opt/rh/python27/root/usr/lib/python2.7/site-packages/pip`にpipが...
どう考えても頭がおかしいと思う。

`get-pip.py`のほうが全然まともだと思う。


※ SCLについては
[ソフトウェアコレクション(SCL：Software Collections)とは？ – StupidDog's blog](http://stupiddog.jp/note/archives/1074)
等を参照。そもそもコンセプトが違う。




```
$ wget https://bootstrap.pypa.io/get-pip.py
$ python get-pip.py --user
```
あとは`$(HOME)/.local/bin`にPATHを通して`hash -r`


# RHEL6にpip

RHEL6のpythonは2.6で

> DEPRECATION: Python 2.6 is no longer supported by the Python core team, please upgrade your Python. A future version of pip will drop support for Python 2.6

とか言われますが、一応動くことは動く。

pipも9.0.3までしか入らない。

```
wget https://bootstrap.pypa.io/2.6/get-pip.py
$ python get-pip.py --user
```
あとは`$(HOME)/.local/bin`にPATHを通して`hash -r`



# pip10問題

(pip version 19以降では問題なくなりました)

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


