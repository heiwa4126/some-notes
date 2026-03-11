# apg メモ

超ふるいパスワード生成CLIツール

## 4桁PINを10個

```console
$ apg -a 1 -M N -m 4 -x 4 -n 10

8621
0357
3886
6821
3613
5301
7330
5706
7702
3294
```

## よくある「英大文字小文字数字記号が1個以上ある長さ8文字から16字のランダムな文字列」10個

```console
$ apg -a 1 -M SNCL -m 8 -x 16 -n 10

=*G2\y?j
Q2f&s-pJD&AG:-
IT1B<ss7@C^=a.}
EFDLg|5+ls7*a{i%
YzOAa/87rFoe4
J8C"iUX=fJ9HCo
dS3McJ.g\F.a(
}[fD=^9@kg(}
=EFkbD4{
`nWazsC"l2
```

「ただし記号は1個だけ」というのは指定できないので

# help (`apg -h`)

```text

apg   Automated Password Generator
        Copyright (c) Adel I. Mirzazhanov

apg   [-a algorithm] [-r file]
      [-M mode] [-E char_string] [-n num_of_pass] [-m min_pass_len]
      [-x max_pass_len] [-c cl_seed] [-d] [-s] [-h] [-y] [-q]

-M mode         new style password modes
-E char_string  exclude characters from password generation process
-r file         apply dictionary check against file
-b filter_file  apply bloom filter check against filter_file
                (filter_file should be created with apgbfm(1) utility)
-p substr_len   paranoid modifier for bloom filter check
-a algorithm    choose algorithm
                 1 - random password generation according to
                     password modes
                 0 - pronounceable password generation
-n num_of_pass  generate num_of_pass passwords
-m min_pass_len minimum password length
-x max_pass_len maximum password length
-s              ask user for a random seed for password
                generation
-c cl_seed      use cl_seed as a random seed for password
-d              do NOT use any delimiters between generated passwords
-l              spell generated password
-t              print pronunciation for generated pronounceable password
-y              print crypted passwords
-q              quiet mode (do not print warnings)
-h              print this help screen
-v              print version information
```

## apg 超ふるいので代替

Ubuntu の `apt show apg` から引用:

> apg has not seen upstream attention since 2003, upstream is not
> answering e-mail, and the upstream web page does not look like it is
> in good working order. The Debian maintainer plans to discontinue apg
> maintenance as soon as an actually maintained software with a
> compariable feature set becomes available.

### apg-go

- [wneessen/apg-go: 🔒 A modern "Automated Password Generator"-clone written in Go](https://github.com/wneessen/apg-go)

- apgと同じオプションで使える
- そこそこ活発
- `go get` でGoLangのモジュールとしても使える

例:

```sh
apg-go -a 1 -M SNCL -m 8 -x 16 -n 10
```

### pwgen

- [jbernard/pwgen: Generate pronounceable passwords](https://github.com/jbernard/pwgen)
- [pwgen(1): make pronounceable passwords - Linux man page](https://linux.die.net/man/1/pwgen)

- `sudo apt install pwgen`
- 順当なおすすめ

```sh
# 10進4桁のランダムな数字を10個
pwgen -1 -s -A -r 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' 4 10

# pwgen を使わないほうが楽
shuf -i 0-9999 -n 10 | sed 's/^/0000/' | sed 's/.*\(....\)$/\1/'

# 英大文字小文字数字記号が1個以上ある長さ8文字から16字のランダムな文字列10個
pwgen -1 -s -c -n -y 16 10

# 「長さ8文字から16字の」はできないので
# こんな感じで "長さ8文字から16字の" を実現
for i in $(seq 10); do
  L=$(shuf -i 8-16 -n 1)
  pwgen -1 -s -c -n -y "$L" 1
done
```
