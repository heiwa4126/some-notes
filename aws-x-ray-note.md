
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
