# GoLangメモ

- [GoLangメモ](#golang%e3%83%a1%e3%83%a2)
- [LinuxでWindowsのバイナリを作る](#linux%e3%81%a7windows%e3%81%ae%e3%83%90%e3%82%a4%e3%83%8a%e3%83%aa%e3%82%92%e4%bd%9c%e3%82%8b)
- [strings.Builder](#stringsbuilder)
- [delve](#delve)
  - [インストール](#%e3%82%a4%e3%83%b3%e3%82%b9%e3%83%88%e3%83%bc%e3%83%ab)
  - [実行例](#%e5%ae%9f%e8%a1%8c%e4%be%8b)
- [GDBでデバッグ](#gdb%e3%81%a7%e3%83%87%e3%83%90%e3%83%83%e3%82%b0)
- [goモジュール](#go%e3%83%a2%e3%82%b8%e3%83%a5%e3%83%bc%e3%83%ab)
- [snapdでgo](#snapd%e3%81%a7go)
- [RHEL/CentOS 7でgolang](#rhelcentos-7%e3%81%a7golang)
- [定番ツールをまとめて](#%e5%ae%9a%e7%95%aa%e3%83%84%e3%83%bc%e3%83%ab%e3%82%92%e3%81%be%e3%81%a8%e3%82%81%e3%81%a6)
- [Goで書いたコードをsystemdでデーモンにする](#go%e3%81%a7%e6%9b%b8%e3%81%84%e3%81%9f%e3%82%b3%e3%83%bc%e3%83%89%e3%82%92systemd%e3%81%a7%e3%83%87%e3%83%bc%e3%83%a2%e3%83%b3%e3%81%ab%e3%81%99%e3%82%8b)
- [golangで書いたコードをsystemdでdaemonに](#golang%e3%81%a7%e6%9b%b8%e3%81%84%e3%81%9f%e3%82%b3%e3%83%bc%e3%83%89%e3%82%92systemd%e3%81%a7daemon%e3%81%ab)

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

Ubuntuだとsnapd使うのが便利。

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

# RHEL/CentOS 7でgolang

EPELで新し目のgolangパッケージを配ってます。
Red Hat 7系でgo入れるならEPELを設定して
```
sudo yum -y install golang
```
を試すこと。snapよりはちょっとリリースは遅い。

あとは↑の[snapdでgo](#snapd%e3%81%a7go)みたいな設定を。

epelのyumでgoを入れたなら、
GOPATHの2つ目は`/usr/lib/golang`



# 定番ツールをまとめて

ディスクに余裕があるなら
``` bash
go get -u golang.org/x/tools/...
```
(300MBぐらい。strip *して200MBぐらい)

余裕がなければこれぐらいは
``` bash
go get -u github.com/rogpeppe/godef
go get -u github.com/nsf/gocode
go get -u github.com/golang/lint/golint
go get -u github.com/kisielk/errcheck
go get -u github.com/derekparker/delve/cmd/dlv
```

[golang/tools: [mirror] Go Tools](https://github.com/golang/tools)


# Goで書いたコードをsystemdでデーモンにする

参考にしたもの：

- [Integration of a Go service with systemd: readiness & liveness | Vincent Bernat](https://vincent.bernat.ch/en/blog/2017-systemd-golang)

`main.go` ([↑から引用](https://vincent.bernat.ch/en/blog/2017-systemd-golang))
``` go
package main

import (
    "log"
    "net"
    "net/http"
)

func main() {
    l, err := net.Listen("tcp", ":8081")
    if err != nil {
        log.Panicf("cannot listen: %s", err)
    }
    http.Serve(l, nil)
}
```

手順
``` bash
mkdir 404
cd !$
vim main.go # 上記のコードをコピペ
go build
# test
./404
curl http://localhost:8081/
```

結果
```
404 NOT FOUND
```

バイナリのサイズを小さくしたかったら
``` bash
go build -ldflags="-w -s"
upx 404
```
など


で、これをsystemdでデーモンにする。

いちばんカンタンで必要十分と思われる`404.service`
```
[Unit]
Description=404 micro-service
Requires=network.target
After=multi-user.target

[Service]
Type=simple
ExecStart=(いま自分のいるディレクトリ)/404
WorkingDirectory=(いま自分のいるディレクトリ)
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target
```

↑のポイント
- 死んだら3秒まって再開する(試しにkill -9 <pid>してみること)。
- `Restart=always`は雑すぎるかも。
- networkは必要

手順
``` bash
sudo vim /lib/systemd/system/404.service # コピペ&編集
sudo systemctl daemon-reload
sudo systemctl start 404.service
sudo systemctl status 404.service
# 404だとPIDと思われるので.serviceもつける
```

`curl http://localhost:8081/`
や
`sudo lsof -p <pid>`
などしてみる。


# golangで書いたコードをsystemdでdaemonに

[Integration of a Go service with systemd: readiness & liveness | Vincent Bernat](https://vincent.bernat.ch/en/blog/2017-systemd-golang)