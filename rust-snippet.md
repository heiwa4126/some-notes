- [Option<&str> -> Option<String>](#optionstr---optionstring)

# Option<&str> -> Option<String>

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
