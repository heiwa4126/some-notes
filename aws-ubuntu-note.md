# AWS 上の Ubuntu のメモ

## cifs.ko が無い

### 問題

まず `sudo apt-get install cifs-utils` して、その後
FSx に cifs で mount しようとすると
`mount error(19): No such device` になる。

```sh
ls "/usr/lib/modules/`uname -r`/kernel/fs/smb/client/cifs.ko"
```

が存在しない。どうする?

### 答

```sh
sudo apt install -y linux-modules-extra-aws
```

これで
FSx の"Attach" のところに出て来るサンプル

```sh
mount -t cifs -o vers=3.0,sec=ntlmsspi,user=UPN形式のユーザ名 //10.0.0.111/share /mnt/fsx
```

を実行するとマウントできる(パスワード聞かれる)

自動マウントにするには:

- user と password のところをクレデンシャルファイルにする
- /etc/fstab に書くと、FSx が死んでる時やネットが死んでるときに起動に失敗してホストごと死ぬので systemd のオートマウントにする

などを考慮すること。
