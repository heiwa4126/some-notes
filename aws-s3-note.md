# S3とKMS

# 基礎

- [S3が暗号化されている実感がわかないので、復号できない場合の挙動を確かめてみた | DevelopersIO](https://dev.classmethod.jp/articles/behavior-when-s3-cannot-be-decrypted/)
- [10分でわかる！Key Management Serviceの仕組み #cmdevio | DevelopersIO](https://dev.classmethod.jp/articles/10minutes-kms/)

# ブロックパブリックアクセス (バケット設定)

[S3のブロックパブリックアクセスが怖くなくなった【AWS S3】](https://zenn.dev/ymasutani/articles/019959e7c990b1)

いまだによくわからん。

[AWS::S3::Bucket PublicAccessBlockConfiguration - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket-publicaccessblockconfiguration.html) を翻訳してみる。

[PutPublicAccessBlock - Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/API/API_PutPublicAccessBlock.html) も援用... って同じだねこれは。

## BlockPublicAcls

Amazon S3が、このバケットとこのバケット内のオブジェクトの
パブリックアクセスコントロールリスト(ACL)をブロックすべきかどうかを指定します。
この要素を true に設定すると、次のような動作になります。

- [PUT Bucket ACL](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/API/API_PutBucketAcl.html) および PUT Object ACL の呼び出しは、指定された ACL が public である場合、失敗します。
- PUT Object の呼び出しは、リクエストに public ACL が含まれている場合、失敗します。
- PUT Bucket 呼び出しは、リクエストにパブリック ACL が含まれている場合、失敗します。

この設定を有効にしても、**既存のポリシーまたは ACLには影響しません**。

パブリックアクセスコントロールリストとパブリックでないアクセスコントロールリストがあるかのように見えるけど
ACLはパブリックしかないらしい。あとPUTは失敗するけどGETについては何も影響がないようだ、

[アクセスコントロールリスト (ACL) の概要 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/acl-overview.html)

> Amazon S3 の最新のユースケースの大部分では ACL を使用する必要がなくなり、オブジェクトごとに個別にアクセスを制御する必要がある異常な状況を除き、ACL を無効にすることをお勧めします

ACLを使うと、1つのバケットの中でパブリック公開オブジェクトと、そうでないオブジェクトを混在できますが
**そんなややこしいのは絶対トラブルの原因になりますのでやめましょう**。

[【アップデート】S3でACLを無効化できるようになりました #reinvent | DevelopersIO](https://dev.classmethod.jp/articles/s3-bucket-owner-enforced/)

Terraformだと [aws_s3_bucket_ownership_controls | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) で。

```terraform
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
```

これでACLについて考える必要はなくなった。trueでいいはず。

## IgnorePublicAcls

順番は前後する。ACLについて考える必要はなくなったので、ここはどうでもいい。
trueでいいはず。

Amazon S3 が、このバケットとこのバケット内のオブジェクトのパブリック ACL を無視するかどうかを指定します。この要素を true に設定すると、Amazon S3はこのバケットとこのバケット内のオブジェクトのすべてのパブリックACLを無視するようになります。

この設定を有効にしても、既存のACLの永続性には影響せず、新しいパブリックACLの設定を妨げることはありません。

こちらも **既存の**。

## BlockPublicPolicy

順番は前後する。

Amazon S3がこのバケットに対してパブリックバケットポリシーをブロックすべきかどうかを指定します。この要素をtrueに設定すると、指定されたバケットポリシーがパブリックアクセスを許可している場合、Amazon S3はPUTバケットポリシーの呼び出しを拒否するようになります。

この設定を有効にすると、既存のバケットポリシーには影響しません。

これも **既存の** なので、先にポリシーを設定すれば (Terraformだったらdepends-onで)
OKだし、PUT APIにしか影響しないみたいだから trueでいいはず。

## RestrictPublicBuckets

これだけ異常

Amazon S3 がこのバケットのパブリックバケットポリシーを制限すべきかどうかを指定します。
この要素を true に設定すると、
バケットにパブリックポリシーがある場合、
このバケットへのアクセスを
AWSサービスプリンシパルとこのアカウント内の認可されたユーザーのみに制限することができます。

この設定を有効にすると、
特定のアカウントへの非公開の委任を含む、任意のパブリックバケットポリシー内のパブリックおよびクロスアカウントアクセスがブロックされることを除いて、
以前に保存されたバケットポリシーに影響を与えません。

Enabling this setting doesn't affect
previously stored bucket policies,
except that
public and cross-account access
within any public bucket policy,
including non-public delegation to specific accounts, is blocked.

既存の設定に一部影響がある。「WWWで公開」みたいなときに影響する。

[Amazon S3 ストレージへのパブリックアクセスのブロック - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/access-control-block-public-access.html)

[Amazon S3 ストレージへのパブリックアクセスのブロック - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/access-control-block-public-access.html#access-control-block-public-access-policy-status)

## まとめると

S3の設定は
まずパブリックでない場合は

- 問答無用にPublicAccessBlockの全部を適応。
- 「ACLを無効化」も併用がおすすめ(コンソールでのデフォルト。「ACL 無効 (推奨)」)

パブリックにせざるをえない場合は(「S3でWWW公開(CloudFrontなし)」など)

- PublicAccessBlockはRestrictPublicBucketだけfalse
- ACLを無効化
- パブリックアクセス用のバケットポリシー書く

「ACLを無効化」は「オブジェクト所有者」のところにあります。

# S3の暗号化とパフォーマンス

tfsecは「S3が暗号化されてない」ってよく言ってくるけど、費用と速度的にはどうなのか。

- [S3デフォルト暗号化によるパフォーマンスを検証してみた - 本日も乙](https://blog.jicoman.info/2018/06/s3-default-encrytion-performance/)
- [Amazon S3 が管理する暗号化キーによるサーバー側の暗号化 (SSE−S3) を使用したデータの保護 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/UsingServerSideEncryption.html)

とりあえず

- 大きなファイルだとI/Oパフォーマンスの低下は顕著
- AWS管理のキーなら無料

ってところか。

# S3オブジェクトロック

> オブジェクトロックは、バージョニングされたバケットでのみ機能し、保持期間とリーガルホールドは個々のオブジェクトバージョンに適用されます。

- [S3 オブジェクトロックの使用 - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/object-lock.html)
- [aws_s3_bucket_object_lock_configuration | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration#default_retention)

# Content-Encode

S3オブジェクトには1個1個メタデータがつけられるので、
`Content-Encode: gzip` なメタデータ(そのままHTTPレスポンスヘッダに帰る)をつけた gzipされたファイルを置いて、WWWアクセス、とか出来る。

React、Vue、Angular などWebpackしてデカい.jsが出る場合などに便利。

ただし

- 別に自動で解凍してくれるわけじゃない。gzipされたデータとメタデータが送られてくるだけ
- コンテンツネゴシエーションしてくれない。リクエストヘッダの `Accept-Encoding` とか全く見ずに、絶対gzipで送ってくる

まあ 普通のブラウザでは gzipが伸張できないことはまずないので問題にはならないだろう。

curlは `curl --compressed` で取れます。

S3を直接たたかずCloudFrontを使う場合は Compress Objects Automatically設定 があるので、
これを設定したほうがハンドリングが楽だと思う。

- [AWS::CloudFront::Distribution DefaultCacheBehavior - AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-distribution-defaultcachebehavior.html#cfn-cloudfront-distribution-defaultcachebehavior-compress)
- [AWS S3 Cloudfront で Webページを gzip 圧縮して配信する方法 - Useful Edge](https://usefuledge.com/aws-cloudfront-gzip.html)

# Etag

S3オブジェクトはEtagが自動で付与する。
基本md5sumなのだけれど以下の例外が:

- [Common Response Headers - Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html)
- [オブジェクトの整合性をチェックする \- Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/checking-object-integrity.html#checking-object-integrity-etag-and-md5)

(上の機械翻訳)

エンティティタグは、オブジェクトの特定のバージョンを表します。
ETag はオブジェクトの内容に対する変更のみを反映し、そのメタデータは反映しません。
ETag はオブジェクトデータの **MD5 ダイジェストであることもありますし、そうでないこともあります。**
そうであるかどうかは、オブジェクトの作成方法と、 以下に説明する暗号化の方法に依存します。

- AWS Management Console、またはPUT Object、POST Object、Copy操作で作成されたオブジェクト。
  - SSE-S3で暗号化された、または平文のオブジェクトは、そのデータのMD5ダイジェストであるETagsを持つ。
  - SSE-CまたはSSE-KMSによって暗号化されたオブジェクトは、そのオブジェクトデータのMD5ダイジェストではないETagsを持ちます。
- Multipart Upload または Part Copy 操作によって作成されたオブジェクトは、暗号化の方法に関係なく、MD5 ダイジェストではない ETag を持ちます。

(引用終わり)

外部からAWSが生成するETagを予想するのは困難なので
[オブジェクトの整合性をチェックする - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/checking-object-integrity.html)
にあるように、アルゴリズムを指定するとかTAGにつけるとかするしかなさそう。
