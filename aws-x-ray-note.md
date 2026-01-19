# そこそこすぐ始められるチュートリアル

- [AWS CLI から AWS X-Ray の使用を開始する - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/scorekeep-ubuntu.html) - 機械翻訳
- [aws-samples/eb-java-scorekeep at xray-gettingstarted](https://github.com/aws-samples/eb-java-scorekeep/tree/xray-gettingstarted)

よくわからん。

AWS SAM は `sam init` で x-ray オプションあるのでそれが早いかも。ああできた。

デプロイして
curl で URL 呼んで
AWS X-Ray コンソールで、トレース開くだけ。

ただこれ CloudWatch log 同様
[AWS::XRay::Group](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-xray-group.html)
書いたほうがいいのでは。Former2 で掘ってみる。

## CFnメモ

上の sam を Former2 で掘ってみた。

app.py は普通。trace 的なものはなにも入ってない。

AWS::Lambda::Function だと

```yaml
Properties:
  TracingConfig:
    Mode: "Active"
```

Role は

- "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
- "arn:aws:iam::aws:policy/service-role/"

"AWS::XRay::Group"はデフォルトしかない

```yaml
XRayGroup:
  Type: "AWS::XRay::Group"
  Properties:
    GroupName: "Default"
    InsightsConfiguration:
      InsightsEnabled: false
      NotificationsEnabled: false
```

プロジェクトごとに指定できたほうがいいよね...

グループの作成
[Configuring groups in the X-Ray console - AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/xray-console-groups.html#xray-console-group-create-console)

ああなるほど。グループはルールベースなんだ。
**最初からフィルタって名前にしとけばいいのに**

[フィルタ式を使用したコンソールでのトレースの検索 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-console-filters.html)

では AWS::XRay::SamplingRule は?

- [AWS::XRay::SamplingRule - AWS CloudFormation](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-xray-samplingrule.html)
- [aws_xray_sampling_rule | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_sampling_rule)

AWS X-Ray

AWS のモニタリングサービスの 1 つで
主にプロファイラ、エラー検出の機能を持つ。

用語

X-Ray で使われる用語は [AWS X-Ray の概念 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-concepts.html) を参照。

とりあえず知っておく用語は以下の 2 つ

トレース

一連のサービス呼び出し・結果の返却(「セグメント」)の塊。たとえば API Gateway の stage から Lambda が呼び出され、Lambda が DynamDB を呼んで... の一連のセグメント。

トレース 1 個分を表示するのが
[X-Rayコンソール](https://console.aws.amazon.com/xray/home#)
の
[traces](https://console.aws.amazon.com/xray/home#/traces)
で、
一定期間のトレースをまとめて表示するのが
[service map](https://console.aws.amazon.com/xray/home#/service-map)

グループ

グループという名前だが、実質フィルタ。トレースに対する条件式を書く。
X-Ray コンソールのトレースやサービスマップでグループを指定すると、フィルタされたトレースのみが表示されるようになる。

条件式はこれ [フィルタ式を使用したコンソールでのトレースの検索 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-console-filters.html)

Lambda の同期呼出のサンプル

非同期呼出や Poll ベース呼出だと

dev で X-Ray を有効にして、prod で無効にする、のようなマスタースイッチ的な機能は?

アプリケーション側では
Lambda Powertools Python を使うなら、[Disabling response auto\-capture](https://awslabs.github.io/aws-lambda-powertools-python/latest/core/tracer/#disabling-response-auto-capture) からの 3 節を参照。

参考リンク
[AWS再入門ブログリレー2022 X-Ray編 | DevelopersIO](https://dev.classmethod.jp/articles/re-introduction-2022-x-ray/)
