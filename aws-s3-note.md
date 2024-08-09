# S3 と KMS

## 基礎

- [S3 が暗号化されている実感がわかないので、復号できない場合の挙動を確かめてみた | DevelopersIO](https://dev.classmethod.jp/articles/behavior-when-s3-cannot-be-decrypted/)
- [10 分でわかる!Key Management Service の仕組み #cmdevio | DevelopersIO](https://dev.classmethod.jp/articles/10minutes-kms/)

## ブロックパブリックアクセス(バケット設定)

[S3 のブロックパブリックアクセスが怖くなくなった【AWS S3】](https://zenn.dev/ymasutani/articles/019959e7c990b1)

いまだによくわからん。

[AWS::S3::Bucket PublicAccessBlockConfiguration - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-publicaccessblockconfiguration.html) を翻訳してみる。

[PutPublicAccessBlock - Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutPublicAccessBlock.html) も援用... って同じだねこれは。

### BlockPublicAcls

Amazon S3 が、このバケットとこのバケット内のオブジェクトの
パブリックアクセスコントロールリスト(ACL)をブロックすべきかどうかを指定します。
この要素を true に設定すると、次のような動作になります。

- [PUT Bucket ACL](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/API/API_PutBucketAcl.html) および PUT Object ACL の呼び出しは、指定された ACL が public である場合、失敗します。
- PUT Object の呼び出しは、リクエストに public ACL が含まれている場合、失敗します。
- PUT Bucket 呼び出しは、リクエストにパブリック ACL が含まれている場合、失敗します。

この設定を有効にしても、**既存のポリシーまたは ACL には影響しません**。

パブリックアクセスコントロールリストとパブリックでないアクセスコントロールリストがあるかのように見えるけど
ACL はパブリックしかないらしい。あと PUT は失敗するけど GET については何も影響がないようだ、

[アクセスコントロールリスト (ACL) の概要 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/acl-overview.html)

> Amazon S3 の最新のユースケースの大部分では ACL を使用する必要がなくなり、オブジェクトごとに個別にアクセスを制御する必要がある異常な状況を除き、ACL を無効にすることをお勧めします

ACL を使うと、1 つのバケットの中でパブリック公開オブジェクトと、そうでないオブジェクトを混在できますが
**そんなややこしいのは絶対トラブルの原因になりますのでやめましょう**。

[【アップデート】S3 で ACL を無効化できるようになりました #reinvent | DevelopersIO](https://dev.classmethod.jp/articles/s3-bucket-owner-enforced/)

Terraform だと [aws_s3_bucket_ownership_controls | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) で。

```terraform
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
```

これで ACL について考える必要はなくなった。true でいいはず。

### IgnorePublicAcls

順番は前後する。ACL について考える必要はなくなったので、ここはどうでもいい。
true でいいはず。

Amazon S3 が、このバケットとこのバケット内のオブジェクトのパブリック ACL を無視するかどうかを指定します。この要素を true に設定すると、Amazon S3 はこのバケットとこのバケット内のオブジェクトのすべてのパブリック ACL を無視するようになります。

この設定を有効にしても、既存の ACL の永続性には影響せず、新しいパブリック ACL の設定を妨げることはありません。

こちらも **既存の**。

### BlockPublicPolicy

順番は前後する。

Amazon S3 がこのバケットに対してパブリックバケットポリシーをブロックすべきかどうかを指定します。この要素を true に設定すると、指定されたバケットポリシーがパブリックアクセスを許可している場合、Amazon S3 は PUT バケットポリシーの呼び出しを拒否するようになります。

この設定を有効にすると、既存のバケットポリシーには影響しません。

これも **既存の** なので、先にポリシーを設定すれば (Terraform だったら depends-on で)
OK だし、PUT API にしか影響しないみたいだから true でいいはず。

### RestrictPublicBuckets

これだけ異常

Amazon S3 がこのバケットのパブリックバケットポリシーを制限すべきかどうかを指定します。
この要素を true に設定すると、
バケットにパブリックポリシーがある場合、
このバケットへのアクセスを
AWS サービスプリンシパルとこのアカウント内の認可されたユーザーのみに制限することができます。

この設定を有効にすると、
特定のアカウントへの非公開の委任を含む、任意のパブリックバケットポリシー内のパブリックおよびクロスアカウントアクセスがブロックされることを除いて、
以前に保存されたバケットポリシーに影響を与えません。

Enabling this setting doesn't affect
previously stored bucket policies,
except that
public and cross-account access
within any public bucket policy,
including non-public delegation to specific accounts, is blocked.

既存の設定に一部影響がある。「WWW で公開」みたいなときに影響する。

[Amazon S3 ストレージへのパブリックアクセスのブロック - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/access-control-block-public-access.html)

[Amazon S3 ストレージへのパブリックアクセスのブロック - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/access-control-block-public-access.html#access-control-block-public-access-policy-status)

### まとめると

S3 の設定は
まずパブリックでない場合は

- 問答無用に PublicAccessBlock の全部を適応。
- 「ACL を無効化」も併用がおすすめ(コンソールでのデフォルト。「ACL 無効 (推奨)」)

パブリックにせざるをえない場合は(「S3 で WWW 公開(CloudFront なし)」など)

- PublicAccessBlock は RestrictPublicBucket だけ false
- ACL を無効化
- パブリックアクセス用のバケットポリシー書く

「ACL を無効化」は「オブジェクト所有者」のところにあります。

## S3 の暗号化とパフォーマンス

tfsec は「S3 が暗号化されてない」ってよく言ってくるけど、費用と速度的にはどうなのか。

- [S3 デフォルト暗号化によるパフォーマンスを検証してみた - 本日も乙](https://blog.jicoman.info/2018/06/s3-default-encrytion-performance/)
- [Amazon S3 が管理する暗号化キーによるサーバー側の暗号化 (SSE−S3) を使用したデータの保護 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/UsingServerSideEncryption.html)

とりあえず

- 大きなファイルだと I/O パフォーマンスの低下は顕著
- AWS 管理のキーなら無料

ってところか。

## S3 オブジェクトロック

> オブジェクトロックは、バージョニングされたバケットでのみ機能し、保持期間とリーガルホールドは個々のオブジェクトバージョンに適用されます。

- [S3 オブジェクトロックの使用 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/object-lock.html)
- [aws_s3_bucket_object_lock_configuration | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration#default_retention)

## Content-Encode

S3 オブジェクトには 1 個 1 個メタデータがつけられるので、
`Content-Encode: gzip` なメタデータ(そのまま HTTP レスポンスヘッダに帰る)をつけた gzip されたファイルを置いて、WWW アクセス、とか出来る。

React、Vue、Angular など Webpack してデカい.js が出る場合などに便利。

ただし

- 別に自動で解凍してくれるわけじゃない。gzip されたデータとメタデータが送られてくるだけ
- コンテンツネゴシエーションしてくれない。リクエストヘッダの `Accept-Encoding` とか全く見ずに、絶対 gzip で送ってくる

まあ 普通のブラウザでは gzip が伸張できないことはまずないので問題にはならないだろう。

curl は `curl --compressed` で取れます。

S3 を直接たたかず CloudFront を使う場合は Compress Objects Automatically 設定 があるので、
これを設定したほうがハンドリングが楽だと思う。

- [AWS::CloudFront::Distribution DefaultCacheBehavior - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-defaultcachebehavior.html#cfn-cloudfront-distribution-defaultcachebehavior-compress)
- [AWS S3 Cloudfront で Web ページを gzip 圧縮して配信する方法 - Useful Edge](https://usefuledge.com/aws-cloudfront-gzip.html)

## Etag

S3 オブジェクトは Etag が自動で付与する。
基本 md5sum なのだけれど以下の例外が:

- [Common Response Headers - Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html)
- [オブジェクトの整合性をチェックする \- Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/checking-object-integrity.html#checking-object-integrity-etag-and-md5)

(上の機械翻訳)

エンティティタグは、オブジェクトの特定のバージョンを表します。
ETag はオブジェクトの内容に対する変更のみを反映し、そのメタデータは反映しません。
ETag はオブジェクトデータの **MD5 ダイジェストであることもありますし、そうでないこともあります。**
そうであるかどうかは、オブジェクトの作成方法と、 以下に説明する暗号化の方法に依存します。

- AWS Management Console、または PUT Object、POST Object、Copy 操作で作成されたオブジェクト。
  - SSE-S3 で暗号化された、または平文のオブジェクトは、そのデータの MD5 ダイジェストである ETags を持つ。
  - SSE-C または SSE-KMS によって暗号化されたオブジェクトは、そのオブジェクトデータの MD5 ダイジェストではない ETags を持ちます。
- Multipart Upload または Part Copy 操作によって作成されたオブジェクトは、暗号化の方法に関係なく、MD5 ダイジェストではない ETag を持ちます。

(引用終わり)

外部から AWS が生成する ETag を予想するのは困難なので
[オブジェクトの整合性をチェックする - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/checking-object-integrity.html)
にあるように、アルゴリズムを指定するとか TAG につけるとかするしかなさそう。
