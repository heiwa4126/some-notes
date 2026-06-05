# crul のメモ

- [curl](https://curl.se/)
- [README - Everything curl](https://everything.curl.dev/)

## ~/.curlrc

```
noproxy=localhost,127.0.0.1,::1
```

## -d (--data) いろいろ

- [curlのオプション--data, --data-binary, --data-raw, --data-urlencodeの違い - Qiita](https://qiita.com/aosho235/items/d89bb027db0c5662d8c5)
- [Ubuntu Manpage: curl - transfer a URL](https://manpages.ubuntu.com/manpages/jammy/en/man1/curl.1.html)

## curlでBASIC認証

こんな感じで

```sh
curl -u username:password https://example.com/api
```

また、

```sh
echo -n 'alice:secret' | base64
```

で得られた値を使って

```sh
curl \
  -H 'Authorization: Basic YWxpY2U6c2VjcmV0' \
  https://example.com/api
```

というのもあり。
