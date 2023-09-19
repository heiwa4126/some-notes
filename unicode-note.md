[char - Rust](https://doc.rust-lang.org/std/primitive.char.html)
読んでたら不安になってきたので
UNICODEをまとめてみる.

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
21ビット(いまのところ)。

で、このコードポイントから

- 上位サロゲート(high-surrogates サロゲートペアの前半の2バイト)
- 下位サロゲート(low-surrogates サロゲートペアの後半の2バイト)

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

って書いてあるので、UTF-8には関係がない。

UTF-16(原則2バイト1文字)で、21bitのコードページを表現しようとするから
こんな変なことをしなきゃならない。

えーとつまり、UTF-16は1文字u32というのはウソなわけだ。

内部の文字コードをUTF-16で持ってる言語はJavaと.NETのC#(メジャーなところでは)。

- [Unicodeと、C#での文字列の扱い - Build Insider](https://www.buildinsider.net/language/csharpunicode/02)
- [.NET で文字エンコーディング クラスを使用する方法 | Microsoft Docs](https://docs.microsoft.com/ja-jp/dotnet/standard/base-types/character-encoding)

サロゲートが問題になるケースで、
一文字を固定バイト長にしたいなら
UTF-32を使う。

Rustのcharの実装はおおむねu32. Goのruneはi32(未確認情報)。

JavaScriptはUTF-16
(と、[What every JavaScript developer should know about Unicode](https://dmitripavlutin.com/what-every-javascript-developer-should-know-about-unicode/)に書いてあった)
だそうだけど、エンジンによって異なりそう。

# ウムラウトなど

Unicodeには
動的合成(dynamic composition)があるので、
UTF-32でも1文字4byteとは限らない。

# emoji

[UnicodeのEmojiの一覧 - Wikipedia](https://ja.wikipedia.org/wiki/Unicode%E3%81%AEEmoji%E3%81%AE%E4%B8%80%E8%A6%A7)
