github.comのメモ

- [80,443/tcpしかつながらないproxyを超えて、githubにsshでつなぐ](#80443tcpしかつながらないproxyを超えてgithubにsshでつなぐ)
- [Firefoxのmarkdown拡張](#firefoxのmarkdown拡張)

# 80,443/tcpしかつながらないproxyを超えて、githubにsshでつなぐ

公式ドキュメント: [Using SSH over the HTTPS port](https://help.github.com/articles/using-ssh-over-the-https-port/)

Linuxだったら~/.ssh/configで
```
Host github.com
     # Hostname github.com
     # Port 22
     Hostname ssh.github.com
     Port 443
     User git
     Compression yes
     IdentityFile ~/.ssh/github
     ProxyCommand  /usr/bin/connect-proxy -H 111.222.333.444:3128 %h %p
```
みたいな感じで(要アレンジ)。


Windowsだったら
* puttyで"github.com"プロファイルを作る
  - port: **443**
  - host: **ssh**.github.com
  - Proxyを環境に合わせて設定
  - 鍵 
* Close window on ExitでNeverを選んで接続することで`ssh -T git@github.com`に相当するテストを行う。

のがコツ。Repositry to cloneは、githubの緑のボタンで出てくるやつをそのまま使える(ここだったら`git@github.com:heiwa4126/some-notes.git`で)

# Firefoxのmarkdown拡張

- [Copy as Markdown – Get this Extension for 🦊 Firefox (ja)](https://addons.mozilla.org/ja/firefox/addon/copy-as-markdown/)

