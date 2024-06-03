# JSON REST API メモ

発端: [Why, after 6 years, I’m over GraphQL](https://bessey.dev/blog/2024/05/24/why-im-over-graphql/)

> この記事では、著者が GraphQL に対する熱意を失った理由について説明しています。主な問題点として、攻撃面の増大、認可やレート制限の複雑さ、クエリ解析の難しさ、パフォーマンスの問題(特に N+1 問題)、およびシステムの複雑化を挙げています。特に、GraphQL が REST よりも多くのセキュリティとパフォーマンス上の課題を抱えていると指摘しています。最後に、OpenAPI 3.0 準拠の JSON REST API を代替として推奨しています。

以下の文章より、元の記事のほうを読んだほうがいいかも...

## JSON REST API の読むべき資料

JSON REST API に関する学習リソースとして、以下の資料をお勧めします:

1. **MDN Web Docs - Introduction to REST and JSON**:

   - このページは REST の基本概念と JSON の使用方法を紹介しています。REST API の設計原則や HTTP メソッドの使い方についての詳しい説明が含まれています。
   - [Introduction to REST and JSON](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON)

2. **RESTful API Tutorial**:

   - RESTful API の設計と実装に関する包括的なガイドです。URI 設計のベストプラクティス、HTTP メソッド、ステートレス性などの重要な概念をカバーしています。
   - [RESTful API Tutorial](https://restfulapi.net/)

3. **Google Cloud - RESTful API Design**:

   - Google Cloud が提供する RESTful API 設計に関するガイドです。設計パターンやベストプラクティス、認証方法について詳述しています。
   - [RESTful API Design](https://cloud.google.com/apis/design)

4. **IBM Cloud - What is REST?**:

   - REST API の基本概念とそのアーキテクチャについての詳細な説明があります。JSON を使ったデータ交換の例も含まれています。
   - [What is REST?](https://www.ibm.com/cloud/learn/rest-apis)

5. **OpenAPI Initiative - OpenAPI Specification**:
   - RESTful API の標準仕様である OpenAPI の公式ドキュメントです。JSON フォーマットで API を定義する方法について詳細に説明されています。
   - [OpenAPI Specification](https://spec.openapis.org/oas/v3.0.3)

これらの資料を活用して、JSON REST API の設計と実装について深く学ぶことができます。

## おまけ: OpenAPI 3.0 関連

OpenAPI 3.0 は、RESTful API の設計と文書化のための標準仕様です。これにより、API の定義を JSON や YAML 形式で記述し、詳細な情報や構造を包括的に表現できます。OpenAPI 3.0 は、以前の Swagger 2.0 に基づいており、コールバックや操作間のリンク、強化されたサンプル、再利用性の向上など、いくつかの新機能が追加されています。

### 主な特徴と利点

1. **機械可読性**: API 定義を機械可読な形式で記述することで、ツールが自動的に処理でき、文書の生成やコードの生成、セキュリティ分析などが可能です。
2. **人間可読性**: 定義はプレーンテキストファイルであるため、デバッグが容易です。
3. **ツーリングエコシステム**: OpenAPI は多くのツールと互換性があり、これにより設計、検証、テストが効率的に行えます。
4. **再利用性**: 一度定義したスキーマやパラメータ、レスポンスを他の API でも再利用できます。

### 学習リソース

1. **SwaggerHub のチュートリアル**: OpenAPI 3.0 を使って API を設計・文書化する方法を詳細に説明しています。特に、SwaggerHub のエディタを使用して迅速に定義を記述し、視覚化することが推奨されています ​ ([SmartBear Support](https://support.smartbear.com/swaggerhub/docs/en/get-started/openapi-3-0-tutorial.html))​​ ([Swagger](https://swagger.io/blog/api-design/openapi-3-0-specification-training/))​。
2. **OpenAPI 公式ドキュメント**: OpenAPI 仕様の詳細な解説とベストプラクティスが掲載されており、API 設計者向けのガイドとして最適です ​ ([OpenAPI Documentation](https://learn.openapis.org/))​。

これらのリソースを活用することで、OpenAPI 3.0 を効果的に学習し、API の設計と文書化を効率的に行うことができます。詳しくは以下のリンクから確認できます:

- [SwaggerHub Documentation](https://support.smartbear.com/swaggerhub/docs/swaggerhub.html)
- [OpenAPI Documentation](https://learn.openapis.org/)
