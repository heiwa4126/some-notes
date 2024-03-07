# GitHub Enterprise のメモ

やっぱり有料プランはすごいや。

## GitHub Actions が早い

Free プランに比べて全然早い

## private レポジトリで GitHub Pages が使える

しかも組織の認証付きになる。

URL は普通は自動生成で乱数っぽい名前になる。
DNS 持ってれば名前はなんとかなりそう。後で試す。

## release にも認証が

GitHub Enterprise の private レポジトリで GitHub Actions で生成したリリースがあります。
このリリースに含まれるバイナリをダウンロードする場合、
ブラウザだと組織メンバーでログインすればダウンロードできます。

## ↑ CLI ではどうですか?

(試してない。以下 Bing Copilot の生成)

GitHub Enterprise のプライベートリポジトリから GitHub Actions で生成されたリリースのバイナリを CLI でダウンロードすることは可能です。
以下の手順を参考にしてください。

1. **GitHub App の作成**:
   - GitHub App を作成します。[こちらのドキュメント](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app)に従って GitHub App を作成してください。
   - **Repository Permissions** で、ダウンロードするための権限を有効化します。具体的には、**Contents** を **Read-only** に設定してください(自動的に **Metadata** も **Read-only** になります)。
   - 作成した GitHub App から **Generate a private key** をクリックして、プライベートキーを作成します。
2. **GitHub App のインストール**:
   - 作成した GitHub App を対象のリポジトリにインストールします。
   - **Only select repositories** を選択し、ダウンロード対象のリポジトリと、ダウンロードするリポジトリの 2 つを選択します。
3. **Repository secrets の設定**:
   - 作成した GitHub App のページにある **App ID** と、ダウンロードしたプライベートキーを使って、以下の 2 つの **Repository secret** を設定します。
     - `APP_ID`
     - `APP_PRIVATE_KEY`
4. **GitHub Actions の設定**:
   - `.github/workflows` ディレクトリに任意の名前の Workflow ファイルを追加します。
   - 以下のように GitHub Apps によるトークンの発行と Release ページからのダウンロードを行います。注意点として、`actions/create-github-app-token` の `owner` と `repositories` を設定しないと、Release ページからダウンロードできる権限があるトークンが発行されません。

```plaintext
name: Download Release Binary

on:
  pull_request:
    types:
      - opened
      - synchronize

jobs:
  download-binary:
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          ref: ${{ github.event.pull_request.head.sha }}

      - name: Generate GitHub App token
        id: generate_token
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}
          owner: ${{ github.repository_owner }}
          repositories: "your-repo-name"

      - name: Download latest binary
        uses: dsaltares/fetch-gh-release-asset@1.1.1
        with:
          repo: your-org/your-repo
          version: latest
          file: your-binary-file.tar.gz
          token: ${{ steps.generate_token.outputs.token }}

      - name: Extract binary
        run: tar -xvf your-binary-file.tar.gz
```

[この設定を使えば、CLI から GitHub Enterprise のプライベートリポジトリのリリースバイナリをダウンロードできます。](https://zenn.dev/takashicc/articles/3d7d556d55fc22)

RAG の元:

- [GitHub Action で GitHub Organization 内にあるプライベートリポジトリの Release を取得する](https://zenn.dev/takashicc/articles/3d7d556d55fc22)
