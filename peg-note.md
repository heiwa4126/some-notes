# PEG (parsing expression grammar) メモ

## EOD (end of data) に対応するのがめんどくさい

- `test1\ntest2\n` を行単位で処理する文法は簡単だけど
- `test1\ntest2` を行単位で処理する文法はめんどくさい。

parser に渡すとき`\n` を追加するのが一番楽。

0x1A(EOF)を追加するアプローチも考えられるけど、
おすすめしない。
