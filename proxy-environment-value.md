# HTTP プロキシを指定する環境変数

まとめると

- だいたい小文字の方
- no_proxy は仕様がバラバラ

ということらしい。

この問題の根源は CERN libwww らしい。

## Python

メジャーなライブラリ [requests](https://pypi.org/project/requests/) におおむね従う。

で [Advanced Usage — Requests 2.32.4 documentation](https://requests.readthedocs.io/en/latest/user/advanced/#proxies)

上のリンク先のサマリ

- 環境変数は
  - http_proxy
  - https_proxy
  - no_proxy
- 小文字の環境変数が大文字よりも優先
- これらの環境変数は、os.environ を通じて取得され、URL のスキーム(http/https)に応じて適用

## Node.js

Node.js のネイティブ fetch や
[fetch-node](https://www.npmjs.com/package/node-fetch) には環境変数で proxy を設定する機能はない。

[Node.js の fetch でプロキシを利用する](https://zenn.dev/onozaty/articles/node-fetch-proxy)
にあるように [undici - npm](https://www.npmjs.com/package/undici) と合わせて使うらしい

「らしい」は、この fetch()が本当に元の fetch なのかちょっとあやしい感じがするので。

で undici の参照する環境変数については
[undici/docs/docs/api/EnvHttpProxyAgent.md at main · nodejs/undici · GitHub](https://github.com/nodejs/undici/blob/main/docs/docs/api/EnvHttpProxyAgent.md)

これの冒頭を読むと Python の request と同じ。

## curl と wget

- wget は小文字の環境変数のみ
- curl は http_proxy のみ小文字だけ [Proxy environment variables - everything curl](https://everything.curl.dev/usingcurl/proxies/env.html)
- ftp_proxy がある
- wget は .wgetrc 設定ファイルでも書ける

参考リンク

- [http_proxy は大文字か小文字か](https://zenn.dev/dannykitadani/articles/580e685ed66db7)
- [We need to talk: Can we standardize NO_PROXY?](https://about.gitlab.com/blog/we-need-to-talk-no-proxy/)
