# Terraform メモ

## インストール

### Debian, Ubuntu

パッケージで
[Install Terraform | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

(下のほうに正しい手段が)

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

この手順通りにやると
`W: https://apt.releases.hashicorp.com/dists/jammy/InRelease: Key is stored in legacy trusted.gpg keyring (/etc/apt/trusted.gpg), see the DEPRECATION section in apt-key(8) for details.`
が出る。

あとで調査。

- [21.10 - apt-key deprecation warning when updating system - Ask Ubuntu](https://askubuntu.com/questions/1398344/apt-key-deprecation-warning-when-updating-system)
- [Ubuntu Manpage: apt-key - Deprecated APT key management utility](https://manpages.ubuntu.com/manpages/jammy/en/man8/apt-key.8.html)

man 8 apt-key の DEPRECATION(廃止)セクションの記述によると

> wget -qO- https://myrepo.example/myrepo.asc | sudo apt-key add -

みたいのは、こうやれ

> wget -qO- https://myrepo.example/myrepo.asc | sudo tee /etc/apt/trusted.gpg.d/myrepo.asc

ということなので

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/trusted.gpg.d/terraform.asc

まず `sudo apt-key list hashicorp`で確認 & `sudo apt-key remove "E8A0 32E0 94D8 EB4E A189  D270 DA41 8C88 A321 9F7B"`
で、改めて
`curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/trusted.gpg.d/terraform.asc`
`sudo apt-key list hashicorp`で再確認

まとめると

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /etc/apt/trusted.gpg.d/hashicorp.asc > /dev/null
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

[第 675 回 apt-key はなぜ廃止予定となったのか:Ubuntu Weekly Recipe | gihyo.jp ... 技術評論社](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0675)

#### pgp 鍵の更新メモ(2023-02 ごろ)

とりあえず
`sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA16FCBCA621E701`
(apt-key は廃止だってば)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
```

参考: [GPG error : The following signatures couldn't be verified because the public key is not available: NO_PUBKEY AA16FCBCA621E701 · Issue \#32622 · hashicorp/terraform](https://github.com/hashicorp/terraform/issues/32622)

### 直接落とす

HashiCorp から落とす。

[HashiCorp Terraform - Provision & Manage any Infrastructure](https://www.hashicorp.com/products/terraform)

あたらしいバージョンは https://releases.hashicorp.com/terraform/ で確認。
GoLang だからダウンロードして展開するだけ。

(2022-06-13)

```sh
sudo yum install curl unzip
## or
sudo apt install curl unzip
##
curl https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_linux_amd64.zip -O
sudo unzip ./terraform_1.2.2_linux_amd64.zip -d /usr/local/bin/
terraform -v
```

## bash への completion

```bash
terraform -install-autocomplete
. ~/.bashrc
```

## プラグインのキャッシュ

プラグイン、GoLang なのででかい。キャッシュするべき。

```
$ cat ~/.terraformrc
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
```

[CLI Configuration \| Terraform by HashiCorp](https://www.terraform.io/cli/config/config-file#plugin_cache_dir)

## ドキュメント

[Overview - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language)

## サンプルなど

[terraform-aws-modules/ec2-instance/aws | Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)

## チュートリアル

[Terraform Tutorials - HashiCorp Learn](https://learn.hashicorp.com/terraform)

## ログを出す

```bash
export TF_LOG=WARN
export TF_LOG_PATH=./terraform.log
```

TF_LOG は TRACE DEBUG INFO WARN ERROR OFF

[Environment Variables | Terraform by HashiCorp](https://www.terraform.io/cli/config/environment-variables)

## security_groups で forces replacement とか言われたら

aws_instance で security_groups を使うな。
vpc_security_group_ids を使うこと。

## associate_public_ip_address で forces replacement とか言われたら

```
  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }
```

[Get terraform to ignore "associate_public_ip_address" status for stopped instance - Stack Overflow](https://stackoverflow.com/questions/52519463/get-terraform-to-ignore-associate-public-ip-address-status-for-stopped-instanc)

## you need to accept terms and subscribe

```output
Error: creating EC2 Instance: OptInRequired: In order to use this AWS Marketplace product you need to accept terms and subscribe.
To do so please visit https://aws.amazon.com/marketplace/pp?sku=cotnnspjrsi38lfn8qo4ibnnm
```

1. (AWS のアカウントでログインしたまま) このページに行く。
2. `Continue to Subscribe` ボタン
3. `Accept Term` ボタン (このへんプロダクトによりけり)

## terraform import aws_key_pair. が失敗する

[Terraform fails to import key pair with Amazon EC2 - Stack Overflow](https://stackoverflow.com/questions/40120065/terraform-fails-to-import-key-pair-with-amazon-ec2)

key-XXXXX の ID ではなくて、名前のほうを引数にする。

## 特定のリソースだけ destory

```bash
terraform destroy -target={リソース名} -target={リソース名} ...
```

## output を output

```bash
terraform output
## 個別指定も
terraform output <name>
## クォートなしで出したいときは
terraform output -raw <name>
## JSONでも
terraform output -json
```

## Terraform の backend

state ファイルを管理共有参照流用できる。

- [Backend Overview - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends)
- [Backend Type: local | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/local)
- [Backend Type: s3 | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/s3)
- [Backend Type: azurerm | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/azurerm)

あとこれ
[Store Remote State | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started)

backend の key に var が使えない。
[Terraform の「ここは variable 使えないのか...」となった所 - Qiita](https://qiita.com/ymmy02/items/e7368abd8e3dafbc5c52)

### backend の key に var が使えないのが辛い

いちおうこういう解決方法が。

`terraform init -backend-config=backend.conf`

[snowflake cloud data platform - "Variables may not be used here" during terraform init - Stack Overflow](https://stackoverflow.com/questions/65838989/variables-may-not-be-used-here-during-terraform-init)

## Linter

- [terraform-linters/tflint: A Pluggable Terraform Linter](https://github.com/terraform-linters/tflint)
- [aquasecurity/tfsec: Security scanner for your Terraform code](https://github.com/aquasecurity/tfsec)

## ランダムな名前

AWS SAM みたいなことをやりたいとき。

name 必須のもの以外で name 省略すれば OK みたい。
ただ普通はもうちょっと意味のある名前にしたいわけだ。

- [How to use unique resource names with Terraform - Advanced Web Machinery](https://advancedweb.hu/how-to-use-unique-resource-names-with-terraform/)
- [Docs overview | hashicorp/random | Terraform Registry](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

## .terraform.lock.hcl

`go.sum` みたいなやつ。

git には残すべきなんだけど、ちがうプラットフォームに持ってくと死ぬ。(Go のバイナリのハッシュが違うから当然だけど)
CI/CD とかで問題になるかも。

## Windows 用の.terraformrc

[CLI Configuration | Terraform by HashiCorp](https://www.terraform.io/cli/config/config-file)

`%APPDATA%\terraform.rc`

plugin_cache_dir とかは掘ってくれない。¥ は\\。

## terraform import

[Import | Terraform by HashiCorp](https://www.terraform.io/cli/import)

> 現在の Terraform import の実装では、リソースをステートにインポートすることしかできません。

まあそうでしょう。

## locals は

マクロみたいに使える感じ。スコープがよくわからん。module の外へ出てこれる?

## aws_iam_role_policy_attachment は

モジュールでもとの role に policy を追加していける感じなのかな。

## ここの名前

```terraform
resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
```

の web の名前は local name でいいみたい。

[Resources - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/resources/syntax)

## terraform-docs

[terraform-docs/terraform-docs: Generate documentation from Terraform modules in various output formats](https://github.com/terraform-docs/terraform-docs)

```bash
curl -LO https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-amd64.tar.gz
tar zxvf terraform-docs-v0.16.0-linux-amd64.tar.gz terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin
```

terraform.tfvars を生成できるのは便利かも。
[Generate terraform.tfvars | terraform-docs](https://terraform-docs.io/how-to/generate-terraform-tfvars/)

```bash
terraform-docs tfvars hcl .
```

stdout に出るので terraform.tfvars にリダイレクトするなどして適当に編集する。

## aws_api_gateway_deployment

deployment に対処するには

```bash
terraform taint aws_api_gateway_deployment.example
```

みたいにするか [Serverless with AWS Lambda and API Gateway | Guides | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/serverless-with-aws-lambda-and-api-gateway)

aws_api_gateway_deployment リソースで
stage_description に時間を指定するか `stage_description = "timestamp = ${timestamp()}"`

[Terraform で作った Amazon API Gateway に変更があっても再デプロイされない問題に対処する - Qiita](https://qiita.com/tksugimoto/items/33f9fe6aa48a1343e360)

[aws_api_gateway_deployment | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) にあるように trigger をコツコツ書くか。

## aws_api_gateway_integration

[aws_api_gateway_integration | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration)

[integration_http_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration#integration_http_method)

> Not all methods are compatible with all AWS integrations. e.g., Lambda function can only be invoked via POST.

type が AWS\* なら **integration_http_method は絶対 POST でないとダメ**。

参照: [Lambda 統合を使用した API Gateway API の「Execution failed due to configuration」(設定エラーのため実行に失敗しました) エラーを修正する](https://aws.amazon.com/jp/premiumsupport/knowledge-center/api-gateway-lambda-template-invoke-error/)

## aws_api_gateway_rest_api で OpenAPI を使う

- [aws_api_gateway_rest_api | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api)
- [terraform-provider-aws/examples/api-gateway-rest-api-openapi at main · hashicorp/terraform-provider-aws](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples/api-gateway-rest-api-openapi)

## terraform output を環境変数に出す

こんな方法やあんな方法が。terraform 自体では特にサポートはない。

- [Assign terraform output to environment variable - Stack Overflow](https://stackoverflow.com/questions/64834935/assign-terraform-output-to-environment-variable)
- [bash - Can I set terraform output to env variables? - Stack Overflow](https://stackoverflow.com/questions/65315202/can-i-set-terraform-output-to-env-variables)
- [Output Data from Terraform | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/outputs)

## リソースのリスト

```bash
terraform state list
```

## AWS マルチアカウント

これとこれを組合せばできるはず。

- [amazon web services - Deploying to multiple AWS accounts with Terraform? - Stack Overflow](https://stackoverflow.com/questions/52206436/deploying-to-multiple-aws-accounts-with-terraform)
- [amazon web services - Terraform を使用して複数のアカウントに展開しますか? - 初心者向けチュートリアル](https://tutorialmore.com/questions-304405.htm)

前者の「SSL 証明書だけ us-east-1 でつくらなければならない」のアレは参考になる。
[alias: Multiple Provider Configurations](https://www.terraform.io/language/providers/configuration#alias-multiple-provider-configurations)

これは AWS と Azure みたいなことはできるのか?

## フォルダの中身を全部 s3 にアップロード

[How to Upload Files to S3 using Terraform](https://linoxide.com/upload-files-to-s3-using-terraform/)

for_each を使う。ただ contents_type はうまくいかないよね...

あと上の例は aws_s3_bucket_object なので [aws_s3_object | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) にするように。

contents_type については
この "Expanding to multi-file upload"の例がいいかも。
[Using Terraform for S3 Storage with MIME Type Association | State Farm Engineering](https://engineering.statefarm.com/blog/terraform-s3-upload-with-mime/)

## backend の練習

たとえば backend を S3 にとれば、別のホストでも OK、のはずなんだけど、ホントかどうかを試してみる。

バックエンドは「S3 バックエンドを作る Terraform」があったので、これをちょっとだけカスタマイズして使わせていただいた。
[Backend の S3 や DynamoDB 自体を terraform で管理するセットアップ方法 - Qiita](https://qiita.com/saiya_moebius/items/a8f8aa3683c2347d607c)

## aws_s3_bucket の website_endpoint が null になる

これバグかなにか。
2 度 apply するととれる。あきらめて Region やなんかから合成するか
aws_s3_bucket_website_configuration の website_endpoint を使う。

## override.tf

- [Override Files - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/files/override)
- [Terraform の state 移動と rename](https://dev.thanaism.com/2021/08/dividing-terraform-state/)

> Terraform では\*\_override.tf あるいは override.tf という名称のファイルは、実行時に上書き情報として処理されるようになっています

## state の移動・分離

検索するといっぱい出てくるのでよくある話らしい。
[terraform state を移動する - Google 検索](https://www.google.co.jp/search?q=terraform+state%E3%82%92%E7%A7%BB%E5%8B%95%E3%81%99%E3%82%8B&lr=lang_ja&hl=ja&tbs=lr%3Alang_1ja&sxsrf=ALiCzsbLvXmfiW05bRGPx4PPXPUMRC543A%3A1657167797350&ei=tV_GYoD-FJ-w2roP0-Gv0Ao&ved=0ahUKEwjArJOP9-X4AhUfmFYBHdPwC6oQ4dUDCA8&uact=5&oq=terraform+state%E3%82%92%E7%A7%BB%E5%8B%95%E3%81%99%E3%82%8B&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEKIEMgUIABCiBDIFCAAQogQyBQgAEKIEMgUIABCiBDoHCAAQRxCwA0oECEEYAEoECEYYAFDjG1ioKmD7L2gBcAF4AIABwQGIAYUGkgEDNC4zmAEAoAEByAEKwAEB&sclient=gws-wiz)

## 自動で読み込まれる変数ファイル (と適応順)

[I tried 4 different Ways to assign variable in terraform | DevelopersIO](https://dev.classmethod.jp/articles/i-tried-4-different-ways-to-assign-variable-in-terraform/) からコピペ

1. Environment variables
1. The terraform.tfvars file,
1. The terraform.tfvars.json file
1. Any _.auto.tfvars or _.auto.tfvars.json files, processed in lexical order of their filenames.
1. Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

1 から順に適応。`*.auto.tfvars`についてはファイル名順。

## terraform.tfvar をレポジトリに含められない問題

[Terraform .tfvars files: Variables Management with Examples](https://spacelift.io/blog/terraform-tfvars)

うまい方法がない。git に「シークレットチャンネル」みたいのがあるといいんだけど。

## Terraform のドリフト検出と反映について

公式:

- [Detecting and Managing Drift with Terraform](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform)
- [Manage Resource Drift | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/resource-drift)

上のはちょっとふるい。(-refresh-only オプションが無い)
下のは [Associate Tutorial List | Terraform - HashiCorp Learn](https://learn.hashicorp.com/collections/terraform/certification-associate-tutorials) の一部

- `terraform refresh` - state を現実にあわせる
- `terraform apply --refresh` - レビュー付き

基本は `terraform apply`だけでも現実との乖離をチェックする。
`pulumi up`は`pulumi refresh`を明示しないとダメ。

## null

- [Terraform の for_each と null で、効率的に AWS のセキュリティグループを定義する | DevelopersIO](https://dev.classmethod.jp/articles/terraform-securitygroup-using-foreach-and-null/)
- [null](https://www.terraform.io/language/expressions/types#null)

> 不在または省略を表す値です。

[驚き最小の原則](https://ja.wikipedia.org/wiki/%E9%A9%9A%E3%81%8D%E6%9C%80%E5%B0%8F%E3%81%AE%E5%8E%9F%E5%89%87)に反している。
こういうところが専用言語が嫌われる理由。

## terrafomer, terracognito

[Releases · GoogleCloudPlatform/terraformer](https://github.com/GoogleCloudPlatform/terraformer/releases)

```bash
curl -L https://github.com/GoogleCloudPlatform/terraformer/releases/download/0.8.21/terraformer-all-linux-amd64 -o terraformer
chmod +x terraformer
mv terraformer ~/bin   # ここは各自アレンジ
```

all(全プロバイダ)だとバイナリが結構でかいので、特定のだけ落としてもいい。

```bash
terraformer import aws list
```

plugins 探しに行く先がよくわからん。
カレントの`.terraform.d`か
`$HOME/.terraform.d/plugins/linux_amd64`らしい。

aws prvider だけの main.tf 作って terraform apply すれば OK。
[Terraformer を使用して既存の AWS 環境をエクスポートする | zoo200's MemoMemo](https://zoo200.net/export-aws-with-terraformer/)

## terraform で条件分岐

terraform に条件分岐は存在しません。三項演算子はある。

[Conditional Expressions - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/expressions/conditionals)

## tfsec、terrascan

[aquasecurity/tfsec: Security scanner for your Terraform code](https://github.com/aquasecurity/tfsec)

```bash
curl https://github.com/aquasecurity/tfsec/releases/download/v1.26.3/tfsec-linux-amd64 -Lo tfsec
chmod +x tfsec
sudo mv tfsec /usr/local/bin
```

"aws_s3_bucket_acl"とか見てくれないで文句を言う。

[tenable/terrascan: Detect compliance and security violations across Infrastructure as Code to mitigate risk before provisioning cloud native infrastructure.](https://github.com/tenable/terrascan)

```bash
curl https://github.com/tenable/terrascan/releases/download/v1.15.2/terrascan_1.15.2_Linux_x86_64.tar.gz -Lo terrascan.tar.gz
tar zxvf terrascan.tar.gz terrascan
chmod +x terrascan
sudo mv terrascan /usr/local/bin
```

## Terraform で IAM ユーザを作りアクセスキーを得る

PGP キーがいる。なければ `gpg --gen-key`

参考

- [Create AWS IAM User Login Profile with PGP encrypted password in Terraform | DevCoops](https://devcoops.com/create-aws-iam-user-login-profile-pgp-ecrypted-password-terraform/)
- [Decrypt iam_user_login_profile password in Terraform | DevCoops](https://devcoops.com/decrypt-aws-iam-user-login-profile-password-terraform/)
- [aws_iam_access_key | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key)

## tfsec:ignore はブロックの直前に書く

こんな感じ

```terraform
## tfsec:ignore:aws-s3-encryption-customer-key
## ここになにか書いたらダメ
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

tfsec:ignore:が複数あるときは 1 行にスペースをセパレータで書く。

## state の現在の設定値を見る

```bash
## 全部
terraform show
## 指定して
terraform state show aws_s3_bucket.www
```

コマンドが違うのがいやだなあ。

## terraformer メモ

> Support terraform 0.13 (for terraform 0.11 use v0.7.9).

tfenv を使って

aws の場合:
[terraformer/aws.md at master · GoogleCloudPlatform/terraformer](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md)

AWS_PROFILE だとダメで、
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
で指定しないと。

`-r iam` だと終わらない。あんまり実用にはならん感じ。

そこそこ使えるのは EC2 ぐらいか?

## former2 メモ

former2 のほうがまともだが、こっちはこっちで
role で managed_policy_arns(CFn の ManagedPolicyArns)が抜けたりするので辛い。

CFn の出力を見ながら、Terraform 出力を編集する感じ。

## terracognita メモ

進行状況が出るのがえらい。
フィルタリングはないみたい。リソース種別単位で include/exclude はできる感じ

時間かかるけど、そこそこいける感じ。こっちを使おう。

aws_cloudwatch_log_group が見つからない。
aws_lambda_permission もない。

`-i aws_cloudwatch_log_group` だと

> could not import from AWS: the resource type is not supported

ですってさ。

## 複数のプラットフォーム対応の.terraform.hcl.lock

[[小ネタ] 複数のプラットフォームで terraform init する際の注意点 | DevelopersIO](https://dev.classmethod.jp/articles/multiplatform-terraform-init-lock/)

とりあえず Linux と Windows なら

```bash
terraform providers lock \
  -platform=windows_amd64 \
  -platform=linux_amd64
```

で。

## state lock の解除方法

たまに S3 を state に使ってるとロックかかるので、手動で解除する

[terraform state lock の解除方法 - Qiita](https://qiita.com/tomy103rider/items/b1dec92aaa57b9af31d9)

```bash
terraform force-unlock <ID>
```

で OK

## aws_internet_gateway で apply 毎に EC2 が再生成されるのを防ぐ

`security_group` でなく、
`vpc_security_group_ids` を使う。

- [security_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#security_groups)
- [vpc_security_group_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#vpc_security_group_ids)

確かに

> VPC の中で使うなら vpc_security_group_ids を使え

って書いてあるなあ。理由はよくわからん。

参照: [Recreating a Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#recreating-a-security-group)

その他:

- [aws_instance security_group vpc_security_group_ids - Google 検索](https://www.google.co.jp/search?hl=ja&q=aws_instance+security_group+vpc_security_group_ids&lr=lang_ja)
- [[Terraform/AWS]EC2 が再作成されるのを防ぐ](https://zenn.dev/shonansurvivors/articles/9e3ddb90d726d5)
- [Terraform で EC2 を作った後に、security_groups の指定方法でインスタンスの再作成になってしまった話 - Qiita](https://qiita.com/charon/items/587cb0c667e9dc2cce45)
- [Terraform で立てた EC2 に後から SG を追加しようとすると EC2 が再作成される - tjinjin's blog](https://cross-black777.hatenablog.com/entry/2016/02/25/090000)

## cidrsubnet() 関数

[cidrsubnet - Functions - Configuration Language | Terraform | HashiCorp Developer](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet)

3 番目の netnum がよくわからん。

```hcl
subnet_cidr = cidrsubnet("10.0.0.0/16", 4, 2)
```

`10.0.0.0/16` に 4bit 足して `10.0.0.0/20`。
で、それの 2+1(0 で始まるから)番目の CIDR で `10.0.32.0/20` になる。

Terraform には REPL はないので、ちょっと試すには Playground を使うと楽。

```hcl
locals {
  parent_cidr = "10.0.0.0/16"
}

output "subnet_cidr" {
  value = cidrsubnet(local.parent_cidr, 4, 2)
}
```

昔は Hashi Corp のがあったらしいんだけど

- [The Terraform Playground を作ろうとしている話](https://zenn.dev/yukin01/articles/ccc0b765c1edbf5649b1)
- [The Terraform Playground](https://yukin01-terraform-playground.web.app/)

## variable に map() を使うときの環境変数

```hcl
variable "my_map" {
  type    = "map"
  default = {
    key1 = "default_value1"
    key2 = "default_value2"
  }
}
```

があったとき(bash)

```bash
TF_VAR_my_map='{"key1":"value1","key2":"value2"}'
```

のように与える。

```bash
TF_VAR_my_map='{
  "key1": "'$other_environment_value1'",
  "key2": "value2"
}'
```

とかでも OK
