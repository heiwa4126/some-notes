# git メモ

- [特定のファイルを最後の commit 時に戻す](#特定のファイルを最後の-commit-時に戻す)
- [全部のファイルを最後の commit 時に戻す](#全部のファイルを最後の-commit-時に戻す)
- [git の設定をリスト](#git-の設定をリスト)
- [gitignore のデフォルト](#gitignore-のデフォルト)
- [symlink の扱い](#symlink-の扱い)
- [master to main](#master-to-main)
- [登録されているリモートリポジトリの確認](#登録されているリモートリポジトリの確認)
- [ubuntu で新しめの git を使う](#ubuntu-で新しめの-git-を使う)
- [git-secrets](#git-secrets)
  - [git-secrets の仲間](#git-secrets-の仲間)
  - [GitHub 側での対策](#github-側での対策)
- [diff を github みたくする](#diff-を-github-みたくする)
- [プロジェクトスケルトンを作るツールで、空のディレクトリに.gitkeep](#プロジェクトスケルトンを作るツールで空のディレクトリにgitkeep)
- [git のシェル補完](#git-のシェル補完)
- [Git for Windows 付属の msys2 mingw は p11-kit が入ってない](#git-for-windows-付属の-msys2-mingw-は-p11-kit-が入ってない)
- [submodule まで含めて git リポジトリの内容を zip ファイルにする](#submodule-まで含めて-git-リポジトリの内容を-zip-ファイルにする)
- [git で symlink を扱いたい](#git-で-symlink-を扱いたい)
  - [etckeeper](#etckeeper)
- [git の補完](#git-の補完)
- [git-crypt](#git-crypt)
- [Git でファイルパーミッションの変更を無視する](#git-でファイルパーミッションの変更を無視する)
- [Git で tag のとりけし](#git-で-tag-のとりけし)
  - [ローカル](#ローカル)
  - [リモート](#リモート)
- [Git の過去コミットのすべての author を書き換える](#git-の過去コミットのすべての-author-を書き換える)
- [コミットの接頭語](#コミットの接頭語)
- [git でリモートレポジトリから特定のブランチをもってくるには?](#git-でリモートレポジトリから特定のブランチをもってくるには)
  - [希望のローカルブランチが存在しない場合](#希望のローカルブランチが存在しない場合)
  - [すでにローカルブランチが存在する場合](#すでにローカルブランチが存在する場合)
- [Git で過去の特定のコミットに移動する方法いろいろ](#git-で過去の特定のコミットに移動する方法いろいろ)
- [Git で過去の特定のコミットに移動すると、必ず detached HEAD 状態になりますか?](#git-で過去の特定のコミットに移動すると必ず-detached-head-状態になりますか)
- [Windows 標準の ssh-agent を使って GitHub に ssh 接続する](#windows-標準の-ssh-agent-を使って-github-に-ssh-接続する)
- [remote から dev を持ってきてローカルの dev ブランチとして使う](#remote-から-dev-を持ってきてローカルの-dev-ブランチとして使う)

## 特定のファイルを最後の commit 時に戻す

```sh
git checkout HEAD^ -- <file_path>
```

## 全部のファイルを最後の commit 時に戻す

```sh
git reset --hard
```

## git の設定をリスト

```bash
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

の 5 通り。

git デフォルト値も出るといいなあ(好きな設定をつっこめるので、ちょっとむずかしい)

## gitignore のデフォルト

`~/.config/git/ignore`

- [Git \- gitignore Documentation](https://git-scm.com/docs/gitignore)
- [~/\.gitignore_global を指定するのをやめ、デフォルトの置き場に置こう](https://zenn.dev/qnighy/articles/1a756f2857dc20)

```sh
mkdir -p ~/.config/git/
echo '*~' >> ~/.config/git/ignore
```

Windows は? 調べる。

## symlink の扱い

[Git - git-config Documentation](https://git-scm.com/docs/git-config)の
`core.symlinks`を参照。false に設定すると(デフォルトは true)

> If false, symbolic links are checked out as small plain files that contain the link text.

うっかり巨大ファイルを symlink しても OK。
Windows で clone しても OK。

```bash
git config --global core.symlinks false
git config --local core.symlinks false
sudo git config --system core.symlinks false
```

適切な範囲で設定しておけばいい。

symlink を無視したいなら、project root で

```bash
find * -type l >> .gitignore
```

`find *`は珍しい。`find .`と比較すること。
`*`がいやなら、

```bash
find . -type l -printf '%P\n' >> .gitignore
```

で

## master to main

意外とめんどくさい

- [How to rename the "master" branch to "main" in Git | Learn Version Control with Git](https://www.git-tower.com/learn/git/faq/git-rename-master-to-main/)
- [Easily rename your Git default branch from master to main - Scott Hanselman](https://www.hanselman.com/blog/EasilyRenameYourGitDefaultBranchFromMasterToMain.aspx)
- [Git: Correct way to change Active Branch in a bare repository? - Stack Overflow](https://stackoverflow.com/questions/3301956/git-correct-way-to-change-active-branch-in-a-bare-repository)

すでに clone されてるやつのあつかいが難しい。

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

次の git からデフォルトが`main`になるらしい。

- [git/git: Git Source Code Mirror - This is a publish-only repository and all pull requests are ignored. Please follow Documentation/SubmittingPatches procedure for any of your improvements.](https://github.com/git/git)

## 登録されているリモートリポジトリの確認

```bash
git remote -v
```

`.git/conf`みるよりちょっと楽。

## ubuntu で新しめの git を使う

- [Git stable releases : “Ubuntu Git Maintainers” team](https://launchpad.net/~git-core/+archive/ubuntu/ppa)
- [Git](https://git-scm.com/download/linux)
- [Ubuntu で git のバージョンを最新版にする | Lonely Mobiler](https://loumo.jp/archives/23149)

```sh
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git
```

## git-secrets

どれだけ役立つかはよくわからないけど、後悔先に立たずだから入れとけ。

- [awslabs/git-secrets: Prevents you from committing secrets and credentials into git repositories](https://github.com/awslabs/git-secrets)
- [AWS Access Key を外部に公開してしまった話 | mediba Creator × Engineer Blog](https://ceblog.mediba.jp/post/638125766874415104/aws-access-key%E3%82%92%E5%A4%96%E9%83%A8%E3%81%AB%E5%85%AC%E9%96%8B%E3%81%97%E3%81%A6%E3%81%97%E3%81%BE%E3%81%A3%E3%81%9F%E8%A9%B1)

Ubuntu だと

```bash
sudo apt install git-secrets
```

で OK

git-secrets インストールしたら
既存または新規の git プロジェクトで

```sh
git secrets --install
git secrets --register-aws
```

参考: [git-secrets はじめました - Qiita](https://qiita.com/jqtype/items/9196e047eddb53d07a91)

でもめんどくさいので
[advanced-configuration](https://github.com/awslabs/git-secrets#advanced-configuration)
にあるように全レポジトリに設定したほうがいいとおもう。

↑ から引用

```sh
git secrets --register-aws --global
## Add hooks to all your local repositories.
git secrets --install ~/.git-templates/git-secrets
git config --global init.templateDir ~/.git-templates/git-secrets
```

既存の git をスキャンとかもできる
(
プロジェクトに移動して、
`git secrets --scan-history`
)

### git-secrets の仲間

- [thoughtworks/talisman: Using a pre-commit hook, Talisman validates the outgoing changeset for things that look suspicious — such as tokens, passwords, and private keys.](https://github.com/thoughtworks/talisman)

Git のセキュア流出防止ツールには、awslabs/git-secrets や thoughtworks/talisman 以外にもいくつかの選択肢があります。以下にいくつかの例を挙げます。

1. **Gitleaks**

   - **URL**: [https://github.com/gitleaks/gitleaks](https://github.com/gitleaks/gitleaks)
   - **概要**: Gitleaks は、秘密情報(API キーやパスワードなど)の Git リポジトリへの漏洩を防ぐためのツールです。簡単に使えるコマンドラインツールであり、CI/CD パイプラインに組み込むことができます。

2. **TruffleHog**

   - **URL**: [https://github.com/trufflesecurity/trufflehog](https://github.com/trufflesecurity/trufflehog)
   - **概要**: TruffleHog は、Git リポジトリ内の秘密情報を検出するためのツールです。特定の正規表現やエンコーディング、バイナリデータに基づいてスキャンを行います。

3. **Repo-Supervisor**

   - **URL**: [https://github.com/auth0/repo-supervisor](https://github.com/auth0/repo-supervisor)
   - **概要**: Repo-Supervisor は、GitHub リポジトリ内の秘密情報の漏洩を監視するためのツールです。スキャン結果をダッシュボードで確認でき、漏洩のリスクを可視化します。

4. **detect-secrets**

   - **URL**: [https://github.com/Yelp/detect-secrets](https://github.com/Yelp/detect-secrets)
   - **概要**: detect-secrets は、静的解析を使用して Git リポジトリ内の秘密情報を検出するためのツールです。プラグインベースであり、カスタマイズが容易です。

5. **git-secrets**(Microsoft の Fork 版)
   - **URL**: [https://github.com/microsoft/git-secrets](https://github.com/microsoft/git-secrets)
   - **概要**: awslabs/git-secrets をベースにした Microsoft のフォーク版です。追加の機能や修正が加えられています。

これらのツールは、それぞれ異なる特長や強みを持っていますので、プロジェクトや使用ケースに応じて最適なツールを選択すると良いでしょう。

### GitHub 側での対策

Git ではなく GitHub での対策

- [データ漏洩を防止する](https://docs.github.com/ja/code-security/getting-started/best-practices-for-preventing-data-leaks-in-your-organization#prevent-data-leaks)
- [データ漏洩を検出する](https://docs.github.com/ja/code-security/getting-started/best-practices-for-preventing-data-leaks-in-your-organization#detect-data-leaks)
- [データ漏洩を軽減する](https://docs.github.com/ja/code-security/getting-started/best-practices-for-preventing-data-leaks-in-your-organization#mitigate-data-leaks)
- [シークレット スキャンについて - GitHub Docs](https://docs.github.com/ja/code-security/secret-scanning/about-secret-scanning)
- [GitHub リポジトリでシークレット スキャンを構成して使用する - Training | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/modules/configure-use-secret-scanning-github-repository/)
-

## diff を github みたくする

- [unix \- ターミナルの diff で、github のように、行の中で具体的に差分がある部分に色付けをしたい \- スタック・オーバーフロー](https://ja.stackoverflow.com/questions/75829/%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E3%81%AE-diff-%E3%81%A7-github-%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB-%E8%A1%8C%E3%81%AE%E4%B8%AD%E3%81%A7%E5%85%B7%E4%BD%93%E7%9A%84%E3%81%AB%E5%B7%AE%E5%88%86%E3%81%8C%E3%81%82%E3%82%8B%E9%83%A8%E5%88%86%E3%81%AB%E8%89%B2%E4%BB%98%E3%81%91%E3%82%92%E3%81%97%E3%81%9F%E3%81%84)
- [git の diff\-highlight を使い始めた \- りんごとバナナとエンジニア](https://udomomo.hatenablog.com/entry/2019/12/01/181404)

## プロジェクトスケルトンを作るツールで、空のディレクトリに.gitkeep

ありがち

```sh
find -type d -empty | xargs -i{} touch {}/.gitkeep
```

TODO:「空でなくなったディレクトリにある.etckeep を消す」も。

## git のシェル補完

[git/contrib/completion at master · git/git](https://github.com/git/git/tree/master/contrib/completion)

Ubuntu だと git パッケージに最初から入ってた。

```terminal
$ dpkg -S /usr/share/bash-completion/completions/git
git: /usr/share/bash-completion/completions/git
```

古い RHEL だとどうか?

## Git for Windows 付属の msys2 mingw は p11-kit が入ってない

で、オレオレ証明書を使って運営している GitLab に https でつながらない。
プライベート CA の証明書はあるのだが、update-ca-trust が p11-kit がなくて死ぬ。

pacman も無いのでインストールできない。

あきらめて

```bash
git config --global http.sslVerify false
```

した。敗北だ。

## submodule まで含めて git リポジトリの内容を zip ファイルにする

```sh
git clone hoge --recursive
## で時々↓でサブモジュールを更新して
git fetch # or `git submodule foreach git pull`
git commit -am 'hogehoge'
```

したレポジトリから zip を作る話。

```sh
pip install git-archive-all
git-archive-all my_repo.zip
```

- [submodule まで含めて git リポジトリの内容を zip ファイルにする - Qiita](https://qiita.com/yohm/items/248fcc36707d5d3b5b86)
- [git archive export with submodules (git archive all / recursive) - Stack Overflow](https://stackoverflow.com/questions/14783127/git-archive-export-with-submodules-git-archive-all-recursive)
- [Kentzo/git-archive-all: A python script wrapper for git-archive that archives a git superproject and its submodules, if it has any. Takes into account .gitattributes](https://github.com/Kentzo/git-archive-all)

おまけ

- [git submodule はトモダチ!怖くないよ! (チートシート付き) - エムスリーテックブログ](https://www.m3tech.blog/entry/git-submodule)

## git で symlink を扱いたい

OS の違いなどを無視して symlink を symlink として扱いたいとき。

```sh
git config --global core.symlinks true
## レポジトリごとに変更する場合は
git config core.symlinks true
git config --unset core.symlinks
## などなど
```

参考: [シンボリックリンクの使い方](https://zenn.dev/kunosu/articles/f2a459431c3a4dfc48cb)

### etckeeper

etckeeper で git を使うなら、

```sh
sudo -i
cd /etc
git config --local core.symlinks true
```

しとくといいと思う。

## git の補完

.bashrc に

```bash
source /usr/share/bash-completion/completions/git
```

で。

## git-crypt

機密情報も版管理したい。

透過的に GPG で暗号化するやつ:
[AGWA/git\-crypt: Transparent file encryption in git](https://github.com/AGWA/git-crypt)

GPG キーが有るのが前提で。
Ubuntu だとパッケージがあった `sudo apt install git-crypt`

```bash
mkdir repo1 && cd repo1
git init
git config user.email "foo@exampe.com"  # 自分のメールアドレスに変更
git config user.name "foo bar"   # 自分の名前に変更
git config init.defaultBranch main
echo "Hello world" > plain.txt
echo "super secret" > secret.txt
git-crypt init
git-crypt add-gpg-user "foo@exampe.com"  # 自分のメールアドレスに変更
echo "secret.txt filter=git-crypt diff=git-crypt" >> .gitattributes
git add --all
git commit -am initial
```

これで元のレポジトリができたので

```bash
cd ..
git clone repo1 repo1-clone
cd repo1-clone
```

ここで `secret.txt`がバイナリなら OK。で

```bash
git-crypt unlock
```

すると GPG のキーを聞いてくるので入力すると復号される。

これでとりあえず当人は OK。
別のユーザにも共有作業させたかったら `git-crypt add-gpg-user` すればいいのか?

`.gitattributes` にファイルとかディレクトリまるごと追加するコマンドがほしい。

↑ これは GitHub にサンプルがあった。

```conf
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
secretdir/** filter=git-crypt diff=git-crypt
```

## Git でファイルパーミッションの変更を無視する

Linux と Windows で git で作業してるときに。Windows 側で

```bash
git config core.filemode false
# ついでに
git config --global core.filemode false
# 確認
git config -l | select-string filemode
# select-stringはpowershellのgrep
```

- [Git でファイルパーミッションの変更(chmod)を無視する \- git config core\.filemode false](https://blog.t5o.me/post/20121119/git-chmod-git-config-core-filemode.html)

## Git で tag のとりけし

`v1.0.0` というタグを取り消すとする。

### ローカル

```bash
# 現状を表示
git --no-pager tag
# タグの削除
git tag -d v1.0.0
# 確認
git --no-pager tag
```

### リモート

```bash
# 現状を表示
git ls-remote --tags
# タグの削除
git push origin :refs/tags/v1.0.0
# 確認
git ls-remote --tags
```

## Git の過去コミットのすべての author を書き換える

いろいろあって。

```bash
git rebase -i --root -x 'git commit --amend --author="新しい作者名 <新しい作者メールアドレス>" -C HEAD'
```

エディタが開いて実行されるコマンドがレビューされるので、そのまま保存すれば実行される。

## コミットの接頭語

[WIP とは何か?(ウィップ、プログラミング用語)| Github の便利なログ管理方法](https://prograshi.com/general/git/wip/) からコピペ

| 接頭語 | 意味                                                                                   |
| :----: | :------------------------------------------------------------------------------------- |
|  [F]   | Fix。バグ修正                                                                          |
|  [A]   | Add。新規追加                                                                          |
|  [U]   | Update。機能修正                                                                       |
|  [R]   | Remove。削除                                                                           |
| [WIP]  | Work In Progress。作業中                                                               |
|  [US]  | Update Submodule。サブモジュールのアップデート。中に対象のサブモジュール名や内容を記載 |

## git でリモートレポジトリから特定のブランチをもってくるには?

```sh
git branch -a
```

でブランチを確認の後

### 希望のローカルブランチが存在しない場合

```sh
git checkout -b ローカルブランチ名 remotes/origin/リモートブランチ名
```

(remotes/origin のところは適切に書き換える)

ローカルブランチ名 と リモートブランチ名が同一な場合は

```sh
git checkout -t origin/ブランチ名
```

### すでにローカルブランチが存在する場合

```sh
# ローカルブランチ名 と リモートブランチ名が異なる場合は
git checkout ローカルブランチ名
git pull origin リモートブランチ名
# ローカルブランチ名 と リモートブランチ名が同一な場合は
git checkout ブランチ名
git pull
```

## Git で過去の特定のコミットに移動する方法いろいろ

Git で特定のコミットに移動するには、以下の方法があります。

1. **コミットハッシュ値を使う方法**

   各コミットには一意のハッシュ値が割り当てられています。このハッシュ値を使って特定のコミットに移動できます。

   ```sh
   git checkout コミットハッシュ値
   ```

   例えば `abcdef0123` がコミットハッシュ値の場合:

   ```sh
   git checkout abcdef0123
   ```

2. **HEAD 相対参照を使う方法**

   `HEAD`はカレントコミットを指しています。`HEAD`からの相対位置を指定すること で、特定のコミットに移動できます。

   ```sh
   git checkout HEAD~n  # n個前のコミットに移動
   git checkout HEAD^n  # n個目の親コミットに移動
   ```

   例えば 3 つ前のコミットに移動する場合:

   ```sh
   git checkout HEAD~3
   ```

3. **ブランチ名を使う方法**

   特定のブランチ上のコミットに移動したい場合は、そのブランチ名を指定します。

   ```sh
   git checkout ブランチ名
   ```

4. **タグを使う方法**

   あらかじめタグを付けておけば、そのタグ名を指定してコミットに移動できます。

   ```sh
   git checkout タグ名
   ```

   移動先のコミットがデタッチド HEAD の状態になるので、作業ブランチを作成する場 合は以下のようにします。

   ```sh
   git checkout -b 新しいブランチ名 コミット参照
   ```

このように、Git にはコミットを指定する様々な方法があります。状況に応じて適切な方法を使い分けましょう。

## Git で過去の特定のコミットに移動すると、必ず detached HEAD 状態になりますか?

Git で過去の特定のコミットに移動すると、通常はデタッチド HEAD 状態になります。デタッチド HEAD 状態とは、ブランチではなく特定のコミットに HEAD が直接指している状態を指します。

ただし、過去のコミットが現在のブランチの最新コミットである場合、または過去のコミットに既にブランチが存在していてそのブランチにチェックアウトした場合は、デタッチド HEAD 状態にはなりません。

デタッチド HEAD 状態で作業を行い、その結果を保存したい場合は、新しいブランチを作成することで可能です。これは以下のコマンドで行うことができます:

```sh
git checkout -b 新しいブランチ名
# 新しめのやりかた
git switch -c 新しいブランチ名
```

もちろん時と場合によっては既存のブランチにチェックアウトしてもいい。

## Windows 標準の ssh-agent を使って GitHub に ssh 接続する

GitHub の ssh 秘密鍵が
`C:\Users\foobar\.ssh\github\github`
にあるとして

管理者権限の Powershell で

```powershell
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
Get-Service ssh-agent

ssh-add C:\Users\foobar\.ssh\github\github
ssh-add -l

notepad $ENV:UserProfile/.ssh/config
```

ssh_config にこんな記述を追加

```config
Host github.com
    User git
    HostName github.com
    Port 22
    IdentityFile C:\Users\foobar\.ssh\github\github
```

接続確認

```console
PS C:> ssh github.com -T

Hi foobar! You've successfully authenticated, but GitHub does not provide shell access.
```

(-T は仮想端末なしオプション)

最後に Git の設定

```powershell
git config --global core.sshCommand "'C:/Windows/System32/OpenSSH/ssh.exe'"
```

これで毎回パスフレーズを入れずに GitHub につながる。

## remote から dev を持ってきてローカルの dev ブランチとして使う

```console
$ git branch --all

* main
remotes/origin/dev
remotes/origin/main
```

のとき remotes/origin/dev を持ってきて、ローカルの dev ブランチにするには

```sh
git fetch origin dev:dev
```

- リモートの dev ブランチをフェッチ
- ローカルに dev ブランチを作成
- フェッチしたリモートの dev ブランチの内容をローカルの dev ブランチに反映

をいっぺんに行う。
