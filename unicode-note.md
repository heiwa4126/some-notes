[char - Rust](https://doc.rust-lang.org/std/primitive.char.html)
読んでたら不安になってきたので
UNICODE をまとめてみる.

# 参考

- [Unicode](https://seiai.ed.jp/sys/text/csd/cf14/c14a070.html)
- [Glossary](http://www.unicode.org/glossary/)
- [サロゲート](http://exlight.net/devel/unicode/surrogate.html)
- [Unicode文字のマッピング - Wikipedia](https://ja.wikipedia.org/wiki/Unicode%E6%96%87%E5%AD%97%E3%81%AE%E3%83%9E%E3%83%83%E3%83%94%E3%83%B3%E3%82%B0)

# 「ユニコードスカラー値」と「コードポイント」

まず、
`U+0000`とか書いてあるアレが「コードポイント」
[code point - Glossary](http://www.unicode.org/glossary/#code_point)
。
範囲は
0 から 0x10FFFF
の
21 ビット(いまのところ)。

で、このコードポイントから

- 上位サロゲート(high-surrogates サロゲートペアの前半の 2 バイト)
- 下位サロゲート(low-surrogates サロゲートペアの後半の 2 バイト)

を除いたものが
「ユニコードスカラー値」
[unicode scalar value - Glossary](http://www.unicode.org/glossary/#unicode_scalar_value)
。

`U+0000`とか書いてあるアレが「ユニコードスカラー値」。[unicode scalar value - Glossary](http://www.unicode.org/glossary/#unicode_scalar_value)

範囲は
0 から 0x7FF
と
0xE000 から 10FFFF
。

# サロゲートペアはなんのためにあるの?

- [Glossary](http://www.unicode.org/glossary/#surrogate_pair)
- [3.8 Surrogates - The Unicode Standard, Version 13.0](http://www.unicode.org/versions/Unicode13.0.0/ch03.pdf#G2630)

> Surrogate pairs are used only in UTF-16.

って書いてあるので、UTF-8 には関係がない。

UTF-16(原則 2 バイト 1 文字)で、21bit のコードページを表現しようとするから
こんな変なことをしなきゃならない。

えーとつまり、UTF-16 は 1 文字 u32 というのはウソなわけだ。

内部の文字コードを UTF-16 で持ってる言語は Java と.NET の C#(メジャーなところでは)。

- [Unicodeと、C#での文字列の扱い - Build Insider](https://www.buildinsider.net/language/csharpunicode/02)
- [.NET で文字エンコーディング クラスを使用する方法 | Microsoft Docs](https://docs.microsoft.com/ja-jp/dotnet/standard/base-types/character-encoding)

サロゲートが問題になるケースで、
一文字を固定バイト長にしたいなら
UTF-32 を使う。

Rust の char の実装はおおむね u32. Go の rune は i32(未確認情報)。

JavaScript は UTF-16
(と、[What every JavaScript developer should know about Unicode](https://dmitripavlutin.com/what-every-javascript-developer-should-know-about-unicode/)に書いてあった)
だそうだけど、エンジンによって異なりそう。

# ウムラウトなど

Unicode には
動的合成(dynamic composition)があるので、
UTF-32 でも 1 文字 4byte とは限らない。

# emoji

[UnicodeのEmojiの一覧 - Wikipedia](https://ja.wikipedia.org/wiki/Unicode%E3%81%AEEmoji%E3%81%AE%E4%B8%80%E8%A6%A7)
