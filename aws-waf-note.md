

# WAFのログ用のKinesisを作る

[ウェブ ACL トラフィック情報のログ記録 \- AWS WAF、AWS Firewall Manager、および AWS Shield Advanced](https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/logging.html)
[送信元、宛先、および名前 - Amazon Kinesis Data Firehose](https://docs.aws.amazon.com/ja_jp/firehose/latest/dev/create-name.html)

> Amazon Kinesis Data Firehose を aws-waf-logs- で始まるプレフィックスを使用して作成します。
> 例えば aws-waf-logs-us-east-2-analytics
> PUT ソースを使用して、動作しているリージョンでデータ firehose を作成します

https://console.aws.amazon.com/kinesis