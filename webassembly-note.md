[I want to… \- WebAssembly](https://webassembly.org/getting-started/developers-guide/)

とりあえず以下のチュートリアルやってみた

https://github.com/golang/go/wiki/WebAssembly#getting-started

goexecがインストールできない上にcloneしてbuildしても動かない
`no required module provides package github.com/shurcooL/go-goon`

代わりに
[http-server - npm](https://www.npmjs.com/package/http-server)
で
`http-server .` した。

最初のデモはconsole.logに出るだけで、まああまり面白くない。
やっぱDOM操作したいよね。

もう1個HelloWorldをCのスクラッチで
[Compiling a New C/C++ Module to WebAssembly - WebAssembly | MDN](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm)

```bash
sudo apt install emscripten -y
```

これは簡単。こっちも `http-server .`で。
