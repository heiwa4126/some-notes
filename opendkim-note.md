# OpenDKIM のメモ

## 【超重要】OpenDKIM の keyTable は1レコード1行で書かなきゃならない

この1レコードが長い。

OpenDKIM が内部で使うdbライブラリ(Berkeley DBなど)が「1キー = 1レコード」を前提としており、改行をレコードの区切りとして扱う。

なんかスクリプト作ったほうがいいかもしれない。

## DKIM canonicalization

```conf
Canonicalization  relaxed/simple
# ↑これは厳しすぎるので
# ↓これぐらいで
Canonicalization  relaxed/relaxed
```
