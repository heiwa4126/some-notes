OSはAmazon Linux2

aws cliもSAMもある。けどPython3は3.7
LambdaのPython3.8が動かない。

3.8入れて、venvでならいけるはず。
```sh
sudo amazon-linux-extras install -y python3.8
python3.8 -m venv ~/.venv/38/
. ~/.venv/38/bin/activate
curl -kL https://bootstrap.pypa.io/get-pip.py -O
python get-pip.py -U
```


ブラウザから使えるのは便利だけど、
メタキーとかが辛い。
tmuxも入ってるんだがctrl-tがブラウザに食われる。
そのへんさえ我慢できれば

あと制限がある。

- [AWS CloudShell – AWS リソースへのコマンドラインアクセス | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/aws-cloudshell-command-line-access-to-aws-resources/)
- [の制限と制約AWS CloudShell - AWS CloudShell](https://docs.aws.amazon.com/ja_jp/cloudshell/latest/userguide/limits.html#persistent-storage-limitations)

- HOMEは永続する。ただし最後にログインしてから120日まで。容量は各リージョンで1GBまで
- 10セッションまで同時接続可能 (タブブラウザっぽく使える)。でもw叩いても他の人は見えない。
