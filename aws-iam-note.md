# policyのprincipal

* ワイルドカードは使えない(匿名アクセスを除く)。
* 匿名アクセスは `*`
* AWSアカウントのルートユーザー(
    `arn:aws:iam::123456789012:root` or `123456789012`)を指定すると「123456789012の全ユーザ」の意味になる。
`arn:aws:iam::123456789012:user/*`(こういう指定はできない)
 的な感じ。理屈に合わないが本当。
* `arn:aws:iam::123456789012:group/`が無い。
* リソースによって指定できるprincipalパターンが微妙に違う。

参考:
* [AWS JSON ポリシーの要素: Principal \- AWS Identity and Access Management](https://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/reference_policies_elements_principal.html)
* [Principals - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/s3-bucket-user-policy-specifying-principal-intro.html)
* [例 3: バケット所有者が自分の所有していないオブジェクトに対するアクセス許可を付与する - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example3.html)


まとめると、「あまりふくざつなことはできない」ということですね。

* 制限なし(匿名アクセス,パブリックアクセス)
* AWSアカウント(複数可)
* AWSユーザ(複数可)

これに加えてS3では
