# Rustメモ

Rustって深いよね(皮肉)。


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