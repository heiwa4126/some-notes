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


すでにcloneされてるやつのあつかいが難しい。

あたらしく始めるなら
```sh
git branch -m main
git remote add origin repositoryanysome
git push -u origin main
```
で
```sh
git clone repositoryanysome -b main
```
みたいに。

次のgitからデフォルトが`main`になるらしい。

- [git/git: Git Source Code Mirror - This is a publish-only repository and all pull requests are ignored. Please follow Documentation/SubmittingPatches procedure for any of your improvements.](https://github.com/git/git)


# 登録されているリモートリポジトリの確認

```
git remote -v
```

`.git/conf`みるよりちょっと楽。


# ubuntuで新しめのgitを使う

- [Git stable releases : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/ppa)
- [Git](https://git-scm.com/download/linux)
- [Ubuntu で git のバージョンを最新版にする | Lonely Mobiler](https://loumo.jp/archives/23149)

```sh
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git
```
