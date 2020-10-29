- [`Option<&str> -> Option<String>`](#optionstr---optionstring)
- [&str -> std::fs::Read](#str---stdfsread)
- [メモリ上ファイル](#メモリ上ファイル)
- [`String <-> Vec<char>`](#string---vecchar)

# `Option<&str> -> Option<String>`

(OptionでもResultでも同じでいける)

```rust
fn c1(x: Option<&str>) -> Option<String> {
    match x {
        None => None,
        Some(s) => Some(s.into()),
    }
}
```
こういうこと↑をやりたい。
(intoのとこはto_stringとかto_ownedとかString::fromとか)


```rust
    // x.map_or(None, |s| Some(s.into()))
    // x.and_then(|s| Some(s.into()))
    // x.map(|s| s.into())
    x.map(String::from)
```
map()を使うのが一番簡単。場合によってはコメントアウトされたとこを応用。

- [std::option::Option - Rust](https://doc.rust-lang.org/std/option/enum.Option.html#method.map)
- [std::result::Result - Rust](https://doc.rust-lang.org/std/result/enum.Result.html#method.map)


# &str -> std::fs::Read

テストとかで、文字列をファイルに見せかけるような場合。

[Rustでバイト列を扱う時のtips | κeenのHappy Hacκing Blog](https://keens.github.io/blog/2016/12/01/rustdebaitoretsuwoatsukautokinotips/)

> 私には割と衝撃だったのですが&[u8]や&mut [u8]、Vec<u8>は直接ReadやWriteのインスタンスになってます。

なので、こういうことができる。
```rust
use std::fs::File;
use std::io::{BufRead, BufReader, Read};

fn read_per_line<T: Read>(r: T) -> anyhow::Result<()> {
    let rb = BufReader::new(r);
    for line in rb.lines() {
        println!("{}", line?)
    }
    Ok(())
}

fn main() -> anyhow::Result<()> {
    // ファイルから(read_per_line()のテスト)
    let r = File::open("./test/test.txt")?;
    read_per_line(r)?;

    // strでもStringでもas_bytes()
    let r = "Hello\nworld!".as_bytes();
    read_per_line(r)?;

    // いきなりbyte列でも
    let r = b"Hello\nworld!";
    read_per_line(r)?;

    Ok(())
}
```

# メモリ上ファイル

これもテストとかで使う。

Stringは
[std::fmt::Write](https://doc.rust-lang.org/std/fmt/trait.Write.html)
をimplしてるのでwrite!で使えるけれど、
これは[std::io::Write](https://doc.rust-lang.org/std/io/trait.Write.html)ではないので
ファイル代わりに渡せない。

`Cursor<Vec<u8>>`ならできる。


```rust
use std::fs::File;
use std::io::{Cursor, Write};

// ここ↓のWriteはstd::io::Write
fn write_some_lines<T: Write>(mut w: T) -> anyhow::Result<()> {
    write!(w, "hello")?;
    write!(w, " world")?;
    Ok(())
}

fn main() -> anyhow::Result<()> {
    // ふつうのファイルでテスト
    let w = File::create("./tmp/hello.txt")?;
    write_some_lines(w)?;

    // メモリ上でテスト
    let mut c: Cursor<Vec<u8>> = Cursor::new(Vec::new());
    write_some_lines(&mut c)?;
    let s = String::from_utf8(c.into_inner())?;　// from_utf8_lossy()もあるよ
    println!("{}", s); // -> hello world

    Ok(())
}
```
ちょっとめんどくさい。

参考:
- [How to create an in-memory object that can be used as a Reader, Writer, or Seek in Rust? - Stack Overflow](https://stackoverflow.com/questions/41069865/how-to-create-an-in-memory-object-that-can-be-used-as-a-reader-writer-or-seek)
- [バイトのベクトル（u8）を文字列に変換する方法](https://qastack.jp/programming/19076719/how-do-i-convert-a-vector-of-bytes-u8-to-a-string)
- GitHub上の使用例: [Search · rust Cursor String::from_utf8 into_inner](https://github.com/search?l=Rust&q=rust+Cursor+String%3A%3Afrom_utf8+into_inner&type=Code)


# `String <-> Vec<char>`

文字列を逆順にする例

```rust
fn reverse_string(s: &str) -> String {
    let mut c: Vec<char> = s.chars().collect();
    c.reverse();
    c.into_iter().collect()
}

fn main() {
    println!("{}", reverse_string("こんにちは"));
}
```

参考:
[string — Vec <char>を文字列に変換する方法](https://www.it-swarm-ja.tech/ja/string/vec-ltchargt%E3%82%92%E6%96%87%E5%AD%97%E5%88%97%E3%81%AB%E5%A4%89%E6%8F%9B%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/1046103135/)

[Trait std::iter::FromIterator](https://doc.rust-lang.org/std/iter/trait.FromIterator.html)を使う例、iter()とinto_iter()のちがいが載ってます↑。