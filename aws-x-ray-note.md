
# そこそこすぐ始められるチュートリアル

- [AWS CLI から AWS X-Ray の使用を開始する - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/scorekeep-ubuntu.html) - 機械翻訳
- [aws-samples/eb-java-scorekeep at xray-gettingstarted](https://github.com/aws-samples/eb-java-scorekeep/tree/xray-gettingstarted)

よくわからん。

AWS SAMは `sam init` で x-rayオプションあるのでそれが早いかも。ああできた。

デプロイして
curlでURL呼んで
AWS X-Rayコンソールで、トレース開くだけ。

ただこれCloudWatch log同様
[AWS::XRay::Group](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-resource-xray-group.html)
書いたほうがいいのでは。Former2で掘ってみる。

## CFnメモ

上のsamをFormer2で掘ってみた。

app.pyは普通。trace的なものはなにも入ってない。

AWS::Lambda::Functionだと
```yaml
Properties:
  TracingConfig: 
    Mode: "Active"
```


Roleは
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
- [aws\_xray\_sampling\_rule | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/xray_sampling_rule)



AWS X-Ray

AWSのモニタリングサービスの1つで
主にプロファイラ、エラー検出の機能を持つ。


用語

X-Rayで使われる用語は [AWS X-Ray の概念 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-concepts.html) を参照。

とりあえず知っておく用語は以下の2つ

トレース

一連のサービス呼び出し・結果の返却(「セグメント」)の塊。たとえばAPI GatewayのstageからLambdaが呼び出され、LambdaがDynamDBを呼んで... の一連のセグメント。

トレース1個分を表示するのが
[X-Rayコンソール](https://console.aws.amazon.com/xray/home#)
の
[traces](https://console.aws.amazon.com/xray/home#/traces)
で、
一定期間のトレースをまとめて表示するのが
[service map](https://console.aws.amazon.com/xray/home#/service-map)

グループ

グループという名前だが、実質フィルタ。トレースに対する条件式を書く。
X-Rayコンソールのトレースやサービスマップでグループを指定すると、フィルタされたトレースのみが表示されるようになる。

条件式はこれ [フィルタ式を使用したコンソールでのトレースの検索 - AWS X-Ray](https://docs.aws.amazon.com/ja_jp/xray/latest/devguide/xray-console-filters.html)








Lambdaの同期呼出のサンプル

非同期呼出やPollベース呼出だと



devでX-Rayを有効にして、prodで無効にする、のようなマスタースイッチ的な機能は?

アプリケーション側では
Lambda Powertools Pythonを使うなら、[Disabling response auto\-capture](https://awslabs.github.io/aws-lambda-powertools-python/latest/core/tracer/#disabling-response-auto-capture) からの3節を参照。


参考リンク
[AWS再入門ブログリレー2022 X-Ray編 | DevelopersIO](https://dev.classmethod.jp/articles/re-introduction-2022-x-ray/)
