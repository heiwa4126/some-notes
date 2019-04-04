# GoLangメモ
- [GoLangメモ](#golangメモ)
- [LinuxでWindowsのバイナリを作る](#linuxでwindowsのバイナリを作る)
- [strings.Builder](#stringsbuilder)
- [delve](#delve)
  - [インストール](#インストール)
  - [実行例](#実行例)
- [GDBでデバッグ](#gdbでデバッグ)

# LinuxでWindowsのバイナリを作る

- [WindowsCrossCompiling · golang/go Wiki · GitHub](https://github.com/golang/go/wiki/WindowsCrossCompiling)
- [Cross compilation with Go 1.5 | Dave Cheney](https://dave.cheney.net/2015/08/22/cross-compilation-with-go-1-5)

# strings.Builder

1.10から標準になった

- [Go言語の strings.Builder による文字列の連結の最適化とベンチマーク - Qiita](https://qiita.com/po3rin/items/2e406645e0b64e0339d3)
- [Go1.10で入るstrings.Builderを検証した #golang - Qiita](https://qiita.com/tenntenn/items/94923a0c527d499db5b9)

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