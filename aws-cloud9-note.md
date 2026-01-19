# lambdaを作りたいのに"AWS Resources"が無い

[amazon web services - Why is the "AWS Resources" tab in cloud9 no longer showing up? - Stack Overflow](https://stackoverflow.com/questions/65762876/why-is-the-aws-resources-tab-in-cloud9-no-longer-showing-up)

1. メニューの window から AWS Toolkit を選ぶ
1. AWS Toolkit のトグルを off にする(cloud9 が再起動する)
1. 右端に"λ"アイコンがあらわれるので押す
1. "λ+"で作成

でも python3.6 しか選べないぞ。しかも死ぬし。

AWS Toolkit を使って lambda を作るには?

SAM ならある。

1. 左端の AWS をクリックして、AWS Explorer ひらく。
1. メニューのアイコンクリック(わかりにくい)
1. "create lambda sam application"

# なんかPython 3.7しかない

[\[AWS\] Cloud9で、Python3\.8をインストールする方法 \- Qiita](https://qiita.com/herohit-tool/items/02dab0fae92dc70dde6a)

`sudo amazon-linux-extras install python3.8`

AWS CLI もなんだか v1 なんだけど。
[Cloud9でAWS CLI v2を使えるようにセットアップする | DevelopersIO](https://dev.classmethod.jp/articles/setup-aws-cli-v2-on-cloud9/)
