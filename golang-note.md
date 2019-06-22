# GoLangメモ
- [GoLangメモ](#GoLang%E3%83%A1%E3%83%A2)
- [LinuxでWindowsのバイナリを作る](#Linux%E3%81%A7Windows%E3%81%AE%E3%83%90%E3%82%A4%E3%83%8A%E3%83%AA%E3%82%92%E4%BD%9C%E3%82%8B)
- [strings.Builder](#stringsBuilder)
- [delve](#delve)
  - [インストール](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
  - [実行例](#%E5%AE%9F%E8%A1%8C%E4%BE%8B)
- [GDBでデバッグ](#GDB%E3%81%A7%E3%83%87%E3%83%90%E3%83%83%E3%82%B0)
- [goモジュール](#go%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB)

# LinuxでWindowsのバイナリを作る

- [WindowsCrossCompiling · golang/go Wiki · GitHub](https://github.com/golang/go/wiki/WindowsCrossCompiling)
- [Cross compilation with Go 1.5 | Dave Cheney](https://dave.cheney.net/2015/08/22/cross-compilation-with-go-1-5)

# strings.Builder

1.10から標準になった

- [strings - Type Builder - The Go Programming Language](https://golang.org/pkg/strings/#Builder)
- [Go言語の strings.Builder による文字列の連結の最適化とベンチマーク - Qiita](https://qiita.com/po3rin/items/2e406645e0b64e0339d3)
- [Go1.10で入るstrings.Builderを検証した #golang - Qiita](https://qiita.com/tenntenn/items/94923a0c527d499db5b9)

> strings.Builderはio.Writerインタフェースを実装しているため、次のようにfmt.Fprintなどの関数で利用できます。

```
var b strings.Builder
fmt.Fprint(&b, "hello")
b.WriteString("world!\n")
```

# delve

* [go-delve/delve: Delve is a debugger for the Go programming language.](https://github.com/go-delve/delve)

## インストール
```
go get -u github.com/go-delve/delve/cmd/dlv
hash -r
```

## 実行例

c1.go :
```
package main

import "fmt"

func addNFactory(n int) func(int) int {
  return func(x int) int {
    return x + n
  }
}
func main() {
  add1 := addNFactory(1)
  add2 := addNFactory(2)
  fmt.Println(add1(1))
  fmt.Println(add2(1))
}
```

デバッグ例
```
$ dlv debug c1.go
Type 'help' for list of commands.
(dlv) b main.main
Breakpoint 1 set at 0x49b458 for main.main() ./c1.go:10
(dlv) c
=>  10: func main() {
    11:         add1 := addNFactory(1)
    12:         add2 := addNFactory(2)
    13:         fmt.Println(add1(1))
    14:         fmt.Println(add2(1))
    15: }
(dlv) n
(dlv) n
(dlv) n
(dlv) locals  (TABキーで補完が効く)
add1 = main.addNFactory.func1
add2 = main.addNFactory.func1
(dlv) whatis add1
func(int) int
(dlv) funcs main.
main.addNFactory
main.addNFactory.func1
main.init
main.main
runtime.main.func1
runtime.main.func2
...
```

# GDBでデバッグ

* [Debugging Go Code with GDB - The Go Programming Language](https://golang.org/doc/gdb)


# goモジュール

go 1.13から標準になる。

以下のリンクが
チュートリアルになってるので、一回やってみると理解できる

* [Using Go Modules - The Go Blog](https://blog.golang.org/using-go-modules)
* [The Go Blog - Using Go Modules / Go Modulesを使う（和訳） - Qiita](https://qiita.com/pokeh/items/139d0f1fe56e358ba597)