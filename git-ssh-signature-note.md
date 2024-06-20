# Git のコミットに ssh 署名するメモ

[コミット署名の検証について - GitHub Docs](https://docs.github.com/ja/authentication/managing-commit-signature-verification/about-commit-signature-verification)
あたりの話を ssh 署名でやってみる。

GPG で署名するのはけっこう面倒

- 準備がめんどう
- キーサーバーが keyserver.ubuntu.com ぐらいしか生きてない

ssh なら

- ssh はすでに設定済みだろ
- 公開鍵は <https://github.com/{GitHub_ID}.keys> で取れる。

## 先に注意

git のコミット署名では
「改ざんの検知」はできるけど
「改ざんを防止」はできません。

たとえば git は、過去コミットの Author と Committer を全部置き換えることができますが、これをコミット署名で防ぐことはできません。

## まず git 周り

```sh
git init
# git config は `-g`オプション付きでグローバルにやってもいい
git config user.email "foo@example.com"
git config user.name "Foo Bar"
git config commit.gpgsign true  # これ設定せずに `git commit -S` -Sオプション付きコミットしてもいいけど絶対忘れるので
git config tag.gpgsign true     # これ設定せずに `git tag -s` -sオプション付きでタグしてもいいけど絶対忘れるので
git config gpg.format ssh
git config user.signingkey {Foo BarさんのGitHubの**公開鍵ファイル**のパス}
```

で、あとで `git log --show-signature` などで
ローカルで署名確認できるように
(確認しないならこのへんは飛ばしていい。けど確認するよね?)

```sh
touch ~/.ssh/allowed_signers
chmod og= ~/.ssh/allowed_signers
git config gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

`~/.ssh/allowed_signers` の書式は 1 行づつ

```text
{GitHub_ID} {←そのひとの公開鍵}
```

みたいに書く。git が署名確認に使う名前空間は"git"なので、`namespaces="git"`を書いてもいい。
`namespaces`の最後の`s`に注意(複数形)。カンマ区切りで複数書けるらしい。

`~/.ssh/allowed_signers` の例

```text
# format: <principals> <options> <keytype> <base64-encoded key>
foobar namespaces="git" ssh-ed25519 AAA...
xyzzy ssh-rsa AAA...
```

コラボレータの公開鍵を
<https://github.com/{GitHub_ID}.keys>
から取得して追加しておくといいでしょう。

allowed_signers ファイルの書式については以下参照:

- [ALLOWED SIGNERS - ssh-keygen(1) - OpenBSD manual pages](https://man.openbsd.org/ssh-keygen.1#ALLOWED_SIGNERS)
- [SSH キーを使ったコミットへの署名 | GitLab](https://gitlab-docs.creationline.com/ee/user/project/repository/ssh_signed_commits/)

## commit してみる

であとは普通に

```sh
git commit -am 'hoge'
git commit -S -am 'huga'  # `git config commit.gpgsign true` しなかった場合
```

して

```sh
git log --show-signature
# or
git show --show-signature {COMMITハッシュ値とか `HEAD` とか `main`とか}
```

で確認できる。

```console
$ git show --show-signature HEAD

commit 6a265173862f1db58d786aafdb8089ffe7ad4e52 (HEAD -> main)
Good "git" signature for foobar with ED25519 key SHA256:ebrCy5yXjtY/CCV21WtQdrZ0sH3zZXXIsi4OszutgsM
Author: Foo Bar <foo@example.com>
Date:   Wed Jun 19 13:41:15 2024 +0900

    add test1.txt

diff --git a/test1.txt b/test1.txt
new file mode 100644
index 0000000..e69de29
```

`Good "git" signature for ...` のあたりは青い色

署名なしだと、signature for の行が表示されない。

## GitHub 側の設定

[Add new SSH key](https://github.com/settings/ssh/new)
で、
"New SSH key"ボタンを押して、
**"Key type" を "Signing key"にして**
コミット署名に使った公開鍵を追加しておきます。

これで GitHub 上のレポジトリのコミットに
緑色の"Verified"マークがつくようになります。

あと
[警戒モードの有効化 - すべてのコミットの検証ステータスを表示する - GitHub Docs](https://docs.github.com/ja/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits#enabling-vigilant-mode)

## おまけ: Depandabot は GPG 署名なので

`git log --show-signature` の時に
Depandabot のプルリクエストをマージしたコミットで
エラーが表示される。
GPG キーをキーサーバから持ってくる。

(GPG のインストールや初期設定は省略)

```sh
gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys B5690EEEBB952194
gpg --edit-key B5690EEEBB952194
# trust, 5, y, q
```

### GPG Key ID: B5690EEEBB952194 について

レポジトリで
`git log --show-signature` すると
Depandabot のプルリクエストをマージしたコミットで
`gpg: using RSA key B5690EEEBB952194`
が見れる。

また GitHub の WebUI でも

1. DepnadaBot をマージしたことがあるレポジトリへ行く。
2. 緑の「Code ▼」ボタンの下にある "99 Commits" をクリックして、コミット履歴を表示させる。
3. DepnadaBot のコミットの "Verified"マークをクリックする。
4. `GPG Key ID: B5690EEEBB952194` と書かれている

のように確認できる。

なおこの辺の記事にあるキー 4AEE18F83AFDEB23 は期限切れ。

- [11. How to Import the Dependabot GPG Public Key](https://secure-git.guide/011_How-to-import-the-dependabot-gpg-public-key)
- [github.com/web-flow.gpg](https://github.com/web-flow.gpg)

## おまけ: 過去コミットの Author と Committer を全部置き換えるスクリプト

上のほうで話題にした
過去コミットの Author と Committer を全部置き換える shell スクリプトです.

```sh
git filter-branch --env-filter '
NEW_NAME="Foo Bar"
NEW_EMAIL="foo@exaple.com"
export GIT_COMMITTER_NAME="$NEW_NAME"
export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
export GIT_AUTHOR_NAME="$NEW_NAME"
export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
' --tag-name-filter cat -- --branches --tags
```

NEW_NAME, NEW_EMAIL のところは置き換えて実行して下さい。
