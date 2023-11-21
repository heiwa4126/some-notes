# Putty メモ

パティ [PuTTY: a free SSH and Telnet client](https://www.chiark.greenend.org.uk/~sgtatham/putty/)

## 環境変数 GIT_SSH

しばしば新しい PC で GIT_SSH を設定し忘れるのでメモ。これに plink.exe へのフルパスを設定しておくこと。

[Git - Environment Variables](https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables)

## Git Extensions

これもよく忘れるのでメモ。

[Releases · gitextensions/gitextensions](https://github.com/gitextensions/gitextensions/releases)
で、putty のパスが、
初期値では Git Extensions 同梱のものになってるので、
Git Extensions の設定から自前の putty のに変更しておく。

とはいうもの最近では Windows で標準でついてる ssh & ssh-agent で git するほうが多いんじゃないのか。
(Windows 標準の ssh には `ForwardAgent yes` がないので WSL 使うケースもあるかも)
