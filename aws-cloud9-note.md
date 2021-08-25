

# lambdaを作りたいのに"AWS Resources"が無い

[amazon web services - Why is the "AWS Resources" tab in cloud9 no longer showing up? - Stack Overflow](https://stackoverflow.com/questions/65762876/why-is-the-aws-resources-tab-in-cloud9-no-longer-showing-up)

1. メニューのwindow から AWS Toolkitを選ぶ
1. AWS Toolkitのトグルをoffにする(cloud9が再起動する)
1. 右端に"λ"アイコンがあらわれるので押す
1. "λ+"で作成

でもpython3.6しか選べないぞ。しかも死ぬし。

AWS Toolkitを使ってlambdaを作るには?

SAMならある。
1. 左端のAWSをクリックして、AWS Explorerひらく。
1. メニューのアイコンクリック(わかりにくい)
1. "create lambda sam application"




# なんかPython 3.7しかない

[\[AWS\] Cloud9で、Python3\.8をインストールする方法 \- Qiita](https://qiita.com/herohit-tool/items/02dab0fae92dc70dde6a)

`sudo amazon-linux-extras install python3.8`


AWS CLIもなんだかv1なんだけど。
[Cloud9でAWS CLI v2を使えるようにセットアップする | DevelopersIO](https://dev.classmethod.jp/articles/setup-aws-cli-v2-on-cloud9/)
