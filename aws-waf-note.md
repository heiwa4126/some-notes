# AWS WAF

## WAF のログ用の Kinesis を作る

[ウェブ ACL トラフィック情報のログ記録 \- AWS WAF、AWS Firewall Manager、および AWS Shield Advanced](https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/logging.html)
[送信元、宛先、および名前 - Amazon Kinesis Data Firehose](https://docs.aws.amazon.com/ja_jp/firehose/latest/dev/create-name.html)

> Amazon Kinesis Data Firehose を aws-waf-logs- で始まるプレフィックスを使用して作成します。
> 例えば aws-waf-logs-us-east-2-analytics
> PUT ソースを使用して、動作しているリージョンでデータ firehose を作成します

https://console.aws.amazon.com/kinesis

## WAF のログを CloudWatch Logs に出す

[AWS WAF のログ記録をオンにする | AWS re:Post](https://repost.aws/ja/knowledge-center/waf-turn-on-logging)

マネジメントコンソールから WAF のログを有効にしようとすると

> Error: WAFLogDestinationPermissionIssueException: Unable to deliver logs to the configured destination. You might need to grant log delivery permissions for the destination. If you're using S3 as your log destination, you might have exceeded your bucket limit.

と言われてどうにもならん。

[Amazon CloudWatch Logs - AWS WAF、AWS Firewall Manager、および AWS Shield Advanced](https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/logging-cw-logs.html#logging-cw-logs-permissions)

[AWS::Logs::ResourcePolicy - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-logs-resourcepolicy.html)

> An account can have up to 10 resource policies per AWS Region.

↑「アカウントごとに 10 個しか作れない」ことに注意

[CloudFormation で AWS WAF のログを CloudWatchLogs に出力してみた | DevelopersIO](https://dev.classmethod.jp/articles/cfn-create-waf-log-to-cwlogs/)

CloudWatch Logs のリソースポリシーを aws cli で表示するには

`aws logs describe-resource-policies`

`aws logs describe-resource-policies | jq -r '.resourcePolicies[]|select(.policyName == "XXXXXPolicy").policyDocument' | yq -y .`

[CloudFormation で AWS WAF のログを CloudWatchLogs に出力してみた | DevelopersIO](https://dev.classmethod.jp/articles/cfn-create-waf-log-to-cwlogs/)で設定している
WAF の policyDocument 部分を YAML にしたもの。

```yaml
Version: "2012-10-17"
Statement:
  - Effect: Allow
    Principal:
      Service: delivery.logs.amazonaws.com
    Action:
      - logs:CreateLogStream
      - logs:PutLogEvents
    Resource: arn:aws:logs:ap-northeast-1:999999999999:log-group:aws-waf-logs-xxxxxxxxxxxx:*
    Condition:
      StringEquals:
        aws:SourceAccount: "999999999999"
      ArnLike:
        aws:SourceArn: arn:aws:logs:ap-northeast-1:999999999999:*
```

すげえざっくりだ。
[AWS WAF のログ記録をオンにする | AWS re:Post](https://repost.aws/ja/knowledge-center/waf-turn-on-logging)
にあるのとほぼ同じになるのでたぶん大丈夫。
