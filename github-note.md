# github.comのメモ

- [github.comのメモ](#githubcomのメモ)
- [80,443/tcpしかつながらないproxyを超えて、githubにsshでつなぐ](#80443tcpしかつながらないproxyを超えてgithubにsshでつなぐ)
- [Firefoxのmarkdown拡張](#firefoxのmarkdown拡張)
- [releaseの練習](#releaseの練習)
  - [タグをつける](#タグをつける)
  - [GitHub側](#github側)



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
  - Auto-login username: git
  - Proxyを環境に合わせて設定
  - 鍵 
* Close window on ExitでNeverを選んで接続することで`ssh -T git@github.com`に相当するテストを行う。

のがコツ。Repositry to cloneは、githubの緑のボタンで出てくるやつをそのまま使える(ここだったら`git@github.com:heiwa4126/some-notes.git`で)

# Firefoxのmarkdown拡張

- [Copy as Markdown – Get this Extension for 🦊 Firefox (ja)](https://addons.mozilla.org/ja/firefox/addon/copy-as-markdown/)


# releaseの練習

## タグをつける

``` bash
# まずコミットする
git commit -a -m "First release"
git push
# tagをつける
git tag v0.0.1
# ローカルでつけたタグを全てリモートに反映させる
git push --tags
```

間違えると取り消すのが結構めんどくさいので慎重に。

おまけ:
``` bash
# tag一覧
git tag -n
# タグの削除(ローカル)
git tag -d tag名
# さらにタグの削除(リモート)
git push :タグ名
```

## GitHub側

- [リリースの作成 - GitHub ヘルプ](https://help.github.com/ja/articles/creating-releases)
- [Github – Tagの付け方とRelease機能の使い方 | Howpon[ハウポン]](https://howpon.com/7676)
- [GitHubのリリース機能を使う - Qiita](https://qiita.com/todogzm/items/db9f5f2cedf976379f84)

要点メモ:

1. releaseのリンクから
2. Draft a new releaseボタン
3. バージョン入れて、フォームを埋める。
4. Attach binariesのところへバイナリをドラッグ&ドロップ

CLIがあると楽なんだが...
REST APIはある。[Create a release](https://developer.github.com/v3/repos/releases/#create-a-release)

goreleaser:
- [goreleaser を使って Github Releases へ簡単デプロイ #golang - Qiita](https://qiita.com/ynozue/items/f939cff562ec782b33f0)
- [GoReleaser](https://goreleaser.com/)
- [goreleaser/goreleaser: Deliver Go binaries as fast and easily as possible](https://github.com/goreleaser/goreleaser)