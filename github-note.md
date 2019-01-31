github.comのメモ

- [80,443/tcpしかつながらないproxyを超えて、githubにsshでつなぐ](#80443tcp%E3%81%97%E3%81%8B%E3%81%A4%E3%81%AA%E3%81%8C%E3%82%89%E3%81%AA%E3%81%84proxy%E3%82%92%E8%B6%85%E3%81%88%E3%81%A6github%E3%81%ABssh%E3%81%A7%E3%81%A4%E3%81%AA%E3%81%90)

# 80,443/tcpしかつながらないproxyを超えて、githubにsshでつなぐ

公式ドキュメント: [Using SSH over the HTTPS port](https://help.github.com/articles/using-ssh-over-the-https-port/)


Windowsだったら
* puttyで"github.com"プロファイルを作る
  - port: 443
  - host: ssh.github.com
  - Proxyを環境に合わせて設定
  - 鍵 
* Close window on ExitでNeverを選んで接続することで`ssh -T git@github.com`に相当するテストを行う。

のがコツ。Repositry to cloneは、githubの緑のボタンで出てくるやつをそのまま使える(ここだったら`git@github.com:heiwa4126/some-notes.git`で)
