# AWS 上の Ubuntu のメモ

## cifs.ko が無い

### 問題

まず `sudo apt-get install cifs-utils` して、その後
FSx に cifs で mount しようとすると
`mount error(19): No such device` になる。

調べてみると CIFS ドライバである cifs.ko が存在しない。

```sh
ls \
/lib/modules/`uname -r`/kernel/fs/cifs/cifs.ko \
/lib/modules/`uname -r`/kernel/fs/smb/client/cifs.ko
```

が存在しない。どうする?

### 答

AWS の場合は

```sh
sudo apt install -y linux-modules-extra-aws
```

これで FSx の"Attach" のところに出て来るコード

```sh
mount -t cifs -o vers=3.0,sec=ntlmsspi,user=UPN形式のユーザ名 //10.0.0.999/share /mnt/fsx
```

を実行するとマウントできる(パスワード聞かれる)

実際に運用する場合は

- user と password のところをクレデンシャルファイルにする
- /etc/fstab に書くと、FSx が死んでる時やネットが死んでるときに起動に失敗してホストごと死ぬのでオートマウントにする

などを考慮すること。

### おまけ

`linux-modules-extra-aws` は
`linux-modules-extra-$(uname -r)` のメタパッケージで、
現在のカーネルリビジョンに対応したパッケージがインストールされるのと同時に
古いリビジョンのパッケージが消えるしかけ。
