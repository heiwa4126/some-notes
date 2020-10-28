- [`Option<&str>` -> `Option<String>`](#optionstr---optionstring)
- [&str -> std::fs::Read](#str---stdfsread)

# `Option<&str>` -> `Option<String>`

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
