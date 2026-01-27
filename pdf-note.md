# PDFのメモ


## パスワードで保護されたPDFを解除する(パスワードがわかる場合)

[qpdf/qpdf: qpdf: A content-preserving PDF document transformer](https://github.com/qpdf/qpdf)
が楽。

Releases から zip をダウンロードして、

```sh
curl -LO https://github.com/qpdf/qpdf/releases/download/v99.9.9/qpdf-99.9.9-bin-linux-x86_64.zip
mkdir qpdf && cd qpdf
unzip ../qpdf-99.9.9-bin-linux-x86_64.zip
bin/qpdf --version
bin/qpdf --help
```

んで

```sh
bin/qpdf --password=SuperSecret --decrypt some/where/input.pdf output.pdf
```

でデクリプトされたPDFができる。

`bin/qpdf` をどこか PATH の通ったところに symlink しておくと起動が楽。

### qpdf のつかいかたメモ

```sh
# パスワード解除(今回使ったやつ)
qpdf --password=pass --decrypt input.pdf output.pdf

# 逆にパスワードを付与する
qpdf --encrypt userpw ownerpw 128 \
  -- input.pdf output-secure.pdf

# ファイル最適化
qpdf --linearize input.pdf output-small.pdf
```

`userpw ownerpw 128` のところの補足

- userpw - 閲覧パスワード - PDF を開くために必要
- ownerpw - 権限パスワード - PDF の制限を解除・編集できる
- 128 - 暗号化強度 - 主に 128-bit AES/RC4
