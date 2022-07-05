- Terraform, AWS SAMなど同様のIaCツール
- AWS CDKに似ているが、AWS CDKの1000倍早い
- 既存言語で書けるのはCDK同様だが、YAMLでも書ける
- Terraformのbackendにあたるのが pulumiのweb一択。GitHubActionみたいなUIがついてる
- チームで使うなら有料
- ~/.aws/credentials とかは見てくれない。環境変数をexport
- Terraform同様GoLangで書かれてる。インストールが簡単。
- すごい「こなれてる」印象。


# インストール

```bash
curl -fsSL https://get.pulumi.com | sh
```

~/.profile (かそれに該当するあれに)
```bash
# Pulumi
if [ -d "$HOME/.pulumi/bin" ] ; then
    PATH="$PATH:$HOME/.pulumi/bin"
fi
```


# ハングアップ

pulumi new aws-goで作ったプロジェクトはpulumi upで死ぬ。
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

gitにはvenvは入ってないのでクローン先では
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
でdev選ぶ。設定は `~/.pulumi/workspaces/`以下に保存される。



# コマンド補完

参考: [Command\-line Completion](https://www.pulumi.com/docs/reference/cli/#command-line-completion)

```bash
pulumi gen-completion bash > ~/.pulumi/bash_completion
```
して

~/.profile (かそれに該当するあれに)
```bash
# Pulumi completion
if [ -f "$HOME/.pulumi/bash_completion" ] ; then
   .  "$HOME/.pulumi/bash_completion"
fi
```

# Pulumiのサンプル

[pulumi/examples: Infrastructure, containers, and serverless apps to AWS, Azure, GCP, and Kubernetes... all deployed with Pulumi](https://github.com/pulumi/examples)

たとえば AWS Lambda(python) + AWS Gatewayを試す手順

```bash
svn export https://github.com/pulumi/examples/trunk/aws-py-apigateway-lambda-serverless
cd aws-py-apigateway-lambda-serverless
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID> 
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
pulumi stack init aws-py-apigateway-lambda-serverless
pulumi config set aws:region us-east-2
pulumi up
# test
curl $(pulumi stack output apigateway-rest-endpoint)/test
pulumi destroy
```
