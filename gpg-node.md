# 参考
- [GnuPG チートシート（簡易版）](https://zenn.dev/spiegel/articles/20200920-gnupg-cheat-sheet)
- 


# キーリングのリスト

```bash
gpg -k
# or
gpg -k user-ID(かIDの一部)
```

# 秘密鍵のパスフレースを変更

```bash
gpg --passwd <user-id>
```

# エクスポートして別ホストでインポート

```bash
# 秘密鍵も含めてエクスポート(パスフレーズ必要)
gpg -a --export-secret-keys bob > bob.asc

# bob.ascを別ホストにコピーしてインポート(パスフレーズ必要)
gpg --import bob.asc
# 確認
gpg -k bob
# たぶん[unknown]なので編集。自分の鍵だったらultimate (trustコマンドで5) にするとか
gpg --edit-key bob
```

# キーサーバー


デフォルトは
hkps://keys.openpgp.org
ですが、
keys.gnupg.netは死んでるみたい。

ほか
- pgp.mit.edu
- pgp.nic.ad.jp
- keyserver.ubuntu.com - いちばんまともっぽい
- keys.mailvelope.com

など [Key server (cryptographic) - Wikipedia](https://en.wikipedia.org/wiki/Key_server_(cryptographic)#Keyserver_examples)


登録は
> gpg --keyserver 鍵サーバ --send-keys 鍵ID


実行例
```bash
gpg -k heiwa4126
gpg --keyserver pgp.nic.ad.jp --send-keys ZZZZZZZZZZZZZZZZZ
gpg --keyserver keyserver.ubuntu.com --send-keys ZZZZZZZZZZZZZZZZZ
```


キーサーバーから検索するには
```bash
gpg --keyserver 鍵サーバ --search-keys メールアドレス
```
