# GitHub Code scanning のメモ

主にCodeQL

## 参考

[自分のOSSリポジトリにGitHubのセキュリティ設定を入れ、自分用の手順書を作った - $shibayu36->blog;](https://blog.shibayu36.org/entry/2026/02/16/173000)

## CodeQL 設定

上のリンクから引用

1. リポジトリ \> Settings \> Advanced Security
2. CodeQL analysisのところでSet up \> Default (とりあえず)
3. 提案されたトリガ(push / PR / schedule)で有効化 (とりあえず)

で、GitHub Actions で "CodeQL Setup" が動くので、
これが正常完了するのを確認する。

根拠はないけど、先に

- dependabot.yml 書いて、ちゃんと Dependabot version updates にエコシステムが全部検知されてて
- かつ Dependency graph が完了してる

状態にしてからCodeQLを設定した方がいいような気がする。

スキャン結果は
リポジトリ \> Security \> Code scanning \> tools \> CodeQL
から確認。

参考:
[コード スキャンのツール状態ページについて - GitHub ドキュメント](https://docs.github.com/ja/code-security/how-tos/scan-code-for-vulnerabilities/manage-your-configuration/about-the-tool-status-page)

### Advance setup

Default setup のかわりに、こちらを選ぶと
`.github/workflows/codeql-analysis.yml` (名前は多少かわる)
が生成されるらしい。

これを編集すると、デフォルトブランチのpushやPR以外でもスキャンできるようになる。
らしい。あとで試す。

Default setup は 「マネージドな CodeQL 実行」らしい

参考:
[GitHub Code Scanning を使ってみた (YAMLの設定方法) #Security - Qiita](https://qiita.com/ymd_h/items/63d9105cd0429317bd6f)

## CodeQL が実際に「問題を検出できている」ことを確認する

### 意図的に脆弱なコードを入れて検出させる

「これを入れれば、CodeQL が検出できて当然」という基準コードがあるので
それを使う。

例: [Database query built from user-controlled sources — CodeQL query help documentation](https://codeql.github.com/codeql-query-help/javascript/js-sql-injection/)

引用:

```javascript
const express = require('express');
const app = express();

app.get('/user', (req, res) => {
  const user = req.query.user;
  // 明示的に危険なコード
  const query = "SELECT * FROM users WHERE name = '" + user + "'";
  db.query(query, (err, result) => {
    res.send(result);
  });
});
```

1. 上記のような、明らかに危険なコードを
   - デフォルトブランチ、
   - または PR として追加
2. 1.によって CodeQL workflow が トリガーされて実行される
3. 以下を確認
   - Security \> Code scanning alerts
   - PR の Code scanning results

ただしく設定されていれば
「SQL injection」「Untrusted data」系のアラートが出る

### CodeQL の 標準テスト用リポジトリを使う

GitHub 公式が用意している 意図的に脆弱なサンプル:

- https://github.com/github/codeql-go

これをforkしてCodeQL workflow を有効化、Security \> Code scanning alerts を確認。

## クエリセットの追加

(TODO)

## ローカルで CodeQL

CodeQL CLI bundle を使う

[CodeQL CLI完全ガイド - コード解析を自動化する #Git - Qiita](https://qiita.com/Hurry_Fox/items/47db72f1c5f8a49a881f)

Docker版は公式ではなく、MS版とコミュニティ版があるらしい

### MS版docker

- [microsoft/codeql-container: Prepackaged and precompiled github codeql container for rapid analysis, deployment and development.](https://github.com/microsoft/codeql-container)
- [microsoft/cstsectools-codeql-container - Docker Image](https://hub.docker.com/r/microsoft/cstsectools-codeql-container)

注意

- 現在は主にスクリプト言語向け(JS / Python 等)
- コンパイル言語(Go / Java / C++)は制限あり

### 私家版docker

- [j3ssie/codeql-docker: Ready to use docker image for CodeQL](https://github.com/j3ssie/codeql-docker)
- [nealfennimore/codeql-docker: CodeQL Docker wrapper](https://github.com/nealfennimore/codeql-docker) - これのみそこそこ新しい
  - [Package codeql](https://github.com/nealfennimore/codeql-docker/pkgs/container/codeql)

### ライセンス

- 公開レポジトリ
- または GitHub Advanced Security がある

プロジェクトで使用可能。

「技術的には止められていないが、契約・利用条件で縛られている」タイプで、Oracle のライセンスに似ている
