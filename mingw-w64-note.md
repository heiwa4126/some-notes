# MinGW-w64 のメモ

Windows 11 の上で .c をコンパイルして .exeを作りたかったので
MinGW-w64 を使ってみる。

## インストール

```pwsh
winget install BrechtSanders.WinLibs.POSIX.UCRT
```

WinLibs は make が mingw32-make という名前で入ってる。

- この名前で使う
- エリアス作る
- gitのbashについてるmakeを使う

などで対処。
