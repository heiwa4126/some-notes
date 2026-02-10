# github.com のメモ

- [GitHub のチュートリアル](#github-のチュートリアル)
- [80,443/tcp しかつながらない proxy を超えて、github に ssh でつなぐ](#80443tcp-しかつながらない-proxy-を超えてgithub-に-ssh-でつなぐ)
- [Firefox の markdown 拡張](#firefox-の-markdown-拡張)
- [release の練習](#release-の練習)
  - [タグをつける](#タグをつける)
  - [GitHub 側](#github-側)
- [GitHub から ssh 公開鍵をインポート](#github-から-ssh-公開鍵をインポート)
- [GitHub から特定のディレクトリだけダウンロード](#github-から特定のディレクトリだけダウンロード)
- [PAT(Personal Access Tokens) について](#patpersonal-access-tokens-について)
- [GitHub のレポジトリで、ブランチ名を master にしているのを main に変えるには?](#github-のレポジトリでブランチ名を-master-にしているのを-main-に変えるには)
- [GitHub のプライベートレポジトリから トークンを使って git clone する手順を教えてください](#github-のプライベートレポジトリから-トークンを使って-git-clone-する手順を教えてください)
- [GitHub CLI を使ってシークレットスキャン(secret scanning)を構築する](#github-cli-を使ってシークレットスキャンsecret-scanningを構築する)
- [GitHub のプラン](#github-のプラン)
- [自分が invite された Organizations が、GitHub のどのプランか知るには?](#自分が-invite-された-organizations-がgithub-のどのプランか知るには)
- [今月使ったリソースを確認する](#今月使ったリソースを確認する)
- ["Your main branch isn't protected" - GitHub の Branch protection rule とは](#your-main-branch-isnt-protected---github-の-branch-protection-rule-とは)
  - [**チーム開発なら追加でおすすめ**](#チーム開発なら追加でおすすめ)
  - [**その他のルールの意味(ざっくり)**](#その他のルールの意味ざっくり)
  - [GitHub でブランチ保護設定画面に行く方法](#github-でブランチ保護設定画面に行く方法)
- [Windows 上の Git Credential Manager (GCM)を WSL で使う](#windows-上の-git-credential-manager-gcmを-wsl-で使う)
- [GitHub 2FA の Recovery codes](#github-2fa-の-recovery-codes)
  - [Recovery code の取得方法](#recovery-code-の取得方法)
  - [Recovery codes の使い方](#recovery-codes-の使い方)
- [default branch 以外も fetch する](#default-branch-以外も-fetch-する)
- [アーカイブモード](#アーカイブモード)
- [ある程度作業が進んだローカルレポジトリから CLI で GitHub レポジトリを作って push する](#ある程度作業が進んだローカルレポジトリから-cli-で-github-レポジトリを作って-push-する)
- [`41898282+github-actions[bot]@users.noreply.github.com` とは何か](#41898282github-actionsbotusersnoreplygithubcom-とは何か)
- [API Rate Limit](#api-rate-limit)

## GitHub のチュートリアル

[GitHub - Microsoft Learn | Microsoft Learn](https://learn.microsoft.com/ja-jp/training/github/)

## 80,443/tcp しかつながらない proxy を超えて、github に ssh でつなぐ

公式ドキュメント: [Using SSH over the HTTPS port](https://help.github.com/articles/using-ssh-over-the-https-port/)

Linux だったら~/.ssh/config で

```config
Host ssh-github.com
     Hostname ssh.github.com
     Port 443
     User git
     Compression yes
     IdentityFile ~/.ssh/github
```

みたいな感じで(要アレンジ)。クローンするとき、
`git@github.com:heiwa4126/some-notes.git` を
`git@ssh-github.com:heiwa4126/some-notes.git` にする。

`Host ssh.github.com` はダメ。
先に`Host github.com` にマッチするみたい。

Windows だったら

- putty で"github.com"プロファイルを作る
  - port: **443**
  - host: **ssh**-github.com
  - Auto-login username: git
  - Proxy を環境に合わせて設定
  - 鍵
- Close window on Exit で Never を選んで接続することで`ssh -T git@github.com`に相当するテストを行う。

のがコツ。Repository to clone は、github の緑のボタンで出てくるやつをそのまま使える(ここだったら`git@github.com:heiwa4126/some-notes.git`で)

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

## GitHub CLI を使ってシークレットスキャン(secret scanning)を構築する

以下大嘘

1. **シークレットスキャンの有効化**:
   - GitHub CLI を使用して、リポジトリでシークレットスキャンを有効にします:

     ```bash
     gh secret scanning enable <repository-name>
     ```

   - `<repository-name>` を実際のリポジトリ名に置き換えてください。

2. **シークレットスキャンのルールの設定** (オプション):
   - 特定のファイルやディレクトリをシークレットスキャンから除外する場合は、次のようにルールを追加できます:

     ```bash
     gh secret scanning rules add <repository-name> --pattern "path/to/ignore/*"
     ```

   - `<repository-name>` を実際のリポジトリ名に置き換えてください。

3. **通知の管理** (オプション):
   - シークレットスキャンアラートの通知受信者をカスタマイズするには、次のようにチームやユーザーを追加できます:

     ```bash
     gh secret scanning recipients add <repository-name> --team "team-name"
     gh secret scanning recipients add <repository-name> --user "username"
     ```

   - `<repository-name>` を実際のリポジトリ名に置き換えてください。

## GitHub のプラン

GitHub にはさまざまなプランが用意されています。それぞれのプランは、機能や価格によって異なります。2024 年 6 月現在の情報に基づくと、以下のようなプランがあります:

1. **Free Plan**:
   - 無料。
   - パブリックおよびプライベートリポジトリの利用が可能。
   - コミュニティサポート。
   - GitHub Actions(CI/CD)には無料の分(2,000 分/月)が含まれる。
   - GitHub Packages には無料のストレージと帯域幅(500MB ストレージ、1GB の帯域幅)が含まれる。

2. **Pro Plan**:
   - 月額$4。
   - Free Plan のすべての機能に加え、より多くの GitHub Actions 分(3,000 分/月)と GitHub Packages のストレージ(2GB ストレージ、10GB の帯域幅)。
   - 高度なシークレットスキャンとコードスペースが利用可能。

3. **Team Plan**:
   - 月額$4/ユーザー。
   - Pro Plan のすべての機能に加え、チーム機能(プロジェクト管理ツール、レビューワーの自動割り当てなど)。
   - 無制限のリポジトリと 5,000 分/月の GitHub Actions。
   - ロールベースのアクセスコントロール。

4. **Enterprise Plan**:
   - 月額$21/ユーザー。
   - Team Plan のすべての機能に加え、企業向けの高度なセキュリティ機能とコンプライアンス。
   - 無制限の GitHub Actions と GitHub Packages。
   - SAML シングルサインオン (SSO)、監査ログ、IP ホワイトリストなどの追加機能。
   - 専用サポートと SLA(サービスレベルアグリーメント)。

## 自分が invite された Organizations が、GitHub のどのプランか知るには?

Organization の設定にアクセスできる管理者権限が必要。(終了)

## 今月使ったリソースを確認する

[Usage this month - Billing](https://github.com/settings/billing/summary#usage)

## "Your main branch isn't protected" - GitHub の Branch protection rule とは

GitHub の Branch protection rule は、リポジトリのブランチを保護するためのルールです。
このルールを設定することで、特定のブランチに対して、必要なレビューが完了している場合にのみマージできるようにしたり、強制プッシュを禁止したりすることができます。

[ブランチ保護ルールを管理する \- GitHub Docs](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)

プロジェクトルートに
"Your main branch isn't protected"
が出てたら

1. **「Protect this branch」**をクリック。
2. GitHub の「Branch protection rules」画面で設定

参考: [保護されたブランチの管理 - GitHub ドキュメント](https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)

ルールたくさんあるので解説(2025-11 現在)

**最低限おすすめのルール**

- ✅ **Restrict deletions**  
  → ブランチ削除を防ぐ
- ✅ **Block force pushes**  
  → 強制プッシュを防ぐ

個人開発なら、最低限これだけでも OK

### **チーム開発なら追加でおすすめ**

- ✅ **Require a pull request before merging**  
  → 直接 push 禁止、必ず PR 経由でマージ
- ✅ **Require status checks to pass**  
  → CI テストが通らないとマージできない
- ✅ **Require code scanning results**(セキュリティ重視なら)  
  → コードスキャン結果必須

### **その他のルールの意味(ざっくり)**

- **Restrict creations / updates** → 特定ユーザー以外がブランチ作成・更新できない
- **Require linear history** → マージコミット禁止(履歴を直線に保つ)
- **Require deployments to succeed** → デプロイ成功後のみマージ可能
- **Require signed commits** → 署名必須(GPG,SSH,S/MIME どれでも)
- **Require code quality results / Copilot code review** → 静的解析や AI レビューを必須にする

### GitHub でブランチ保護設定画面に行く方法

うっかり"Your main branch isn't protected"表示を消してしまった場合

1. 対象リポジトリのトップページを開く
2. 上部メニューから「Settings」をクリック
3. 左側メニューで「Branches」を選択
4. 「Branch protection rules」セクションにある「Add rule」をクリック
5. 「Branch name pattern」に main と入力し、必要な保護オプションを設定

もしメインブランチが master なら 5.では master と入力してね

で、画面変わって Target branches でデフォルトブランチを追加。
Enforcement status を Active に変更。

これでやっと完成。

## Windows 上の Git Credential Manager (GCM)を WSL で使う

まず Windows 側で GCM 入ってるか確認。

```console
PowerShell 7.5.4

ps> git --version
git version 2.52.0.windows.1

ps> git config --system credential.helper
manager

ps> git credential-manager --version
2.6.1+786ab03440ddc82e807a97c0e540f5247e44cec6
```

**重要**: **GCM が使われるのはトランスポートが https の場合のみ**

WSL の場合、Windows の EXE を起動できるので、
Windows の Git Credentials Manager (GCM)を読んで
Windows Credential Manager(Windows 資格情報マネージャー) にストアする方法がある。

あまり参考にならない: [WSL の GCM を確認して設定するコマンド](https://learn.microsoft.com/ja-jp/windows/wsl/tutorials/wsl-git#commands-to-check-and-set-up-gcm-for-wsl)

で、

`git-credential-manager.exe`
はだいたい
`C:\Program Files\Git\mingw64\bin\git-credential-manager.exe`
にあるので(**要確認**)

WSL 側で

```sh
# 確認
ls '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'

# 既存の設定を確認
git config --global --get credential.helper

# 設定
git config --global credential.helper '/mnt/c/Program Files/Git/mingw64/bin/git-credential-manager.exe'
## 設定されたことを確認
git config --global --get credential.helper
```

## GitHub 2FA の Recovery codes

まさかの時にそなえて Recovery code を取得しておきましょう

### Recovery code の取得方法

1. GitHub にログイン
2. <https://github.com/settings/auth/recovery-codes> へ移動

参考: [2 要素認証リカバリコードのダウンロード](https://docs.github.com/ja/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication-recovery-methods#downloading-your-two-factor-authentication-recovery-codes)

### Recovery codes の使い方

参考: [2 要素認証クレデンシャルをなくした際のアカウントの回復 - GitHub ドキュメント](https://docs.github.com/ja/authentication/securing-your-account-with-two-factor-authentication-2fa/recovering-your-account-if-you-lose-your-2fa-credentials)

1.  GitHub ログイン画面でユーザー名とパスワードを入力
2.  2FA コード入力画面で「Enter a recovery code」を選択
3.  保存してあるリカバリーコードのうち、**未使用の 1 つ**を入力

**注意!**

- 各コードは**一度しか使えません**。
- 使用したコードは無効になるので、残りのコードを安全な場所に保管してください
- すべて使い切った場合は、GitHub で新しいリカバリーコードを再生成できます(上の「取得方法」参照)

## default branch 以外も fetch する

GitHub から default branch を clone したあと、ほかのブランチも fetch するには?

前提として
GitHub のリポジトリを通常の git clone(--single-branch を付けない)で複製した場合:

```sh
# まず取得済みのリモートブランチ一覧を確認
git branch -r

# 特定のリモートブランチを取得
git checkout -b feature-branch origin/feature-branch
```

## アーカイブモード

古くてもうメンテしないコードは アーカイブ(Archive)モードにする。

リードオンリーになり、Issues / PR の作成や Pushができなくなる。
Dependabotも動かない。

Settings → Danger Zone → "Archive this repository"
確認ダイアログにリポジトリ名を入力して確定

## ある程度作業が進んだローカルレポジトリから CLI で GitHub レポジトリを作って push する

基本はこれ

```sh
gh repo create --public --source=. --remote=origin --push
```

ただこれだと gh が使ってるプロトコルになるので、
「gh は HTTPS だけど git push は ssh」
みたいなときは

```sh
gh repo create --public --source=. --remote=origin
git remote set-url origin git@github.com:yourGitHubUsername/repoName.git
git push origin HEAD
```

みたいにしないとダメ。

```sh
gh config set git_protocol ssh
gh repo create --public --source=. --remote=origin --push
gh config set git_protocol https
```

という手もあり。

## `41898282+github-actions[bot]@users.noreply.github.com` とは何か

まず、GitHubには noreply メールアドレスというのを各ユーザに割り振られてる
(自分のは
[Email settings](https://github.com/settings/emails)
でみられる)。

詳細: [Email addresses reference - GitHub Docs](https://docs.github.com/en/account-and-profile/reference/email-addresses-reference#your-noreply-email-address)

で、最近は `ID+USERNAME@users.noreply.github.com` という形式。

このアドレスは「メールアドレスが識別子として必要な時に使う用」で、
このアドレスに送信しても何も起きないが、
GitHubとユーザ自身はこれが誰だか知っている。

`+USERNAME` のところは**エリアスっぽく見えるけど**、
**ぜんぜんエリアスではなくて、変更できない**。

で、 `41898282+github-actions[bot]@users.noreply.github.com` は

- ユーザー名: `github-actions[bot]`
- ユーザーID: 41898282
- メールアドレス: `41898282+github-actions[bot]@users.noreply.github.com`
- 種類: GitHub App ではなく、組込みのシステムアイデンティティ(system account)

ということ。**一見あやしいアドレスに見えるが、これは本当にIDなのでそのまま使うのが正しい**。

主な GitHub System/Botアカウント:

| Bot名                    | ユーザーID | メールアドレス例                                           | 役割               |
| ------------------------ | ---------- | ---------------------------------------------------------- | ------------------ |
| `github-actions[bot]`    | `41898282` | `41898282+github-actions[bot]@users.noreply.github.com`    | GitHub Actions実行 |
| `dependabot[bot]`        | `49699333` | `49699333+dependabot[bot]@users.noreply.github.com`        | 依存関係更新PR     |
| `github-codespaces[bot]` | `61023967` | `61023967+github-codespaces[bot]@users.noreply.github.com` | Codespaces関連     |

詳しい情報はAPI経由でこんな具合に取得できます。

```bash
curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/users/github-actions%5Bbot%5D
```

↑のJSONの .html_url にアクセスすると、それぞれの紹介になってて面白いです。

## API Rate Limit

こんなエラーになる。

> 403 API rate limit of 60 still exceeded until 2026-02-10 11:41:48 +0900 JST, not making remote request. [rate reset in 13m59s]

GitHub の REST API では、

- Authorization ヘッダが無い
- OAuth / PAT / GitHub App のいずれも使っていない

この条件を満たすリクエストは、**unauthenticated request(未認証リクエスト)** として扱われる。

未認証リクエストの識別子は「送信元 IP アドレス」だけ。なので:

- 同じ IP から来た未認証リクエストは すべて同一バケット
- 別のユーザーでも、同じ NAT / Proxy / CI runner / 会社ネットワークなら 合算
- 上限は 60 requests / hour

参照: [A Developer's Guide: Managing Rate Limits for the GitHub API](https://www.lunar.dev/post/a-developers-guide-managing-rate-limits-for-the-github-api)

未認証リクエストと認証リクエストを比較してみる。

```sh
curl https://api.github.com/rate_limit | jq -S . > 1.json
gh api /rate_limit | jq  -S . > 2.json
difft 1.json 2.json
```

※ difft は [Wilfred/difftastic: a structural diff that understands syntax](https://github.com/Wilfred/difftastic)  
※ `jq -S` は「キーでソート」

出力例:

```console
$ difft 1.json 2.json
2.json --- JSON
 1 {                                          1 {
 2   "rate": {                                2   "rate": {
 3     "limit": 60,                           3     "limit": 5000,
 4     "remaining": 59,                       4     "remaining": 5000,
 5     "reset": 1770695186,                   5     "reset": 1770695534,
 6     "resource": "core",                    .
 7     "used": 1                              6     "used": 0
 8   },                                       7   },
 (以下略)
```

おまけ

```console
$ date -d @1770695186
2026年  2月 10日 火曜日 12:46:26 JST
```

(Macだったら`date -r 1770695186`)
