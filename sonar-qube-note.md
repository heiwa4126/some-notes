# SonarQube メモ

GitHub Enterprise で Code Scanning が使えない(GHAS が買ってもらえない)ので SonarQube community edition でやれないかなぁ、と思って調べてみた。

## 対応言語

SonarQube community edition は Python や npm のプロジェクトをスキャンできるだろうか。

- [9.9 LTA - Languages overview](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/languages/overview/)
- [latest(10.6) - Languages overview](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/languages/overview/)

対応してます。

Community Edition は 15 のプログラミング言語(Java、JavaScript、C#、TypeScript、Kotlin、Ruby、Go、Scala、Flex、Python、PHP、HTML、CSS、XML、VB.NET)をサポートしており、多くの商用プロジェクトのニーズを満たすことができます。

## ライセンス

SonarQube Community Edition は商用で使えますか?

はい、SonarQube Community Edition は商用プロジェクトでも使用することができます。以下に主なポイントをまとめます:

SonarQube Community Edition は、オープンソースかつ無料のバージョンであり、商用利用も可能です。

[Sonarqube Community Edition | bitegarden - Plugins for SonarQube and SonarCloud](https://www.bitegarden.com/sonarqube-community-edition-and-all-the-plugins-availables)

SonarSource の公式コミュニティフォーラムでも、Community Edition を商用プロジェクトの分析に使用することは問題ないと明確に述べられています。

[Could the SonarQube Community Edition use for commercal project - SonarQube - Sonar Community](https://community.sonarsource.com/t/could-the-sonarqube-community-edition-use-for-commercal-project/19727)

ただし、SonarQube 自体をプロジェクトに組み込んだり、修正したりする場合は、SonarQube のライセンス
<https://www.sonarqube.org/downloads/license/>
を確認し、その条件に従う必要があります。

商用プロジェクトのコードを SonarQube で分析する場合、そのソースコードを公開する必要はありません。プライベートに保持したまま使用できます。

SonarLint についても同様の状況が適用されます。

したがって、SonarQube Community Edition は商用プロジェクトでも自由に使用でき、コードの品質向上やセキュリティ強化に活用することができます。

## CI/CD

GitHub Actions で使えますか?

[GitHub integration](https://docs.sonarsource.com/sonarqube/9.9/devops-platform-integration/github-integration/)

前提として `GitHub Enterprise version 3.4+` が要る。と書いてある。

## 検出できる脆弱性

SonarScanner community edition はコード中の脆弱性を検出できますか?

基本的な脆弱性検出: Community Edition では、一部の基本的な脆弱性を検出することができます。

高度な脆弱性検出の制限: XSS や SQL インジェクションなどの高度なセキュリティ脆弱性の検出は、Community Edition には含まれていません。

商用版での提供: より高度な脆弱性検出機能は、SonarCloud や商用版の SonarQube(Developer Edition 以上)で利用可能です[5]。

プラグインによる拡張: 一部のオープンソースプラグインを使用することで、Community Edition の機能を拡張できる可能性がありますが、公式にサポートされているわけではありません。

SonarLint を使用すると、IDE で既知の脆弱性を可視化することができますが、新しい脆弱性の検出は限定的です。

SonarQube Community Edition で検出可能な基本的な脆弱性の例を ECMAScript(JavaScript)で示します。以下に、いくつかの一般的な例を挙げます:

1. 安全でない乱数生成:

   ```javascript
   // 脆弱性のあるコード
   function generateRandomId() {
     return Math.random().toString(36).substr(2, 9);
   }
   ```

   SonarQube は、暗号学的に安全でない乱数生成の使用を検出し、警告を出します。

2. ハードコードされたクレデンシャル:

   ```javascript
   // 脆弱性のあるコード
   const password = 'mySecretPassword123';
   const apiKey = '1234567890abcdef';
   ```

   SonarQube は、ソースコード内にハードコードされたパスワードや API キーを検出します。

3. 無限ループの可能性:

   ```javascript
   // 脆弱性のあるコード
   function processItems(items) {
     while (items.length > 0) {
       // items.length が変更されない場合、無限ループになる
     }
   }
   ```

   SonarQube は、潜在的な無限ループを検出し、警告を出します。

4. 未使用の変数:

   ```javascript
   // 脆弱性のあるコード
   function calculateTotal(price, quantity) {
     const tax = 0.1; // この変数は使用されていない
     return price * quantity;
   }
   ```

   SonarQube は、未使用の変数を検出し、コードの品質向上のために警告を出します。

5. 不適切な例外処理:

   ```javascript
   // 脆弱性のあるコード
   try {
     // 何らかの処理
   } catch (error) {
     console.log(error);
   }
   ```

   SonarQube は、単に例外をログに記録するだけの不適切な例外処理を検出します。

6. 不要なコード:

   ```javascript
   // 脆弱性のあるコード
   function isPositive(num) {
     if (num > 0) {
       return true;
     } else {
       return false;
     }
   }
   ```

   SonarQube は、このような冗長なコードを検出し、簡潔な書き方を提案します。

## docker note

```sh
docker pull sonarqube
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube

docker pull sonarsource/sonar-scanner-cli
```

[sonarsource/sonar-scanner-cli - Docker Image | Docker Hub](https://hub.docker.com/r/sonarsource/sonar-scanner-cli)
