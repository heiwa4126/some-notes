# GitHub Pages のメモ

## GitHub Pages は free のレポジトリと Enterprise で違う構造の URL に発行されるみたい

実際に試したところ

- free - `https://{GitHubID}.github.io/{RepositoryName}/`
- Enterprise - `https://{randomName}.github.io/`

になりました。

free と Enterprise で同じ形式にすることはできないらしい。
→ できないわけじゃないのだが、なんかややこしい... このへん [カスタムドメインと GitHub Pages について - GitHub Docs](https://docs.github.com/ja/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages)

## どうもさらにややこしいらしい

- ユーザーサイト(組織サイト)　(`https://<username>.github.io` または `https://<organization>.github.io`)
- プロジェクトサイト

の 2 種類があるらしい。