# github.com のメモ

- [github.com のメモ](#githubcom-のメモ)
  - [80,443/tcp しかつながらない proxy を超えて、github に ssh でつなぐ](#80443tcp-しかつながらない-proxy-を超えてgithub-に-ssh-でつなぐ)
  - [Firefox の markdown 拡張](#firefox-の-markdown-拡張)
  - [release の練習](#release-の練習)
    - [タグをつける](#タグをつける)
    - [GitHub 側](#github-側)
  - [GitHub から ssh 公開鍵をインポート](#github-から-ssh-公開鍵をインポート)
  - [GitHub から特定のディレクトリだけダウンロード](#github-から特定のディレクトリだけダウンロード)
  - [GitHub の Branch protection rule とは](#github-の-branch-protection-rule-とは)
  - [PAT(Personal Access Tokens) について](#patpersonal-access-tokens-について)
  - [GitHub のレポジトリで、ブランチ名を master にしているのを main に変えるには?](#github-のレポジトリでブランチ名を-master-にしているのを-main-に変えるには)
  - [GitHub のプライベートレポジトリから トークンを使って git clone する手順を教えてください](#github-のプライベートレポジトリから-トークンを使って-git-clone-する手順を教えてください)

## 80,443/tcp しかつながらない proxy を超えて、github に ssh でつなぐ

公式ドキュメント: [Using SSH over the HTTPS port](https://help.github.com/articles/using-ssh-over-the-https-port/)

Linux だったら~/.ssh/config で

```conf
Host github.com
     # Hostname github.com
     # Port 22
     Hostname ssh.github.com
     Port 443
     User git
     Compression yes
     IdentityFile ~/.ssh/github
     ProxyCommand  /usr/bin/connect-proxy -H 111.222.333.444:3128 %h %p
```

みたいな感じで(要アレンジ)。

Windows だったら

- putty で"github.com"プロファイルを作る
  - port: **443**
  - host: **ssh**.github.com
  - Auto-login username: git
  - Proxy を環境に合わせて設定
  - 鍵
- Close window on Exit で Never を選んで接続することで`ssh -T git@github.com`に相当するテストを行う。

のがコツ。Repositry to clone は、github の緑のボタンで出てくるやつをそのまま使える(ここだったら`git@github.com:heiwa4126/some-notes.git`で)

## Firefox の markdown 拡張

- [Copy as Markdown - Get this Extension for 🦊 Firefox (ja)](https://addons.mozilla.org/ja/firefox/addon/copy-as-markdown/)

## release の練習

### タグをつける

```bash
# まずコミットする
git commit -a -m "First release"
git push

# tagをつける
git tag v0.0.1

# ローカルでつけたタグを全てリモートに反映させる
git push --tags
```

間違えると取り消すのが結構めんどくさいので慎重に。

おまけ:

```bash
# tag一覧
git tag -n

# タグの削除(ローカル)
git tag -d tag名

# さらにタグの削除(リモート)
git push :タグ名
```

### GitHub 側

- [リリースの作成 - GitHub ヘルプ](https://help.github.com/ja/articles/creating-releases)
- [Github - Tag の付け方と Release 機能の使い方 | Howpon[ハウポン]](https://howpon.com/7676)
- [GitHub のリリース機能を使う - Qiita](https://qiita.com/todogzm/items/db9f5f2cedf976379f84)

要点メモ:

1. release のリンクから
2. Draft a new release ボタン
3. バージョン入れて、フォームを埋める。
4. Attach binaries のところへバイナリをドラッグ&ドロップ

CLI があると楽なんだが...
REST API はある。[Create a release](https://developer.github.com/v3/repos/releases/#create-a-release)

goreleaser:

- [goreleaser を使って Github Releases へ簡単デプロイ #golang - Qiita](https://qiita.com/ynozue/items/f939cff562ec782b33f0)
- [GoReleaser](https://goreleaser.com/)
- [goreleaser/goreleaser: Deliver Go binaries as fast and easily as possible](https://github.com/goreleaser/goreleaser)

## GitHub から ssh 公開鍵をインポート

GitHub の公開鍵は `https://github.com/ユーザ名.keys` で公開されているので curl かなんかで>>すればいいけど、専用のコマンドもある。

[Ubuntu Manpage: ssh-import-id - retrieve one or more public keys from a public keyserver and append them](http://manpages.ubuntu.com/manpages/xenial/man1/ssh-import-id.1.html)

> ssh-import-id-gh USER_ID_1 [USER_ID_2] ... [USER_ID_n]

GitHub の ssh キーの操作は以下参照

- [GitHub アカウントへの新しい SSH キーの追加 - GitHub Docs](https://docs.github.com/ja/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
- [SSH and GPG keys](https://github.com/settings/keys)

## GitHub から特定のディレクトリだけダウンロード

全部を clone するのは辛いとき。

- [git - How to download a folder from github? - Stack Overflow](https://stackoverflow.com/questions/33066582/how-to-download-a-folder-from-github) - svn を使う方法と tarball で一部取り出す方法
- [git - Download a single folder or directory from a GitHub repo - Stack Overflow](https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo) - ブラウザが使えるならツールもある

## GitHub の Branch protection rule とは

GitHub の Branch protection rule は、リポジトリのブランチを保護するためのルールです。
このルールを設定することで、特定のブランチに対して、必要なレビューが完了している場合にのみマージできるようにしたり、強制プッシュを禁止したりすることができます。

[ブランチ保護ルールを管理する \- GitHub Docs](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)

## PAT(Personal Access Tokens) について

今のところ 2 種類ある。

- [Personal Access Tokens (Classic)](https://github.com/settings/tokens)
- [Fine-grained Personal Access Tokens](https://github.com/settings/tokens?type=beta)

Fine-grained Personal Access Tokens (「きめ細かい個人用アクセストークン」) の方はベータ(2024-04 現在)

[personal access token の種類](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-token-%E3%81%AE%E7%A8%AE%E9%A1%9E) 参照。

"Repository access" が追加されて

- **All repositories** - すべてのリポジトリに対する権限が付与されます。
- **Only select repositories** - 特定のリポジトリのみに権限を与えることができます。リポジトリを個別に選択する必要があります。
- **No repositories** - リポジトリに対する権限はありません。

の 3 種類が選べる。

Personal Access Tokens (Classic) の
スコープは [OAuth アプリのスコープ - GitHub Docs](https://docs.github.com/ja/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps#available-scopes)

こっちのほうがわかりやすくない?

## GitHub のレポジトリで、ブランチ名を master にしているのを main に変えるには?

```sh
# ローカルリポジトリで作業ブランチを切り替える
git checkout -b main
# リモートにmainブランチを作成する
git push -u origin main
```

次に、GitHub のリポジトリページで、Settings の Default branch で値を main に変更し、更新ボタンを押す。詳しくは [デフォルトブランチを変更する](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch#changing-the-default-branch) 参照

```sh
# ローカルのmasterブランチを削除する(オプション)
git branch -d master
```

あとは他の developers に通知しておしまい。

## GitHub のプライベートレポジトリから トークンを使って git clone する手順を教えてください

(未チェック。あとで試す)

GitHub のプライベートリポジトリからクローンするには、以下の手順を実行します。

1. **パーソナルアクセストークンの作成**

   - GitHub にログインし、設定 > Developer settings > Personal access tokens に移動します。
   - "Tokens (classic)" セクションで "Generate new token" をクリックします。
   - トークンの名前を入力し、必要なスコープ (repo の場合は repo にチェックを入れる) を選択して "Generate token" をクリックします。

2. **リポジトリのクローン**

   - コマンドラインで作業ディレクトリに移動します。
   - 以下のコマンドを実行してリポジトリをクローンします。

   ```sh
   git clone https://github.com/ユーザー名/リポジトリ名.git
   ```

   - ユーザー名とリポジトリ名は、実際のユーザー名とリポジトリ名に置き換えてください。
   - プロンプトでユーザー名を求められたら、ユーザー名の代わりにトークンを入力します。
   - トークンは表示されないので、コピー&ペーストして Enter キーを押します。

3. **クローンの確認**
   - リポジトリがクローンされたことを確認するには、作業ディレクトリに移動し中身を確認します。

これで GitHub のプライベートリポジトリのクローンが完了します。トークンは大切に扱い、第三者に共有しないよう注意してください。
