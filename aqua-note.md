# aquaproj/aqua のメモ

"CLI Version Manager"
「コマンドラインツールのバージョン管理をするコマンドラインツール」

カートゥーン・ヒーローズではない。

- [aqua Official Website | aqua](https://aquaproj.github.io/)
- [aqua CLI Version Manager 入門](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook)
- GitHub - [aquaproj/aqua: Declarative CLI Version manager written in Go. Support Lazy Install, Registry, and continuous update with Renovate. CLI version is switched seamlessly](https://github.com/aquaproj/aqua)

## 感想

便利!
でも慣れるまで大変。むやみに人にすすめないほうがいいかも

コンセプトをつかめば、いい感じに使える

## 概要

主に GitHub Release で配布されている CLI ツールを配布する。

依存ライブラリの無い/少ない Go や Rust の CLI ツールを配布するのに便利。

いままで GitHub の該当ページの Release を開いてダウンロードして
rename して、みたいのが簡単にできるし、バージョン管理もできる(これがメイン)。

CI/CD で使いやすくできている。

GoLang で書かれており Windows でも動く。

[各ツールと比べた aqua の良さ](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/what-aqua#%E5%90%84%E3%83%84%E3%83%BC%E3%83%AB%E3%81%A8%E6%AF%94%E3%81%B9%E3%81%9F-aqua-%E3%81%AE%E8%89%AF%E3%81%95)

## Registry

aqua の Standard Registry は
<https://github.com/aquaproj/aqua-registry>
で、
<https://github.com/aquaproj/aqua-registry/blob/main/aqua.yaml>
には aqua 本体や関連ツールの定義だけ。

[Registry とは| aqua CLI Version Manager 入門](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/registry)

で pkgs/ 以下が本番で、定義(YAML2 個)書いてプルリクする仕掛け。

例えば suzuki-shunsuke の
[pinact](https://github.com/suzuki-shunsuke/pinact)
は:  
<https://github.com/aquaproj/aqua-registry/tree/main/pkgs/suzuki-shunsuke/pinact>

ここの registry.yaml を見れば Sigstore にも対応してるのがわかる。

詳しい手順は以下参照

- [Contributing | aqua](https://aquaproj.github.io/docs/products/aqua-registry/contributing/)
- [Standard Registry への Contribution](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/contribute-to-standard-registry)

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

[Quick Start | aqua](https://aquaproj.github.io/docs/tutorial/)

※ `gh`がインストールされていない環境で実行すること

```sh
mkdir working_dir && cd !$
aqua init # カレントディレクトリに aqua.yaml ができる
aqua g -i cli/cli # 最新版の gh (GitHub CLI) をパッケージ名で指定
aqua g -i # TUIでインタラクティブにパッケージ指定.
## Tab キーで選択(チェック)を追加
## Shift+Tab で選択を解除
## Enter キーで確定
## 終了はCtrl+C(fzfだから)
# `aqua g -i`の結果は aqua.yaml に書き込まれる
# `-i` なしだと表示だけ
aqua i -l # インストールするかわりにリンクだけ作る。実行時にインストールされる
# aqua i # インストール

# インストールしたパッケージを使ってみる。びっくりする
gh version

# どこにあるか見てみよう。ちょっとびっくりする
which gh
ls -lad $(which gh)
```

- [aqua generate](https://aquaproj.github.io/docs/reference/usage#aqua-generate)
- [aqua install](https://aquaproj.github.io/docs/reference/usage#aqua-install)

## なんか使い方の説明が不親切...

[aqua - Declarative CLI Version Manager (2022-05-31) - asciinema.org](https://asciinema.org/a/498262?autoplay=1)
見るのが早い。

## aqua.yaml 探索の流れ

[設定ファイルの探索](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/tutorial#%E8%A8%AD%E5%AE%9A%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E6%8E%A2%E7%B4%A2)

1. カレントディレクトリから親ディレクトリへ順に aqua.yaml を探索 (ルートまで探す)。Windows だったらそのドライブのルートディレクトリらしい
2. 見つからなければ $AQUA_GLOBAL_CONFIG 環境変数のファイルを使う
3. それもなければあきらめる

先に見つかったもの優先。
たとえば
./aqua.yaml と ~/.aqua.yaml が両方存在している場合は、
./aqua.yaml だけ使う。

あとオプション `-c`,`--config` 環境変数 `$AQUA_CONFIG` でも指定できる。

まよったときは `aqua info` で表示。

## 「グローバル(per-user)」にインストールするには

[グローバルなインストール](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/tutorial#%E3%82%B0%E3%83%AD%E3%83%BC%E3%83%90%E3%83%AB%E3%81%AA%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)

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
(`-d`オプションと環境変数で日にちは指定できる)

## aqua 自体のアップデート

`aqua update-aqua`

- [aqua update\-aqua で aqua 本体の update](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/tips#aqua-update-aqua-%E3%81%A7-aqua-%E6%9C%AC%E4%BD%93%E3%81%AE-update)
- [aqua update\-aqua](https://aquaproj.github.io/docs/reference/usage#aqua-update-aqua)

## チェックサム

- [Search packages | aqua](https://aquaproj.github.io/docs/tutorial/search-packages)
- [Checksum の検証| aqua CLI Version Manager 入門](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/checksum-verification)

チェックサムの扱いがややこしい。

まずデフォルトではチェックサムは有効になっていない。

有効にする場合

```yaml
checksum:
  enabled: true
```

require_checksum はデフォルトで false
この場合

- Release に\*\_checksums.txt があればそれを使う
- なければ自分で計算
- aqua-checksums.json に記録 (全アーキテクチャ版)

```yaml
checksum:
  enabled: true
  require_checksum: true
```

## Mend Renovate

- [Renovate による自動 update | aqua CLI Version Manager 入門](https://zenn.dev/shunsuke_suzuki/books/aqua-handbook/viewer/renovate)
- [Update packages by Renovate | aqua](https://aquaproj.github.io/docs/guides/renovate/)

[renovate](https://github.com/renovatebot/renovate)
は
dependabot みたいなもので、
このドキュメントは aqua.yaml を renovate 対応にする手順を説明している。

Renovate は評判だけ読むと dependabot よりははるかにいいらしい。

[Renovate を使ってほぼ完全自動で依存パッケージをアップデートする](https://zenn.dev/book000/articles/renovate-dep-auto-update)

たしかに dependabot、1 パッケージづつ PR 出てきて、マージできないもんな...

## aqua が検索で探しにくい問題

aquaproj か aqua cli で探すといいらしい。

## Windows で `aqua i` でインストールされる場所

`%LOCALAPPDATA%\aquaproj-aqua\bin`

パスに追記する。

あとグローバル設定に移動するには

```pwsh
cd (Split-Path $Env:AQUA_GLOBAL_CONFIG)
```

## 特定のパッケージを更新させない

```yaml
- name: golang/go@go1.25.7
  update:
    enabled": false
```

こんな感じ。CLI から設定できないっぽい。
あと "~1.25" や "^1.25" みたいのは無い。

- [Exclude some packages from the target of aqua update](https://aquaproj.github.io/docs/guides/update-command/#exclude-some-packages-from-the-target-of-aqua-update)
- [packages](https://aquaproj.github.io/docs/reference/config/#packages) の update.enabled: のところ
