# PEG (parsing expression grammar) メモ

## EOD (end of data) に対応するのがめんどくさい

- `test1\ntest2\n` を行単位で処理する文法は簡単だけど
- `test1\ntest2` を行単位で処理する文法はめんどくさい。

parser に渡すとき`\n` を追加するのが一番楽。

0x1A(EOF)を追加するアプローチも考えられるけど、
おすすめしない。

## PEG 内で外部パッケージを使うのが難しい

.pegjs や.peggy ファイル内で import 文や require 文を使う簡単な方法が無い。
難しい方法はある。

一番簡単な解決策は
cli で生成した perser の.mjs の最後に import 文を追加すること。

run-scripts で実行すればいい。
