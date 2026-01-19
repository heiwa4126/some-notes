# cargoでasmを出力

よく見るのは

```sh
cargo rustc --release -- --emit asm
```

だけど、うまくいかない。

```sh
cargo rustc --release -- --emit asm -C 'llvm-args=-x86-asm-syntax=intel'
```

が使える。

ちょっとしたコードの検証には [Compiler Explorer](https://rust.godbolt.org/) が楽。

Compiler Explorer のコツ：

- pub つけないと最適化されて消えてなくなる

参照:

- [Rustのゼロコスト抽象化の効果をアセンブラで確認](https://blog.rust-jp.rs/tatsuya6502/posts/2019-12-zero-cost-abstraction/)
- [Cannot product disassembly file using `cargo rustc -- --emit asm` · Issue #8199 · rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8199)
- [assembly - Rustオプティマイザーがこれらの役に立たない命令(Godbolt Compiler Explorerでテスト済み)を削除しないのはなぜですか？ - ITツールウェブ](https://ja.coder.work/so/assembly/504471)
- [C++ オンラインコンパイラ - C++ の歩き方 | CppMap](https://cppmap.github.io/tools/onlinecompilers/)

# rustのインストールメモ

[rust-lang/rustup: The Rust toolchain installer](https://github.com/rust-lang/rustup)
を使う。

参照: [Other Installation Methods - Rust Forge](https://forge.rust-lang.org/infra/other-installation-methods.html)

Linux だったら

```sh
curl https://sh.rustup.rs -sSf | sh
```

インストールが終わったら

```sh
rustup update
```

バージョンの確認は

```sh
cargo --version
rustc --version
rustdoc --version
rustup --version
```

# Iteratorサンプル

[Rust playground](https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=7108685ed017337a850c0ad212b13039)

```rust
struct Countdown {
    cnt: i32,
}

impl Iterator for Countdown {
    type Item = i32;
    fn next(&mut self) -> Option<i32> {
        if self.cnt < 0 {
            None
        } else {
            self.cnt -= 1;
            Some(self.cnt + 1)
        }
    }
}

fn main() {
    for n in (Countdown { cnt: 9 }) {
        println!("{}", n);
    }
}
```

`Option<i32>`
のところは
`Option<Self::Item>`
でもいいです。

他のサンプル:

- [std::iter - Rust](https://doc.rust-lang.org/std/iter/#implementing-iterator)

# Iteratorで中身を書き換える例

```rust
fn main() {
    let mut a = [1,2,3];
    println!("{:?}", &a);

    for n in a.iter_mut() {
        *n *= 2
    }
    println!("{:?}", &a);
}
```

a はスライスでなくても vec でも同じ。例)

```rust
let mut a = vec![1,2,3];
```

- [slice method.iter_mut - Rust](https://doc.rust-lang.org/std/primitive.slice.html#method.iter_mut)
- [Vec method.iter_mut - Rust](https://doc.rust-lang.org/std/vec/struct.Vec.html#method.iter_mut)

# コアライブラリと標準ライブラリ

core クレート
と
std クレート
があるのか...

- [core - Rust](https://doc.rust-lang.org/core/)
- [std - Rust](https://doc.rust-lang.org/std/)

この違いは
[最小限の#![no_std]プログラム - The Embedonomicon](https://tomoyuki-nakabayashi.github.io/embedonomicon/smallest-no-std.html)
参照。

# write openしたファイルのクローズ

[std::fs::File - Rust](https://doc.rust-lang.org/std/fs/struct.File.html)
close メソッドがない。デストラクタ的に close される。

で、これだと write open したファイルのクローズのエラーがハンドリングできないので、
[std::fs::File - Rust](https://doc.rust-lang.org/std/fs/struct.File.html#method.sync_all)
sync_all()を使う。sync_data()はメタデータは sync されない、んだそうだが、どういうタイミングで使うかよくわからない。

# derive(Debug)とは

- [継承(Derive) - Rust By Example 日本語版](https://doc.rust-jp.rs/rust-by-example-ja/trait/derive.html)
- [std::fmt::Debug - Rust](https://doc.rust-lang.org/std/fmt/trait.Debug.html)

を参照
