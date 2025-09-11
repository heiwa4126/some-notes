# aqua のメモ

カートゥーン・ヒーローズではない。
[aqua Official Website | aqua](https://aquaproj.github.io/)

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

.profile 等に PATH だけ追加する & 反映。

```console
$ aqua -v
aqua version 2.53.11
```

「グローバル(per-user)」にインストールするには
これ読む。[Install tools globally | aqua](https://aquaproj.github.io/docs/tutorial/global-config/)
