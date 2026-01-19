- Terraform, AWS SAM など同様の IaC ツール
- AWS CDK に似ているが、AWS CDK の 1000 倍早い
- 既存言語で書けるのは CDK 同様だが、YAML でも書ける
- Terraform の backend にあたるのが Pulumi の web(Pulumi Cloud Console)。GitHubAction みたいな UI がついてる
  - Local State もある。
- Pulumi Cloud Console をチームで使うなら有料 [Pricing | Pulumi](https://www.pulumi.com/pricing/)
- ~/.aws/credentials とかは見てくれない。環境変数を export または
- Terraform 同様 GoLang で書かれてる。インストールが簡単。
- すごい「こなれてる」印象。

# インストール

```bash
curl -fsSL https://get.pulumi.com | sh
```

`~/.pulumi/bin`にインストールされる。

~/.profile (かそれに該当するあれに)

```bash
# Pulumi
if [ -d "$HOME/.pulumi/bin" ] ; then
    PATH="$PATH:$HOME/.pulumi/bin"
fi
```

# コマンド補完

参考: [Command\-line Completion](https://www.pulumi.com/docs/reference/cli/#command-line-completion)

```bash
~/.pulumi/bin/pulumi gen-completion bash > ~/.pulumi/bash_completion
```

して

~/.profile (かそれに該当するあれに)

```bash
# Pulumi completion
if [ -f "$HOME/.pulumi/bash_completion" ] ; then
   .  "$HOME/.pulumi/bash_completion"
fi
```

# 利点欠点

CDK と同じく「最終的には宣言型になるのだが、その定義を手続き的に行う」やつ。これは「上から順番に処理される」ということ。

利点は既存言語の文法と関数が使えること。

欠点は、やっぱりフレームワークなので理解がめんどくさいこと。依存関係を勝手に解決してくれないこと(これは辛い)。

これはよい - [Terraform と Pulumiを比較する | apps-gcp.com](https://www.apps-gcp.com/terraform-pulumi-comparison/)

# メモ

- dev
- qa (Quality Assurance) QA 環境検証環境
- prod

# ハングアップ

pulumi new aws-go で作ったプロジェクトは pulumi up で死ぬ。
というか「すさまじく重い」だけなんだろうけど。

```
   1817 ?        Ds     0:03 tmux
   1818 pts/1    Ss     0:00  \_ -bash
   4081 pts/1    Dl+    0:03      \_ pulumi up
   4089 pts/1    Sl     0:02          \_ /home/heiwa/.pulumi/bin/pulumi-language-go -root=/home/heiwa/works/pulimi/quickstart 127.0.0.1:45813
   4103 pts/1    Sl     0:04              \_ /usr/bin/go run /home/heiwa/works/pulimi/quickstart
   5387 pts/1    Dl     0:06                  \_ /usr/lib/go-1.18/pkg/tool/linux_amd64/compile -o /tmp/go-build885722727/b002/_pkg_.a -trimpath /tmp/go-build885722727/b002=>
 -p github.com/pulumi/pulumi-aws/sdk/v5/go/aws/s3 -lang=go1.17 -complete -buildid 1xCTkzYjSPJsVoiuiErp/1xCTkzYjSPJsVoiuiErp -goversion go1.18.1 -c=2 -nolocalimports -importc
fg /tmp/go-build885722727/b002/importcfg -pack /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/accessPoint.go /home/heiwa/go/pkg/mod/github.com/p
ulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/accountPublicAccessBlock.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/analyticsConfiguration.go /h
ome/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucket.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketAcceler
ateConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketAclV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v
5.7.2/go/aws/s3/bucketCorsConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketIntelligentTieringConfiguration.go /home/heiwa
/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketLifecycleConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s
3/bucketLoggingV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketMetric.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v
5.7.2/go/aws/s3/bucketNotification.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketObject.go /home/heiwa/go/pkg/mod/github.com/pulumi/pu
lumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketObjectLockConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketObjectv2.go /home/heiwa
/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketOwnershipControls.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucke
tPolicy.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketPublicAccessBlock.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@
v5.7.2/go/aws/s3/bucketReplicationConfig.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketRequestPaymentConfigurationV2.go /home/heiwa/go
/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketServerSideEncryptionConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/
go/aws/s3/bucketV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/bucketVersioningV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/s
dk/v5@v5.7.2/go/aws/s3/bucketWebsiteConfigurationV2.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getBucket.go /home/heiwa/go/pkg/mod/github
.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getBucketObject.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getBucketObjects.go /home/heiwa
/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getBucketPolicy.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getCanonicalU
serId.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/getObject.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3
/getObjects.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/init.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s
3/inventory.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/objectCopy.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go
/aws/s3/pulumiEnums.go /home/heiwa/go/pkg/mod/github.com/pulumi/pulumi-aws/sdk/v5@v5.7.2/go/aws/s3/pulumiTypes.go
```

# aws-python

ここの内容
[Get Started with AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/)

```bash
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
mkdir quickstart && cd quickstart
pulumi new aws-python
# リージョンとか聞かれる。
# 特定のwwwページにアクセスするよう言われる。githubでログインした。
# venvを自動で作りpipも勝手にやる。
. ./venv/bin/activate
vim __main__.py  # S3バケット名だけ変える
pulumi up
```

このへんまちがい

git には venv は入ってないのでクローン先では

```bash
git clone xxxxx
python3 -m venv ./venv
. ./venv/bin/activate
pip install -r requirements.txt
```

しないとダメだ。このへんが「既存の言語が使える」の欠点。

あと

```bash
pulumi config
```

で dev 選ぶ。設定は `~/.pulumi/workspaces/`以下に保存される。

このへんからただしい手順

```bash
git clone xxxxx
cd xxxx
python3 -m venv ./venv
. ./venv/bin/activate
# で、
pulumi stack select dev
# または
pulumi stack new dev2
pulumi config set aws:region us-east-2
# で
pulumi up  # pip install -r requirements.txtは自動で行う(手動でもいいけど)
```

この手順も不要なのがあって、venv の activate はこのあと開発するなら必要。デプロイだけなら不要

[Pulumiを使用する上での実践的なTips | DevelopersIO](https://dev.classmethod.jp/articles/pulumi-tips/)

# Pulumiのサンプル

[pulumi/examples: Infrastructure, containers, and serverless apps to AWS, Azure, GCP, and Kubernetes... all deployed with Pulumi](https://github.com/pulumi/examples)

たとえば AWS Lambda(python) + AWS Gateway のサンプルコードを試す手順は

```bash
# GitHubのsvn APIで特定のディレクトリ以下だけを取得
sudo apt install subversion
svn export https://github.com/pulumi/examples/trunk/aws-py-apigateway-lambda-serverless

# プロジェクトに移動
cd aws-py-apigateway-lambda-serverless
pulumi stack init dev   # スタック名は自由に選んで!
## プロジェクト名は Pulumi.yaml に書かれたものになります

# AWSのIAMアカウントを環境変数で設定
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
## または
pulumi config set aws:profile default
##↑ ~/.aws/credentials,configのdefaultプロファイルが使われる(~/.aws/*以外にもできる)。

# 環境設定
pulumi config set aws:region us-east-2   # 好きなリージョンをえらんでね!

# デプロイ
pulumi up  # 自動でvenv環境を作り、pip install -r requirements.txtした上でデプロイする

# test
curl $(pulumi stack output apigateway-rest-endpoint)/test
```

このあと開発するなら

```bash
. ./venv/bin/activate
```

で python の venv 環境に入って `__main__.py` をいじりましょう。

サンプルを消す場合は

```bash
pulumi destroy
```

で。

# Pulumiのstack

「スタック」は AWS CloudFormation の stack とかではなくて、
dev, prod みたいなもの。Terraform の workspace みたいなもの?

スタックごとに変数(Configuration)を設定できる。
Terraform の variable, CFn の parameter に相当する。

すごいのはこれらが Pulumi Cloud に保存されること。
(outputs も、だがこれは CFn とか Terraform でも同じなので驚かない)

```bash
pulumi stack ls
pulumi stack select
pulumi stack select <名前>

# カレントのスタックに設定をする
pulumi config #list
pulumi config set <key> <value>
```

# Pulumiでマルチアカウントや異なるリージョン

```typescript
const eastRegion = new aws.Provider("east", {
  profile: aws.config.profile,
  region: "us-east-1", // Per AWS, ACM certificate must be in the us-east-1 region.
});
```

にして

```typescript
const certificateValidation = new aws.acm.CertificateValidation(
  "certificateValidation",
  {
    certificateArn: certificate.arn,
    validationRecordFqdns: validationRecordFqdns,
  },
  { provider: eastRegion },
);
```

みたいにいけばできるらしい。

[examples/index.ts at master · pulumi/examples](https://github.com/pulumi/examples/blob/master/aws-ts-static-website/index.ts)

# TerraformのDataやimportに近いもの

- [Import | Pulumi](https://www.pulumi.com/docs/intro/concepts/resources/options/import/)
- [Pulumi で既存のリソースを取り込む - tech.guitarrapc.cóm](https://tech.guitarrapc.com/entry/2019/12/09/015611)
