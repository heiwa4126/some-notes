# GPG メモ

## 参考

- [GnuPG チートシート(簡易版)](https://zenn.dev/spiegel/articles/20200920-gnupg-cheat-sheet)

## キーリングのリスト

```bash
gpg -k
## or
gpg -k user-ID(かIDの一部)
```

## 秘密鍵のパスフレースを変更

```bash
gpg --passwd <user-id>
```

## エクスポートして別ホストでインポート

```bash
## 秘密鍵も含めてエクスポート(パスフレーズ必要)
gpg -a --export-secret-keys bob > bob.asc

## bob.ascを別ホストにコピーしてインポート(パスフレーズ必要)
gpg --import bob.asc
## 確認
gpg -k bob
## たぶん[unknown]なので編集。自分の鍵だったらultimate (trustコマンドで5) にするとか
gpg --edit-key bob
```

## キーサーバー

デフォルトは
`hkps://keys.openpgp.org`
ですが、
keys.gnupg.net は死んでるみたい。

ほか

- keyserver.ubuntu.com - いちばんまともっぽい
- pgp.mit.edu
- pgp.nic.ad.jp
- keys.mailvelope.com
- pool.sks-keyservers.net (分散型キーサーバネットワーク)

など [Key server (cryptographic) - Wikipedia](<https://en.wikipedia.org/wiki/Key_server_(cryptographic)#Keyserver_examples>)

登録は

> gpg --keyserver 鍵サーバ --send-keys 鍵 ID

実行例

```bash
gpg -k heiwa4126  # ZZZZ...のとこはここで表示されたIDに置き換える
gpg --keyserver pgp.nic.ad.jp --send-keys ZZZZZZZZZZZZZZZZZ
gpg --keyserver keyserver.ubuntu.com --send-keys ZZZZZZZZZZZZZZZZZ
```

キーサーバーから検索するには

```bash
gpg --keyserver 鍵サーバ --search-keys メールアドレス
```

### keys.openpgp.org はベリファイメール式

--send-key のあとメールアドレスにベリファイメールが届く式になっている。
リンク先が変な日本語だけど、まあ理解できるのでがんばって。
メールは 2 回とどくよ。

あと keys.openpgp.org は `-search-keys` で部分検索ができないよ!

## キーサーバのデフォルトを設定するには?

`~/.gnupg/gpg.conf` で

```config
keyserver hkp://keyserver.ubuntu.com
# または keyserver hkp://keys.gnupg.net
# または keyserver hkp://pgp.mit.edu
```

## GPG で単一ファイルの公開鍵暗号&複号

例:

```sh
gpg --encrypt --recipient alice@example.com secret.pdf
gpg --decrypt secret.pdf.gpg > secret.pdf
```

--encrypt, --recipient, --decrypt はショートオプションがあって、
-e, -r, -d
