
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

Compiler Explorerのコツ：
- pubつけないと最適化されて消えてなくなる

参照:
- [Rustのゼロコスト抽象化の効果をアセンブラで確認](https://blog.rust-jp.rs/tatsuya6502/posts/2019-12-zero-cost-abstraction/)
- [Cannot product disassembly file using ```cargo rustc -- --emit asm``` · Issue #8199 · rust-lang/cargo](https://github.com/rust-lang/cargo/issues/8199)
- [assembly - Rustオプティマイザーがこれらの役に立たない命令(Godbolt Compiler Explorerでテスト済み)を削除しないのはなぜですか？ - ITツールウェブ](https://ja.coder.work/so/assembly/504471)
- [C++ オンラインコンパイラ - C++ の歩き方 | CppMap](https://cppmap.github.io/tools/onlinecompilers/)


