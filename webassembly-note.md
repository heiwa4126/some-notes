[I want to… \- WebAssembly](https://webassembly.org/getting-started/developers-guide/)


# Golang

とりあえず以下のチュートリアルやってみた

https://github.com/golang/go/wiki/WebAssembly#getting-started

goexecがインストールできない上にcloneしてbuildしても動かない
`no required module provides package github.com/shurcooL/go-goon`

代わりに
[http-server - npm](https://www.npmjs.com/package/http-server)
で
`http-server .` した。

最初のデモはconsole.logに出るだけで、まああまり面白くない。
やっぱDOM操作したいよね。-> [js package - syscall/js - Go Packages](https://pkg.go.dev/syscall/js)



goexecのかわりにgoevalが使える。
[dolmen-go/goeval: Run Go snippets instantly from the command-line](https://github.com/dolmen-go/goeval)

```bash
go install github.com/dolmen-go/goeval@master
goeval 'fmt.Println("Hello, world!")'
```

今回は
```bash
goeval 'http.ListenAndServe(":8080", http.FileServer(http.Dir(".")))'
```


# C

もう1個HelloWorldをCのスクラッチで
[Compiling a New C/C++ Module to WebAssembly - WebAssembly | MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm)

```bash
sudo apt install emscripten -y
```

これは簡単。こっちも `http-server .`で。

日本語:
[C/C++ から WebAssembly へのコンパイル - WebAssembly | MDN](https://developer.mozilla.org/ja/docs/WebAssembly/C_to_wasm)


# Rust

Rustもすこし
https://rustwasm.github.io/docs/book/game-of-life/setup.html

けっこう規模が大きくて簡単には終わらん.

先に
[Compiling from Rust to WebAssembly - WebAssembly | MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_wasm)
をやってからにする。やった。

終わった後から日本語訳があるのに気が付いた。
[Rust から WebAssembly にコンパイルする - WebAssembly | MDN](https://developer.mozilla.org/ja/docs/WebAssembly/Rust_to_wasm)

[vite \(react\.ts\) で wasmを動かす](https://zenn.dev/pilefort/articles/fd90d9f6a426f9)
これやってみる。なるほど出来た。


# WebAssembly

まとめると

実行はそこそこ高速。ただJavaScriptの実行自体もかなり早い。
引数と戻り値のハンドリングのオーバーヘッドが大きい。
ので単に速度を期待するとがっかりする。

DOMとか直接操作できない(永遠にできない)。
ただしブラウザ以外ではWASIみたいのが[WebAssemblyをWebブラウザ以外の実行環境へ。システムインターフェイスへのアクセスを可能にする「WASI」の策定開始。Mozillaが呼びかけNode.jsらが賛同 － Publickey](https://www.publickey1.jp/blog/19/webassemblywebwasimozillanodejs.html)

利点は既存言語のライブラリが使えること。
あとコンパイラが強力なら最適化は期待できること。

- [WebAssemblyハンズオン: 実際に動かして基礎を学ぶ（翻訳）｜TechRacho by BPS株式会社](https://techracho.bpsinc.jp/hachi8833/2020_11_02/97774)
- [Hands-on WebAssembly: Try the basics—Martian Chronicles, Evil Martians’ team blog](https://evilmartians.com/chronicles/hands-on-webassembly-try-the-basics)
