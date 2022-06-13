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
