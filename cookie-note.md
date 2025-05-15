# Cookie のメモ

## なぜ Secure 属性が http://localhost で動く?

ローカルで動いてる開発サーバで気が付いたんだけど、
なんか localhost は例外扱いになってるらしい。

[Set-Cookie - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie#secure)
には

> with the https: scheme (except on localhost)

と記述がある。
