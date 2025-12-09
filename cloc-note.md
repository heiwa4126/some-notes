# cloc のメモ

コードの行数を数えるやつ。Count Lines of Code (CLOC)

- [AlDanial/cloc: cloc counts blank lines, comment lines, and physical lines of source code in many programming languages.](https://github.com/AlDanial/cloc)
- [対応言語](https://github.com/AlDanial/cloc?tab=readme-ov-file#Languages)

## インストール

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
