# IPv6 メモ

## IPv6 はそもそも何 bit だっけ?

IPv6 は 128 ビット。

## IPv6 の CIDR /56 にはいくつ IP がある?

2\*\*(128-56) = 4722366482869645213696 個

- 56 ビットがネットワーク部、
- 残りの 128 - 56 = 72 ビットがホスト部

## IPv6 のローカルアドレス

IPv6 のプライベートアドレスは、「ユニークローカルアドレス(ULA)」と呼ぶ。

アドレスブロックは「fc00::/7」

[ユニークローカルアドレス - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%A6%E3%83%8B%E3%83%BC%E3%82%AF%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9)

ULA の例:

```text
fe80::1234:5678:9abc:def0
```

## IPv6 の接続テスト

AAAA レコードしかもってない & ping に答える FQDN

```bash
ping ipv6.google.com
# or
ping ipv6.test-ipv6.com
```

AAAA しかないので `-6` オプションがいらない。

## IPv6 の接続テスト用 WWW サイト

いくつかブラウザで簡易テストができるサイトがある。

いまこのホストから、そのホストに IPv6 でつながるかの確認

- [IPv6 test - IPv6/4 connectivity and speed test](https://ipv6-test.com/)

FQDN を指定してチェックする

- [IPv6 Website Compatibility Checker - Test if the Domain Supports IPv6](https://iplocation.io/ipv6-compatibility-checker)
- [Is your site IPv6 ready?](https://ready.chair6.net/)

## AWS の IPv6

VPC でも subnet でもいきなり public な IPv6 が振られる...

Amazon 提供の IPv6 CIDR ブロック(Amazon-provided IPv6 CIDR block)は /56

VPC の IPv4 CIDR はデフォルトでは/16 で、
サブネットの IPv4 CIDR のデフォルトは/20 で

これにあわせると 128 - (32 - 20) = 116 で IPv6 CIDR は /116 より小さければいい。
