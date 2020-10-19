# gitメモ

# gitの設定をリスト

``` bash
git config -l # 全設定
git config --global -l # globalだけ
git config --local -l # local設定だけ
```

範囲は
1. `--system`
2. `--global`
3. `--local`
4. `--worktree`
5. `--file <filename>`

の5通り。

gitデフォルト値も出るといいなあ(好きな設定をつっこめるので、ちょっとむずかしい)


# symlinkの扱い

[Git - git-config Documentation](https://git-scm.com/docs/git-config)の
`core.symlinks`を参照。falseに設定すると(デフォルトはtrue)

> If false, symbolic links are checked out as small plain files that contain the link text.

うっかり巨大ファイルをsymlinkしてもOK。
WindowsでcloneしてもOK。

``` bash
git config --global core.symlinks false
git config --local core.symlinks false
sudo git config --system core.symlinks false
```
適切な範囲で設定しておけばいい。

symlinkを無視したいなら、project rootで
``` bash
find * -type l >> .gitignore
```

`find *`は珍しい。`find .`と比較すること。
`*`がいやなら、

``` bash
find . -type l -printf '%P\n' >> .gitignore
```
で

# master to main

意外とめんどくさい

- [How to rename the "master" branch to "main" in Git | Learn Version Control with Git](https://www.git-tower.com/learn/git/faq/git-rename-master-to-main/)
- [Easily rename your Git default branch from master to main - Scott Hanselman](https://www.hanselman.com/blog/EasilyRenameYourGitDefaultBranchFromMasterToMain.aspx)
- [Git: Correct way to change Active Branch in a bare repository? - Stack Overflow](https://stackoverflow.com/questions/3301956/git-correct-way-to-change-active-branch-in-a-bare-repository)


# 登録されているリモートリポジトリの確認

```
git remote -v
```

`.git/conf`みるよりちょっと楽。