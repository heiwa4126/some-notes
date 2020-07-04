# GoLangメモ

- [GoLangメモ](#golangメモ)
- [LinuxでWindowsのバイナリを作る](#linuxでwindowsのバイナリを作る)
- [strings.Builder](#stringsbuilder)
- [delve](#delve)
  - [インストール](#インストール)
  - [実行例](#実行例)
- [GDBでデバッグ](#gdbでデバッグ)
- [goモジュール](#goモジュール)
- [go run](#go-run)
- [snapdでgo](#snapdでgo)
- [Goで書いたコードをsystemdでデーモンにする](#goで書いたコードをsystemdでデーモンにする)
- [golangで書いたコードをsystemdでdaemonに](#golangで書いたコードをsystemdでdaemonに)
- [構造体の比較](#構造体の比較)
- [よく忘れるGolang](#よく忘れるgolang)
  - [キャスト](#キャスト)
  - [永遠ループ](#永遠ループ)
  - [while](#while)
  - [type()](#type)
    - [タイプの表示](#タイプの表示)
    - [タイプの比較](#タイプの比較)
- [interface](#interface)
- [deferの中のエラー](#deferの中のエラー)
- [テストのカバレッジ](#テストのカバレッジ)
- [shadowingによるバグ](#shadowingによるバグ)
- [golangci-lint](#golangci-lint)
- [panic()のドキュメント](#panicのドキュメント)
- [errorでスタックトレースが欲しいとき](#errorでスタックトレースが欲しいとき)

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

mainのmain()は`b main.main`ですむのに、
モジュールについてはフルパスでないといけないのはめんどくさい。
go.modを見るような設定があるはず。

参考:
[Golangのデバッガdelveの使い方 - Qiita](https://qiita.com/minamijoyo/items/4da68467c1c5d94c8cd7)


# GDBでデバッグ

* [Debugging Go Code with GDB - The Go Programming Language](https://golang.org/doc/gdb)


# goモジュール

go 1.13から標準になる。

以下のリンクが
チュートリアルになってるので、一回やってみると理解できる

* [Using Go Modules - The Go Blog](https://blog.golang.org/using-go-modules)
* [The Go Blog - Using Go Modules / Go Modulesを使う（和訳） - Qiita](https://qiita.com/pokeh/items/139d0f1fe56e358ba597)


# go run

go runの引数はpackageなので
mainパッケージのmain()が1つしかない、ちゃんとしたプロジェクトなら
`go run .`
で実行できる。もちろんパッケージ名をフルで指定してもいい。
`go run github.com/heiwa4126/gogogophers`
みたいな(でもしないよ)。

サブパッケージ以下のテストも
`go test ./feather/...`
みたいにできる。
`go test feather/...`
ではダメ。


# snapdでgo

Ubuntuだとsnapd使うのが便利。

[Install Go for Linux using the Snap Store | Snapcraft](https://snapcraft.io/go)

``` bash
sudo snap install go --channel=1.13/stable --classic
```

```
error: cannot install "go": classic confinement requires snaps under /snap or symlink from /snap to
       /var/lib/snapd/snap
```
と言われたら
``` sh
sudo ln -s /var/lib/snapd/snap /snap
```
してもういちど。

```
Warning: /var/lib/snapd/snap/bin was not found in your $PATH. If you've not restarted your session
         since you installed snapd, try doing that. Please see https://forum.snapcraft.io/t/9469
         for more details.
```
があったらパスを通す。


GOPATHの例(~/.profile)

``` bash
# GoLang
export MYGOPATH="$HOME/works/go_project"
export GOPATH="$HOME/.go:/snap/go/current:$MYGOPATH"
export PATH="$HOME/.go/bin:$PATH:$MYGOPATH/bin"
alias gcd='cd $MYGOPATH/src/github.com/heiwa4126'
```

[motemen/ghq](https://github.com/motemen/ghq) 使うなら
git config --global ghq.root "$MYGOPATH/src"
```

GOPATHがない場合は"GOPATH="$HOME/go"になるみたい。
"$HOME/go/bin"をPATHに追加



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


最近(2020頭)
```bash
GO111MODULE=on go get -u golang.org/x/tools/gopls@latest
GO111MODULE=on go get -u github.com/sqs/goreturns
GO111MODULE=on go get -u github.com/rogpeppe/godef
go get -u github.com/go-delve/delve/cmd/dlv
GO111MODULE=on go get -u golang.org/x/lint/golint
GO111MODULE=on go get -u github.com/lukehoban/go-outline
GO111MODULE=on go get -u github.com/motemen/gore/cmd/gore

GO111MODULE=on go get -u github.com/nsf/gocode
```



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


# 構造体の比較

なんか値まで比較してくれるみたい。

```go
package main

import (
	"fmt"
)

type p struct{ x, y int }

func main() {
	o := p{0, 0}
	a := p{1, 2}
	b := p{1, 2}

	fmt.Printf("o=%v\n", o)
	fmt.Printf("a=%v\n", a)
	fmt.Printf("b=%v\n", b)

	fmt.Printf("o==a? : %t\n", o == a)
	fmt.Printf("b==a? : %t\n", b == a)
}
```
[The Go Playground](https://play.golang.org/p/e2OngSSFisB)

結果:
```
o={0 0}
a={1 2}
b={1 2}
o==a? : false
b==a? : true
```

# よく忘れるGolang

他の言語とちゃんぽんにやってるとわけがわからなくなることメモ。
やっぱGoってなんかちょっと変だかららら。

## キャスト

型アサーション (Type Assertion)。
interfaceにのみ使える

```go
var x interface{} = 1
y := x.(int)
```

キャストできない場合
```go
var x interface{} = "string"
y := x.(int)
```
panicする。 [Go Playground](https://play.golang.org/p/eor3uIt5RtK)

"string"が"100"とかでもダメ

panicさせたくない場合は
```go
y, ok := x.(int)
```
[Go Playground](https://play.golang.org/p/OKbUpOBX0Uw)


参考:
[型のキャストと、型アサーションによる型変換 | まくまくHugo/Goノート](https://maku77.github.io/hugo/go/cast.html)

## 永遠ループ

```go
for {
  // ...
}
```

## while

while無いです

```go
for coundown > 0 {
    fmt.Printf("coundown: %d\n", coundown)
    coundown--
}
```
引用元: [Go言語 - forループによる繰り返し処理 - 覚えたら書く](https://blog.y-yuki.net/entry/2017/05/06/000000)

## type()

### タイプの表示

```go
fmt.Println(reflect.TypeOf(x))
// or
fmt.Printf("%T\n",x)
```

interfaceなら`Type switches`も - [A Tour of Go](https://tour.golang.org/methods/16)


### タイプの比較

`x is int`みたいのが無いようだ。

```go
reflect.TypeOf(x).String() == "int"
```
しか思いつかない。

でもこれだと
type xがインタフェースyを持ってるかチェック
みたいのはできないね。





# interface

例えば
[io.Writerインタフェース](https://golang.org/pkg/io/#Writer)の定義は
```go
type Writer interface {
    Write(p []byte) (n int, err error)
}
```
なので、
```go
func (t T)Write(p []byte) (n int, err error)
// or
func (t *T)Write(p []byte) (n int, err error)
```
を持つtype Tなら、io.Writeの代わりに渡すことができる。

例えば
[fmt.Fprintf()](https://golang.org/pkg/fmt/#Fprintf)に。

で、上記のWrite()を持つタイプ(とWrite())は
- [bytes.Buffer](https://golang.org/pkg/bytes/#Buffer.Write)
- [bufio.Writer](https://golang.org/pkg/bufio/#Writer.Write) - 最後にFlush()が必要

などがある。

自作するなら

```go
package main

import (
  "fmt"
)

type Hoge struct {
  label string
}

func (h Hoge) Write(b []byte) (n int, err error) {
  fmt.Printf("(%s) len=%d\n", h.label, len(b))
  return len(b), nil
}

func main() {
  h := Hoge{"hoge1"}
  fmt.Fprintf(h, "Hello, world")
}
```

上記だと
Hoge.Write()がhogeを実体渡ししていて、コピーができるのでよくない。

```go
package main

import (
  "fmt"
)

type Hoge struct {
  label string
}

func (h *Hoge) Write(b []byte) (n int, err error) {
  fmt.Printf("(%s) len=%d\n", h.label, len(b))
  return len(b), nil
}

func main() {
  h := &Hoge{"hoge1"}
  fmt.Fprintf(h, "Hello, world")
}
```
にする。`fmt.Fprintf()`は何も変更していないのがすごいところ。


インタフェース引数は実体でも参照でも受けるが、

```go
func (t T)Write(p []byte) (n int, err error)
```
を実装したなら実体(T)を

```go
func (t *T)Write(p []byte) (n int, err error)
```
を実装したなら参照(&T)を渡さなければならない。

呼ばれる関数は
[fmt.Fprintf()](https://golang.org/pkg/fmt/#Fprintf)
にある通り、
実体でも参照でも
`fx(i interface, ...)`
で
`fx(i *interface, ...)`
にはならない。


例)
```go
package main

import (
  "fmt"
)

type SS interface {
  DoAnything()
}

type S1 struct {
  cnt int
  n   int
}

func (s1 *S1) DoAnything() {
  s1.cnt++
  fmt.Printf("(%d)n=%d\n", s1.cnt, s1.n)
}

type S2 struct {
  cnt int
  s   string
}

func (s2 *S2) DoAnything() {
  s2.cnt += 100
  fmt.Printf("(%d)s=%s\n", s2.cnt, s2.s)
}

type Z1 struct {
}

func (_ Z1) DoAnything() {
  fmt.Println("Do nothing")
}

func test1(ss SS) {
  ss.DoAnything()
}

func test2(ss SS) {
  fmt.Printf("%#v\n", ss)
}

func main() {
  s1 := &S1{0, 1}
  s2 := &S2{0, "Two"}
  test1(s1)
  test1(s2)
  test1(s1)
  test1(s2)

  z1 := Z1{}
  test2(z1)
}
```

# deferの中のエラー

よくあるのに正しく書くのは難しい。
write openしたファイルのClose()など。

[defer の中で発生した error を処理し忘れる - Go 言語(Golang) はまりどころと解決策 | yunabe.jp](https://www.yunabe.jp/docs/golang_pitfall.html#defer-%E3%81%AE%E4%B8%AD%E3%81%A7%E7%99%BA%E7%94%9F%E3%81%97%E3%81%9F-error-%E3%82%92%E5%87%A6%E7%90%86%E3%81%97%E5%BF%98%E3%82%8C%E3%82%8B)

> 返り値のerrorをdeferから上書きできるように名前(err)をつけておく

こんなパターン
``` go
  func xxx() (err error) {
    // ...
    // fileのWrite Open etc...
    // ...
    defer func() {
      if cerr := f.Close(); err == nil {
        err = cerr
      }
    }()
  }
```

[Goでdeferの処理中のエラーを返す書き方を工夫してみた · hnakamur's blog](https://hnakamur.github.io/blog/2015/04/27/write_function_for_go_defer/)

↑名前付きの*errorを使う例。

f.Write()の場合は、f.Sync()を使う、という技もあり。
```go
func helloNotes() error {
    f, err := os.Create("/home/joeshaw/notes.txt")
    if err != nil {
        return err
    }
    defer f.Close()

    if err = io.WriteString(f, "hello world"); err != nil {
        return err
    }

    return f.Sync()
}
```
引用元: [Don't defer Close() on writable files – joe shaw](https://www.joeshaw.org/dont-defer-close-on-writable-files/)


goroutineに続く

これとか参考:
- [複数のGoroutineをWaitGroup（ErrGroup）で制御する - Hack Your Design!](https://blog.toshimaru.net/goroutine-with-waitgroup/#goroutine--errgroup-%E3%82%92%E4%BD%BF%E3%81%86)


# テストのカバレッジ

```sh
go test ./... -cover
```

```
coverage: 76.7% of statements
```
みたいのが表示される。

```sh
go test ./... -coverprofile=cover.out
go tool cover -html=cover.out -o cover.html
```
で、
緑がカバーしたところ、赤がしてないところ、みたいな
カバレッジレポート`cover.html`ができる。 (`-o`を使わないと/tmpにできる)

```sh
go tool cover -func=cover.out
```
で関数単位のレポートなど。

参考:
- [Goのテスト作成とカバレッジ率＆カバレッジ行表示をしてみる - Qiita](https://qiita.com/silverfox/items/11332bdc5d33838c2c7b)
- [Go でコードカバレッジを取得する - Qiita](https://qiita.com/kkohtaka/items/965fe08821cda8c9da8a)
- [The cover story - The Go Blog](https://blog.golang.org/cover)


# shadowingによるバグ

`:=` Short Variable Declaration Operator は便利だけど、ブロックの中で使うと、あっさりshadowingによるバグを起こす。

[Big Sky :: Go 言語で変数のシャドウイングを避けたいなら shadow を使おう。](https://mattn.kaoriya.net/software/lang/go/20200227102218.htm)
にあったサンプル。

`main.go`:
```go
package main

import (
  "fmt"
)

var condition = true

func main() {

  var hoge *string
  if condition {
    hoge, err := do("word") // <- "shadowing" here
    if err != nil {
      return
    }
    fmt.Printf("checkpoint: %v\n", *hoge)
  } else {
    hoge = nil
  }

  fmt.Printf("result: %v\n", hoge)
}

func do(v string) (*string, error) {
  return &v, nil
}
```

実行すると、あら不思議
```
checkpoint: word
result: <nil>
```

検出するには
```
go get -u golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow
```
でshadowコマンドをインストールして

``` sh
shadow ./...
# or
shadow main.go
# or
go vet -vettool=$(which shadow) ./...
```
する。

```
./main.go:15:3: declaration of "hoge" shadows declaration at line 13
```
みたいな結果が出るので治す。


ほか参考:
- [goの静的解析ツールをGithub Actionsのv2で動かしてみた - Qiita](https://qiita.com/grandcolline/items/04c168844dfca3a8ede7)
- [Go言語用のあらゆるLinterを丸っと並列実行する、gometalinterを使いこなそう - Sider Blog](https://blog-ja.sideci.com/entry/2017/07/04/110000)
- [gometalinter が deprecated になったので golangci-lint に移行しよう - あふん](https://ponde-m.hatenablog.com/entry/2019/03/24/230333)
- [golangci/golangci-lint: Fast linters Runner for Go](https://github.com/golangci/golangci-lint)


# golangci-lint

使え。

- [Install | golangci-lint](https://golangci-lint.run/usage/install/#local-installation)
- [Quick Start | golangci-lint](https://golangci-lint.run/usage/quick-start)


# panic()のドキュメント

- [builtin - The Go Programming Language](https://golang.org/pkg/builtin/)

ビルドインモジュールのドキュメントにある。

[println()](https://golang.org/pkg/builtin/#println)
とか知らなかった(fmt.Println()ではなく)


# errorでスタックトレースが欲しいとき

(2020-07. Go 1.14現在)

- [pkg/errors: Simple error handling primitives](https://github.com/pkg/errors)
- [Goでエラーのスタックトレースを追える&表示する方法 - Qiita](https://qiita.com/roba4coding/items/769ddb220bc61cd19df1)
- [pkg/errors から徐々に Go 1.13 errors へ移行する - blog.syfm](https://syfm.hatenablog.com/entry/2019/12/27/193348)
- [How to get stacktraces from errors in Golang with go-errors/errors | Bugsnag Blog](https://www.bugsnag.com/blog/go-errors)
- [errors - The Go Programming Language](https://golang.org/pkg/errors/)

お手軽にスタックトレースが欲しいならば、やっぱり

- github.com/pkg/errorsをimportする
- errors.New()でエラーを生成する
- 表示したいところで、フォーマット文字列に%+vを使う

引用元: [Goでエラーのスタックトレースを追える&表示する方法 - Qiita](https://qiita.com/roba4coding/items/769ddb220bc61cd19df1)

みたいです。