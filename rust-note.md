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
- [便利マクロ](#便利マクロ)
- [マクロ展開後のソースを見る](#マクロ展開後のソースを見る)
- [Rustの更新](#rustの更新)
- [Rustのプロジェクトの始め方](#rustのプロジェクトの始め方)
- [型を表示](#型を表示)
- [trait トレイト](#trait-トレイト)
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
- [impl Trait](#impl-trait)
- [print!のフォーマット](#printのフォーマット)
- [traitとcrate](#traitとcrate)
- [pub use](#pub-use)
- [iter](#iter)
- [「スタックは高速です」](#スタックは高速です)
- [構造体に文字列](#構造体に文字列)
- [derive Ordがどう実装されるか知りたい](#derive-ordがどう実装されるか知りたい)
- [into_iter()とiter()](#into_iterとiter)
- [concat!](#concat)
- [cargo clean](#cargo-clean)
- [map!がない](#mapがない)
- [overflow](#overflow)
- [Rustで「普通のenum」](#rustで普通のenum)
- [ライフタイム](#ライフタイム)
- [Rustのデバッグ](#rustのデバッグ)
- [ラムダを返す](#ラムダを返す)
- [traitいろいろ](#traitいろいろ)
- [Cannot move out of X which is behind a shared reference](#cannot-move-out-of-x-which-is-behind-a-shared-reference)
- [Result <-> Option](#result---option)
- [regexメモ](#regexメモ)
- [cargoいろいろ](#cargoいろいろ)
- [いつか役に立つかも](#いつか役に立つかも)
- [macro_use](#macro_use)
- [rustupメモ](#rustupメモ)
- [cargo clippy](#cargo-clippy)
- [rust-src](#rust-src)
- [環境設定(2020-10)](#環境設定2020-10)
  - [emacsでrust-mode + racer](#emacsでrust-mode--racer)
  - [emacsでrustic + rls](#emacsでrustic--rls)
  - [emacsでrust-analizer](#emacsでrust-analizer)
- [vscode上でデバッグする](#vscode上でデバッグする)
- [BufReadとBufReader](#bufreadとbufreader)
- [stdのとき読み込まれるモジュールは](#stdのとき読み込まれるモジュールは)
- [AsRef](#asref)
- [パフォーマンス](#パフォーマンス)
- [「文字列の配列」](#文字列の配列)
- [encodingについてもう少し](#encodingについてもう少し)
  - [用語を整理](#用語を整理)


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

- [Rustのエラー処理 - Qiita](https://qiita.com/fujitayy/items/cafe661415b6aa33d884)


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
- [expect()よりunwrap_or_else()を使うべき場合 - Qiita](https://qiita.com/garkimasera/items/f39d2900f20c90d13259)

# anyhow

- [anyhow - crates.io: Rust Package Registry](https://crates.io/crates/anyhow)
- [anyhow - Rust](https://docs.rs/anyhow/1.0.31/anyhow/)
- [dtolnay/anyhow: Flexible concrete Error type built on std: :Error](https://github.com/dtolnay/anyhow)
- [Rustの便利クレート - Qiita](https://qiita.com/qryxip/items/7c16ab9ef3072c1d7199#anyhow)
- [anyhowの簡単な使い方 - Shinjuku.rs #8 dalance - Speaker Deck](https://speakerdeck.com/dalance/shinjuku-dot-rs-number-8-dalance)


macros:
- [anyhow::anyhow - Rust](https://docs.rs/anyhow/1.0.32/anyhow/macro.anyhow.html)
- [anyhow::bail - Rust](https://docs.rs/anyhow/1.0.32/anyhow/macro.bail.html) - これは便利
- [anyhow::ensure - Rust](https://docs.rs/anyhow/1.0.32/anyhow/macro.ensure.html) - if $cond bail!

anyhowを使いたくなかたら
```rust
fn main() -> Result<(), Box<dyn std::error::Error>> {
```
みたいのもあり。

```rust
use anyhow::Result;
```
してResultすると、どのResultかすぐわからなくなるので、anyhow::Resultと書くことにする。

# 便利マクロ

[Rustの便利マクロ特集 - Qiita](https://qiita.com/elipmoc101/items/f76a47385b2669ec6db3)


# マクロ展開後のソースを見る

- [rust - How do I see the expanded macro code that's causing my compile error? - Stack Overflow](https://stackoverflow.com/questions/28580386/how-do-i-see-the-expanded-macro-code-thats-causing-my-compile-error)
- [dtolnay/cargo-expand: Subcommand to show result of macro expansion](https://github.com/dtolnay/cargo-expand)

> $ rustc -Z unstable-options --pretty=expanded src/main.rs
error: the option `Z` is only accepted on the nightly compiler

ありゃりゃ。

```sh
rustup update nightly
rustup default nightly
cargo install cargo-expand
cargo expand --bin プロジェクトの名前
cargo expand --lib ライブラリの名前
cargo expand -- 関数名
```

...Cloneの実装がひどい。まあ汎用だとこうなるのかな。

[Rustのprintln!の中身 - Qiita](https://qiita.com/4hiziri/items/1aed9e264630f90e3dec)


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


# trait トレイト

インタフェースみたいなもの。

[基本トレイト - あるマのメモ書き](https://yossan.hatenablog.com/entry/2020/08/31/215358)


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
- [How do I convert a &str to a String in Rust?](https://blog.mgattozzi.dev/how-do-i-str-string/)
- [rust String &str の変換と、文字列 数値 の変換 - Qiita](https://qiita.com/smicle/items/29a4d5d1d14ad7f77f60)

String, strの他にも
OsString、OsStr、CString、CStr
がある。

[文字列型 - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch08-02-strings.html)


`impl Into<String>`は面白い。
使い方は [Search · impl Into<String>](https://github.com/search?l=Rust&q=impl+Into%3CString%3E&type=Code)
参照。

このクレートも便利
- [big_s - crates.io: Rust Package Registry](https://crates.io/crates/big_s)

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


# impl Trait

[イテレータを返す関数を書きたいんですけど？ → やめとけ。 死ぬぞ。 - Qiita](https://qiita.com/wada314/items/201ab5d66ac7daeb9c3d)

そこでimpl Traitだ。

[安定化間近！Rustのimpl Traitを今こそ理解する - 簡潔なQ](https://qnighy.hatenablog.com/entry/2018/01/28/220000)


# print!のフォーマット

[std::fmt - Rust](https://doc.rust-lang.org/std/fmt/)

# traitとcrate

> 注釈: 違いはあるものの、トレイトは他の言語でよくインターフェイスと呼ばれる機能に類似しています。

- [トレイト：共通の振る舞いを定義する - The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/ch10-02-traits.html)
- [オブジェクト指向経験者のためのRust入門 - Qiita](https://qiita.com/nacika_ins/items/cf3782bd371da79def74)
- [trait - Rust](https://doc.rust-lang.org/std/keyword.trait.html)

クレートの方はモジュールとかパッケージとかでおおむねいいのかな。
これがまた微妙で...

[Rustのcrateとmoduleについて - Kekeの日記](https://www.1915keke.com/entry/2018/11/13/181145)


# pub use

[Rustでファイル分割 - Qiita](https://qiita.com/CreativeGP/items/496556a825486218bdaf)

# iter

- [std::iter::Iterator - Rust](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
- [Rustのイテレータの網羅的かつ大雑把な紹介 - Qiita](https://qiita.com/lo48576/items/34887794c146042aebf1)

iteretorをstructに含めようとするとつらい。


# 「スタックは高速です」

- [所有権とは？ - The Rust Programming Language](https://doc.rust-jp.rs/book/second-edition/ch04-01-what-is-ownership.html)
- [What is Ownership? - The Rust Programming Language](https://doc.rust-lang.org/book/second-edition/ch04-01-what-is-ownership.html)

「スタックは高速です」と書いてあったらしい2nd Editonの原文は
"The second edition of the book is no longer distributed with Rust's documentation."
となってて閲覧できず、カレントバージョンでは「スタックは高速です」にあたる文章がない。

- [What is Ownership? - The Rust Programming Language](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [所有権とは？ - The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/ch04-01-what-is-ownership.html)
-
「スタックは高速です」の意味はおそらくアロケート/でアロケートが早い、ということではないだろうか。

いやでも「ヒープへのデータアクセスは、スタックのデータへのアクセスよりも低速です」って書いてあるな...

ヒープへアクセスするにはポインタ経由だから?


[Box, スタックとヒープ - Rust By Example 日本語版](https://doc.rust-jp.rs/rust-by-example-ja/std/box.html)

> ボックスとは正確にはヒープ上におかれたTの値へのスマートポインタです


# 構造体に文字列

- [Rustの構造体に文字列を持たせるいくつかの方法 - Qiita](https://qiita.com/Kogia_sima/items/6899c5196813cf231054)
- [Idiomatic string parmeter types: &str vs AsRef<str> vs Into<String> - The Rust Programming Language Forum](https://users.rust-lang.org/t/idiomatic-string-parmeter-types-str-vs-asref-str-vs-into-string/7934)


`impl Into<String>`はいい感じ。

- [実践Rust入門 11日目 - HacoLab](https://hacolab.hatenablog.com/entry/2019/07/13/235700)
- [rust - How to accept &str, String and &String in a single function? - Stack Overflow](https://stackoverflow.com/questions/55079070/how-to-accept-str-string-and-string-in-a-single-function)
- [引数でのimpl とジェネリクスの違い - Qiita](https://qiita.com/kawadumax/items/580807d3f20ddd76725f)

# derive Ordがどう実装されるか知りたい

(todo)

[タイプのOrdの実装は厄介ですか?](https://www.366service.com/jp/qa/2af89d26e6b845e375e66880c037c79a)


# into_iter()とiter()

- [Vec< Option< T>>をオプション< Vec< T>に変換するにはどうすればよいですか](https://www.366service.com/jp/qa/04f7eb9483f2bf6fe0ace72802ce9770)
- [iter()とinto_iter()の違いとちょっとした落とし穴 - Qiita](https://qiita.com/harvath/items/b79eaf61e73e79e3fc0f)
- [iter()とinto_iter()の違いを整理した - さんちゃのblog](https://dawn.hateblo.jp/entry/2017/07/24/165933)
- [iterとinto_iterの違いは何ですか？](https://qastack.jp/programming/34733811/what-is-the-difference-between-iter-and-into-iter)

# concat!

[std::concat - Rust](https://doc.rust-lang.org/std/macro.concat.html)

便利そうだけどリテラルにしか使えない。

# cargo clean

Rustのプロジェクトは、ちっちゃなコードでも500MBとかになるので、
サンプルコードなどをためしにコンパイルしたら
`cargo clean`しておくといいと思う。

こんな感じ。`clean.sh`
```sh
#!/bin/bash -e
cd `dirname $0`
for D in `find . -type f -name Cargo.toml` ; do
    D=`dirname "$D"`; echo "$D"
    pushd "$D" &> /dev/null
    cargo clean
    popd &> /dev/null
done
```

実行例
```
$ du -hs .
1.4G    .

$ ./clean.sh
(略)

$ du -hs .
3.7M    .
```

# map!がない

vec!はあるのにhashmapにはマクロがない。

- [rust - How do I create a HashMap literal? - Stack Overflow](https://stackoverflow.com/questions/27582739/how-do-i-create-a-hashmap-literal)
- [Rustにおける連想配列リテラル・ハッシュリテラル相当 - Qiita](https://qiita.com/qnighy/items/b1d63b1931447758d607)
- [hashmap - HashMapリテラルを作成するにはどうすればよいですか？](https://python5.com/q/zrlajgwn)

これなんかよさそう
- [maplit - Rust](https://docs.rs/maplit/1.0.2/maplit/)


# overflow

これが実行時エラーになるところがすごい(releaseでなければ)。
```rust
fn sub(a: u32, b: u32) -> u32 {
    a - b
}
fn main() {
    println!("{}", sub(1, 2));
}
```

これも。
```rust
fn add(a: i16, b: i16) -> i16 {
    a + b
}
fn main() {
    println!("{}", add(0x7fff, 2));
}
```

releaseだとエラーにならないので注意

# Rustで「普通のenum」

enumを定数列挙に使いたいとき。 ...みんな困ってるんだな。
多分「Rust的に正しくない」。だいたい算術orやandできないし。

古い:
- [rust で数値からenumに変換する - エンジニアですよ！](https://totem3.hatenablog.jp/entry/2015/08/07/222303)
- [rust - How do I match enum values with an integer? - Stack Overflow](https://stackoverflow.com/questions/28028854/how-do-i-match-enum-values-with-an-integer/28029279#28029279)

ここの頭のとこから:
[serde - how can I set an enum value from an integer in rust? - Stack Overflow](https://stackoverflow.com/questions/61641338/how-can-i-set-an-enum-value-from-an-integer-in-rust)


「ふつうのenum」でいいなら
```rust
#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct MyEnum(u16);
impl Clone for MyEnum {
    #[inline]
    fn clone(&self) -> Arch {
        Arch(self.0)
    }
}
```
みたいな実装でよさそう。

# ライフタイム

[Rustの2種類の 'static | 俺とお前とlaysakura](https://laysakura.github.io/2020/05/21/rust-static-lifetime-and-static-bounds/)



# Rustのデバッグ

gdbで普通に。lldbもあれば使える。rust-gdbやrust-lldbを使うとpコマンドが楽になる。

- [Rust のデバッグチートシート - Qiita](https://qiita.com/legokichi/items/e2f807f70316a916f4be)
- [LLDBとかいう次世代高性能デバッガ - Qiita](https://qiita.com/theefool/items/8b985ce71dcdccf26abc)
- [Rustのデバッグ体験を上げるには - verilog書く人](http://segafreder.hatenablog.com/entry/2018/12/13/145210)

# ラムダを返す

[Rust - クロージャーとラムダ式 | rust Tutorial](https://sodocumentation.net/ja/rust/topic/1815/%E3%82%AF%E3%83%AD%E3%83%BC%E3%82%B8%E3%83%A3%E3%83%BC%E3%81%A8%E3%83%A9%E3%83%A0%E3%83%80%E5%BC%8F#----------)

Box::newすればいいのか。

[Rust勉強中 - その20 -> クロージャ - Qiita](https://qiita.com/deta-mamoru/items/85f724cab5412c056cbd)

> moveありなしで所有権の移動、借用が変化するのはクロージャ外の変数のみで


# traitいろいろ

[Rust勉強中 - その19 -> ユーティリティトレイト - Qiita](https://qiita.com/deta-mamoru/items/62f5edebb359d7acd563)


# Cannot move out of X which is behind a shared reference

- [Cannot move out of X which is behind a shared reference - help - The Rust Programming Language Forum](https://users.rust-lang.org/t/cannot-move-out-of-x-which-is-behind-a-shared-reference/33263)
- [rust - Cannot move out of borrowed content / cannot move out of behind a shared reference - Stack Overflow](https://stackoverflow.com/questions/28158738/cannot-move-out-of-borrowed-content-cannot-move-out-of-behind-a-shared-referen)


# Result <-> Option

OptionをResultにする。ok_orとok_or_else

[std::option::Option - Rust](https://doc.rust-lang.org/beta/std/option/enum.Option.html#method.ok_or)

Eにあたるものを返して(Err(E)ではなく)、?でreturnとかできるので(.の連鎖の途中でも)、かっこよく書ける。

- [OptionをResultにする - Qiita](https://qiita.com/nacika_ins/items/3a71dee5bab5a4b17a86)
- [マクロなしでOptionをResultに簡略化する方法はありますか?](https://www.366service.com/jp/qa/93d40e68866da0f680290f8c957619f6)


Resultをoptionにする、のはok()とerr()。

[std::result::Result - Rust](https://doc.rust-lang.org/beta/std/result/enum.Result.html#method.ok)


# regexメモ

- [regex - Rust](https://docs.rs/regex/1.4.1/regex/)
- [正規表現でつかえるパターン](https://docs.rs/regex/1.4.1/regex/#syntax)

perlreのメタクォートエスケープシーケンス(\Q...\E)みたいのはなくて、regex::escapeを使う
([quotemeta - Perldoc Browser](https://perldoc.perl.org/functions/quotemeta)相当)。

例:
```rust
use anyhow::Result;
use regex::{self, Regex};

fn main() -> Result<()> {
    // let re = Regex::new(r#"a.txt"#)?; // wrong
    let re = Regex::new(&regex::escape(r#"a.txt"#))?;
    assert!(re.is_match("baaa.txtx"));
    assert!(!re.is_match("xxxxx.txt"));
    assert!(!re.is_match("a1txt"));
    Ok(())
}
```

マッチは

# cargoいろいろ

[cargo-*系ツールの紹介 - Qiita](https://qiita.com/sinkuu/items/3ea25a942d80fce74a90)

# いつか役に立つかも

[Rust：Cargoでmain.rs以外のソースファイルのmain()関数を実行する - Qiita](https://qiita.com/tatsuya6502/items/7c41dd981ffa56bcab99)

# macro_use

```rust
#[macro_use]
extern crate some_crate;
```
とはなにか。

Rust 2015までのルール。2018では
```
use some::macro;
```
みたいに書ける(はず)。

書き換えられる例ではlazy_static
```rust
use lazy_static::lazy_static;
```
で全然OK。
- [Search · use "lazy_static::lazy_static"](https://github.com/search?l=Rust&q=use+%22lazy_static%3A%3Alazy_static%22&type=code)
- [rust-lang-nursery/lazy-static.rs: A small macro for defining lazy evaluated static variables in Rust.](https://github.com/rust-lang-nursery/lazy-static.rs)

# rustupメモ

コンポーネント一覧
```sh
rustup component list
rustup component list --installed
rustup component list --installed --toolchain nightly
```
意味は見たまんまですね。わかりやすい


# cargo clippy

なぜかcargo cleanしてからでないと
cargo clippyがちゃんと動かない。

clippy便利すぎるのでかならず使うべし。
`rustup component add clippy`で入るし。

- [rust-clippy/README.md at master · Manishearth/rust-clippy · GitHub](https://github.com/Manishearth/rust-clippy/blob/master/README.md)

Cargo.tomlに書いて、debugのときはclippyになるようにする方法:

- [rust - ビルドスクリプトでclippyを実行する簡単な方法はありますか？貨物プロジェクトで](https://stackoverrun.com/ja/q/11414843)
- [Rustのlintライクなツールclippyを使う - Qiita](https://qiita.com/hhatto/items/9415cc5c11b3b201030a)
- [clippy - crates.io: Rust Package Registry](https://crates.io/crates/clippy/0.0.94)

Cargo.tomlに追加
```ini
[build-dependencies]
clippy = { version = "*", optional = true }
```

main.rs と lib.rsのあたまに (実際はbinary crateならmain.rsに...でいいらしい)
```rust
#![cfg_attr(feature="clippy", feature(plugin))]
#![cfg_attr(feature="clippy", plugin(clippy))]
```
を書いとく。

これで安心。


# rust-src

- [Can't find `/src/rust/src` after running `rust-src` · Issue #2522 · rust-lang/rustup](https://github.com/rust-lang/rustup/issues/2522)

つうわけで
```sh
rustup component add rust-src
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library
```
が正しいです(2020-10-16)。勝手に変えるな、


# 環境設定(2020-10)

こんなかんじか?
```sh
# ↓linuxの場合
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# インストール後
rustup toolchain add nightly
rustup update
rustup component add rust-analysis rust-src rls clippy
export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library
cargo +nightly install racer
```

cargo-expandは便利かもしれない。
```sh
cargo +nightly install cargo-expand
```

RUST_SRC_PATHは展開後の値と
```
source $HOME/.cargo/env
```
を
.xxx_profileに書いとく。

ただこれやると~/.cargo ~/.rustupの下、合わせて3GBぐらいになるのが辛い。

参考:
- [Rustエディタ - Qiita](https://qiita.com/geek_777/items/5eb25ce0d12fc81a8f60)
- [racer-rust/racer: Rust Code Completion utility](https://github.com/racer-rust/racer)
- [rust-lang/rls: Repository for the Rust Language Server (aka RLS)](https://github.com/rust-lang/rls)
- [rust-lang/rust-clippy: A bunch of lints to catch common mistakes and improve your Rust code](https://github.com/rust-lang/rust-clippy#usage)


## emacsでrust-mode + racer

[Rustの開発環境を整える(Windows, Emacs) - magのOSS備忘録](http://boiled-mag.hatenablog.jp/entry/2017/08/15/150224)

```
M-x package-refresh-contents
M-x package-install RET ... RET
M-x package-autoremove
```

パッケージをいれる。

- cargo
- racer
- company
- flycheck-rust
- cargo-mode (やめた)

おまけ

- rainbow-delimiters-mode
- smartparens-mode

で
``` lisp
;;
;; rust - rust-mode + racer
;;
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
(with-eval-after-load 'racer
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)
  (define-key racer-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (define-key racer-mode-map (kbd "C-c C-d") #'racer-describe)
  (setq company-tooltip-align-annotations t)
  )
(with-eval-after-load 'rust-mode
  (add-hook 'rust-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'rust-mode-hook #'smartparens-mode)
  ;(add-hook 'rust-mode-hook #'cargo-minor-mode)
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (setq-default rust-format-on-save t)
  (define-key rust-mode-map (kbd "C-c C-r") #'rust-run)
  (define-key rust-mode-map (kbd "C-c C-t") #'rust-test)
  (define-key rust-mode-map (kbd "C-c C-c") #'rust-run-clippy)
  )
```
GNU Emacs 27.1で試した(emacsはsnapで入れた)。
lsp (rls,rust-analyzer)よりはサクサク動くのがよい。

racerのキーバインドは
[GitHub - racer-rust/emacs-racer: Racer support for Emacs](https://github.com/racer-rust/emacs-racer)
に親切に書いてある。

cargo modeのキーバインドは:
 * C-c C-c C-e - cargo-process-bench
 * C-c C-c C-b - cargo-process-build
 * C-c C-c C-l - cargo-process-clean
 * C-c C-c C-d - cargo-process-doc
 * C-c C-c C-v - cargo-process-doc-open
 * C-c C-c C-n - cargo-process-new
 * C-c C-c C-i - cargo-process-init
 * C-c C-c C-r - cargo-process-run
 * C-c C-c C-x - cargo-process-run-example
 * C-c C-c C-s - cargo-process-search
 * C-c C-c C-t - cargo-process-test
 * C-c C-c C-u - cargo-process-update
 * C-c C-c C-c - cargo-process-repeat
 * C-c C-c C-f - cargo-process-current-test
 * C-c C-c C-o - cargo-process-current-file-tests
 * C-c C-c C-O - cargo-process-outdated
 * C-c C-c C-m - cargo-process-fmt
 * C-c C-c C-k - cargo-process-check
 * C-c C-c C-K - cargo-process-clippy (Kが大文字)
 * C-c C-c C-a - cargo-process-add
 * C-c C-c C-D - cargo-process-rm
 * C-c C-c C-U - cargo-process-upgrade
 * C-c C-c C-A - cargo-process-audit

たぶんこんなにいらない。
cargo-modeはコメントアウトした or remove。
上↑で定義したキーバインドが不足だったら考える。


## emacsでrustic + rls

racerと比べて重い。なぜかAPIの補完してくれない。調べ中

- [brotzeit/rustic: Rust development environment for Emacs](https://github.com/brotzeit/rustic)

rlsのほうがエラーが的確でいい。でもAPIのcompletionがどーしてもできない。
rust-analizerにすると、APIのcompletionもできるけど、重い。

両方入れといてM-x rustic-mode で切り替えるとか。

## emacsでrust-analizer

- [rust-analyzer/rust-analyzer: An experimental Rust compiler front-end for IDEs](https://github.com/rust-analyzer/rust-analyzer)
- [User Manual](https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary)

バイナリおとしたら動かなかったので、ソースからビルドした。
ものすごく時間かかった。

APIのcode completeもちゃんとやってくれるけど、rlsと比べると重い。


# vscode上でデバッグする

rustのextentionだけだとデバッグできない。
CodeLLDB (よくわかってない)を入れる。

- [How to Debug Rust with Visual Studio Code](https://www.forrestthewoods.com/blog/how-to-debug-rust-with-visual-studio-code/)
- [Rust IDE に化ける VSCode - OPTiM TECH BLOG](https://tech-blog.optim.co.jp/entry/2019/07/18/173000)




# BufReadとBufReader

なんで2つあるの?

- [[Rust] Read と BufRead の違い - Qiita](https://qiita.com/osanshouo/items/1cf8175e1430c64372d1)
- [std::io::Read - Rust](https://doc.rust-lang.org/std/io/trait.Read.html) - これはtrait
- [std::io::BufRead - Rust](https://doc.rust-lang.org/std/io/trait.BufRead.html) - これもtrait
- [std::io::BufReader - Rust](https://doc.rust-lang.org/std/io/struct.BufReader.html) - structure

structreでimplされていないtraitのデフォルト実装を使うには、
traitもuseしないといけないらしい?


# stdのとき読み込まれるモジュールは

ずばりこれです。
[std::prelude - Rust](https://doc.rust-lang.org/std/prelude/index.html#prelude-contents)


# AsRef

関数に、Stringの参照が、スライスとして渡せるのは
[Trait std::convert::AsRef](https://doc.rust-lang.org/std/convert/trait.AsRef.html)
がimplされてるから。

[string.rs.html -- source](https://doc.rust-lang.org/src/alloc/string.rs.html#2248-2253) (リンク先は変わるかも)
```rust
#[stable(feature = "rust1", since = "1.0.0")]
impl AsRef<str> for String {
    #[inline]
    fn as_ref(&self) -> &str {
        self
    }
}
```

あと `&[T]`を引数にとる関数に、`Vec<T>`の参照を渡せるのも
`impl<T> AsRef<[T]> for Vec<T>`がimplされてるから。

[vec.rs.html -- source](https://doc.rust-lang.org/src/alloc/vec.rs.html#2483-2487)  (リンク先は変わるかも)
```rsut
#[stable(feature = "rust1", since = "1.0.0")]
impl<T> AsRef<[T]> for Vec<T> {
    fn as_ref(&self) -> &[T] {
        self
    }
}
```

サンプル: [Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=461a3d3a4096ab7e0c1e5640c730b85f)
```rust
fn vs(sl: &[&str]) {
    println!("{:?}", sl);

}
pub fn main() {
    let s1 = &["hello","world"];
    let v1 = vec!["goodbye","cruel","world"];

    vs(s1);
    vs(&v1);
}
```

# パフォーマンス

[【翻訳】Rustにおけるパフォーマンスの落とし穴 - Read -> Blog](https://codom.hatenablog.com/entry/2017/06/03/221318)

# 「文字列の配列」

関数の引数・戻り値によくあるのが「文字列の配列」 だけど、

- `Vec<String>`
- `Vec<&str>`
- `&[String]`
- `&[&str]`

の4パターンがありうる。

戻り値にスライスが使えるのは引数の一部を返すときだけなので、
大抵の場合 `f(..) -> Vec<U>`になる。

`Vec<T>` -> `&[T]`は超簡単なので、
引数はスライスがいい。
(`f(x:&[T]) -> Vec<U>`)。

同じ理由で`String`->`&str`も簡単なので
`f(x:&[&str]) -> Vec<String> {...}`
みたいな感じ?

となると
`Vec<String> -> Vec<&str>`
は要る。

```rust
fn like_this(v: &[String]) -> Vec<&str> {
    v.iter().map(AsRef::as_ref).collect()
}
```
こんなので。

> イミュータブルな場合、スライスとVecの違いはcapacityメソッドがあるかどうかだけです

[Rustを覚えて間もない頃にやってしまいがちなこと - Qiita](https://qiita.com/mosh/items/709effc9e451b9b8a5f4)

# encodingについてもう少し

文字コード変換のメジャーなクレートは2種類?

- [lifthrasiir/rust-encoding: Character encoding support for Rust](https://github.com/lifthrasiir/rust-encoding)
- [hsivonen/encoding_rs: A Gecko-oriented implementation of the Encoding Standard in Rust](https://github.com/hsivonen/encoding_rs)

- [Encoding - Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/encoding.html)

## 用語を整理

- decode - byte列を、コーディングを指定してRustの内部表現に変換
- encode - Rustの内部表現を、コーディングを指定してbyte列に

byte列のところをioにしたものがstreaming。
