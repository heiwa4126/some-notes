# mkcert のメモ

- [FiloSottile/mkcert: A simple zero-config tool to make locally trusted development certificates with any names you'd like.](https://github.com/FiloSottile/mkcert)
- [Ubuntu Manpage: mkcert - zero-config tool to make locally trusted certificates](https://manpages.ubuntu.com/manpages/noble/en/man1/mkcert.1.html)
- [Chocolatey Software | mkcert 1.4.4](https://community.chocolatey.org/packages/mkcert)

HTTPS でないとダメな API とか サービス Worker とか OAuth とかを開発するとき。

ブラウザを動かす OS の上に mkcert をインストールして `mkcert -install` を実行するのが楽。

たとえば WSL2 で開発してるなら、Windows 上で

```powershell
# Windows に mkcert をインストール
sudo choco install mkcert

# Windows の system trust store と Firefox(あれば) に CAの証明書をインストール
sudo mkcert -install
## WindowsではFirefoxは未サポートらしい。`mkcert -CAROOT`でpemみつけて手動でやる。

# localhost用の証明書と鍵ファイルをカレントディレクトリにつくる
mkcert localhost
```

で、出来た .pem ファイル 2 個を WSL にコピーして使いまわす。

このケースだと
Playwright の headless なんかはどちらで動くのか...

`mkcert -CAROOT` で CA 鍵の場所を表示できるので、これを WSL 側に設定する。
Node なら `export NODE_EXTRA_CA_CERTS="/path/to/your/rootCA.pem"`でできるけど
Python だと辛いかも。
