# GitHub Pages のメモ

## GitHub Pages は free のレポジトリと Enterprise で違う構造の URL に発行されるみたい

実際に試したところ

- free - `https://{GitHubID}.github.io/{RepositoryName}/`
- Enterprise - `https://{randomName}.github.io/`

になりました。

free と Enterprise で同じ形式にすることはできないらしい。
→ できないわけじゃないのだが、なんかややこしい... このへん [カスタムドメインと GitHub Pages について - GitHub Docs](https://docs.github.com/ja/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages)

### どうもさらにややこしいらしい

- ユーザーサイト(組織サイト)　(`https://<username>.github.io` または `https://<organization>.github.io`)
- プロジェクトサイト

の 2 種類があるらしい。

## サブディレクトリでないところに発行はできる?

GitHub Pages は `https://<user name>.github.io/<repository name>/` という形式の URL になりますが、
サブディレクトリに配置するのはいろいろ面倒なことが多いです。

- `https://<repository name>.<user name>.github.io/`
- または `https://<user name>.<repository name>.github.io/`

のような形式にできませんか?

答え: **できません**

ただし
[GitHub Pages サイトのカスタムドメインを設定する - GitHub Docs](https://docs.github.com/ja/pages/configuring-a-custom-domain-for-your-github-pages-site)
で出来るらしい。→ あっさり出来た。

上の公式ドキュメントはわけがわからないけど
