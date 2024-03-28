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

[CLI Commands - CDK for Terraform | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/cdktf/cli-reference/commands#deploy)
に

```sh
cdktf deploy '*'
```

みたいなサンプルが載ってるので参照。

(**以下嘘**)

いまのところ無い。1 個のスタックにまとめるぐらいしかなさそう。

[Deploy all stack in project...or not? · Issue #1587 · hashicorp/terraform-cdk](https://github.com/hashicorp/terraform-cdk/issues/1587)

## cdktf deploy の最後の選択肢

(依存するスタックのサンプルを作って試さないと...)

### Q

`cdktf deploy` を実行すると、最後に 3 つの選択肢が出てきます。

- **Approve** - Applies the changes outlined in the plan.
- **Dismiss** - Does not apply the changes outlined in the plan. This will also prevent depending stacks from planning.
- **Stop** - Does not apply the changes. Currently running stacks will be finished, but no new ones will be started.

これらを解説してください。

### A

これらの選択肢は、cdktf deploy コマンドによって生成された実行計画(plan)に対する操作を指定するためのものです。

1. **Approve**

   - この選択肢を選ぶと、実行計画で示された変更をクラウドリソースに適用(Apply)します。
   - つまり、実際にクラウド上にリソースが作成、更新、削除されます。

2. **Dismiss**

   - この選択肢を選ぶと、実行計画で示された変更はクラウドリソースに適用されません。
   - さらに、この実行計画に依存する他のスタックの計画も実行されなくなります。
   - 変更を加えずに、そのまま終了します。

3. **Stop**
   - この選択肢を選ぶと、現在実行中のスタックは完了しますが、新しいスタックの実行は開始されません。
   - つまり、既に実行中のスタックについては変更が適用されますが、まだ実行されていないスタックについては変更が適用されません。

一般的には、実行計画を確認し、問題がなければ**Approve**を選択して変更を適用します。変更を適用したくない場合は**Dismiss**を選択します。実行中のスタックについてのみ変更を適用したい場合は**Stop**を選択します。

これらの選択肢により、cdktf を使ったクラウドリソースの管理において、実行計画を確認し、意図した変更のみを適用できるようになっています。
