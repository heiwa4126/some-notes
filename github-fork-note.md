# GitHub でフォーク

GitHub 上に foobar(仮名) という public リポジトリがあり、
これを少しだけ自分用に改造したいとする。

できれば foobar 側のアップデートも取り込みたいし、
場合によっては、自分の修正を foobar に PR で送りたい。
その場合、どのようなブランチ構成にするのがよいか?

## これは fork + upstream 追跡の構成が定石

### 全体構成

```
upstream (foobar 本家)
    ↓  fetch/merge
origin (GitHub 上の自分の fork)
    ↓  clone
local (手元)
```

### ブランチ構成

```
main          ← upstream/main を追跡。直接コミットしない
├── my/tweaks ← 自分のカスタマイズをまとめるブランチ
└── fix/foo   ← PRを送るときだけ main から切る一時ブランチ
```

**ポイントは `main` を upstream と同期専用にしておくこと。**  
自分の変更は必ず別ブランチに乗せる。

### セットアップ手順

```bash
# 1. GitHub で foobar を fork(UIでポチっと)

# 2. fork した自分のリポジトリを clone
git clone git@github.com:yourname/foobar.git
cd foobar

# 3. upstream を登録
git remote add upstream git@github.com:original/foobar.git

# 確認
git remote -v
# origin    git@github.com:yourname/foobar.git (fetch/push)
# upstream  git@github.com:original/foobar.git (fetch/push)

# 4. 自分のカスタマイズ用ブランチを切る
git switch -c my/tweaks
# ...改造してコミット...
git push -u origin my/tweaks
```

### upstream の更新を取り込む

```bash
# upstream の最新を取得
git fetch upstream

# main を upstream に合わせる
git switch main
git merge upstream/main   # (または rebase)
git push origin main

# 自分のブランチに upstream の変更を取り込む
git switch my/tweaks
git rebase main           # ← rebase 推奨 (履歴がきれいになる)
```

`my/tweaks` が main の先端に乗り直されるので、コンフリクトもここで解消できます。

### PR を送りたいとき

```bash
# main (最新の upstream 同期済み) から専用ブランチを切る
git switch main
git switch -c fix/some-bug

# 修正してコミットし、push
git push -u origin fix/some-bug
# → GitHub で upstream に向けて PR を作成
```

PR がマージされたら `fix/some-bug` は削除して OK。  
自分のカスタマイズ (`my/tweaks`) とは完全に分離されているので、衝突しにくくなります。

### まとめ

| ブランチ    | 役割                     | push先                       |
| ----------- | ------------------------ | ---------------------------- |
| `main`      | upstream同期用・触らない | origin/main                  |
| `my/tweaks` | 自分の改造               | origin/my/tweaks             |
| `fix/xxx`   | PR用・使い捨て           | origin/fix/xxx → upstream PR |

この構成なら「upstream 更新の追従」「自分の改造維持」「PR を送る」の 3 つが綺麗に分離できます。

## ブランチ名の '/' には何か意味がある?

Git 的には `/` に特別な意味はなく、単なる ref 名の一部です。

ただし慣習として「名前空間っぽく使う」方法が広く定着していて、多くのツール (GitHub、GitLab、各種 GUI クライアント) はスラッシュを見てフォルダ階層のように表示してくれます。

制約として、既存のブランチ名と新しいブランチ名が親子のような関係になる形では共存できません。

```sh
git switch -c feat/foo        # 作成済み
git switch -c feat/foo/bar    # ❌ feat/foo が存在するので feat/foo/bar は作れない
```

逆も同様。

```sh
git switch -c feat/foo/bar    # 作成済み
git switch -c feat/foo        # ❌ feat/foo/bar が存在するので feat/foo は作れない
```
