# pythonのメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

- [pythonのメモ](#python%e3%81%ae%e3%83%a1%e3%83%a2)
- [pythonをインストールする(2019-12)](#python%e3%82%92%e3%82%a4%e3%83%b3%e3%82%b9%e3%83%88%e3%83%bc%e3%83%ab%e3%81%99%e3%82%8b2019-12)
  - [Amazon Linux 2](#amazon-linux-2)
  - [Ubuntu 18.04 TLS](#ubuntu-1804-tls)
  - [RHEL7, CentOS7](#rhel7-centos7)
  - [RHEL8, CentOS8](#rhel8-centos8)
- [pipをユーザーローカルに入れる](#pip%e3%82%92%e3%83%a6%e3%83%bc%e3%82%b6%e3%83%bc%e3%83%ad%e3%83%bc%e3%82%ab%e3%83%ab%e3%81%ab%e5%85%a5%e3%82%8c%e3%82%8b)
- [pip --user のパス](#pip---user-%e3%81%ae%e3%83%91%e3%82%b9)
- [古いパッケージを見つける](#%e5%8f%a4%e3%81%84%e3%83%91%e3%83%83%e3%82%b1%e3%83%bc%e3%82%b8%e3%82%92%e8%a6%8b%e3%81%a4%e3%81%91%e3%82%8b)
- [pipで更新可能なものをすべて更新するスクリプト](#pip%e3%81%a7%e6%9b%b4%e6%96%b0%e5%8f%af%e8%83%bd%e3%81%aa%e3%82%82%e3%81%ae%e3%82%92%e3%81%99%e3%81%b9%e3%81%a6%e6%9b%b4%e6%96%b0%e3%81%99%e3%82%8b%e3%82%b9%e3%82%af%e3%83%aa%e3%83%97%e3%83%88)
- [vscodeとpipenv](#vscode%e3%81%a8pipenv)
- [RHEL7にpip](#rhel7%e3%81%abpip)
- [RHEL6にpip](#rhel6%e3%81%abpip)
- [pip10問題](#pip10%e5%95%8f%e9%a1%8c)
- [magic](#magic)
- [Ubuntu 18.04 LTSでpython3.7](#ubuntu-1804-lts%e3%81%a7python37)
- [venv](#venv)
- [pythonのEOL](#python%e3%81%aeeol)



# pythonをインストールする(2019-12)

システムワイドにpython3と、
新し目のpip3をuser install directoryに
インストールする手順。

## Amazon Linux 2

RHEL7同様python3が公式に配布されるようになった。いまのところpython3.7。

``` sh
sudo yum install python3
```

pip3
``` sh
pip3 intsall -U --user pip
```
デフォルトでは
`$HOME/.local/bin`のパスの優先順が低いので、
.bash_profileを修正する。

オリジナル
```
PATH=$PATH:$HOME/.local/bin:$HOME/bin
```

修正後
```
PATH=$HOME/.local/bin:$HOME/bin:$PATH
```

テスト 
```
$ python3 --version
Python 3.7.4
$ pip3 --version
pip 19.3.1 from /home/xxxxx/.local/lib/python3.7/site-packages/pip (python 3.7)
```

## Ubuntu 18.04 TLS

最初からpython3 (3.6)が入っているはず。もしなければ

``` sh
sudo apt install python3
```

pip3
``` sh
pip3 intsall -U --user pip
```

デフォルトでは
`$HOME/.local/bin`のパスがないので、
~/.profileを修正する。

追加例
```
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi
```

テスト
```
$ python3 --version
Python 3.6.9
$ pip3 --version
pip 19.3.1 from /home/xxxxx/.local/lib/python3.6/site-packages/pip (python 3.6)
```

Ubuntuでは公式にPython 3.7と3.8も配布されているが、システム標準のPython3にはできない。
venvなどで使うか、バージョンを明示して使う。

Ubuntu 20.04 LTSからはPython3が標準のpythonになる予定

## RHEL7, CentOS7

python3が公式に配布されるようになった。いまのところpython3.6。

``` sh
sudo yum install python3
```

pip3
``` sh
pip3 intsall -U --user pip
```
デフォルトでは
`$HOME/.local/bin`のパスの優先順が低いので、
.bash_profileを修正する。

オリジナル
```
PATH=$PATH:$HOME/.local/bin:$HOME/bin
```

修正後
```
PATH=$HOME/.local/bin:$HOME/bin:$PATH
```

テスト 
```
$ python3 --version
Python 3.6.8
$ pip3 --version
pip 19.3.1 from /home/xxxxx/.local/lib/python3.6/site-packages/pip (python 3.6)
```

## RHEL8, CentOS8

pythonはデフォルトでは入らない。
pythonで書かれたシステムパッケージは、ユーザが`python`と叩いて使うpythonとは別パッケージになっていてる。

システムが使うPythonは
```
# /usr/libexec/platform-python --version
Python 3.6.8
# rpm -qf /usr/libexec/platform-python
platform-python-3.6.8-15.1.el8.x86_64
```
である。

ユーザが使うPython3とpip3のインストールは
``` sh
sudo yum install python36
pip3 intsall -U --user pip
hash -r
```

テスト 
```
$ python3 --version
Python 3.6.8
$ pip3 --version
pip 19.3.1 from /home/xxxxx/.local/lib/python3.6/site-packages/pip (python 3.6)
```

`python`でpython3を使うようにしたい場合は
```
$ sudo update-alternatives --config python

There are 2 programs which provide 'python'.

  Selection    Command
-----------------------------------------------
*+ 1           /usr/libexec/no-python
   2           /usr/bin/python3

Enter to keep the current selection[+], or type selection number:
```
で`/usr/bin/python3`を選ぶ。





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


# Ubuntu 18.04 LTSでpython3.7

3.8もあるけどAzure Functionsが3.7.x対応なので一応。

rootで
```sh
apt install python3.7 python3.7-dev
```

python3を3.7にすると動かなくなるシステムツールが山ほどあるので
あんまりいじるのはやめておく。

python3-aptパッケージのこのへんが
```
/usr/lib/python3/dist-packages/apt_pkg.cpython-36m-x86_64-linux-gnu.so
/usr/lib/python3/dist-packages/apt_pkg.pyi
```
36用なので。

venvとか使うしかない。

Ubuntu 20.04 LTSでは Python 3.8が標準でPython2は入らないらしい。


# venv

[venv --- 仮想環境の作成 — Python 3.7.5 ドキュメント](https://docs.python.org/ja/3.7/library/venv.html)

Ubuntu 18.04 LTSで

```sh
sudo apt install python3.7 python3.7-dev python3.7-venv
python3.7 -m venv ~/.venv/37
. ~/.venv/37/bin/activate
python --version
python3 --version
pip install -U pip
deactivate
```

activateをエリアスにしておくといいかも
```
alias p37='source "$HOME/.venv/37/bin/activate"'
```
こんな感じ?

他venvのtips:
```
python3.7 -m venv ~/.venv/37 --clear
```
で、環境を作り直す。


この環境で`pip --user`するとどうなるのか?

# pythonのEOL

- [PEP 494 -- Python 3.6 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0494/#lifespan)
- [PEP 537 -- Python 3.7 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0537/#lifespan)
- [PEP 569 -- Python 3.8 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0569/#lifespan)

|version|date|
|---|---|
|Python 3.6|2021-12|
|Python 3.7|2023-06|
|Python 3.8|2024-08|


今後はAWS Lambdaは3.8で書く

- [AWS Lambda now supports Python 3.8](https://aws.amazon.com/jp/about-aws/whats-new/2019/11/aws-lambda-now-supports-python-3-8/)
- [AWS Lambda で Python 3.8 ランタイム がサポートされました ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/aws_lambda_support_python38/)