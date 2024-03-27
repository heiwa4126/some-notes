# cdktf メモ

## cdktf 感想

- 最初の npm i が結構重い
- 最初の cdktf deploy が結構重い (`terraform init`も含んでるから...)

## cdktf でリソースの dependency を解決する手法を教えてください

(この項未整理)

cdktf でリソースの依存関係(dependency)を解決するための主な手法は以下の通りです。

1. **リソース参照(Resource References)**

   - リソースの出力値を他のリソースの入力値として参照することで依存関係を表現します。
   - TypeScript/Python/Java などの手続き型言語では、この参照関係を明示的に記述する必要があります。
   - 例:

     ```typescript
     const bucket = new s3.Bucket(this, 'MyBucket');
     new lambda.Function(this, 'MyLambda', {
        code: ...,
        environment: {
            BUCKET_NAME: bucket.bucketName
            }
        });
     ```

2. **依存関係の明示(Explicit Dependencies)**

   - リソース定義時に、依存するリソースを明示的に指定することができます。
   - cdktf の `Construct` クラスには `node.addDependency()` メソッドがあり、依存対象のリソースを渡すことで依存関係を設定できます。
   - 例: `lambda.node.addDependency(bucket);`

3. **リソース間のデータ渡し(Data Passing between Resources)**

   - リソース間でデータを直接やり取りすることで、依存関係を表現できます。
   - データ渡しにはコンストラクタ引数やプロパティを利用します。
   - 例: `new lambda.Function(this, 'MyLambda', { bucket: bucket, ... });`

4. **リソース生成順序の制御(Resource Ordering Control)**

   - リソースの生成順序を明示的に制御することで、依存関係を表現できます。
   - cdktf には `Resource.addDependency()` メソッドがあり、他のリソースを依存対象として追加できます。
   - 例: `const lambda = new lambda.Function(...);` `bucket.node.addDependency(lambda);`

5. **Terraform メタ引数(Terraform Meta-Arguments)**

   - Terraform のメタ引数として `depends_on` を利用し、依存関係を宣言できます。
   - cdktf からはメタ引数を直接設定することが可能です。
   - 例: `new s3.Bucket(this, 'MyBucket', { dependsOn: [lambda] });`

6. **リソースモジュール化(Resource Modularization)**
   - 依存関係の複雑なリソースをモジュール化し、内部の依存関係を隠蔽することができます。
   - モジュールの入力として必要なリソースを渡すことで、依存関係を表現できます。

適切な手法は、依存関係のタイプやリソースの種類、コードの可読性など、様々な要因に応じて選択する必要があります。明示的な依存関係設定と、リソース参照を組み合わせることが一般的です。cdktf ではコード生成時に最適化が行われるため、多くの場合簡単な記述で済みますが、複雑なケースでは手作業による調整が必要な場合もあります。

## マルチスタックの cdktf で複数のスタックをデプロイする方法

いまのところ無い。1 個のスタックにまとめるぐらいしかなさそう。

[Deploy all stack in project...or not? · Issue #1587 · hashicorp/terraform-cdk](https://github.com/hashicorp/terraform-cdk/issues/1587)

cdktf チームからのコメントによると、マルチスタックのデプロイは将来的な機能拡張として検討されているものの、現在の開発の優先順位は低いようです。理由として以下の点が挙げられています。

1. **Terraform CLI でのマルチスタックサポート**
   Terraform CLI そのものがマルチスタックのデプロイをネイティブにサポートしていないため、cdktf でその機能を提供するのは難しい。

2. **スタック間の依存関係管理の複雑さ**
   スタック間の依存関係を適切に管理することが難しく、Terraform のステートファイル管理とも密接に関係する。

3. **cdktf のスコープ**
   cdktf は Terraform プロバイダーの上でデプロイされるリソースを表すのが主な目的であり、マルチスタックはその範疇を逸脱する。

代わりに、以下のような回避策が提案されています。

- 単一の cdktf スタックで環境ごとにリソースをグループ化し、必要に応じてデプロイする
- cdktf の外部から別の IaC ツール(Terragrunt、環境変数など)を使ってマルチスタックを管理する
- Terraform ネイティブの機能であるモジュールや Workspace 機能を利用する

マルチスタックのユースケースが非常に重要な場合は、上記の代替手段を検討する必要があるでしょう。
cdktf チームは機能拡張のリクエストを歓迎していますが、現時点ではマルチスタックのサポートは限定的であることがわかります。
将来のアップデートで対応が改善される可能性もあるため、状況は注視する必要がありそうです。
