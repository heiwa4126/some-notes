CDK v2がどうもうまくいかないので(無限ループしてCPUをつかいまくる)、
ローカルのWindsows上で環境作って試してみる。

「どうもうまくいかない」のではなくてやたらと遅いだけだった。
Pythonだと`cdk synth`で20秒もかかるの(環境による)。
メモリも使いまくるのでクラウドだと死ぬ。

CDK2はJavaScript(とTS)以外は実用にならない感じ。
JavaScriptでも十分遅くてムカつく。

いままでAWS SAM, Terraformと使ってきたけど、この遅さはちょっとCDK使う気になれない。
CDKは宣言型が苦手な人がつかうのかなあ。(CDKも宣言型だけど)

npmが新しいと `cdk init --language typescript` で

```
npm WARN config global `--global`, `--local` are deprecated. Use `--location=global` instead.
```

が出て-gオプションが無視されるのもキツい。

[AWS CDK: The Good, the Bad and the Ugly - TechConnect IT Solutions](https://techconnect.com.au/aws-cdk-the-good-the-bad-and-the-ugly/)

> Anyone who has used AWS CDK will note how horribly, horribly slow it is. When you run cdk diff, everything is funnelled through the TypeScript codebase into CloudFormation templates by a process I would only describe as slow and chunky.

(訳)AWS CDKを使ったことがある人なら誰でも、それがいかに恐ろしく遅いかを指摘するだろう。
cdk diffを実行すると、すべてがTypeScriptコードベースを通してCloudFormationテンプレートに集約され、遅くてもっさりしているとしか言いようがない処理になる。

Pulimiとかやってみます。
