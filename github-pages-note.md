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

## Fallback Routing

GitHub Pages は Fallback Routing の機能がないけど、
例えば index.html をコピーして 404.html としてデプロイすれば、
SPA で固定 URL っぽいことができるらしい(未検証)。

GitHub Actions 的には
<https://vite.dev/guide/static-deploy.html#github-pages> のサンプルで
ビルドの直後に

```yaml
- name: Build
  run: npm run build

- name: Copy index.html to 404.html
  run: cp dist/index.html dist/404.html
```

のようにすればいいはず。

やってみた
→
できた。
[heiwa4126/react-githubpages2: react-githubpages1 を改造して、疑似 Fallback Routing で BrowserRouter でいけるかテストしてみる](https://github.com/heiwa4126/react-githubpages2)
