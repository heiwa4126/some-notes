# systemdのメモ

- [systemdのメモ](#systemdのメモ)
- [systemctl list-dependencies](#systemctl-list-dependencies)

# systemctl list-dependencies

ユニットを省略すると`default.target`がデフォルト値

- [【Linuxのサービス依存関係と順序関係】systemctl list-dependencies と systemd-analyze の見方 | SEの道標](https://milestone-of-se.nesuke.com/sv-basic/linux-basic/systemctl-list-dependencies/)
- [Systemdのサービスの依存関係を調べる方法 - ククログ(2015-12-28)](https://www.clear-code.com/blog/2015/12/28.html)

`--after`や`--before`をつけないと

> 依存関係を調べてツリー表示できます。 ここでいう依存関係はRequires=やWants=といった、必要となるunitに着目した依存関係です。

> 他に何のUnitを起動する必要があるかを示しています。
> 階層の深さは起動順序とは関係がありません。
> あくまでどのUnitの起動が必要とされているかを示しているに過ぎません

> *.wants というディレクトリの下に SymbolicLink を配置することで依存関係を示すこともできます。これが依存関係を示す方法の2つ目です。(実は WantedBy= に指定すると .wants ディレクトリに SymbolicLinkを作成する動作になるのでそういう意味では同じかもしれません

`--after`や`--before`をつけると

> --beforeを指定するとunitファイルのBefore=ディレクティブをたどって依存関係を表示します。 同様に--afterを指定するとunitファイルのAfter=ディレクティブをたどって依存関係を表示します。

>  (--after) 階層が深いものほど、先に実行されている必要があります。

> (--before) 起動した後に何を起動する必要があるか

`--all (-a)`オプション

> 全ての Unit で再帰的に依存関係を表示する場合は -a を使います


[NetworkTarget](https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/)
```
systemctl list-dependencies network-online.target
```
