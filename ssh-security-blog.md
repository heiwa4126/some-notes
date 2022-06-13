# sshdのポートを変えよう

インターネットからsshに




## 基本

いちおうsshのセキュリティの基本を、ざっくりと書いておきます。こまかいことは以下参照

- [Simple SSH Security \| Disk Notifier](https://disknotifier.com/blog/simple-ssh-security/)
- ↑のGoogle翻訳 [シンプルなSSHセキュリティ| ディスク通知機能](https://disknotifier-com.translate.goog/blog/simple-ssh-security/?_x_tr_sl=en&_x_tr_tl=ja&_x_tr_hl=ja&_x_tr_pto=nui)


### 重要: 設定のチェック

設定を変更して、sshdに設定を反映させる前に
`sshd -t` で `/etc/ssh/sshd_config` の間違いをチェックすること。

sshdに設定を反映させるのは `systemctl reload sshd` 。

いまつないでいるsshは古い設定のまま残るので(命綱)、
別のターミナルで接続して、動作確認すること。

また設定を反映後必ず `systemctl status sshd` でエラーが出ていないか確認すること。

### パスワード

`/etc/ssh/sshd_config`で

まず `PasswordAuthentication` を `no` に設定。

さらに
`KbdInteractiveAuthentication`を`no` に設定。
`ChallengeResponseAuthentication` は `KbdInteractiveAuthentication` の別名だけど、
この名前で設定しないこと(わかりにくいから)。

ここで `systemctl reload sshd`


## 弱い素数を削除

```bash
awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
mv /etc/ssh/moduli.safe /etc/ssh/moduli
```

## 強力な暗号のみ使う

`/etc/ssh/sshd_config.d/ssh_hardening.conf`
という名前で以下を作成
```
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com

HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
```

で `systemctl reload sshd`

確認は
`ssh -c aes128-cbc localhost`
で、接続に失敗するはず。
