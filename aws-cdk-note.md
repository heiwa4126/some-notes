# AWS CDK

- [AWS CDK](#aws-cdk)
- [インストール](#インストール)
- [AWS CDK Workshop](#aws-cdk-workshop)
- [AWS CloudShell](#aws-cloudshell)

# インストール

v1とv2でけっこう違うらしい。

```bash
npm install --location=global aws-cdk
cdk bootstrap aws://123456789012/ap-northeast-1
```

# AWS CDK Workshop

素性はよくわからないけど日本語あった
[AWS Cloud Development Kit \(AWS CDK\) ワークショップへようこそ！ ](https://summit-online-japan-cdk.workshop.aws/)

オリジナル: [AWS CDK Intro Workshop :: AWS Cloud Development Kit (AWS CDK) Workshop](https://cdkworkshop.com/)

# AWS CloudShell

AWS CloudShell (2021-11-08)

```
$ aws --version
aws-cli/2.2.15 Python/3.8.8 Linux/4.14.243-185.433.amzn2.x86_64 exec-env/CloudShell exe/x86_64.amzn.2 prompt/off

$ sam --version
SAM CLI, version 1.23.0

$ cdk --version
bash: cdk: command not found

$ node -v
v14.16.1

$ sudo npm install -g aws-cdk
$ cdk --version
1.131.0 (build 7560c79)
```

最初からは入ってなかった。
