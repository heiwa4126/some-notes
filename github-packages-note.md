# GitHub Packages

「パッケージリポジトリ」または「アーティファクトリポジトリ」。

似たサービスには

- Azure Artifacts
  - [Publish and download npm packages - Azure Artifacts | Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/artifacts/get-started-npm?view=azure-devops&tabs=Windows)
- AWS CodeArtifact
  - [Getting started with CodeArtifact - CodeArtifact](https://docs.aws.amazon.com/jp_ja/codeartifact/latest/ug/getting-started.html)
  - [CodeArtifact を npm で使用する - CodeArtifact](https://docs.aws.amazon.com/ja_jp/codeartifact/latest/ug/using-npm.html)
- GitLab Package Registry
  - [GitLab Package Registry administration | GitLab](https://docs.gitlab.co.jp/ee/administration/packages/)
- NPM private packages
  - [Creating and publishing private packages | npm Docs](https://docs.npmjs.com/creating-and-publishing-private-packages)
  - [About private packages | npm Docs](https://docs.npmjs.com/about-private-packages)
- Artifact Registry (Google)
- JFrog Artifactory

などがある。

## 認証

- パブリックにできる。 `npm i github:foo/bar` で他の設定不要で @foo/bar パッケージが入れられる。
  - `npm i https://github.com/foo/bar` でも OK だけど、package.json には全部 `git+ssh:` になる。
- プライベートのままでも ssh 経由でつながるなら `npm i github:foo/bar` で行ける。
- .npmrc と token つかえば、プライベートでだろうがなんだろうが OK

`github:` スキーマは `git+ssh://git@github.com/` と同値らしい。

参照: [npm-install | npm Docs](https://docs.npmjs.com/cli/v9/commands/npm-install)

## ドキュメント

[GitHub Packages のドキュメント - GitHub Docs](https://docs.github.com/ja/packages)

## 重要

GitHub Packages で作ったパッケージを使うには、
元のレポジトリがパブリックでもプライベートでも、
personal access token (classic) の認証が必要。

## チュートリアルやってみる

- [GitHub Packages のクイックスタート - GitHub Docs](https://docs.github.com/ja/packages/quickstart)

personal access token のところは公式の解説がわかりにくい

- [個人用アクセス トークンを管理する - GitHub Docs](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [GitHub Packages を使って自作ライブラリを管理しよう｜エンジニアファースト](https://engineer-first.net/create-github-packages)
- [Personal access tokens \(classic\)](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-tokens-classic)
  [personal access token \(classic\) の作成](https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-token-classic-%E3%81%AE%E4%BD%9C%E6%88%90)

## GitHub Packages 用の PAT (Personal Access Tokens (Classic)) を作る

1. GitHub の [Personal Access Tokens (Classic)](https://github.com/settings/tokens) へ行く。
1. 上のプルダウンで "Generate new token (classic)" を設定

1. - Note: Read Packages
   - Expiration: とりあえずデフォルトの "30 days" で (お好みで)
   - Select scopes: read:packages のみ

1. 一番下の "Generate token" ボタン

で、Personal Access Token (classic) トークンが表示されたところで

### オーガニゼーションだと、ひとてま必要

上記に加えて以下の作業が必要:

Personal Access Token (classic) のトークンが表示されたところで(後からでもできる)

1. トークンの横に "Configure SSO" のプルダウンが出るので、対象のオーガニゼーションの横の "Authorize" を押す。
2. "Credential authorized to access <オーガニゼーション>" が表示される。

## で、パッケージを使うプロジェクトで

プロジェクトのルートの.npmrc に

```config
@SCOPE:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=例のトークン
```

を追加する。.npmrc はいろいろなところに置けるので、状況によって場所を変える。

「例のトークン」は一応機密情報なので
プロジェクトルートに .npmrc を置く場合、

- .gitignore に .npmrc を書く
- `chmod og= .npmrc` する

`@SCOPE:registry` のところは
`@SCOPE/package-name:registry` のようにパッケージまで指定もできる。嘘かも

### npmrc の場所について

npmrc の場所は以下の順で検索されます。

1. プロジェクトの `.npmrc` ファイル
2. `$PREFIX/etc/npmrc`
3. `$PREFIX/npmrc`
4. グローバル `~/.npmrc`

参照: [npmrc | npm Docs](https://docs.npmjs.com/cli/v10/configuring-npm/npmrc)

## リンク

- [GitHub Packages を使用して private な npm パッケージとして公開する](https://zenn.dev/052hide/articles/github-packages-npm-052hide)
- [GitHub Packages で npm パッケージを公開してみた - あしたのチーム Tech Blog](https://engineer.ashita-team.com/entry/test-github-packages)
- [Node.js パッケージの公開 - GitHub Docs](https://docs.github.com/ja/actions/publishing-packages/publishing-nodejs-packages)

## GitHub Packages つかいかた

(未整理)

1. package.json ファイルに publishConfig セクションを追加します。このセクションでは、パッケージを公開するレジストリとして GitHub Packages を指定します:

   ```json
   "publishConfig": {
      "registry":"https://npm.pkg.github.com/"
   }
   ```

1. GitHub のユーザ名をパッケージ名の前に追加します(name フィールド)。例えば、あなたの GitHub ユーザ名が `heiwa4126` であれば:

   ```json
   "name": "@heiwa4126/npm-hello0-ts",
   ```

1. パッケージを公開します。まず、GitHub のパーソナルアクセストークンを使用して npm にログインします:

   ```sh
   npm login --registry=https://npm.pkg.github.com/
   ```

1. 次に、パッケージを公開します:

   ```sh
   npm publish
   ```

これらの手順を実行すると、パッケージは GitHub Packages に公開されます。

### GitHub Packages で公開したパッケージをインストールする方法は?

(ここも未整理)

1. .npmrc ファイルをプロジェクトのルートディレクトリに作成します(すでに存在する場合はそのまま使用します)。このファイルには、パッケージをインストールするレジストリとして GitHub Packages を指定します:

   ```config
   @heiwa4126:registry=https://npm.pkg.github.com/
   ```

   ここで、`@heiwa4126` はあなたの GitHub ユーザ名です。

1. 次に、通常の npm install コマンドを使用してパッケージをインストールします:

   ```sh
   npm install @heiwa4126/npm-hello0-ts
   ```

これにより、GitHub Packages からパッケージがインストールされます。

### GitHub Package のリポジトリが private な場合はどうしますか?

GitHub Packages のリポジトリがプライベートの場合でも、パッケージをインストールすることは可能です。ただし、そのためには GitHub のパーソナルアクセストークンが必要となります。このトークンは、パッケージを読み取る権限を持つ必要があります。

以下の手順でパッケージをインストールします:

1. GitHub でパーソナルアクセストークンを生成します。これは [GitHub の設定ページ](https://github.com/settings/tokens) から行うことができます。トークンには read:packages のスコープを含める必要があります。

2. 生成したトークンを使用して、npm にログインします:

   ```sh
   npm login --registry=https://npm.pkg.github.com/ --scope=@heiwa4126
   ```

   ここで、`@heiwa4126` はあなたの GitHub ユーザ名です。プロンプトが表示されたら、GitHub のユーザ名とパーソナルアクセストークンを入力します。

3. 通常の npm install コマンドを使用してパッケージをインストールします:

   ```sh
   npm install @heiwa4126/npm-hello0-ts
   ```

これにより、プライベートな GitHub Packages からパッケージがインストールされます。
