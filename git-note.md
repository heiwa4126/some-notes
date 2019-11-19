# gitメモ

# gitの設定をリスト

``` bash
git config -l # 全設定
git config --global -l # globalだけ
git config --local -l # local設定だけ
```

範囲は
1. `--system`
2. `--global`
3. `--local`
4. `--worktree`
5. `--file <filename>`

の5通り。

gitデフォルト値も出るといいなあ(好きな設定をつっこめるので、ちょっとむずかしい)


# symlinkの扱い

[Git - git-config Documentation](https://git-scm.com/docs/git-config)の
`core.symlinks`を参照。falseに設定すると(デフォルトはtrue)

> If false, symbolic links are checked out as small plain files that contain the link text.

うっかり巨大ファイルをsymlinkしてもOK。
WindowsでcloneしてもOK。

``` bash
git config --global core.symlinks false
git config --local core.symlinks false
sudo git config --system core.symlinks false
```
適切な範囲で設定しておけばいい。

symlinkを無視したいなら、project rootで
``` bash
find * -type l >> .gitignore
```

`find *`は珍しい。`find .`と比較すること。
`*`がいやなら、

``` bash
find . -type l -printf '%P\n' >> .gitignore
```
で
