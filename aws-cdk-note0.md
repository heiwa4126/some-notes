CDK v2 がどうもうまくいかないので(無限ループして CPU をつかいまくる)、
ローカルの Windsows 上で環境作って試してみる。

「どうもうまくいかない」のではなくてやたらと遅いだけだった。
Python だと`cdk synth`で 20 秒もかかるの(環境による)。
メモリも使いまくるのでクラウドだと死ぬ。

CDK2 は JavaScript(と TS)以外は実用にならない感じ。
JavaScript でも十分遅くてムカつく。

いままで AWS SAM, Terraform と使ってきたけど、この遅さはちょっと CDK 使う気になれない。
CDK は宣言型が苦手な人がつかうのかなあ。(CDK も宣言型だけど)

npm が新しいと `cdk init --language typescript` で

```
npm WARN config global `--global`, `--local` are deprecated. Use `--location=global` instead.
```

が出て-g オプションが無視されるのもキツい。

[AWS CDK: The Good, the Bad and the Ugly - TechConnect IT Solutions](https://techconnect.com.au/aws-cdk-the-good-the-bad-and-the-ugly/)

> Anyone who has used AWS CDK will note how horribly, horribly slow it is. When you run cdk diff, everything is funnelled through the TypeScript codebase into CloudFormation templates by a process I would only describe as slow and chunky.

(訳)AWS CDK を使ったことがある人なら誰でも、それがいかに恐ろしく遅いかを指摘するだろう。
cdk diff を実行すると、すべてが TypeScript コードベースを通して CloudFormation テンプレートに集約され、遅くてもっさりしているとしか言いようがない処理になる。

Pulimi とかやってみます。
