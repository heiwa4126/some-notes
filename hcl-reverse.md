# AWSの既存リソースからterraformのHCLにするツールを使ってみた

いわゆる `reverse Terraform tool` であるところの

- terraformer
- former2
- terracognita

を使ってみたのでメモを書いておきます。(2022 年 7 月現在)

## terraforming (試してません)

[dtan4/terraforming: Export existing AWS resources to Terraform style (tf, tfstate) / No longer actively maintained](https://github.com/dtan4/terraforming)

[Ruby](https://www.ruby-lang.org/)製のツール。
有名だったが今はメンテナンスされていない。

## terraformer

[GoogleCloudPlatform/terraformer: CLI tool to generate terraform files from existing infrastructure (reverse Terraform). Infrastructure to Code](https://github.com/GoogleCloudPlatform/terraformer)

Google のプロジェクト。
[Go](https://go.dev/)製。
AWS 以外にもさまざまなクラウドに対応。メインは当然 GCP。

README にある通り

> Support terraform 0.13 (for terraform 0.11 use v0.7.9).

Terraform の 0.13 でしか動かない
(自分は[tfenv](https://github.com/tfutils/tfenv)を介して 0.13.7 でテストしました)。

使い方がちょっと変で、`version.tf` にプロバイダ指定して、
`terraform init`でプラグイン入れてから、
`terraformer ...`を実行する。

AWS でサポートしているリソースは
[ここにある通り](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md#supported-services)。

とはいうものの AWS に関してはあまりメンテナンスされていないようで、
ちゃんと取れるのは ec2_instance や VPC ぐらい。ほかはエラーがだーっと出る。

いまのところ AWS については実用にならないレベル。

## former2

[former2](https://github.com/iann0036/former2)
には terraform 出力があるので試してみた。

role で managed_policy_arns(CFn の ManagedPolicyArns)が抜けたりするので、
そのまま使うのは危険。
CFn 出力をみながら手動で HCL にしていく感じになる。

## terracognita

[cycloidio/terracognita: Reads from existing public and private cloud providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration](https://github.com/cycloidio/terracognita/)

これも Go 製。AWS 以外にも有名クラウドと vSphere に対応。

進行状況が出るのがえらい。
リソース種別単位で include/exclude できる。
デフォルトは「AWS アカウントのサポートしているリソース全部」。

サポートしているリソースは
[terracognita/resources.go](https://github.com/cycloidio/terracognita/blob/master/aws/resources.go)
にある通りで、自分的には

- aws_cloudwatch_log_group
- aws_lambda_permission

などがなくて困った。

## 結論

AWS の既存リソースから HCL にするには
terracognita と former2 を併用するのが良いと思う。
(2022 年 7 月現在)

## 補足: terracognita の使い方メモ

主に

- [terracognitaのREADME](https://github.com/cycloidio/terracognita)
- [TerraCognita | Docs](https://docs.cycloid.io/open-source-software/terracognita.html) - ちょっと古い

からの引用と補足です。

### インストール

Linux にインストールするには、GitHub にバイナリビルドがあるので

```bash
curl -L https://github.com/cycloidio/terracognita/releases/latest/download/terracognita-linux-amd64.tar.gz -o terracognita-linux-amd64.tar.gz
tar -xf terracognita-linux-amd64.tar.gz
chmod u+x terracognita-linux-amd64
sudo mv terracognita-linux-amd64 /usr/local/bin/terracognita
rm terracognita-linux-amd64.tar.gz
```

で。

### 実行サンプル

AWS アカウントは readonly で十分で、
キーはデフォルトプロファイルまたは
AWS_ACCESS_KEY_ID,
AWS_SECRET_ACCESS_KEY,
AWS_DEFAULT_REGION
を export (AWS_PROFILE は使えなかった)。

例: 1 個の HCL に全リソースを出力する例。それなりに長い時間と巨大なファイルができる。

```bash
terracognita aws \
  --hcl outputs/resources.tf
```

例: 1 個の HCL に lambda と policyrole を出力する例。コンマで区切って、HCL のリソース名で指示。

```bash
terracognita aws \
  --hcl outputs/resources.tf \
  -i aws_lambda_function,aws_iam_policy aws_iam_role
```

例: ./module ディレクトリにリソース単位風の HCL ファイルを出力する例。

```bash
terracognita aws --module module
```

(実際にやってみるとわかりますが、巨大なパラメータファイルと、
モジュール類になるので、あんまり便利じゃないです)
