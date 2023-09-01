# python のメモ

検索すれば出てくるけど、毎回探すのは面倒なのでまとめておく。

- [python のメモ](#pythonのメモ)
- [python をインストールする(2019-12)](#pythonをインストールする2019-12)
  - [Amazon Linux 2](#amazon-linux-2)
  - [Ubuntu 18.04 TLS](#ubuntu-1804-tls)
  - [RHEL7, CentOS7](#rhel7-centos7)
  - [RHEL8, CentOS8](#rhel8-centos8)
  - [Windows python 本家の配布](#windows-python本家の配布)
  - [Anaconda, miniconda](#anaconda-miniconda)
  - [Windows msys2](#windows-msys2)
  - [Windows Store](#windows-store)
- [Jupyter notebook](#jupyter-notebook)
- [pip をユーザーローカルに入れる](#pipをユーザーローカルに入れる)
- [pip --user のパス](#pip---user-のパス)
- [古いパッケージを見つける](#古いパッケージを見つける)
- [pip で更新可能なものをすべて更新するスクリプト](#pipで更新可能なものをすべて更新するスクリプト)
- [vscode と pipenv](#vscodeとpipenv)
- [RHEL7 に pip](#rhel7にpip)
- [RHEL6 に pip](#rhel6にpip)
- [pip10 問題](#pip10問題)
- [magic](#magic)
- [Ubuntu 18.04 LTS で python3.7](#ubuntu-1804-ltsでpython37)
- [Ubuntu 18.04 LTS で python3.9](#ubuntu-1804-ltsでpython39)
- [Ubuntu 20.04](#ubuntu-2004)
- [venv](#venv)
- [python の EOL](#pythonのeol)
- [モジュールとパッケージ](#モジュールとパッケージ)
- [Windows10 上での Python](#windows10上でのpython)
- [Jupyter Notebook の tips](#jupyter-notebookのtips)
- [2020-resolver](#2020-resolver)
- [WARNING: pip is being invoked by an old script wrapper.](#warning-pip-is-being-invoked-by-an-old-script-wrapper)
- [ubuntu20.04LTS 以降で python を python3 にする](#ubuntu2004lts以降でpythonをpython3にする)
- [Python Static Analysis Tools](#python-static-analysis-tools)
- [emacs で LSP で python](#emacsでlspでpython)
- [vscode で pylance 使うときに](#vscodeでpylance使うときに)
- [python の regex に PCRE の\\Q...\\E 的なもの](#pythonのregexにpcreのqe的なもの)
- [black](#black)
- [black + flake8](#black--flake8)
- [nose](#nose)
- [ローカルタイムゾーンを得る](#ローカルタイムゾーンを得る)
- [~/.config/flake8 サンプル](#configflake8サンプル)
- [PyFlakes](#pyflakes)
- [fleak8](#fleak8)
- [コードレビューもどき](#コードレビューもどき)
- [python にタイプヒント](#pythonにタイプヒント)
- [1 個上のフォルダから import](#1個上のフォルダからimport)

# python をインストールする(2019-12)

システムワイドに python3 と、
新し目の pip3 を user install directory に
インストールする手順。

## Amazon Linux 2

RHEL7 同様 python3 が公式に配布されるようになった。いまのところ python3.7。

```sh
sudo yum install python3
```

pip3

```sh
pip3 intsall -U --user pip
```

デフォルトでは
`$HOME/.local/bin`のパスの優先順が低いので、
.bash_profile を修正する。

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

最初から python3 (3.6)が入っているはず。もしなければ

```sh
sudo apt install python3
```

pip3

```sh
pip3 intsall -U --user pip
```

デフォルトでは
`$HOME/.local/bin`のパスがないので、
~/.profile を修正する。

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

Ubuntu では公式に Python 3.7 と 3.8 も配布されているが、システム標準の Python3 にはできない。
venv などで使うか、バージョンを明示して使う。

Ubuntu 20.04 LTS からは Python3 が標準の python になる予定

ほか参考:

- [（備忘録）Ubuntu 18.04 LTS で Jupyter Notebook 環境構築 - Qiita](https://qiita.com/zono_0/items/49eb8605ef4d841b2c26)

## RHEL7, CentOS7

python3 が公式に配布されるようになった。いまのところ python3.6。

```sh
sudo yum install python3
```

pip3

```sh
pip3 intsall -U --user pip
```

デフォルトでは
`$HOME/.local/bin`のパスの優先順が低いので、
.bash_profile を修正する。

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

python はデフォルトでは入らない。
python で書かれたシステムパッケージは、ユーザが`python`と叩いて使う python とは別パッケージになっていてる。

システムが使う Python は

```
# /usr/libexec/platform-python --version
Python 3.6.8
# rpm -qf /usr/libexec/platform-python
platform-python-3.6.8-15.1.el8.x86_64
```

である。

ユーザが使う Python3 と pip3 のインストールは

```sh
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

`python`で python3 を使うようにしたい場合は

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

## Windows python 本家の配布

[Download Python | Python.org](https://www.python.org/downloads/)

注: たぶんすぐ直ると思うけど、jupyter はいまのところ 3.8 では動かない(asynio の引数がかわったらしい) ので、jupyter notebook を使うつもりなら 3.7 をインストール。

インストーラに従う。

![インストーラーの画面](imgs/w1.png "インストーラ")

インストール後「Path の長さ制限を解除する」ボタンが出てくるので、解除する。

pip3 の最新版のインストールは、管理者権限でないコマンドプロンプトから

```
pip3 install -U --user　pip
```

これは`C:\Users\ユーザ名\AppData\Roaming\Python\Python38\Scripts`にインストールされるので、
ここを Path に追加し、優先度を高くする。(Python3.7 だったら 38 のところは 37)

テスト

```
C:>python --version
Python 3.8.1

C:>pip3 --version
pip 19.3.1 from C:\Users\xxxxx\AppData\Roaming\Python\Python38\site-packages\pip (python 3.8)
```

## Anaconda, miniconda

- [Anaconda Python/R Distribution - Free Download](https://www.anaconda.com/distribution/)
- [Miniconda — Conda documentation](https://docs.conda.io/en/latest/miniconda.html)

インストール・アンインストールにすごい時間がかかるので、十分な時間的余裕をもって実行すること。

conda のパッケージ管理は、conda コマンドを使う。

たとえば、インストールされているパッケージや python 自体の更新は
インストール後、スタートメニュー->Anaconda 3->Anaconda Prompt (Anaconda 3)->右クリックで「管理者として起動」

```
conda update --all
```

で出来る。

pip でインストールすると、すぐ不具合が起きるので、
conda は「`Jupyter Notebook`環境をすぐ作りたい」というときなどに使うこと。

## Windows msys2

[MSYS2 homepage](http://www.msys2.org/)参照。たぶん使うことは少ないと思うので TODO。

## Windows Store

Windows Store で`python`で検索して、Python 3.8 をインストール。

`C:\Program Files\WindowsApps\PythonSoftwareFoundation.Python.3.8_3.8.496.0_x64__xxxxxxxx`
のような名前でインストールされて、とてもまともに使えない。

# Jupyter notebook

Windows 版では Python3.7 以下(2019-12 現在。たぶんすぐ直る。[windows - Jupyter Notebook with Python 3.8 - NotImplementedError - Stack Overflow](https://stackoverflow.com/questions/58422817/jupyter-notebook-with-python-3-8-notimplementederror)参照)

python3 と pip3 インストール後

```sh
pip install --user -U jupyter numpy matplotlib
```

numpy と matplotlib はオマケ(グラフとか書きたいでしょう?)

```
jupyper notebook
```

で起動。
表示される URL(`http://localhost:8888/token=xxxx`)に web ブラウザでつないで、
あとは UI に従う。

# pip をユーザーローカルに入れる

python2 と python3 があって、
ディストリのパッケージでは古い pip しか入らなくて、
みたいな状況のとき
(Ubuntu 18.04LTS)

```bash
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python2 get-pip.py -U --user
python3 get-pip.py -U --user
hash -r
rm get-pip.py
```

これで pip2,pip3,pip(=pip3)が使える。

Ubuntu のデフォルトの.profile では
`%HOME/.local/bin`が存在するときのみ PATH に追加、
という仕様になってるので、(RHEL7 とかでは無条件に追加)
最初の 1 回は

```bash
PATH="$HOME/.local/bin:$PATH"
hash -r
```

する。

RHEL7/CentOS7 では ~/.bash_profile で

```bash
# User specific environment and startup programs
# PATH=$PATH:$HOME/.local/bin:$HOME/bin
PATH=$HOME/.local/bin:$PATH:$HOME/bin
```

`.local/bin`が先になるように修正しておく。

# pip --user のパス

```
python -c "import site; print(site.USER_BASE)"
```

この出力の/bin に PATH を通せばいろいろ捗る。

参考:

- [pip に--user をつけた時のインストール先を変える - Qiita](https://qiita.com/ronin_gw/items/cdf8112b61649ca455f5)
- [29.13. site — サイト固有の設定フック — Python 3.6.5 ドキュメント](https://docs.python.jp/3/library/site.html)

よくわからないときは

```sh
python3 -m site
```

を実行。

[site --- サイト固有の設定フック — Python 3.10.4 ドキュメント](https://docs.python.org/ja/3/library/site.html)

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
[pip で一括アップデート - Qiita](https://qiita.com/manji-0/items/d3d824d77c18c2f28569)
などを参考に。

参考:

- [pip で更新可能なパッケージを一覧表示 - Qiita](https://qiita.com/Klein/items/a3110d20532ba9f9057b)

# pip で更新可能なものをすべて更新するスクリプト

依存関係で問題があるかもしれない。

```
#!/bin/bash
pip3 list --user --outdated --format=freeze | \
  grep -v '^\-e' | \
  cut -d = -f 1  | \
  xargs -r -n1 pip3 install --user -U
hash -r
```

python2 用は pip3 を pip2 にする。

`--user`でなく、システムワイドに実行するのはやめたほうがいい。
OS ディストリのパッケージを消す時があるから。(certbot で失敗した)

同様の理由で`rootで--user`もやめたほうがいい。

おまけ: certbot & nginx を再インストールする apt

```
apt-get install --reinstall certbot python-certbot-nginx python3-certbot python3-certbot-nginx
```

# vscode と pipenv

pipenv または virtualenv で作業すると、グローバルやユーザにインストールした
pylint や autopep8 を vscode が見つけてくれない。

virtualenv 下に pylint や autopep8 をインストールすればいいのだが、
結構サイズがデカいので、
`.vscode/settings.json`で
該当バージョンの python に対応したパスを指定してやる。
以下は例:

```
{
    ...
    "python.linting.pylintPath": "C:\\ProgramData\\Anaconda3\\Scripts\\pylint.exe",
    "python.formatting.autopep8Path": "C:\\ProgramData\\Anaconda3\\Scripts\\autopep8.exe",
    ...
}
```

また`"python.pythonPath"`も virtualenv 下の python を指定する。

さらに`.vscode/settings.json`を git に含めないようにしておく。

もっと楽な方法がありそうだがなあ。

# RHEL7 に pip

最近の(2019-11)RHEL7 では公式レポジトリに Python3.6 が入っていて、ちょっと古めの pip3 も入る。

```bash
sudo yum install python3
```

で。

以下古い情報。

RHEL はチャネル(レポジトリ)が細分化されててめんどくさい。

引用元: [How to install pip on Red Hat Enterprise Linux?](https://access.redhat.com/solutions/1519803)

```
# subscription-manager repos --enable rhel-server-rhscl-7-rpms
# yum install python27-python-pip -y
# scl enable python27 bash
# pip install --upgrade pip
```

こうすると` /opt/rh/python27/root/usr/lib/python2.7/site-packages/pip`に pip が...
どう考えても頭がおかしいと思う。

`get-pip.py`のほうが全然まともだと思う。

※ SCL については
[ソフトウェアコレクション(SCL：Software Collections)とは？ – StupidDog's blog](http://stupiddog.jp/note/archives/1074)
等を参照。そもそもコンセプトが違う。

```
$ wget https://bootstrap.pypa.io/get-pip.py
$ python get-pip.py --user
```

あとは`$(HOME)/.local/bin`に PATH を通して`hash -r`

# RHEL6 に pip

RHEL6 の python は 2.6 で

> DEPRECATION: Python 2.6 is no longer supported by the Python core team, please upgrade your Python. A future version of pip will drop support for Python 2.6

とか言われますが、一応動くことは動く。

pip も 9.0.3 までしか入らない。

```
wget https://bootstrap.pypa.io/2.6/get-pip.py
$ python get-pip.py --user
```

あとは`$(HOME)/.local/bin`に PATH を通して`hash -r`

# pip10 問題

(pip version 19 以降では問題なくなりました)

- [pip install --upgrade pip (10.0.0) 後の奇妙な挙動について - 雑記](http://icchy.hatenablog.jp/entry/2018/04/17/064443)

Ubuntu16.04LTS の python3.5 で pip10 に更新すると

```
$ pip
Traceback (most recent call last):
  File "/usr/bin/pip", line 9, in <module>
    from pip import main
ImportError: cannot import name main
```

こんな感じになる問題。

自分は ↑ のリンクを受けて
~/.profile に

```
alias pip='python3 -m pip'
alias pip3='python3 -m pip'
```

を書いていちおう解決、ということにしましたけど。

ただ AWS や Azure で立てた Ubuntu では何もしないでもエラーにならなくて
よくわからない。

# magic

`magic`という名前のモジュールが何種類もあるらしい。

- [julian-r/python-magic: A python wrapper for libmagic](https://github.com/julian-r/python-magic) MIME 判別用の magic. 下の magic のフォークだが、バイナリ付きで Windows や Mac でも動く
- [ahupp/python-magic: A python wrapper for libmagic](https://github.com/ahupp/python-magic) MIME 判別用の magic(Windows や Mac では動かない)

他に ImageMagick の Python ラッパーもあって
[Develop @ ImageMagick](http://www.imagemagick.org/script/develop.php#python)
ますますわけがわからない。

# Ubuntu 18.04 LTS で python3.7

3.8 もあるけど Azure Functions が 3.7.x 対応なので一応。

root で

```sh
apt install python3.7 python3.7-dev
```

python3 を 3.7 にすると動かなくなるシステムツールが山ほどあるので
あんまりいじるのはやめておく。

python3-apt パッケージのこのへんが

```
/usr/lib/python3/dist-packages/apt_pkg.cpython-36m-x86_64-linux-gnu.so
/usr/lib/python3/dist-packages/apt_pkg.pyi
```

36 用なので。

venv とか使うしかない。

Ubuntu 20.04 LTS では Python 3.8 が標準で Python2 は入らないらしい。

# Ubuntu 18.04 LTS で python3.9

いちおうこんな感じで(おすすめしない)

```sh
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.9 python3.9-venv python3.9-dev
python3.9 -V
```

もういいかげん OS をアップグレードするべき。

んで venv

```sh
python3.9 -m venv ~/.venv/39
.  ~/.venv/39/bin/activate
```

# Ubuntu 20.04

`python-is-python3`という名前のパッケージがあって、
これをインストールすると`python`が`python3`になる。

(実態は symlink)

# venv

[venv --- 仮想環境の作成 — Python 3.7.5 ドキュメント](https://docs.python.org/ja/3.7/library/venv.html)

Ubuntu 18.04 LTS で

```sh
sudo apt install python3.7 python3.7-dev python3.7-venv
python3.7 -m venv ~/.venv/37
. ~/.venv/37/bin/activate
python --version
python3 --version
pip install -U pip
deactivate
```

activate をエリアスにしておくといいかも

```
alias p37='source "$HOME/.venv/37/bin/activate"'
```

こんな感じ?

他 venv の tips:

```
python3.7 -m venv ~/.venv/37 --clear
```

で、環境を作り直す。

この環境で`pip --user`するとどうなるのか?

# python の EOL

- [PEP 494 -- Python 3.6 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0494/#lifespan)
- [PEP 537 -- Python 3.7 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0537/#lifespan)
- [PEP 569 -- Python 3.8 Release Schedule | Python.org](https://www.python.org/dev/peps/pep-0569/#lifespan)

| version    | date    |
| ---------- | ------- |
| Python 3.6 | 2021-12 |
| Python 3.7 | 2023-06 |
| Python 3.8 | 2024-08 |

今後は AWS Lambda は 3.8 で書く

- [AWS Lambda now supports Python 3.8](https://aws.amazon.com/jp/about-aws/whats-new/2019/11/aws-lambda-now-supports-python-3-8/)
- [AWS Lambda で Python 3.8 ランタイム がサポートされました ｜ Developers.IO](https://dev.classmethod.jp/cloud/aws/aws_lambda_support_python38/)

# モジュールとパッケージ

[6. モジュール — Python 3.8.1 ドキュメント](https://docs.python.org/ja/3/tutorial/modules.html)
に書いてあるとおりなので必ず読むこと。

ものすごい適当なまとめ:

- モジュールは\*.py ファイル。
- パッケージはディレクトリで、`__init.py__`が必須。
  - ディレクトリに複数のモジュールを置けて、これを「サブモジュール」と呼ぶ。
  - `__init.py__`だけで、他のファイルは置かなくても良い。
  - `__init.py__`は、中身がなくてもよい(size=0)。
  - パッケージのディレクトリは階層化できる(それぞれに`__init.py__`は必要)。

[5. インポートシステム — Python 3.8.1 ドキュメント](https://docs.python.org/ja/3/reference/import.html)

「名前空間パッケージ(Namespace Packages)」

[Python にまつわるアイデア： Python のパッケージとモジュールの違い - Life with Python](https://www.lifewithpython.com/2018/05/python-difference-between-package-and-module.html)

# Windows10 上での Python

Anaconda より、本家 Python の配布が良い感じ(2020-01 現在)。

[Download Python | Python.org](https://www.python.org/downloads/)

Jupyter のバグ回避で 3.7 を使ってる。

- proxy や ZScaler のネットワークシステムまわりで、設定が不要。
  - Anaconda だとめちゃめちゃ苦労した
- Mathplot も pip ですんなり入る。

# Jupyter Notebook の tips

- [Jupyter Notebook で Prompt の番号をリセットするたったひとつの冴えたやりかた - Qiita](https://qiita.com/iktakahiro/items/32d65ebee6b7d784eed1)

# 2020-resolver

```sh
mkdir -p ~/.config/pip
echo "
[install]
use-feature=2020-resolver
" >> ~/.config/pip/pip.conf
```

2020-12 ごろ

> WARNING: --use-feature=2020-resolver no longer has any effect, since it is now the default dependency resolver in pip. This will become an error in pip 21.0.

とか言い出したので `~/.config/pip/pip.conf`の該当行をコメントアウトした。

# WARNING: pip is being invoked by an old script wrapper.

[ImportError in system pip wrappers after an upgrade · Issue #5599 · pypa/pip · GitHub](https://github.com/pypa/pip/issues/5599)

要は`pip`じゃなくて`python3 -m pip`を使え、ということらしいけどめんどくさい...

alias にするとか

```sh
#!/bin/sh -xe
PIP="python3 -m pip"
$PIP install --user -U pip
```

こんな感じで。

# ubuntu20.04LTS 以降で python を python3 にする

```sh
sudo apt install python-is-python3
```

参考:
[Ubuntu – パッケージ検索結果 -- python-is-python3](https://packages.ubuntu.com/search?keywords=python-is-python3&searchon=names)

逆に
`python-is-python2-but-deprecated`
というパッケージもある。

あと標準だと pip も入ってない。

```
sudo apt install python3-pip
```

開発するなら

```sh
pip install --user 'python-language-server[all]'
```

など。

参考:

- [Python (Palantir) - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/page/lsp-pyls/)
- [GitHub - palantir/python-language-server: An implementation of the Language Server Protocol for Python](https://github.com/palantir/python-language-server)

自分はフォーマッタは black が楽で好きなので

```
pip install --user black pyls-black
```

# Python Static Analysis Tools

pyflakes
pycheckers
pyre
(TODO) pyre おもしろそう。

# emacs で LSP で python

2021-04 ぐらい。Python2 は考えない。
emacs >= 26.1 で。
これより低かったら、いろいろ悩むよりは
snap で emacs 27 がかんたんにインストールできるので、そっちを使う。
`sudo snap install emacs --classic`

python の LSP、
[Languages - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/page/languages/)
には 4 つリストされているけど、pyls を使う例。

- [Python (Palantir) - LSP Mode - LSP support for Emacs](https://emacs-lsp.github.io/lsp-mode/page/lsp-pyls/)
- [GitHub - palantir/python-language-server: An implementation of the Language Server Protocol for Python](https://github.com/palantir/python-language-server)

自分はフォーマッタは black が楽で好きなので

```sh
pip3 install --user -U 'python-language-server[all]' black pyls-black
hash -r
```

`~/.local/bin/pyls`ができて、パスが通ってることを確認(`which pyls`とかで)。

pyls は古い、って言われるようになった。

```sh
pip3 install --user -U python-lsp-server python-lsp-black
```

emacs の設定は`~/.emacs.d`式で。

```sh
mkdir ~/.emacs.d/elpa/gnupg -p --mode 0700
echo "keyserver hkp://keys.gnupg.net" > ~/.emacs.d/elpa/gnupg/gpg.conf
gpg --homedir ~/.emacs.d/elpa/gnupg --recv-keys 066DAFCB81E42C40
```

(gpg の`--keyserver`オプションでもいいかも。
`gpg --keyserver hkp://keys.gnupg.net ...`)

で、`emacs -q ~/.emacs.d/init.el`

````lisp
(require 'package)
;; package-archivesを上書き
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(line-number-mode t)
(column-number-mode t)
(require 'paren) (show-paren-mode t)
(save-place-mode 1)
(prefer-coding-system 'utf-8)
(setq save-place-file "~/.emacs.d/.emacs-places")
(setq next-line-add-newlines nil)
(put 'narrow-to-region 'disabled nil)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default show-trailing-whitespace t)

(setq-default tab-width 2 indent-tabs-mode nil)
(define-key esc-map "g" 'goto-line)   ;; \M-g で 指定行へジャンプ

;; completion
(setq completion-ignore-case t)

;; python LSP mode
(add-hook 'python-mode-hook #'lsp)
(add-hook 'before-save-hook 'lsp-format-buffer 'append)
重要なのは最後の3行だけ。


emacsたちあげて

`M-x package-refresh-contents`
`M-x package-install[ret] lsp-ui[ret]`

これでOK.

他flycheckとかお好みで入れる。
`pip3 install --user --upgrade pyflakes flake8`
`M-x package-install[ret] flycheck-pyflakes[ret]`


# bytesとbytearray

- [bytes - 組み込み型 — Python 3.9.4 ドキュメント](https://docs.python.org/ja/3/library/stdtypes.html#bytes)
- [bytearray - 組み込み型 — Python 3.9.4 ドキュメント](https://docs.python.org/ja/3/library/stdtypes.html#bytearray)

> bytearray オブジェクトは可変なので、 bytes と bytearray の操作 で解説されている bytes オブジェクトと共通の操作に加えて、 mutable シーケンス操作もサポートしています。

[ミュータブルなシーケンス型 - 組み込み型 — Python 3.9.4 ドキュメント](https://docs.python.org/ja/3/library/stdtypes.html#typesseq-mutable)

例:
```python
b1 = b"b\x00\x01\x02"  # bytes
b2 = bytearray(b1)     # bytearray

print(b2)
b2[1] = 0x11  # bytearrayはmutable
print(b2)

print(b1)
b1[1] = 0x11  # raise TypeError: 'bytes' object does not support item assignment
print(b1)
````

# vscode で pylance 使うときに

settings.json に

```json
{
  "python.languageServer": "Pylance",
  "python.analysis.typeCheckingMode": "basic"
}
```

表示されるルール一覧はここに
[pylance-release/DIAGNOSTIC_SEVERITY_RULES.md at main · microsoft/pylance-release · GitHub](https://github.com/microsoft/pylance-release/blob/main/DIAGNOSTIC_SEVERITY_RULES.md)

# python の regex に PCRE の\Q...\E 的なもの

PCRE には\Q...\E ではさむとメタ文字が意味を失う、というのがあって

> If you want to remove the special meaning from a sequence of characters, you can do so by putting them between \Q and \E
> [pcrepattern specification](https://www.pcre.org/original/doc/html/pcrepattern.html)

`re.escape(pattern)`で。

# black

[psf/black: The uncompromising Python code formatter](https://github.com/psf/black)

無設定で使える。

たぶん行の最大長だけは変えたほうがいい(88)。
[The Black code style — Black 21.7b0 documentation](https://black.readthedocs.io/en/stable/the_black_code_style/current_style.html#line-length)

# black + flake8

[Using Black with other tools — Black 21.7b0 documentation](https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html?highlight=E203#flake8)

# nose

`nosetests`がテストファイルを見つけてくれないとき。

[python \- Nose unable to find tests in ubuntu \- Stack Overflow](https://stackoverflow.com/questions/1457104/nose-unable-to-find-tests-in-ubuntu)

executable だとスキップされます。

トラブルシューティングには

```sh
nosetests -vv --collect-only
```

が便利

# ローカルタイムゾーンを得る

python スクリプトの動いているホストのローカルタイムゾーンを得る。

[datetime - Python: Figure out local timezone - Stack Overflow](https://stackoverflow.com/questions/2720319/python-figure-out-local-timezone)

```python
from datetime import datetime,timezone
LOCAL_TIMEZONE = datetime.now(timezone.utc).astimezone().tzinfo
```

# ~/.config/flake8 サンプル

```
[flake8]
max-line-length = 166
# ignore = E203, E266, E501, W503, F403, F401, E999
ignore = E203, E266, E501, W503, F403, F401
select = B,C,E,F,W,T4,B9
```

# PyFlakes

[PyCQA/pyflakes: A simple program which checks Python source files for errors](https://github.com/PyCQA/pyflakes)

# fleak8

[PyCQA/flake8: flake8 is a python tool that glues together pycodestyle, pyflakes, mccabe, and third-party plugins to check the style and quality of some python code.](https://github.com/PyCQA/flake8)

```
Flake8 is a wrapper around these tools:

PyFlakes
pycodestyle
Ned Batchelder's McCabe script
```

McCabe? 循環的複雑度?

- [PyCQA/mccabe: McCabe complexity checker for Python](https://github.com/PyCQA/mccabe)
- [McCabe 循環的複雑度 | Rogue Wave - Documentation](https://docs.roguewave.com/jp/klocwork/current/mccabecyclomaticcomplexity)

よくわからないけどネストが深いと警告してくれる、ってことかな...

# コードレビューもどき

オートフォーマッタを使いましょう。
おすすめ: black (psf/black)

lint を使いましょう。
おすすめ: flake8 (PyCQA/flake8)

(TIPS: black + flake8 の場合、flake8 の設定に(例えば~/.config/flake8)
`ignore = E203`
だけは追加しましょう)

↑[Using Black with other tools — Black 21.9b0 documentation](https://black.readthedocs.io/en/stable/guides/using_black_with_other_tools.html)

使い方を書きましょう。

requirements.txt を書きましょう。

.gitignore を書いて **pycache** などは git から除外しましょう。

pyflakes などで未使用の import を検出しましょう。

ローカルなモジュールはサブディレクトリを作ってその下に置きましょう。

例)

```
gencacert/app/crypt.py ->　gencacert/app/lib/crypt.py
んで
from crypt import AESCipher -> from lib.crypt import AESCipher
とする
```

コマンドラインからパラメータを受け取るなら DI っぽくモジュール解析部分と、関数本体を分けましょう。

docstring はなるべく書きましょう。

ネストは深くならないようにしましょう。 Python のインデントが 4 だったり、max-line-length が 80 や 88 などだったりするのはそれなりに意味があります。

定数を形だけでもいいからなるべく外出しにしましょう。

デプロイ方法を書きましょう。

モジュールでない CLI から実行するコードには、shebang 書いて、実行権限もつけましょう。

# python にタイプヒント

[typing --- 型ヒントのサポート — Python 3.10.0b2 ドキュメント](https://docs.python.org/ja/3/library/typing.html)

型ヒント書くと補完が効くので便利なんだけど、
ちょっと複雑になるともう手に負えないのが欠点。GoLang がどれだけ偉大かわかる。

んで例えば boto3 の場合

- [alliefitter/boto3_type_annotations: Deprecated. A maintained fork is available at https://github.com/vemel/mypy_boto3](https://github.com/alliefitter/boto3_type_annotations)
- [boto3\-stubs · PyPI](https://pypi.org/project/boto3-stubs/)
- [boto3\-stubs を使って、boto3 でコード補完を有効にしよう \- Qiita](https://qiita.com/smatsumt/items/5235bcd794e634153982)

でも全然効かない...

# 1 個上のフォルダから import

プロジェクトルートにある python モジュールを
サブディレクトリから読む。

いろいろ試したんだけど、概ね以下に落ち着く

まず
作業中はプロジェクトルートで

```sh
export PYTHONLIB="$PWD"
```

で、IDE などがちゃんとパスを見つけてくれる。

で、コードには

```python
import sys; sys.path.append("..")
```

みたいのを書いておく。
これでとりあえず動くけど、コードのあるディレクトリ!=cwd でない場合問題になる。

PYTHONPATH 環境変数を使うほうがいいかもしれない。

パス類をさっくり見たいときは

```sh
python3 -m site
```

で。

```
$ python3 -m site
sys.path = [
    '/home/heiwa',
    '/usr/lib/python310.zip',
    '/usr/lib/python3.10',
    '/usr/lib/python3.10/lib-dynload',
    '/usr/local/lib/python3.10/dist-packages',
    '/usr/lib/python3/dist-packages',
]
USER_BASE: '/home/hoge/.local' (doesn't exist)
USER_SITE: '/home/hoge/.local/lib/python3.10/site-packages' (doesn't exist)
ENABLE_USER_SITE: True
```
