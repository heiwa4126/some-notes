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
