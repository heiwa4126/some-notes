# GoLangメモ
- [GoLangメモ](#golangメモ)
- [LinuxでWindowsのバイナリを作る](#linuxでwindowsのバイナリを作る)
- [strings.Builder](#stringsbuilder)
- [delve](#delve)
  - [インストール](#インストール)
  - [実行例](#実行例)
- [GDBでデバッグ](#gdbでデバッグ)
- [goモジュール](#goモジュール)
- [snapdでgo](#snapdでgo)
  - [おまけ: CentOS7でsnapd](#おまけ-centos7でsnapd)
  - [おまけ: snapdで古いのを消す](#おまけ-snapdで古いのを消す)

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


# snapdでgo

[Install Go for Linux using the Snap Store | Snapcraft](https://snapcraft.io/go)

``` bash
sudo snap install go --channel=1.13/stable --classic
```

GOPATHの例(~/.profile)

``` bash
# GoLang
export MYGOPATH="$HOME/works/go_project"
export GOPATH="$HOME/.go:/snap/go/current:$MYGOPATH"
export PATH="$HOME/.go/bin:$PATH:$MYGOPATH/bin"
alias gcd='cd $MYGOPATH/src/github.com/heiwa4126'
```

[motemen/ghq](https://github.com/motemen/ghq) 使うなら
``` bash
git config --global ghq.root "$MYGOPATH/src"
```

emacs使うなら以下参照:

- [Goプログラミングの環境構築 | Emacs JP](https://emacs-jp.github.io/programming/golang)

## おまけ: CentOS7でsnapd

``` bash
yum update
yum install yum-plugin-copr epel-release
yum copr enable ngompa/snapcore-el7
yum install snapd bridge-utils
systemctl enable --now snapd.socket
systemctl enable --now snapd
ln -s /var/lib/snapd/snap /snap
```

あと `/snap/bin`にパスを通す。

## おまけ: snapdで古いのを消す

例)
``` bash
$ snap list --all
Name              Version    Rev   Tracking  Publisher   Notes
amazon-ssm-agent  2.3.662.0  1455  stable/…  aws✓        disabled,classic
amazon-ssm-agent  2.3.672.0  1480  stable/…  aws✓        classic
core              16-2.41    7713  stable    canonical✓  core,disabled
core              16-2.42    7917  stable    canonical✓  core
go                1.13       4409  1.13      mwhudson    disabled,classic
go                1.13.1     4517  1.13      mwhudson    classic
```

で、古いのを消す例
```
snap remove core --revision=7713
```

まとめて消したいときは:

[How to remove disabled (unused) snap packages with a single line of command? - Ask Ubuntu](https://askubuntu.com/questions/1036633/how-to-remove-disabled-unused-snap-packages-with-a-single-line-of-command)