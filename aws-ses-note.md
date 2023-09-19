SESアイデンティティの「作成とベリファイ」はCFnではできない
**(本当)**。CFnがないのでFormer2でもみつからない。

CFnのカスタムリソースを作った人ならいる。
[medmunds/aws-cfn-ses-domain: AWS CloudFormation resources for Amazon SES domain and email identities](https://github.com/medmunds/aws-cfn-ses-domain)

(追記: AWS CDKならできる。サンプル: [amazon web services - Verify SES email address through CDK - Stack Overflow](https://stackoverflow.com/questions/65886628/verify-ses-email-address-through-cdk))

AWS CLIなら
SES emailアイデンティティを作成してベリファイメールを送る [verify-email-identity](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ses/verify-email-identity.html)
をつかってできる。boto3でも同様。

参考: [E メールアドレスの検証 - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/verify-email-addresses-procedure.html)

で、バウンスは
[Amazon SES での E メール送信のテスト \- Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/send-email-simulator.html)
のアドレスのうち、

- bounce
- suppressionlist
- complaint (やや特殊なメールがとどく)

がSENDERに届く(デフォルト設定の`ForwardingEnabled: true`)。

> E メールのフィードバック転送はデフォルトで有効です

[E メールで送信された Amazon SES 通知 - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/monitor-sending-activity-using-notifications-email.html)

デフォルト動作以外に

- Bounce (エラーや不在)
- Complaint (スパム扱いされた)
- Delivery (うまく配送された)

についてSNSトピックを指定できる(Eメール以外にいろんな先に流せる)。

AWS CLIは
[set-identity-notification-topic](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ses/set-identity-notification-topic.html) - SES emailアイデンティティにバウンスノーティフィケーションのSNSトピックを設定。

SES IDにひもづいた属性をリストする方は
[get-identity-notification-attributes](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ses/get-identity-notification-attributes.html)
で、こちらは
オプションが `--identities` と複数になるのに注意。

# ベリファイメール

これでカスタマイズできるらしい。
[カスタム検証 E メールテンプレートの使用 - Amazon Simple Email Service Classic](https://docs.aws.amazon.com/ja_jp/ses/latest/DeveloperGuide/send-email-verify-address-custom.html)
試す。

# 調べる

SES IDがドメインだったら?
→ まあおおむね同じみたい。
