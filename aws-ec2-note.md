# AWS EC2 のメモ

## キーペアのインポート

- キーペアはリージョンごと
- ポータルからキーペアのインポートはできない(昔は出来たような気がするんだけど)

AWS CLI を使って.ssh の下から pub キーをインポートする。

[import-key-pair — AWS CLI 2.15.24 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/import-key-pair.html)

例

```bash
aws ec2 import-key-pair \
  --key-name xxxx \
  --public-key-material fileb://~/.ssh/xxxx.pub \
  --region us-east-1

# 確認
aws ec2 describe-key-pairs \
    --key-name xxxx \
    --region us-east-1
```

## Windows のパスワードを受け取る

要約: 秘密キーは OpenSSH 形式でないとダメ

最近では Windows インスタンスのパスワードはキーペアの秘密鍵で複合して受け取る式になっていて、
ポータルに秘密鍵ファイルを指定するかコピペする。

で、古めの PKCS#8 形式 の秘密キーファイルをそのまま貼り付けると
`-----BEGIN RSA PRIVATE KEY----- -----END RSA PRIVATE KEY----- の形式でないとダメ`
と言われるので変換する。

実行例:

```terminal
$ mkdir /tmp/x

$ cd /tmp/x

$ cp -a ~/.ssh/xxxxx .

$ ssh-keygen -p -m PEM -f xxxxx
Enter old passphrase:
Enter new passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved with the new passphrase.
```

- -----BEGIN PRIVATE KEY----- で始まる形式は PKCS#8 形式と呼ばれます。
- -----BEGIN RSA PRIVATE KEY----- で始まる形式は OpenSSH 形式または PEM 形式と呼ばれます。

OpenSSH 7.8 以降では、デフォルトで OpenSSH 形式が使用されます。
それ以前のバージョンの OpenSSH では、PKCS#8 形式がデフォルトで使用されていました。

実際はさらにややこしい。参考: [RSA 鍵のフォーマットについて](https://zenn.dev/htlsne/articles/rsa-key-format)
