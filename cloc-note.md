# cloc のメモ

コードの行数を数えるやつ。Count Lines of Code (CLOC)

- [AlDanial/cloc: cloc counts blank lines, comment lines, and physical lines of source code in many programming languages.](https://github.com/AlDanial/cloc)
- [対応言語](https://github.com/AlDanial/cloc?tab=readme-ov-file#Languages)

## インストール

[Install via package manager](https://github.com/AlDanial/cloc?tab=readme-ov-file#install-via-package-manager)

```sh
sudo apt install cloc
```

Windows 版は Chocolatey と Scoop のパッケージがある

- [Chocolatey Software | Count Lines of Code (CLOC)](https://community.chocolatey.org/packages/cloc/)
- [Scoop - Apps (cloc)](https://scoop.sh/#/apps?q=cloc&p=1)

npm パッケージまである。これはラッパーなので Perl は別途必要。

- [cloc - npm](https://www.npmjs.com/package/cloc?activeTab=readme)

## git と

```sh
# .gitignore に含まれるファイルを除外
cloc . --exclude-list-file=.gitignore

# gitで管理してるファイルのみカウント
cloc $(git ls-files)
```

### 実行例

```console
$ cloc $(git ls-files)
      32 text files.
      31 unique files.
       6 files ignored.

github.com/AlDanial/cloc v 1.90  T=0.02 s (1531.5 files/s, 274546.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
YAML                             4            563             18           2106
TypeScript                       8            132            131            728
Markdown                         6            165              0            406
HTML                             5             19              0            214
JSON                             3              5              0            174
-------------------------------------------------------------------------------
SUM:                            26            884            149           3628
-------------------------------------------------------------------------------
```

これ TypeScript のプロジェクトなんで、lock ファイルが大きい。
それをメトリックに入れるのはどうかとは思うけど

## 便利なオプション

- `--json` : JSON 形式で出力
- `--yaml` : YAML 形式で出力
- `--csv` : CSV 形式で出力
- `--md` : Markdown の表形式で出力
- `--sql=xxxxx.sql` : SQL で出力

```sh
# 特定の言語だけ計測
cloc . --include-lang=Python,JavaScript
```
