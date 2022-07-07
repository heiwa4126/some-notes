#  Pulumi 入門

[Pulumi](https://www.pulumi.com/)を使ってみたら大変楽しかったのでメモを書いておきます。

## Pulumi まとめ

- Terraform, AWS SAMなど同様の[IaC](https://docs.microsoft.com/ja-jp/learn/modules/explore-infrastructure-code-configuration-management/)ツール。
- AWS CDKに似ているが、AWS CDKの1000倍早いし、ちゃんと動く。
- Linux, MacOS, Windowsで動く。
- Terraform同様GoLangで書かれてる。インストールが超簡単。
- 専用言語でなく既存言語で書けるのはCDK同様 (TypeScript, Python, C#, Go, Java)
   - YAMLでも書ける
   - Go, Java版はベータ
- Terraformのbackendにあたるのが [Pulumi Cloud](https://app.pulumi.com/)。GitHubActionみたいなUIがついてる。
  - デフォルトのstate保存場所は上記のクラウドだが、Local Stateもある。
- Pulumi Cloud をチームで使うなら有料 ([価格表](https://www.pulumi.com/pricing/))


## チュートリアルをやってみる

以下、
[Get Started with AWS](https://www.pulumi.com/docs/get-started/aws/)
にある「AWS S3をWWW公開するチュートリアル」を

- Linux (Ubuntu 22.04LTSを使いました) 
- Python (3.10) 
 
でやってみます。ほかのOSの方は[Get Started with AWS](https://www.pulumi.com/docs/get-started/aws/)を参照してください。


## Pulumiのインストール

[Before You Begin | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/begin/)

```bash
curl -fsSL https://get.pulumi.com | sh
```

`~/.pulumi/bin`にインストールされるので

~/.profile (または~/.bash_rcに)
```bash
# Pulumi
if [ -d "$HOME/.pulumi/bin" ] ; then
    PATH="$PATH:$HOME/.pulumi/bin"
fi
```
と追記してPATHを通しましょう。

コマンド補完もあります。参考: [Command-line Completion](https://www.pulumi.com/docs/reference/cli/#command-line-completion)

```bash
~/.pulumi/bin/pulumi gen-completion bash > ~/.pulumi/bash_completion
```
を実行して

~/.profile (または~/.bash_rcに)
```bash
# Pulumi completion
if [ -f "$HOME/.pulumi/bash_completion" ] ; then
   .  "$HOME/.pulumi/bash_completion"
fi
```

あとは一旦 logout & login するなどして、以上の設定を反映させましょう。

## AWSのIAMアカウントの設定

[Configure Pulumi to access your AWS account](https://www.pulumi.com/docs/get-started/aws/begin/#configure-pulumi-to-access-your-aws-account)

デプロイ先アカウントの設定は様々な方法がありますが(参考: [AWS Classic Setup | Pulumi](https://www.pulumi.com/registry/packages/aws/installation-configuration/#create-a-shared-credentials-file))
ここではチュートリアルにあるように

```bash
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
```
で設定します。


## プロジェクトの作成

[Create a New Project](https://www.pulumi.com/docs/get-started/aws/create-project/#create-a-new-project)

```bash
mkdir quickstart && cd quickstart
pulumi new aws-python
```

上記を実行すると、

- プロジェクト名 (デフォルトはディレクトリ名)
- プロジェクトの説明
- スタック名 (デフォルトは`dev`)
- AWSのリージョン (デフォルトは`us-east-1`)

を聞いてきますので、リージョン以外はとりあえずただENTERを押せばいいです。

「スタック」はTerraformのworkspaceみたいなものです。stateとvariable(parameter)をまとめて管理します。devはdev, qa, prodのdevですね。
スタックについて詳しくは [Stacks | Pulumi](https://www.pulumi.com/docs/intro/concepts/stack/) を参照してください。

続けて、
いままで Pulumi Cloudに入ったことのないユーザ(ユーザ毎です)では、以下のような表示が出ます。

**TODO**

このURLをWWWブラウザで開くと、
いままで Pulumi Cloudに入ったことのないブラウザ(ブラウザ毎です)では
以下のような画面になり、アカウントの作成を促されます

自分はGitHub連携でアカウントを作りました。

すると以下のような画面になって、


**TODO**


自分はホスト名にしました

i-xxxxxxx のようなトークンが得られますので、これを最初のターミナルに張り付けて、ENTERを押しましょう。これでカレントユーザとPulumi Cloudとの連携ができました。


## プロジェクトのカスタマイズ

[Review the New Project | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/review-project/)

初期状態では「S3バケットを1個作る」プロジェクトが出来ます。

エディタで `__main__.py` を開き
```bash
vim __main__.py
```
でS3バケットの名前だけ修正しましょう(S3は世界で1つだけの名前をつける必要があります)。

```python
import pulumi
from pulumi_aws import s3

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket('ota-pulumi-bucket')   # <-ここだけ各々変えてください。

# Export the name of the bucket
pulumi.export('bucket_name',  bucket.id)
```

## プロジェクトの最初のデプロイ

[Deploy the Stack | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/deploy-stack/)

```bash
pulumi up
```

を実行するとレビュー画面が出て、yes/no/details を選択するように要求されます。
矢印キーの上下で yes を選んでENTERを押すとデプロイが始まります。


## プロジェクトの修正

[Modify the Program | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/modify-program/)

```bash
cat <<EOT > index.html
<html>
    <body>
        <h1>Hello, Pulumi!</h1>
    </body>
</html>
EOT
```
を実行して、 `index.html` を作ります。


また `__main__.py` にコードを追加して

```python
"""An AWS Python Pulumi program"""

import pulumi
from pulumi_aws import s3

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket(
    "ota-pulumi-bucket",  # <-ここだけは各々変えてください。
    website=s3.BucketWebsiteArgs(
        index_document="index.html",
    ),
)

bucketObject = s3.BucketObject(
    "index.html",
    acl="public-read",
    content_type="text/html",
    bucket=bucket,
    source=pulumi.FileAsset("index.html"),
)

# Export the name of the bucket
pulumi.export("bucket_name", bucket.id)
pulumi.export(
    "bucket_endpoint", pulumi.Output.concat("http://", bucket.website_endpoint)
)
```
のようにしましょう。

## プロジェクトの再デプロイと削除

[Deploy the Changes | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/deploy-changes/)

再び
```bash
pulumi up
```
で、デプロイするとAWS S3をWWW公開するチュートリアルの出来上がり。


```bash
curl $(pulumi stack output bucket_endpoint)
```
で確認しましょう。


[Destroy the Stack | AWS | Pulumi](https://www.pulumi.com/docs/get-started/aws/destroy-stack/)

```bash
pulumi destory
```

でデプロイしたものは全部消えます。これでチュートリアルは完了。


## 公式サンプル

Pulumiの公式サンプルは
[pulumi/examples: Infrastructure, containers, and serverless apps to AWS, Azure, GCP, and Kubernetes... all deployed with Pulumi](https://github.com/pulumi/examples)
にあります。これらを基盤にプロジェクトを作っていくといいでしょう。

たとえば AWS Lambda(Python) + AWS Gatewayのサンプルコード([これ](https://github.com/pulumi/examples/tree/master/aws-py-apigateway-lambda-serverless))を試す手順は

```bash
# GitHubのsvn APIで特定のディレクトリ以下だけを取得
sudo apt install subversion
svn export https://github.com/pulumi/examples/trunk/aws-py-apigateway-lambda-serverless

# プロジェクトに移動
cd aws-py-apigateway-lambda-serverless
pulumi stack init dev   # スタック名は自由に選んで!
## プロジェクト名は Pulumi.yaml の name: に書かれたものになります

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

テストで "Cheers from AWS Lambda!!" と表示されれば‘OKです。

このあと開発するなら
```bash
. ./venv/bin/activate
```
でPythonのvenv環境に入って `__main__.py` をいじりましょう。

サンプルを消す場合は
```bash
pulumi destroy
```
で。


# 感想

すごく「こなれてる」感じで楽しいです。stateをparameterをクラウドにおけるのがえらい(Enterprise版に入るとコードの方もGitHub連携できるそうです)。

AWS CDKと同じく「最終的には宣言型になるのだが、その定義を手続き的に行う」やつ。これは「上から順番に処理される」ということ。

利点は既存言語の文法と関数とツールが使えること。IDE, formatterやlinterがそのまま使えるのは便利。

欠点は、やっぱりフレームワークなので理解がめんどくさいこと。あと、依存関係を勝手に解決してくれないこと(これは辛い)。

これは参考になる(少し古い)  [Terraform と Pulumiを比較する | apps-gcp.com](https://www.apps-gcp.com/terraform-pulumi-comparison/)。Terraformのimportやdataに相当するものはあります。[Import | Pulumi](https://www.pulumi.com/docs/intro/concepts/resources/options/import/)

Terraform同様AWSのマルチリージョン、マルチアカウントに対応している(らしい。まだ試してない)。

aws-goのプロジェクトを作ったらpulumi upでスタックした。非力なホストで実行しないこと。

Terraformと比べると検索結果が少ない感じ。後発なのでしかたないのと、HCL一本じゃないので各言語毎に分かれるみたい。
