# インストール



## Debian, Ubuntu

パッケージで
[Install Terraform | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)


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


## 直接落とす

HashiCorpから落とす。

[HashiCorp Terraform - Provision & Manage any Infrastructure](https://www.hashicorp.com/products/terraform)

あたらしいバージョンは https://releases.hashicorp.com/terraform/ で確認。
GoLangだからダウンロードして展開するだけ。

(2022-06-13)
```sh
sudo yum install curl unzip
# or
sudo apt install curl unzip
#
curl https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_linux_amd64.zip -O
sudo unzip ./terraform_1.2.2_linux_amd64.zip -d /usr/local/bin/
terraform -v
```

# bashへのcompletion

```bash
terraform -install-autocomplete
. ~/.bashrc 
```


# ドキュメント

[Overview - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language)


# サンプルなど

[terraform-aws-modules/ec2-instance/aws | Terraform Registry](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)

# チュートリアル

[Terraform Tutorials - HashiCorp Learn](https://learn.hashicorp.com/terraform)

# ログを出す


```bash
export TF_LOG=WARN
export TF_LOG_PATH=./terraform.log
```

TF_LOGは TRACE DEBUG INFO WARN ERROR OFF

[Environment Variables | Terraform by HashiCorp](https://www.terraform.io/cli/config/environment-variables)


# security_groups で forces replacement とか言われたら

aws_instance で security_groupsを使うな。
vpc_security_group_idsを使うこと。


# associate_public_ip_address で forces replacement とか言われたら

```
  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }
```

[Get terraform to ignore "associate_public_ip_address" status for stopped instance - Stack Overflow](https://stackoverflow.com/questions/52519463/get-terraform-to-ignore-associate-public-ip-address-status-for-stopped-instanc)

# you need to accept terms and subscribe

```
Error: creating EC2 Instance: OptInRequired: In order to use this AWS Marketplace product you need to accept terms and subscribe.
To do so please visit https://aws.amazon.com/marketplace/pp?sku=cotnnspjrsi38lfn8qo4ibnnm
```

1. (AWSのアカウントでログインしたまま) このページに行く。
2. `Continue to Subscribe` ボタン
3. `Accept Term` ボタン (このへんプロダクトによりけり)

#  terraform import aws_key_pair. が失敗する

[Terraform fails to import key pair with Amazon EC2 - Stack Overflow](https://stackoverflow.com/questions/40120065/terraform-fails-to-import-key-pair-with-amazon-ec2)

key-XXXXX の IDではなくて、名前のほうを引数にする。

# 特定のリソースだけdestory

```bash
terraform destroy -target={リソース名} -target={リソース名} ...
```

# outputをoutput

```bash
terraform output
# 個別指定も
terraform output <name>
# クォートなしで出したいときは
terraform output -raw <name>
# JSONでも
terraform output -json
```

# Terraformのbackend

stateファイルを管理共有流用できる。

- [Backend Overview - Configuration Language | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends)
- [Backend Type: local | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/local)
- [Backend Type: s3 | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/s3)
- [Backend Type: azurerm | Terraform by HashiCorp](https://www.terraform.io/language/settings/backends/azurerm) 

あとこれ
[Store Remote State | Terraform - HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/aws-remote?in=terraform/aws-get-started)

backendのkeyにvarが使えない。
[Terraformの「ここはvariable使えないのか...」となった所 - Qiita](https://qiita.com/ymmy02/items/e7368abd8e3dafbc5c52)



# Linter

- [terraform-linters/tflint: A Pluggable Terraform Linter](https://github.com/terraform-linters/tflint)
- [aquasecurity/tfsec: Security scanner for your Terraform code](https://github.com/aquasecurity/tfsec)
