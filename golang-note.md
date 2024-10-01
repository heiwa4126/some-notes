# Go 言語 メモ

- [Go 言語 メモ](#go-言語-メモ)
  - [Linux で Windows のバイナリを作る](#linux-で-windows-のバイナリを作る)
  - [strings.Builder](#stringsbuilder)
  - [delve](#delve)
    - [インストール](#インストール)
    - [実行例](#実行例)
  - [GDB でデバッグ](#gdb-でデバッグ)
  - [go モジュール](#go-モジュール)
  - [go run](#go-run)
  - [snapd で go](#snapd-で-go)
  - [Go で書いたコードを systemd でデーモンにする](#go-で書いたコードを-systemd-でデーモンにする)
  - [golang で書いたコードを systemd で daemon に](#golang-で書いたコードを-systemd-で-daemon-に)
  - [構造体の比較](#構造体の比較)
  - [よく忘れる Golang](#よく忘れる-golang)
    - [キャスト](#キャスト)
    - [永遠ループ](#永遠ループ)
    - [while](#while)
    - [type()](#type)
      - [タイプの表示](#タイプの表示)
      - [タイプの比較](#タイプの比較)
  - [interface](#interface)
  - [defer の中のエラー](#defer-の中のエラー)
  - [テストのカバレッジ](#テストのカバレッジ)
  - [shadowing によるバグ](#shadowing-によるバグ)
  - [golangci-lint](#golangci-lint)
  - [panic()のドキュメント](#panicのドキュメント)
  - [error でスタックトレースが欲しいとき](#error-でスタックトレースが欲しいとき)
  - [バイナリと依存モジュールのバージョン表示](#バイナリと依存モジュールのバージョン表示)
  - [trimpath オプション](#trimpath-オプション)
  - [JSON から go の type xxxx struct にするやつ](#json-から-go-の-type-xxxx-struct-にするやつ)
  - [strings.HasSuffix](#stringshassuffix)
  - [標準プロジェクトレイアウト](#標準プロジェクトレイアウト)
  - [おもしろい記事](#おもしろい記事)
  - [有名ツールリスト](#有名ツールリスト)
  - [windows で btime,atime,ctime,mtime](#windows-で-btimeatimectimemtime)
  - [emacs での環境](#emacs-での環境)
  - [go-mode](#go-mode)
  - [Windows と Linux でソースを分ける](#windows-と-linux-でソースを分ける)
  - [事前に型のわからない JSON を読む](#事前に型のわからない-json-を読む)
  - [インタフェースメモ](#インタフェースメモ)
  - ["//go:build"](#gobuild)

## Linux で Windows のバイナリを作る

- [WindowsCrossCompiling · golang/go Wiki · GitHub](https://github.com/golang/go/wiki/WindowsCrossCompiling)
- [Cross compilation with Go 1.5 | Dave Cheney](https://dave.cheney.net/2015/08/22/cross-compilation-with-go-1-5)

## strings.Builder

1.10 から標準になった

- [strings - Type Builder - The Go Programming Language](https://golang.org/pkg/strings/#Builder)
- [Go 言語の strings.Builder による文字列の連結の最適化とベンチマーク - Qiita](https://qiita.com/po3rin/items/2e406645e0b64e0339d3)
- [Go1.10 で入る strings.Builder を検証した #golang - Qiita](https://qiita.com/tenntenn/items/94923a0c527d499db5b9)

> strings.Builder は io.Writer インタフェースを実装しているため、次のように fmt.Fprint などの関数で利用できます。

```
var b strings.Builder
fmt.Fprint(&b, "hello")
b.WriteString("world!\n")
```

## delve

- [go-delve/delve: Delve is a debugger for the Go programming language.](https://github.com/go-delve/delve)

### インストール

```
go get -u github.com/go-delve/delve/cmd/dlv
hash -r
```

### 実行例

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

main の main()は`b main.main`ですむのに、
モジュールについてはフルパスでないといけないのはめんどくさい。
go.mod を見るような設定があるはず。

参考:
[Golang のデバッガ delve の使い方 - Qiita](https://qiita.com/minamijoyo/items/4da68467c1c5d94c8cd7)

## GDB でデバッグ

- [Debugging Go Code with GDB - The Go Programming Language](https://golang.org/doc/gdb)

## go モジュール

go 1.13 から標準になる。

以下のリンクが
チュートリアルになってるので、一回やってみると理解できる

- [Using Go Modules - The Go Blog](https://blog.golang.org/using-go-modules)
- [The Go Blog - Using Go Modules / Go Modules を使う（和訳） - Qiita](https://qiita.com/pokeh/items/139d0f1fe56e358ba597)

## go run

go run の引数は package なので
main パッケージの main()が 1 つしかない、ちゃんとしたプロジェクトなら
`go run .`
で実行できる。もちろんパッケージ名をフルで指定してもいい。
`go run github.com/heiwa4126/gogogophers`
みたいな(でもしないよ)。

サブパッケージ以下のテストも
`go test ./feather/...`
みたいにできる。
`go test feather/...`
ではダメ。

## snapd で go

Ubuntu だと snapd 使うのが便利。

[Install Go for Linux using the Snap Store | Snapcraft](https://snapcraft.io/go)

```bash
sudo snap install go --classic
## バージョンを指定するなら↓
sudo snap install go --channel=1.13/stable --classic
```

```
error: cannot install "go": classic confinement requires snaps under /snap or symlink from /snap to
       /var/lib/snapd/snap
```

と言われたら

```sh
sudo ln -s /var/lib/snapd/snap /snap
```

してもういちど。

```
Warning: /var/lib/snapd/snap/bin was not found in your $PATH. If you've not restarted your session
         since you installed snapd, try doing that. Please see https://forum.snapcraft.io/t/9469
         for more details.
```

があったらパスを通す。

GOPATH の例(~/.profile)

```bash
## GoLang
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

## RHEL/CentOS 7でgolang

EPELで新し目のgolangパッケージを配ってます。
Red Hat 7系でgo入れるならEPELを設定して
```

sudo yum -y install golang

````
を試すこと。snapよりはちょっとリリースは遅い。

あとは↑の[snapdでgo](#snapd%e3%81%a7go)みたいな設定を。

epelのyumでgoを入れたなら、
GOPATHの2つ目は`/usr/lib/golang`



## 定番ツールをまとめて

ディスクに余裕があるなら
``` bash
go get -u golang.org/x/tools/...
````

(300MB ぐらい。strip \*して 200MB ぐらい)

余裕がなければこれぐらいは

```bash
go get -u github.com/rogpeppe/godef
go get -u github.com/nsf/gocode
go get -u github.com/golang/lint/golint
go get -u github.com/kisielk/errcheck
go get -u github.com/derekparker/delve/cmd/dlv
```

[golang/tools: [mirror] Go Tools](https://github.com/golang/tools)

最近(2020 頭)

```bash
cd
## GOPATH以外のどこかで実行
GO111MODULE=on go get -u golang.org/x/tools/gopls@latest
GO111MODULE=on go get -u github.com/sqs/goreturns
GO111MODULE=on go get -u github.com/rogpeppe/godef
go get -u github.com/go-delve/delve/cmd/dlv
GO111MODULE=on go get -u golang.org/x/lint/golint
GO111MODULE=on go get -u github.com/lukehoban/go-outline
GO111MODULE=on go get -u github.com/motemen/gore/cmd/gore

GO111MODULE=on go get -u github.com/nsf/gocode
GO111MODULE=on go get -u golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.30.0
```

## Go で書いたコードを systemd でデーモンにする

参考にしたもの：

- [Integration of a Go service with systemd: readiness & liveness | Vincent Bernat](https://vincent.bernat.ch/en/blog/2017-systemd-golang)

`main.go` ([↑ から引用](https://vincent.bernat.ch/en/blog/2017-systemd-golang))

```go
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

```bash
mkdir 404
cd !$
vim main.go # 上記のコードをコピペ
go build
## test
./404
curl http://localhost:8081/
```

結果

```
404 NOT FOUND
```

バイナリのサイズを小さくしたかったら

```bash
go build -ldflags="-w -s"
upx 404
```

など

で、これを systemd でデーモンにする。

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

↑ のポイント

- 死んだら 3 秒まって再開する(試しに kill -9 <pid>してみること)。
- `Restart=always`は雑すぎるかも。
- network は必要

手順

```bash
sudo vim /lib/systemd/system/404.service # コピペ&編集
sudo systemctl daemon-reload
sudo systemctl start 404.service
sudo systemctl status 404.service
## 404だとPIDと思われるので.serviceもつける
```

`curl http://localhost:8081/`
や
`sudo lsof -p <pid>`
などしてみる。

## golang で書いたコードを systemd で daemon に

[Integration of a Go service with systemd: readiness & liveness | Vincent Bernat](https://vincent.bernat.ch/en/blog/2017-systemd-golang)

## 構造体の比較

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

## よく忘れる Golang

他の言語とちゃんぽんにやってるとわけがわからなくなることメモ。
やっぱ Go ってなんかちょっと変だかららら。

### キャスト

型アサーション (Type Assertion)。
interface にのみ使える

```go
var x interface{} = 1
y := x.(int)
```

キャストできない場合

```go
var x interface{} = "string"
y := x.(int)
```

panic する。 [Go Playground](https://play.golang.org/p/eor3uIt5RtK)

"string"が"100"とかでもダメ

panic させたくない場合は

```go
y, ok := x.(int)
```

[Go Playground](https://play.golang.org/p/OKbUpOBX0Uw)

参考:
[型のキャストと、型アサーションによる型変換 | まくまく Hugo/Go ノート](https://maku77.github.io/hugo/go/cast.html)

### 永遠ループ

```go
for {
  // ...
}
```

### while

while 無いです

```go
for coundown > 0 {
    fmt.Printf("coundown: %d\n", coundown)
    coundown--
}
```

引用元: [Go 言語 - for ループによる繰り返し処理 - 覚えたら書く](https://blog.y-yuki.net/entry/2017/05/06/000000)

### type()

#### タイプの表示

```go
fmt.Println(reflect.TypeOf(x))
// or
fmt.Printf("%T\n",x)
```

interface なら`Type switches`も - [A Tour of Go](https://tour.golang.org/methods/16)

#### タイプの比較

`x is int`みたいのが無いようだ。

```go
reflect.TypeOf(x).String() == "int"
```

しか思いつかない。

でもこれだと
type x がインタフェース y を持ってるかチェック
みたいのはできないね。

## interface

例えば
[io.Writer インタフェース](https://golang.org/pkg/io/#Writer)の定義は

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

を持つ type T なら、io.Write の代わりに渡すことができる。

例えば
[fmt.Fprintf()](https://golang.org/pkg/fmt/#Fprintf)に。

で、上記の Write()を持つタイプ(と Write())は

- [bytes.Buffer](https://golang.org/pkg/bytes/#Buffer.Write)
- [bufio.Writer](https://golang.org/pkg/bufio/#Writer.Write) - 最後に Flush()が必要

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
Hoge.Write()が hoge を実体渡ししていて、コピーができるのでよくない。

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

## defer の中のエラー

よくあるのに正しく書くのは難しい。
write open したファイルの Close()など。

[defer の中で発生した error を処理し忘れる - Go 言語(Golang) はまりどころと解決策 | yunabe.jp](https://www.yunabe.jp/docs/golang_pitfall.html#defer-%E3%81%AE%E4%B8%AD%E3%81%A7%E7%99%BA%E7%94%9F%E3%81%97%E3%81%9F-error-%E3%82%92%E5%87%A6%E7%90%86%E3%81%97%E5%BF%98%E3%82%8C%E3%82%8B)

> 返り値の error を defer から上書きできるように名前(err)をつけておく

こんなパターン

```go
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

[Go で defer の処理中のエラーを返す書き方を工夫してみた · hnakamur's blog](https://hnakamur.github.io/blog/2015/04/27/write_function_for_go_defer/)

↑ 名前付きの\*error を使う例。

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

goroutine に続く

これとか参考:

- [複数の Goroutine を WaitGroup（ErrGroup）で制御する - Hack Your Design!](https://blog.toshimaru.net/goroutine-with-waitgroup/#goroutine--errgroup-%E3%82%92%E4%BD%BF%E3%81%86)

## テストのカバレッジ

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
カバレッジレポート`cover.html`ができる。 (`-o`を使わないと/tmp にできる)

```sh
go tool cover -func=cover.out
```

で関数単位のレポートなど。

参考:

- [Go のテスト作成とカバレッジ率&カバレッジ行表示をしてみる - Qiita](https://qiita.com/silverfox/items/11332bdc5d33838c2c7b)
- [Go でコードカバレッジを取得する - Qiita](https://qiita.com/kkohtaka/items/965fe08821cda8c9da8a)
- [The cover story - The Go Blog](https://blog.golang.org/cover)

## shadowing によるバグ

`:=` Short Variable Declaration Operator は便利だけど、ブロックの中で使うと、あっさり shadowing によるバグを起こす。

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

で shadow コマンドをインストールして

```sh
shadow ./...
## or
shadow main.go
## or
go vet -vettool=$(which shadow) ./...
```

する。

```
./main.go:15:3: declaration of "hoge" shadows declaration at line 13
```

みたいな結果が出るので治す。

ほか参考:

- [go の静的解析ツールを Github Actions の v2 で動かしてみた - Qiita](https://qiita.com/grandcolline/items/04c168844dfca3a8ede7)
- [Go 言語用のあらゆる Linter を丸っと並列実行する、gometalinter を使いこなそう - Sider Blog](https://blog-ja.sideci.com/entry/2017/07/04/110000)
- [gometalinter が deprecated になったので golangci-lint に移行しよう - あふん](https://ponde-m.hatenablog.com/entry/2019/03/24/230333)
- [golangci/golangci-lint: Fast linters Runner for Go](https://github.com/golangci/golangci-lint)

## golangci-lint

使え。

- [Install | golangci-lint](https://golangci-lint.run/usage/install/#local-installation)
- [Quick Start | golangci-lint](https://golangci-lint.run/usage/quick-start)

## panic()のドキュメント

- [builtin - The Go Programming Language](https://golang.org/pkg/builtin/)

ビルドインモジュールのドキュメントにある。

[println()](https://golang.org/pkg/builtin/#println)
とか知らなかった(fmt.Println()ではなく)

## error でスタックトレースが欲しいとき

(2020-07. Go 1.14 現在)

- [pkg/errors: Simple error handling primitives](https://github.com/pkg/errors)
- [Go でエラーのスタックトレースを追える&表示する方法 - Qiita](https://qiita.com/roba4coding/items/769ddb220bc61cd19df1)
- [pkg/errors から徐々に Go 1.13 errors へ移行する - blog.syfm](https://syfm.hatenablog.com/entry/2019/12/27/193348)
- [How to get stacktraces from errors in Golang with go-errors/errors | Bugsnag Blog](https://www.bugsnag.com/blog/go-errors)
- [errors - The Go Programming Language](https://golang.org/pkg/errors/)

お手軽にスタックトレースが欲しいならば、やっぱり

- github.com/pkg/errors を import する
- errors.New()でエラーを生成する
- 表示したいところで、フォーマット文字列に%+v を使う

引用元: [Go でエラーのスタックトレースを追える&表示する方法 - Qiita](https://qiita.com/roba4coding/items/769ddb220bc61cd19df1)

みたいです。

## バイナリと依存モジュールのバージョン表示

いつのまにか
`go version -m 対象ファイル`
で表示できるようになった。(go 1.13 以降? `go help version`参照)

実行例:

```
$  go version -m auditfilter1
auditfilter1: go1.14.6
        path    github.com/heiwa4126/auditfilter1
        mod     github.com/heiwa4126/auditfilter1       (devel)
        dep     github.com/fatih/color  v1.7.0  h1:DkWD4oS2D8LGGgTQ6IvwJJXSL5Vp2ffcQg58nFV38Ys=
        dep     github.com/goccy/go-yaml        v1.8.0  h1:WCe9sBiI0oZb6EC6f3kq3dv0+aEiNdstT7b4xxq4MJQ=
        dep     github.com/mattn/go-colorable   v0.1.4  h1:snbPLB8fVfU9iwbbo30TPtbLRzwWu6aJS6Xh4eaaviA=
        dep     github.com/mattn/go-isatty      v0.0.10 h1:qxFzApOv4WsAL965uUPIsXzAKCZxN2p9UqdhFS4ZW10=
        dep     golang.org/x/sys        v0.0.0-20191010194322-b09406accb47      h1:/XfQ9z7ib8eEJX2hdgFTZJ/ntt0swNk5oYBziWeTCvY=
        dep     golang.org/x/xerrors    v0.0.0-20191011141410-1b5146add898      h1:/atklqdjdhuosWIl6AIbOeHJjicWYPqR9bpxqxYG2pA=
```

## trimpath オプション

`strings`コマンド使うとよくわかるけど、バイナリにパスがフルパスで入ってる。
これを取り除くオプション。

ちょっとバイナリサイズが小さくなる。snap で go 入れてると結構大きい。

```sh
go build -ldflags "-s -w" -trimpath
```

- [golang の実行ファイルからファイルパスを除きたい - Qiita](https://qiita.com/umisama/items/51d7f595d79aea577e38)
- [how to delete source file path informatin in panic‘s stack trace](https://groups.google.com/g/golang-nuts/c/Xr2Zsa0YfKs?pli=1)
- [go - The Go Programming Language](https://golang.org/cmd/go/#hdr-Compile_packages_and_dependencies)

## JSON から go の type xxxx struct にするやつ

いろいろあるけど

- [JSON to Go Struct](https://transform.tools/json-to-go)
- [JSON-to-Go: Convert JSON to Go instantly](https://mholt.github.io/json-to-go/)
- [mholt/json-to-go: Translates JSON into a Go type in your browser instantly (original)](https://github.com/mholt/json-to-go)

もちろん YAML もあります

- [YAML-to-Go: Convert YAML to Go instantly](https://zhwt.github.io/yaml-to-go/)
- [Zhwt/yaml-to-go: Translates YAML into a Go type in your browser instantly.](https://github.com/Zhwt/yaml-to-go)

## strings.HasSuffix

文字列の先頭一致、末尾一致。

[strings - The Go Programming Language](https://golang.org/pkg/strings/#HasPrefix)

わりとよく使うのにとっさに出てこないのは関数の名前のせいだと思う。
メモメモ

実装は ↓

```go
// HasPrefix tests whether the string s begins with prefix.
func HasPrefix(s, prefix string) bool {
  return len(s) >= len(prefix) && s[0:len(prefix)] == prefix
}

// HasSuffix tests whether the string s ends with suffix.
func HasSuffix(s, suffix string) bool {
  return len(s) >= len(suffix) && s[len(s)-len(suffix):] == suffix
}
```

Rust だと

- [str::starts_with](https://doc.rust-lang.org/std/primitive.str.html#method.starts_with)
- [str::ends_with](https://doc.rust-lang.org/std/primitive.str.html#method.ends_with)

Python だと str.startswith, str.endswith

## 標準プロジェクトレイアウト

すこし「標準」っぽくしてみよう。

- [golang-standards/project-layout: Standard Go Project Layout](https://github.com/golang-standards/project-layout)
- [Go にはディレクトリ構成のスタンダードがあるらしい。 - Qiita](https://qiita.com/sueken/items/87093e5941bfbc09bea8)
- [Go の標準プロジェクトレイアウトを読み解く - Tech Do | メディアドゥの技術ブログ](https://techdo.mediado.jp/entry/2019/01/18/112503)

サンプルプロジェクト:

- [vmware-tanzu/velero: Backup and migrate Kubernetes applications and their persistent volumes](https://github.com/vmware-tanzu/velero)

テストデータを/test に置くのはちょっといやだ。
/pkg, /internal も大げさではないか?

プロジェクトルートに main.go がないと`go build`ができない。

やっぱりけっこうめんどくさい。利点が見えない

## おもしろい記事

- [Optimized abs() for int64 in Go](http://cavaliercoder.com/blog/optimized-abs-for-int64-in-go.html)

## 有名ツールリスト

- gocode
- gopkgs
- go-outline
- go-symbols
- guru
- gorename
- gotests
- gomodifytags
- dlv
- godef
- goimports
- golint
- impl
- fillstruct
- goplay
- godoctor
- gocode-gomod

(古い。あとで直す)

2022-11 ごろに vscode が自動で入れるツール

- gotests
- gomodifytags
- impl
- goplay
- dlv
- staticcheck
- gopls
- go-outline

## windows で btime,atime,ctime,mtime

サンプル:
[djherbis/times: #golang file times (atime, mtime, ctime, btime)](https://github.com/djherbis/times)

OS ごとの条件コンパイルのサンプルにもなってます。

touch みたいのは
[go - Windows での「ファイル作成日時」を変更する方法 - スタック・オーバーフロー](https://ja.stackoverflow.com/questions/47540/windows%E3%81%A7%E3%81%AE-%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E4%BD%9C%E6%88%90%E6%97%A5%E6%99%82-%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95)

## emacs での環境

gopls で LSP モード。
のコピペ。

```sh
cd
GO111MODULE=on go get -u golang.org/x/tools/gopls@latest
GO111MODULE=on go get -u github.com/sqs/goreturns
```

パッケージは

- lsp
- go-mode
- comapny-go
- company-lsp
- yasnippet (使いかたがよくわからん [Emacs に yasnippet を導入&スニペットの登録方法 | vdeep](http://vdeep.net/emacs-yasnippet))

```lisp
(add-hook
 'go-mode-hook
 (lambda()
   (setq indent-tabs-mode nil)
   (setq c-basic-offset 2)
   (setq tab-width 2)
   (setq gofmt-command "goreturns")
   (add-hook 'before-save-hook 'gofmt-before-save)
   )
 )
```

あとは
[tools/emacs.md at master · golang/tools](https://github.com/golang/tools/blob/master/gopls/doc/emacs.md)
の例を追加。一部を除き go 専用ってわけではないので注意。

## go-mode

emacs の go-mode には`go test`とか実行するコマンドが無い。

- [nlamirault/gotest.el: Emacs mode to go unit test command line tool](https://github.com/nlamirault/gotest.el)

## Windows と Linux でソースを分ける

- `foo_linux.go` と `foo_windows.go` みたいにする
- `runtime.GOOS`で分岐する (参照:[go/syslist.go at master · golang/go](https://github.com/golang/go/blob/master/src/go/build/syslist.go))
- build constraints を使う
  - `go help buildconstraint | less`参照 or [build - The Go Programming Language](https://golang.org/pkg/go/build/#hdr-Build_Constraints)
  - [Go の Build Constraints に関するメモ - Qiita](https://qiita.com/hnw/items/7dd4d10e837158d6156a)

## 事前に型のわからない JSON を読む

普通は構造体にアノテーション使うけど、
REST API みたいに型が変わるものが帰ってくる場合など。

- [JSON の処理 · Build web application with Golang](https://astaxie.gitbooks.io/build-web-application-with-golang/content/ja/07.2.html)
- [JSON · Build web application with Golang](https://astaxie.gitbooks.io/build-web-application-with-golang/content/en/07.2.html) - "Parse to interface" の節
- [bitly/go-simplejson: a Go package to interact with arbitrary JSON](https://github.com/bitly/go-simplejson)
- [simplejson · pkg.go.dev](https://pkg.go.dev/github.com/bitly/go-simplejson)
- [golang は ゆるふわに JSON を扱えまぁす! — KaoriYa](https://www.kaoriya.net/blog/2016/06/25/)
- [koron/go-dproxy: dProxy - document proxy](https://github.com/koron/go-dproxy)
- [mattn/go-jsonpointer](https://github.com/mattn/go-jsonpointer)

そもそも違う構造体指定しても json.Unmarshal()はエラーにならない。
逆に、バリデーションしたい場合はどうすればいい?

## インタフェースメモ

(以下は間違ってるかもしれません)

インタフェースを関数にわたす、または戻り値として受け取るときに、
インタフェースはすでに structure の pointer みたいになってるので、
宣言で `*MyInterface` みたいに書くと、コンパイル通りません。
いつでもどこでも `MyInterface` が正しい。

## "//go:build"

[Build Constraints](https://pkg.go.dev/go/build#hdr-Build_Constraints)というもの。
