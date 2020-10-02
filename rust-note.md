# Rustメモ

Rustって深いよね(皮肉)。

- [Rustメモ](#rustメモ)
- [std::strにiter()がない](#stdstrにiterがない)
- [type(var)みたいの](#typevarみたいの)
- [クレート & カーゴ](#クレート--カーゴ)
- [Rustは何で「サビ」なの?](#rustは何でサビなの)
- [testでprintln!](#testでprintln)
- [Rustのエラーハンドリング](#rustのエラーハンドリング)
- [anyhow](#anyhow)
- [Rustの更新](#rustの更新)
- [Rustのプロジェクトの始め方](#rustのプロジェクトの始め方)
- [型を表示](#型を表示)
- [スライスいろいろ](#スライスいろいろ)
- [Cargo.tomlの書式](#cargotomlの書式)
- [バージョンを表示する](#バージョンを表示する)
- [rls (Rust Language Server)](#rls-rust-language-server)
- [rustfmt](#rustfmt)
- [emacsでRust](#emacsでrust)
- [String <-> &str](#string---str)
- [RAWテキストの書き方](#rawテキストの書き方)
- [Rustのモジュール](#rustのモジュール)
- [RHEL7にllvm](#rhel7にllvm)
- [cargo test](#cargo-test)
- [OptionとResult](#optionとresult)
- [型変換イディオム](#型変換イディオム)
- [RustでExcelファイルを作る](#rustでexcelファイルを作る)
- [Boxとdyn](#boxとdyn)
- [print!のフォーマット](#printのフォーマット)


# std::strにiter()がない

&strはスライスかと思っていたら、なんか特別扱いらしい(Rustは「特別扱い」が多い)。

[std::str - Rust](https://doc.rust-lang.org/beta/std/str/index.html)

iter()はないけど、専用のbyte(),chars(),char_indices()がある。

[スライス - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch04-03-slices.html)
の`first_word()`の例

chars()の例
``` Rust
fn first_word(s:&str) -> &str {
    for (i, item) in s.chars().enumerate() {
        if item == ' ' {
            return &s[0..i];
        }
    }
    &s[..]
}

fn main() {
    let s = "Hello, world!";
    println!("{}",s);
    println!("{}",first_word(s));
}
```

ただ、sが日本語だったりすると途端に死ぬ。
比較対象が' '空白でいいなら,bytes()を使った方がいい。
``` Rust
fn first_word(s:&str) -> &str {
    for (i, item) in s.bytes().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}
```

汎用ならchar_indices()を使う。
Unicodeもちゃんと探せる。

あまり意味のない例:
```Rust
// delmの直前までの文字列を返す
fn find_char(s:&str,delm:char) -> &str {
    for (i, item) in s.char_indices() {
        if item == delm {
            return &s[0..i];
        }
    }
    &s[..]
}

fn main() {
    let s2 = "世界の皆さん こんにちは";
    println!("{}",find_char(s2,'ん'));
}
```
実行すると`世界の皆さ`になります。
[Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=9904cd1381674fed2f5350752c924315)


# type(var)みたいの

[How do I print the type of a variable in Rust? - Stack Overflow](https://stackoverflow.com/questions/21747136/how-do-i-print-the-type-of-a-variable-in-rust)

↑要は、
存在しないメソッドつけてコンパイルしてみろ、
という話。

# クレート & カーゴ

> 英語でcrate「木枠や物を運ぶかご」という意味です

[クレートとは？バリケンネルと何が違うの？ | 犬のQ&A集 - dogoo.com](https://www.dogoo.com/toukou/dogqa/faq_log/5067051.htm)


>  カーゴ【cargo】 の解説
>    １ 船・飛行機・列車などの積み荷

[cargo（カーゴ）の意味 - goo国語辞書](https://dictionary.goo.ne.jp/word/%E3%82%AB%E3%83%BC%E3%82%B4/)

# Rustは何で「サビ」なの?

[Internet archaeology: the definitive, end-all source for why Rust is named "Rust" : rust](https://www.reddit.com/r/rust/comments/27jvdt/internet_archaeology_the_definitive_endall_source/)

"rust fungi"に由来するそうですが、
[サビキン目 - Wikipedia](https://ja.wikipedia.org/wiki/%E3%82%B5%E3%83%93%E3%82%AD%E3%83%B3%E7%9B%AE)
↑にあるように「Chromeの反対」の方が好きだな。

# testでprintln!

```
cargo test -- --nocapture
```
[関数の出力を表示する - テストを走らせる - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch11-02-running-tests.html#a%E9%96%A2%E6%95%B0%E3%81%AE%E5%87%BA%E5%8A%9B%E3%82%92%E8%A1%A8%E7%A4%BA%E3%81%99%E3%82%8B)

golangの
`go test -v`
みたいなやつ。


# Rustのエラーハンドリング

Go言語の
[builtin - The Go Programming Language](https://golang.org/pkg/builtin/#error)
```go
type error interface {
    Error() string
}
```
文字列返すError()関数だけ実装すればいい、
とか、`fmr.Errorf()`みたいな、簡単なものとは違うらしい。

例)
[teip/errors.rs at master · greymd/teip](https://github.com/greymd/teip/blob/master/src/errors.rs)

ある関数の返す`Result<T, E>`のEのenumを作る。Javaのexception列挙するようなノリ。

そのenumに
[std::fmt::Display - Rust](https://doc.rust-lang.org/std/fmt/trait.Display.html)
と
[std::error::Error - Rust](https://doc.rust-lang.org/std/error/trait.Error.html)
を
implする。

参照: [Rust のエラーまわりの変遷 - Qiita](https://qiita.com/legokichi/items/d4819f7d464c0d2ce2b8#1-error-%E3%81%A8-debug-%E3%81%A8-display-%E3%83%88%E3%83%AC%E3%82%A4%E3%83%88%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%97%E3%81%AA%E3%81%84%E3%81%A8%E3%81%84%E3%81%91%E3%81%AA%E3%81%84)

難しすぎる。

この例とかを使う。
- [Error Handling - A Gentle Introduction to Rust](https://stevedonovan.github.io/rust-gentle-intro/6-error-handling.html)
- [Boxing errors - Rust By Example](https://doc.rust-lang.org/stable/rust-by-example/error/multiple_error_types/boxing_errors.html)


この辺読む:
- [Rustのエラー処理 - Qiita](https://qiita.com/fujitayy/items/cafe661415b6aa33d884) - failureはもはやメンテされてないらしい
- [std::convert::From - Rust](https://doc.rust-lang.org/std/convert/trait.From.html)
- [From failure to Fehler](https://boats.gitlab.io/blog/post/failure-to-fehler/) - fehlerはドイツ語でエラー
- [Rust のエラーまわりの変遷 - Qiita](https://qiita.com/legokichi/items/d4819f7d464c0d2ce2b8)
- [Error Handling Survey](https://blog.yoshuawuyts.com/error-handling-survey/)
- [Rustエラーライブラリのトレンド解説（2020年1月版） - Qiita](https://qiita.com/dalance/items/7e0fa481626c76d59f65)
  - [Rustのエラーライブラリ利用状況を調べてみた - Qiita](https://qiita.com/dalance/items/4704b16c0718f6dfb7c0) - ↑前編

[Fix the Error trait by withoutboats · Pull Request #2504 · rust-lang/rfcs](https://github.com/rust-lang/rfcs/pull/2504)
に基づいた、新しい
`std::error::Error`は
いつふつーに使える様になるかわからん。

1. 昔の[std::error::Error](https://doc.rust-lang.org/std/error/trait.Error.html)
1. [failure](https://boats.gitlab.io/failure/)
1. anyhowとthiserror

の順で学ぶしかないかな。

ほか参考:
- [Rustでエラーを合成する - Qiita](https://qiita.com/termoshtt/items/8c015d9289613ec640f1)
- [RFC 2504 "fix_error": Rustの新たなErrorトレイト - Qiita](https://qiita.com/termoshtt/items/830008898f90c647a971)

# anyhow

- [anyhow - crates.io: Rust Package Registry](https://crates.io/crates/anyhow)
- [anyhow - Rust](https://docs.rs/anyhow/1.0.31/anyhow/)
- [Rustの便利クレート - Qiita](https://qiita.com/qryxip/items/7c16ab9ef3072c1d7199#anyhow)
- [anyhowの簡単な使い方 - Shinjuku.rs #8 dalance - Speaker Deck](https://speakerdeck.com/dalance/shinjuku-dot-rs-number-8-dalance)


# Rustの更新

```sh
rustup update
```

[Install Rust - Rust Programming Language](https://www.rust-lang.org/tools/install)


# Rustのプロジェクトの始め方

```sh
cargo init hello95
cd !$
cargo run
cargo build
./target/debug/hello95
cargo build --release
./target/release/hello95
RUSTFLAGS="-C link-arg=-s" cargo build --release
./target/release/hello95
```


# 型を表示

1.38から[std::any::type_name - Rust](https://doc.rust-lang.org/std/any/fn.type_name.html)が使える。

コード例
```rust
fn typename<T>(_: T) -> &'static str{
    std::any::type_name::<T>()
}

fn main() {
    let x = (1 .. 11).skip(2).collect::<Vec<_>>();
    println!("{} {:?}", typename(&x), &x);
}
```
[rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=95e89835d488491109a897a2cad55d97)


# スライスいろいろ

[slice - Rust](https://doc.rust-lang.org/std/primitive.slice.html)

```rust
// 長さ8の10で初期化されたi32のスライス
let mut x = [10_i32 ; 8];
```
これはsliceじゃなくてarrayだ。
[array - Rust](https://doc.rust-lang.org/std/primitive.array.html)


# Cargo.tomlの書式

- [The Manifest Format - The Cargo Book](https://doc.rust-lang.org/cargo/reference/manifest.html)
- [cargo metadata - The Cargo Book](https://doc.rust-lang.org/cargo/commands/cargo-metadata.html)

# バージョンを表示する

Cargo.tomlに書いたnameやversionを表示するにはこんな感じ。

```rust
fn main() {
    const VERSION: &'static str = env!("CARGO_PKG_VERSION");
    const PROCNAME: &'static str = env!("CARGO_PKG_NAME");
    println!("{} v{}", PROCNAME, VERSION);
}
```
キモはstd::env!マクロ。
コンパイル時に環境変数の値を取得できる。

```rust
    println!("{} v{}", env!("CARGO_PKG_NAME"), env!("CARGO_PKG_VERSION"));
```
でもいい。


- [How can a Rust program access metadata from its Cargo package? - Stack Overflow](https://stackoverflow.com/questions/27840394/how-can-a-rust-program-access-metadata-from-its-cargo-package)
- [Environment Variables - The Cargo Book](https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-sets-for-crates)
- [std::env - Rust](https://doc.rust-lang.org/std/macro.env.html)
- [crate コンパイル時に crate のバージョン文字列を得る - Qiita](https://qiita.com/uasi/items/a9dd5af3cc923496118a)

# rls (Rust Language Server)

```
$ rls
error: 'rls' is not installed for the toolchain 'stable-x86_64-unknown-linux-gnu'
To install, run `rustup component add rls --toolchain stable-x86_64-unknown-linux-gnu`

$ rustup component add rls --toolchain stable-x86_64-unknown-linux-gnu
info: downloading component 'rls'
info: installing component 'rls'
info: Defaulting to 500.0 MiB unpack ram
  7.9 MiB /   7.9 MiB (100 %)   5.6 MiB/s in  1s ETA:  0s

$ rls -V
rls 1.41.0 (dd341d5 2020-06-30)
```

# rustfmt

Linuxの場合
```sh
mkdir -p "$HOME/.config/rustfmt"
echo 'edition = "2018"' >> "$HOME/.config/rustfmt/rustfmt.toml"
```

# emacsでRust

rustic (+lsp　or eglot) + rlsがいいらしい。
rustiはEmacs 26以上でないとだめみたい。

- [brotzeit/rustic: Rust development environment for Emacs](https://github.com/brotzeit/rustic)
- [Rust開発環境 on Emacs更新](https://skoji.jp/blog/2020/03/rust-dev.html)


# String <-> &str

- [&str を String に変換する4つの方法 - Qiita](https://qiita.com/uasi/items/3b08a5ba81fede837531)
- [rust String &str の変換と、文字列 数値 の変換 - Qiita](https://qiita.com/smicle/items/29a4d5d1d14ad7f77f60)

String, strの他にも
OsString、OsStr、CString、CStr
がある。

[文字列型 - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch08-02-strings.html)

# RAWテキストの書き方

- [[Rust] 文字列リテラル: エスケープあるいは raw string - Qiita](https://qiita.com/osanshouo/items/59790f5fcd515a0ae559)
- [Rust: Raw string literals - rahul thakoor](https://rahul-thakoor.github.io/rust-raw-string-literals/)

実用的かしらんけど、なんかすごい。

```rust
r#"これ"は引用符"#
```

# Rustのモジュール

わけがわからない。lib.rsってなんでこれいるの?

- [Rustのモジュールの使い方 2018 Edition版 | κeenのHappy Hacκing Blog](https://keens.github.io/blog/2018/12/08/rustnomoju_runotsukaikata_2018_editionhan/)

Goみたいに複数のファイルで1パッケージ、というのはないみたい。
1ファイルnモジュール。Javaっぽい。

# RHEL7にllvm

たまにRustでLLVM要求されるので

- [Hello World - installing Clang/LLVM on RHEL 7 | Red Hat Developer](https://developers.redhat.com/HW/ClangLLVM-RHEL-7)
- [How to Install LLVM on CentOS7 – Linux Hint](https://linuxhint.com/install_llvm_centos7/)
  
とりあえず
```sh
sudo yum install clang llvm-devel
```
でうんと古いのはインストールできる。

# cargo test

print!()を抑制しない(go test の-v)
```sh
cargo test -- --nocapture
```

特定のテストを実行
```sh
cargo test foo
```
fooを含む関数名だけ実行される

# OptionとResult

- [RustのOptionとResult - Qiita](https://qiita.com/take4s5i/items/c890fa66db3f71f41ce7)
- [RustでOption値やResult値を上手に扱う - Qiita](https://qiita.com/tatsuya6502/items/cd41599291e2e5f38a4a)
- 

「unwrap()はpanic!するかもしれない」ことを忘れないこと。
unwrap_or()やunwrap_or_else()が使えるなら使う。


# 型変換イディオム

- [Rust の型変換イディオム - Qiita](https://qiita.com/legokichi/items/0f1c592d46a9aaf9a0ea)
- [競技プログラミングにおけるPythonとRustの対応関係まとめ - Qiita](https://qiita.com/wotsushi/items/4a6797f52080453a0440)

`&[&str] -> Vec<String>`
``` rust
let a = &["a","b","c"];
let b = a.itor().map(|&x| x.to_string()).collect();
// or
let b = a.itor().map(std::string::ToString::to_string).collect();
```

# RustでExcelファイルを作る

- [spsheet - Rust](https://docs.rs/spsheet/0.1.0/spsheet/) - 出来たxlsxやodsが「不正」と表示されて怖くて使えない。
- [xlsxwriter - Rust](https://docs.rs/xlsxwriter/0.3.2/xlsxwriter/) - LLVMを要求される。?の使い方が古いらしくコンパイラが通らない。
- [simple_excel_writer - Rust](https://docs.rs/simple_excel_writer/0.1.7/simple_excel_writer/) - とりあえずまともに動く。

おまけ
- [Rust で Excel オートメーション - Qiita](https://qiita.com/benki/items/de2e104a5866fad0ebab)

# Boxとdyn

- [Box<T>はヒープのデータを指し、既知のサイズである - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch15-01-box.html)
- [Rustで複数のimpl Traitを返す - Qiita](https://qiita.com/taiki-e/items/39688f6c86b919988222)

# print!のフォーマット

[std::fmt - Rust](https://doc.rust-lang.org/std/fmt/)
