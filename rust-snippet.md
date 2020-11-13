- [`Option<&str> -> Option<String>`](#optionstr---optionstring)
- [&str -> std::fs::Read](#str---stdfsread)
- [メモリ上ファイル](#メモリ上ファイル)
- [`String <-> Vec<char>`](#string---vecchar)
- [sliceでindex(),rindex()](#sliceでindexrindex)
- [非UTF-8のCSVを読む](#非utf-8のcsvを読む)
  - [他の方法](#他の方法)
  - [How to write a non-UTF8 encoded csv file?](#how-to-write-a-non-utf8-encoded-csv-file)
- [mutable slice](#mutable-slice)
- [長さを指定して&strを作る](#長さを指定してstrを作る)
- [IBMをHALにする](#ibmをhalにする)
- [Resultを返すIterator](#resultを返すiterator)
- [structureの一部をcloneせずに取り出す。](#structureの一部をcloneせずに取り出す)

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

文字列を逆順にする例: [Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=c2eb571e17ae29e30b19c47d7b55cb8f)

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

# sliceでindex(),rindex()

strにはfind,rfindがある。

- [method.find - Rust](https://doc.rust-lang.org/std/primitive.str.html#method.find)

slice一般にはposition,rpositionがある。

- [method.position - std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.position)
- [method.rposition - std::iter::Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.rposition)

`[u8]`から探す例。 [Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2015&gist=20c53bc660ef4d00841e44e6fb050b70)

```rust
fn main(){
    let b = b"Hello, world!";
    let i0 = b.iter().position(|&x| x == b'o');
    let i1 = b.iter().rposition(|&x| x == b'o');
    let i2 = b[..8].iter().rposition(|&x| x == b'o');
    println!("{:?},{:?},{:?}", i0, i1, i2);
}
```

こういうのも
[memchr - Rust](https://docs.rs/memchr/2.3.4/memchr/)
u8しか探せないけど早い(らしい)。

# 非UTF-8のCSVを読む

超ありそうな話。

参考:
- [character encoding - How to read a non-UTF8 encoded csv file? - Stack Overflow](https://stackoverflow.com/questions/53826986/how-to-read-a-non-utf8-encoded-csv-file)
- [csv - UTF8以外でエンコードされたcsvファイルを読み取る方法は？ - ITツールウェブ](https://ja.ojit.com/so/csv/2747577) - ↑の自動翻訳
- [character encoding - UTF8でエンコードされていないcsvファイルを読み取る方法 - 初心者向けチュートリアル](https://tutorialmore.com/questions-2197244.htm) - これも↑↑の自動翻訳
- [encoding_rs_io::DecodeReaderBytesBuilder - Rust](https://docs.rs/encoding_rs_io/0.1.4/encoding_rs_io/struct.DecodeReaderBytesBuilder.html)
- [Search · DecodeReaderBytesBuilder language:Rust](https://github.com/search?q=DecodeReaderBytesBuilder+language%3ARust&type=Code&ref=advsearch&l=Rust&l=) - GitHub上でもあんまり使われてない感じ... 新しいAPIとか??

`encoding_rs::SHIFT_JIS`で検索するとけっこう出てくるので、
「透過的に読もう/書こう」とする人がすくないのかもしれない。

さすがに長くなったのでレポジトリつくった。

[csv::StringRecord - Rust](https://docs.rs/csv/1.1.3/csv/struct.StringRecord.html)
を参照。

## 他の方法

- [CSV processing - Rust Cookbook](https://rust-lang-nursery.github.io/rust-cookbook/encoding/csv.html#read-csv-records)
- [csv::tutorial - Rust](https://docs.rs/csv/1.0.0/csv/tutorial/index.html)

Serde を使うといけそう。
[serde-rs/serde: Serialization framework for Rust](https://github.com/serde-rs/serde)

## How to write a non-UTF8 encoded csv file?

わがらん。
goだと簡単なんだけど。
encoding_rs_ioにWriterがあれば。

# mutable slice

> Slices are either mutable or shared.

と書いてあるので出来るはず(**意味あるかどうかは別として**)。

- [std::slice - Rust](https://doc.rust-lang.org/std/slice/index.html)
- [primitive slice - Rust](https://doc.rust-lang.org/std/primitive.slice.html)

`std::slice`の先頭に載ってるサンプルと
`primitive slice`の先頭に載ってるサンプルが
違う。

[Rust Playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=cbbc97ccc497d662193a72d9529972ca)
```rust
fn type_of<T>(_: T) -> &'static str {
    std::any::type_name::<T>()
}

fn main() {
    // example from [std::slice - Rust](https://doc.rust-lang.org/std/slice/index.html)
    let x = &mut [1, 2, 3]; // mutable array, not mutable slice
    x[1] = 7;
    println!("x = {:?}", x);
    println!("x = {}", type_of(x));

    // example from [slice - Rust](https://doc.rust-lang.org/std/primitive.slice.html)
    let mut x = [1, 2, 3];
    let x = &mut x[..]; // Take a full slice of `x`.
    x[1] = 7;
    println!("x = {:?}", x);
    println!("x = {}", type_of(x));
}
```
primitiveの方のサンプルでmutableなsliceが作れる。

実行結果
```
x = [1, 7, 3]
x = &mut [i32; 3]
x = [1, 7, 3]
x = &mut [i32]
```
std::strの方はarrayのref



# 長さを指定して&strを作る

`&str`は`&[u8]`なんだから (もうこの時点で間違い)
```rust
let buf: &mut str = &mut [0u8; BUF_SIZE];
```
とかできそうな気がするけどコンパイルできない。

```rust
let buf = &mut [0u8; BUF_SIZE];
let mut buf = std::str::from_utf8_mut(buf).unwrap();
```
みたいにしないとできない。なんだか効率が悪そう。

# IBMをHALにする

"あいうえお"
も
"ぁぃぅぇぉ"
になる。

```rust
let s = "IBM";

let s = s
    .chars()
    .map(|x| std::char::from_u32((x as u32) - 1).unwrap())
    .collect::<String>();

println!("{:?}", s);
```

これいきなり思いつけるひとがいたら天才。


# Resultを返すIterator

[パフォーマンス比較：ループVSイテレータ - The Rust Programming Language 日本語版](https://doc.rust-jp.rs/book-ja/ch13-04-performance.html)
によると、ループを使わないほうが早いらしい。
でもResultを返すiteratorだと`?`演算子が使えなくなるよね?(たとえばBufRead::lines()) という話。

そもそもiter()って中断できるの?

参考:
- [ResultやOptionが要素型の場合のiteratorの捌き方 - Qiita](https://qiita.com/knknkn1162/items/d411d6a127ece8020811) - errをハンドルしてない。panic!してるだけ
- [Iterating over Results - Rust By Example](https://doc.rust-lang.org/stable/rust-by-example/error/iter_result.html)
- [Rewrite help: imperative -> functional style - The Rust Programming Language Forum](https://users.rust-lang.org/t/rewrite-help-imperative-functional-style/28614)
- [rust - How do I stop iteration and return an error when Iterator::map returns a Result::Err? - Stack Overflow](https://stackoverflow.com/questions/26368288/how-do-i-stop-iteration-and-return-an-error-when-iteratormap-returns-a-result)


# structureの一部をcloneせずに取り出す。

[std::mem::take](https://doc.rust-lang.org/std/mem/fn.take.html)を使うと、
&mutを受けてデフォルト値と置き換えることができる。

```rust
use std::mem;

#[derive(Debug)]
struct MCU {
    film: String,
    year: u32, // release year
}
impl MCU {
    fn new(film: &str, year: u32) -> MCU {
        MCU {
            film: String::from(film),
            year,
        }
    }
}

fn main() {
    // このリストから製作年でソートされたタイトルのVecを得たい。
    let mut l1 = vec![
        MCU::new("Captain Marvel", 2019),
        MCU::new("Guardians of the Galaxy", 2014),
        MCU::new("The Incredible Hulk", 2008),
        MCU::new("Thor", 2011),
    ];
    l1.sort_by(|a, b| a.year.cmp(&b.year));

    // let l1 = l1.iter().map(|f| f.film.clone()).collect::<Vec<String>>();
    // ↑期待通りに動くけど、Stringをcloneしたくない!
    // ↓takeを使う。
    let l1 = l1
        .iter_mut()
        .map(|f| mem::take(&mut f.film))
      .collect::<Vec<String>>();
    // 結果表示
    println!("{:?}", &l1);
```

Stringをclone()するコストより、String::new()のほうがコストが低いだろう、という予測

