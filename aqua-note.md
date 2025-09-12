# aqua のメモ

カートゥーン・ヒーローズではない。
[aqua Official Website | aqua](https://aquaproj.github.io/)

## 感想

便利!
でも慣れるまで大変。むやみに人にすすめないほうがいいかも

## 概要

主に GitHub Release で配布されている CLI ツールを配布する。
依存ライブラリの無い/少ない Go や Rust の CLI ツールを配布するのに便利。

いままで GitHub の該当ページの Release を開いてダウンロードして
rename して、みたいのが簡単にできるし、バージョン管理もできる。

GoLang だから Windows でも動く。

aqua の Standard Registry は
<https://github.com/aquaproj/aqua-registry>
で、
<https://github.com/aquaproj/aqua-registry/blob/main/aqua.yaml>
には aqua 本体や関連ツールの定義だけ。

で pkgs/ 以下が本番で、定義(YAML2 個)書いてプルリクする仕掛け。

例えば suzuki-shunsuke の
[pinact](https://github.com/suzuki-shunsuke/pinact)
は:  
<https://github.com/aquaproj/aqua-registry/tree/main/pkgs/suzuki-shunsuke/pinact>

ここの registry.yaml を見れば Sigstore にも対応してるのがわかる。

(詳しい手順は
[Contributing | aqua](https://aquaproj.github.io/docs/products/aqua-registry/contributing/)
参照)

定義は別にプロジェクトオーナーが書く必要は無いみたい。
例えば jqlang/jq。
<https://github.com/aquaproj/aqua-registry/commits/main/pkgs/jqlang/jq/pkg.yaml>

## インストール

とりあえず WSL2 でやってみるよ。パターンはいろいろあるけど
[aqua-installer | aqua](https://aquaproj.github.io/docs/products/aqua-installer#shell-script)で。per-user でインストールされる。

.profile か.bashrc 等に PATH 追加する(表示される)。
bash 補完もある。

```bash
export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
# これはあとで export AQUA_GLOBAL_CONFIG=${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml
if command -v aqua &> /dev/null; then
  eval "$(aqua completion bash)"
fi
```

反映させるのを忘れるな。

```console
$ aqua -v
aqua version 2.53.11
```

## なんかインストールしてみよう

```sh
mkdir working_dir && cd !$
aqua init # カレントディレクトリに aqua.yaml ができる
aqua g -i cli/cli # 最新版のgh (GitHub CLI) をパッケージ名で指定
aqua g # TUIでインタラクティブにパッケージ指定.
## Tab キーで選択（チェック）を追加
## Shift+Tab で選択を解除
## Enter キーで確定
## 終了はCtrl+C(fzfだから)
# `aqua g -i`, `aqua g`の結果は aqua.yaml に書き込まれる
aqua i # インストール
aqua i -l # インストールするかわりにリンクだけ作る。実行時にインストールされる

# インストールしたパッケージを使ってみよう
gh version

# どこにあるか見てみよう
which gh
ls -lad $(which gh)
```

- [aqua generate](https://aquaproj.github.io/docs/reference/usage#aqua-generate)
- [aqua install](https://aquaproj.github.io/docs/reference/usage#aqua-install)

## なんか使い方の説明が不親切...

[aqua - Declarative CLI Version Manager (2022-05-31) - asciinema.org](https://asciinema.org/a/498262?autoplay=1)
見るのが早い。

## aqua.yaml 探索の流れ

1. カレントディレクトリから親ディレクトリへ順に aqua.yaml を探索 ($HOME まで探す)
2. 見つからなければ $AQUA_GLOBAL_CONFIG 環境変数のパスを指定
3. それもなければ ~/.aqua.yaml を使用

拡張子は .yaml でも.yml でもいいらしい。(優先度はよくわからん)

先に見つかったもの優先。
たとえば
./aqua.yaml と ~/.aqua.yaml が両方存在している場合は、
./aqua.yaml だけ使う。

あとオプション `-c`,`--config` 環境変数 `$AQUA_CONFIG` でも指定できる。

まよったときは `aqua info` で表示。

## 「グローバル(per-user)」にインストールするには

`npm i -g` 的な。

前の節よめば、まあわかるでしょうけど、
これ読む。[Install tools globally | aqua](https://aquaproj.github.io/docs/tutorial/global-config/)

AQUA_GLOBAL_CONFIG を設定したら、
ディレクトリ作成 & 移動 & `aqua init` がよさそう。

## `aqua g` は cwd の aqua.yaml にしか影響をおよぼさないみたい...

つまり `./aqua.yaml`にしか。

あと AQUA_GLOBAL_CONFIG のある場所に移動して aqua g でもダメ。

## パッケージの削除が難しい

基本

```sh
aqua rm <pkgname>
aqua rm --all
aqua vacuum
```

らしいんだけど、これだと PATH のリンクも消えないしバイナリも消えない。

上の間違い:

```sh
aqua rm -m pl <pkgname>
# 全消し
aqua rm -m pl --all
# リンクは残す、んだったら `-m p`。これなら使う時にインストールされる
```

`aqua vacuum` は全然違くて、「60 日以上使われていないものを"未使用"として消す」だそうです。
