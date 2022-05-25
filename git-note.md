# gitメモ

- [gitメモ](#gitメモ)
- [gitの設定をリスト](#gitの設定をリスト)
- [gitignoreのデフォルト](#gitignoreのデフォルト)
- [symlinkの扱い](#symlinkの扱い)
- [master to main](#master-to-main)
- [登録されているリモートリポジトリの確認](#登録されているリモートリポジトリの確認)
- [ubuntuで新しめのgitを使う](#ubuntuで新しめのgitを使う)
- [git-secrets](#git-secrets)
- [diffをgithubみたくする](#diffをgithubみたくする)
- [プロジェクトスケルトンを作るツールで、空のディレクトリに.gitkeep](#プロジェクトスケルトンを作るツールで空のディレクトリにgitkeep)
- [gitのシェル補完](#gitのシェル補完)
- [Git for Windows付属のmsys2 mingwはp11-kitが入ってない](#git-for-windows付属のmsys2-mingwはp11-kitが入ってない)
- [submoduleまで含めてgitリポジトリの内容をzipファイルにする](#submoduleまで含めてgitリポジトリの内容をzipファイルにする)
- [gitでsymlinkを扱いたい](#gitでsymlinkを扱いたい)
  - [etckeeper](#etckeeper)


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

# gitignoreのデフォルト

`~/.config/git/ignore`

- [Git \- gitignore Documentation](https://git-scm.com/docs/gitignore)
- [~/\.gitignore\_global を指定するのをやめ、デフォルトの置き場に置こう](https://zenn.dev/qnighy/articles/1a756f2857dc20)

```sh
mkdir -p ~/.config/git/
echo '*~' >> ~/.config/git/ignore
```

Windowsは? 調べる。


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

# git-secrets

どれだけ役立つかはよくわからないけど、後悔先に立たずだから入れとけ。

- [awslabs/git-secrets: Prevents you from committing secrets and credentials into git repositories](https://github.com/awslabs/git-secrets)
- [AWS Access Keyを外部に公開してしまった話 | mediba Creator × Engineer Blog](https://ceblog.mediba.jp/post/638125766874415104/aws-access-key%E3%82%92%E5%A4%96%E9%83%A8%E3%81%AB%E5%85%AC%E9%96%8B%E3%81%97%E3%81%A6%E3%81%97%E3%81%BE%E3%81%A3%E3%81%9F%E8%A9%B1)

git-secretsインストールしたら
既存または新規のgitプロジェクトで
```sh
git secrets --install
git secrets --register-aws
```

参考: [git-secretsはじめました - Qiita](https://qiita.com/jqtype/items/9196e047eddb53d07a91)

でもめんどくさいので
[advanced-configuration](https://github.com/awslabs/git-secrets#advanced-configuration)
にあるように全レポジトリに設定したほうがいいとおもう。

↑から引用
```sh
git secrets --register-aws --global
# Add hooks to all your local repositories.
git secrets --install ~/.git-templates/git-secrets
git config --global init.templateDir ~/.git-templates/git-secrets
```

既存のgitをスキャンとかもできる
(
    プロジェクトに移動して、
    `git secrets --scan-history`
)


# diffをgithubみたくする

- [unix \- ターミナルの diff で、github のように、行の中で具体的に差分がある部分に色付けをしたい \- スタック・オーバーフロー](https://ja.stackoverflow.com/questions/75829/%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E3%81%AE-diff-%E3%81%A7-github-%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB-%E8%A1%8C%E3%81%AE%E4%B8%AD%E3%81%A7%E5%85%B7%E4%BD%93%E7%9A%84%E3%81%AB%E5%B7%AE%E5%88%86%E3%81%8C%E3%81%82%E3%82%8B%E9%83%A8%E5%88%86%E3%81%AB%E8%89%B2%E4%BB%98%E3%81%91%E3%82%92%E3%81%97%E3%81%9F%E3%81%84)
- [gitのdiff\-highlightを使い始めた \- りんごとバナナとエンジニア](https://udomomo.hatenablog.com/entry/2019/12/01/181404)


# プロジェクトスケルトンを作るツールで、空のディレクトリに.gitkeep

ありがち

```sh
find -type d -empty | xargs -i{} touch {}/.gitkeep
```

TODO:「空でなくなったディレクトリにある.etckeepを消す」も。


# gitのシェル補完

[git/contrib/completion at master · git/git](https://github.com/git/git/tree/master/contrib/completion)

Ubuntuだとgitパッケージに最初から入ってた。

```
$ dpkg -S /usr/share/bash-completion/completions/git
git: /usr/share/bash-completion/completions/git
```

古いRHELだとどうか?


# Git for Windows付属のmsys2 mingwはp11-kitが入ってない

で、オレオレ証明書を使って運営しているGitLabにhttpsでつながらない。
プライベートCAの証明書はあるのだが、update-ca-trustがp11-kitがなくて死ぬ。

pacmanも無いのでインストールできない。

あきらめて
```
git config --global http.sslVerify false
```
した。敗北だ。


# submoduleまで含めてgitリポジトリの内容をzipファイルにする

```sh
git clone hoge --recursive
# で時々↓でサブモジュールを更新して
git fetch # or `git submodule foreach git pull`
git commit -am 'hogehoge'
```
したレポジトリからzipを作る話。

```sh
pip install git-archive-all
git-archive-all my_repo.zip
```

* [submoduleまで含めてgitリポジトリの内容をzipファイルにする - Qiita](https://qiita.com/yohm/items/248fcc36707d5d3b5b86)
* [git archive export with submodules (git archive all / recursive) - Stack Overflow](https://stackoverflow.com/questions/14783127/git-archive-export-with-submodules-git-archive-all-recursive)
* [Kentzo/git-archive-all: A python script wrapper for git-archive that archives a git superproject and its submodules, if it has any. Takes into account .gitattributes](https://github.com/Kentzo/git-archive-all)

おまけ
* [git submodule はトモダチ！怖くないよ！ （チートシート付き） - エムスリーテックブログ](https://www.m3tech.blog/entry/git-submodule)


# gitでsymlinkを扱いたい

OSの違いなどを無視してsymlinkをsymlinkとして扱いたいとき。

```sh
git config --global core.symlinks true
# レポジトリごとに変更する場合は
git config core.symlinks true
git config --unset core.symlinks
# などなど
```

参考: [シンボリックリンクの使い方](https://zenn.dev/kunosu/articles/f2a459431c3a4dfc48cb)


## etckeeper

etckeeperでgitを使うなら、

```sh
sudo -i
cd /etc
git config --local core.symlinks true
```

しとくといいと思う。
