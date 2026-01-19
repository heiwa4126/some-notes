# PKI まわりのメモ

## 署名は暗号ではない

## 署名(Digital Signature)と証明書(Certificate)のちがい

「デジタル署名」は理解しやすいのだけど、「証明書」はちょっとややこしい。

「この公開鍵が、確かにこの人(たとえば「サーバー」)のものです」と証明するのが証明書。

「公開鍵+属性情報」に CA が署名したものが証明書。

あと証明書には「証明書の連鎖(Certificate Chain)」がある。署名にはない。

## 鍵や証明書をファイルに保存したり読んだり

X.509 は「証明書」の規格で、公開鍵を保存する書式は定義があるけど、
秘密鍵を保存するのはない。

PKCS(Public-Key Cryptography Standards)

PKCS は RSA が策定。

- PKCS#1: RSA 鍵の構造と署名方式
- PKCS#12: 鍵と証明書をまとめて保存する形式(.pfx/.p12)
- PKCS#8: 秘密鍵の保存形式(RSA 以外も対応)

(上のリストは時間順)

んで PKCS はデータ構造(ASN.1 スキーマ)で、
これをどうファイルに保存するかは決めていなかった。

PEM(Privacy Enhanced Mail)は
IETF(Internet Engineering Task Force)策定

DER(Distinguished Encoding Rules; 識別符号化規則)
は ITU-T X.690 規格

> DER は、ASN.1(Abstract Syntax Notation One)データ構造を
> バイナリ形式でエンコードするための規則の一つ

PKCS#8 からはエンコード方式も規格に入っていて
PEM か DER かのどちらか。

- [RFC 5208 - Public-Key Cryptography Standards (PKCS) #8: Private-Key Information Syntax Specification Version 1.2](https://datatracker.ietf.org/doc/html/rfc5208)
- [RFC 5958 - Asymmetric Key Packages](https://datatracker.ietf.org/doc/html/rfc5958)

PKCS#12 はもっとややこしくて
公開鍵部分は X.509 で、秘密鍵部分は PKCS#8 形式
(おおむね)らしい。

- [RFC 7292 - PKCS #12: Personal Information Exchange Syntax v1.1](https://datatracker.ietf.org/doc/html/rfc7292)

PKCS#12(というか.pfx/.p12) の構造:

- PKCS#12 は独自の ASN.1 構造を持つ
- 複数の証明書、秘密鍵、その他のデータを階層的に格納
- 全体がパスワードベースで暗号化される
- バイナリ形式(DER ライクだが、PKCS#12 専用の構造)

.p12 と.pfx は同じ。
1990 年代前半に Microsoft が Personal Information Exchange(PFX)という独自規格を作り
それが PKCS#12 として 90 年代後半に採用されたという経緯らしい。

「.p12 の方がわかりやすいのになぜ MS は.pfx というのですか?」はそういうこと

あと ASN.1(Abstract Syntax Notation One)。
protobuf(Protocol Buffers)に似たもの。
ほか JSON Schema + JSON が近い。
要は「スキーマによるバリデーション」があるということ

> スキーマに基づいて高速で扱えるバイナリデータ

[Sneak peek: A new ASN.1 API for Python -The Trail of Bits Blog](https://blog.trailofbits.com/2025/04/18/sneak-peek-a-new-asn.1-api-for-python/)

あと忘れてたけど X.509 には

- X.509 v3 証明書の構造(Subject, Issuer, Validity など)
- 拡張フィールド(KeyUsage, SubjectAltName など)
- ASN.1 構文による定義
- DER(Distinguished Encoding Rules)によるエンコード方式

がちゃんと策定されています。

## CSR
