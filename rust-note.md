# Rustメモ

Rustって深いよね(皮肉)。

- [Rustメモ](#rustメモ)
- [std::strにiter()がない](#stdstrにiterがない)
- [type(var)みたいの](#typevarみたいの)
- [クレート & カーゴ](#クレート--カーゴ)
- [Rsutは何で「サビ」なの?](#rsutは何でサビなの)
- [testでprintln!](#testでprintln)
- [Rustのエラーハンドリング](#rustのエラーハンドリング)


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

# Rsutは何で「サビ」なの?

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
[Error Handling - A Gentle Introduction to Rust](https://stevedonovan.github.io/rust-gentle-intro/6-error-handling.html)

この辺読む:
- [Rustのエラー処理 - Qiita](https://qiita.com/fujitayy/items/cafe661415b6aa33d884) - failureはもはやメンテされてないらしい
- [std::convert::From - Rust](https://doc.rust-lang.org/std/convert/trait.From.html)
- [From failure to Fehler](https://boats.gitlab.io/blog/post/failure-to-fehler/) - fehlerはドイツ語でエラー
- [Rust のエラーまわりの変遷 - Qiita](https://qiita.com/legokichi/items/d4819f7d464c0d2ce2b8)
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
