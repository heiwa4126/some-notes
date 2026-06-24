# `aws login` (`aws sso login`ではない) のメモ

- [コンソール認証情報を使用してログインする (推奨)](https://docs.aws.amazon.com/ja_jp/signin/latest/userguide/command-line-sign-in.html#command-line-sign-in-local-development)
- [login — AWS CLI 2.35.8 Command Reference](https://docs.aws.amazon.com/cli/latest/reference/login)

## default プロファイルとして登録されるしかけ

なのですでに default プロファイルが存在してると文句を言う

## ブラウザが使えないとき

たとえば ssh でつないだ端末で `aws login` したいとき。

リファレンス <https://docs.aws.amazon.com/cli/latest/reference/login/#examples> に
"Example 2: To login from a remote host" として掲載されてる。

```sh
aws login --remote
```

ベリファイコードがすげえ長くて驚く

## `aws logout` もあるよ

<https://docs.aws.amazon.com/cli/latest/reference/logout/>

ただちに無効にしたいときに使う。
